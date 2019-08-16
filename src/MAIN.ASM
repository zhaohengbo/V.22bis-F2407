; main.asm
; 

     .include "msp58c80.i8x"
     .include "global.inc"
     .include "common.inc"
     .include "cid.inc"

    .ref    Timer, AUInit
    .ref    _c_int0
    .ref    _CID_status
    .ref    CheckCPE, RXV23, RXV21, TXV23, TXV21
    .ref    _AS
    .ref    CPTD
    .ref    Dtmf
    .ref    _DtmfFlag
    .ref    BusyFilt

    .def    _FConnect,_FDisConnect
    .def    _EightKHz
    .def    _table_read
    .global End_V21, End_V23

Mips    .set    7 ; 6:6mips 7:7mips 8:8mips 12:12mips

_mdm_sta    .usect  "SMain",1   ; status for modem DSP
MTmp1       .usect  "SMain",1   ; local dummy variable
MTmp2       .usect  "SMain",1
OffIn0      .usect  "SMain",1   ; x(n-1) for offset suppression
OffOut      .usect  "SMain",1   ; y(n) for offset suppression
Energy      .usect  "SMain",1   ; average ABS of input

RamEnd      .usect  "EndRam",1  ; zone for debug

    .sect   "vectors"

	.if		IsDsk
	b		InitDsk
	.else
    b       Reset   ; reset
    b       $       ; int0
    b       SigmaIt ; sigma delta
    b       $       ; real time counter
    .space  16*16   ; reserve 16 words
    b       Timer   ; timer
    b       $       ; serial receive
    b       $       ; serial transmit
    b		DTrap   ; trap (for debug)
	.endif

    .text
	.if		IsDsk
	.include	"initdsk.asm"
	.endif
; Trap for debug
DTrap
	dint
	b		$
;
; after reset
;
Reset
	.if		IsDsk
	.else
    dint
    ssxm
    sovm
; clock
    call    _EightKHz
; init port b0
    lack    #04FA1h ; 0100 1111 1010 0001
    ldpk    #0      ; b5,7,8,9,10,11,14 output  ; B0
    sacl    BDIR
    lack    #04FA0h ; 0100 1111 1010 0000
    sacl    BO      ; put bit to 1
; init 58C20
    lack    #003h   ; 00 0011
    ldpk    #0
    sacl    ADAC    ; enable AD and DA
; timer
    .if     Mips = 6
    lack    #320-1  ; 4.096*6/4/320=2400*8
    .endif
    .if     Mips = 7
    lack    #373-1  ; 4.096*7/4/373.333=2400*8
    .endif
    .if     Mips = 8
    lack    #427-1  ; 4.096*8/4/426.6666=2400*8
    .endif
    .if     Mips = 12
    lack    #640-1  ; 4.096*12/4/640=2400*8
    .endif
    ldpk    #0
    sacl    PRD     ; it at 8*2400Hz
; init AS (caller ID alerting signal)
	.endif

; init Uart
    call    AUInit
;
    zac
    ldpk    #_AS
    sacl    _AS
; init constant One
    lac     #1
    ldp     #One
    sacl    One

; init offset compensation
    zac
    ldp     #OffIn0
    sacl    OffIn0
    ldp     #OffOut
    sacl    OffOut
;---------------------------
;
; DRAM
;
;---------------------------
    .if     UseDram
    lack    #0      ; all D as input
    ldpk    0
    sacl    DDIR

    lack    #0DC00h     ; 1101 1100 0000 0000
    sacl    MEMTYPE     ; DRAM wide (4bit) refresh 7 wait state
    call    aClearDram

     .endif

    .if		IsDsk
	.else
; interrupt mask
    lack    #0Ah
    ldpk    #0
    sacl    IMR     ;  0     0   1    0    1     0
	.endif

; init mode
    ldpk    #_CID
    lack    #CIDMode
    sacl    _CID

; init CID status register
    ldp     #_CID_status
    zac
    sacl    _CID_status
;

    eint

	.if		IsDsk
;
; init speed of AIC
; init A register
    ldp     #AicCmd
    lac     #1*256+25       ; A register fclk=10000/(2*25)=200khz
    sacl    AicCmd
    lac     #1
    sacl    AicFlag
; wait command send
    .newblock
$1
    lac     AicFlag
    bnz     $1
; init B register
    lac     #2*256+25       ; B register Fs=fclk/25=8kHz
    sacl    AicCmd
    lac     #1
    sacl    AicFlag
	.endif


    call    _c_int0  ; start C program
    b       $

;
; aClearDram
;
    .if     UseDram
    .newblock
aClearDram
     ZAC
     LDPK    #TMP1
     SACL    TMP1
     OUT     TMP1,AAL
     OUT     TMP1,AAH
     LAR     AR2,#0FFFFH
     LARP    AR2
$0
     OUT     TMP1,ADBP
     BANZ    $0,*-
$1
     OUT     TMP1,ADBP
     BANZ    $1,*-
$2
     OUT     TMP1,ADBP
     BANZ    $2,*-
$3
     OUT     TMP1,ADBP
     BANZ    $3,*-
     OUT     TMP1,AAL
     OUT     TMP1,AAH
     ret
;
; void aClearDram(void)
;
    .global _cClearDram
_cClearDram
;   dint
    call    aClearDram
;   eint
    ret
     .endif


;--------------------
;
; 58C20 at 8kHz 
;
;--------------------
_EightKHz
    .if     Mips = 6
    lack    #0F537h ; 111 1 0101 001 10111
                    ; 0101  SDPD 4.096*12/12=Sigma delta 8.0kHz
                    ; 001   PCPD 4.096*12/4*2 = 6.14MIPS
                    ; 10111 PLLFG 4.096*12MHz           
    .endif
    .if     Mips = 7
    lack    #0F63Bh ; 111 1 0110 001 11011
                    ; 0110  SDPD 4.096*14/14=Sigma delta 8.0kHz
                    ; 001   PCPD 4.096*14/4*2 = 7.17MIPS
                    ; 11011 PLLFG 4.096*14MHz           
    .endif
    .if     Mips = 8
    lack    #0F30Fh ; 111 1 0011 000 01111
                    ; 0011  SDPD 4.096*8/8=Sigma delta 8.0kHz
                    ; 000   PCPD 4.096*8/4*1 = 8.20MIPS
                    ; 01111 PLLFG 4.096*8MHz           
    .endif
    .if     Mips = 12
    lack    #0F517h ; 111 1 0101 000 10111
                    ; 0101  SDPD 4.096*12/12=Sigma delta 8.0kHz 
                    ; 000   PCPD 4.096*12/4/1 = 12.29Mips
                    ; 10111 PLLFG 4.096*12MHz
    .endif
    ldpk    #0
    sacl    FREQ
    ret



;----------------------
;
; void FConnect(void)
; connection to the line
; warning: eint
;----------------------
_FConnect
    ldpk    #0
    dint
    lac     BO
    andk    #~CON
    sacl    BO
    eint
	ret
; 
;----------------------
;
; void FDisConnect(void)
; disconnection of the line
; warning: eint
;----------------------
_FDisConnect
    ldpk    #0
    dint
    lac     BO
    ork     #CON
    sacl    BO
    ldpk    #_Connect
    lac     #OFF
    sacl    _Connect
    lack    #CIDMode
    ldpk    #_CID
    sacl    _CID
    zac
    ldp     #_CID_status
    sacl    _CID_status
    eint
	ret
; 
;---------------------
;
; it sigma delta
;
;---------------------
SigmaIt

	.if		IsDsk
RintIsr
	.endif

    .newblock
; save context

    sst     ItPage0+0   ; status
    sst1    ItPage0+1   ; status 1
    ldpk    #_CID          ; page 0
    sach    ItPage0+2   ; accuh
    sacl    ItPage0+3   ; accul


; test modem state
    lac     _CID
    bnz     NotModem   ; not modem
;    bnz     NotModem,*,ARIn   ; not modem
	mar		*,ARIn

	.include "V22it.asm"

;
; control oversampling converter
;
NotModem

	.if		IsDsk
	.else
    lack    #08h	; mask SDINT
;    ldpk    #0
    sacl    IMR     ;  0     0   1    0    0     0
	.endif

; soft timer
    lac     _Tim0
    add     #1
    sacl    _Tim0
; save context
    sar     ar0,ItPage0+4
    sar     ar1,ItPage0+5
    sar     ar2,ItPage0+6
    sar     ar3,ItPage0+7
    spm     0
    sph     ItPage0+8   ; prh 
    spl     ItPage0+9   ; prl
    mpyk    1
    spl     ItPage0+10  ; t
    ssxm
;

	.if		IsDsk
	.newblock
    ldp     #FromAD
    in      FromAD, SDTR     ; store the audio data from AIC
    ldp     #AicFlag
    lac     AicFlag
    bz      $5           ; AicFlag=0
    sub     #1
    bz      $3           ; AicFlag=1
; AicFlag=2 send AicCmd
    ldp     #AicCmd
    out     AicCmd,SDTR
    zac
    ldp     #AicFlag
    sacl    AicFlag
    b       $6
; AicFlag=1 send data with command bit
$3
    lac     #2
    sacl    AicFlag
    ldp     #ForDA
    lac     ForDA
    andk    #0fffch
    or      #3
    ldp     #Y1
    sacl    Y1
    out     Y1,  SDTR     ; send the audio data back to AIC
    b       $6
; AicFlag=0 send 
$5
    ldp     #ForDA
    lac     ForDA
    andk    #0fffch
    ldp     #Y1
    sacl    Y1    
    out     Y1, SDTR     ; send the audio data back to AIC
$6
;	b		End_V23
	ldp		#0
	splk	#CLR_RINT + CLR_XINT,IFR	; block 2nd interrupt

	.else		; not a c2xx DSK

    ldpk    #ForDA
    lacc    ForDA
    ldpk    #0
    sacl    SDDA        ; send sample to DA
    lac     SDAD        ; get AD sample
    ldpk    #FromAD
    sacl    FromAD      ; save sample
	.endif

;debug-----MIPS indicator
;   rptk    #15
;   nop
;end debug

    ldpk    #_CID
    lac     _CID
    sub     #FSKV21
    bz      RXV21       ; reception V21, calls transmission V21
;   call    RXV21       ; TXV21 returns to "End_V21"
;   call    TXV21
;   b       no_filter
no_V21
;	lac		_CID
	sub		#(FSKV23-FSKV21)
	bnz		no_V23		 ; reception V23
	call	RXV23		 
	b		TXV23			; TXV23 returns to "End_V23"
;   b       no_filter
no_V23
    lac     _CID
    sub     #CIDMode

    bnz     no_FSK

    ldp     #_CID_status
    lac     _CID_status
    and     #CID_ON
    bz      no_filter
        
	call	CheckCPE
	call	RXV23
;	.endif

    b       no_filter
no_FSK
;   ldp     #_CID
    lac     _CID
    sub     #CPTMode
    bnz     no_filter
;	b		no_filter	; debug
    call    Offset      ; offset compensation due to 58C20
    call    CPTD
    ldp     #_DtmfFlag
    lac     _DtmfFlag
    bz      no_filter
do_Dtmf
    call    BusyFilt
    call    Dtmf
no_filter
End_V21                 ; return address V21
End_V23                 ; return address V23
; restore context
    ldpk    #ItPage0
    dint

	.if		IsDsk
	.else
    lack    #0Ah	; restore
    sacl    IMR     ;  0     0   1    0    1     0
	.endif

    lt      ItPage0+9
    mpyk    1           ; prl
    lt      ItPage0+10  ; t
    lph     ItPage0+8   ; prh
    lar     ar3,ItPage0+7
    lar     ar2,ItPage0+6
    lar     ar1,ItPage0+5
    lar     ar0,ItPage0+4
    zals    ItPage0+3   ; accl
    addh    ItPage0+2   ; acch

    lst1    ItPage0+1    ; status1
    lst     ItPage0+0    ; status
    eint
    ret


; C-callable routine that allows looking up values in a ROM table
_table_read
        mar     *-                  ; AR1 = &(&program memory word)
        lac     *+                  ; acc = &program memory word
        tblr    *                   ; 
        lac     *,ar1               ; acc = program memory word
        ret

;
; 58C20 offset compensation
;
; input ItTmp1
; output OffOut
; modify: ItTmp1, accu
; y(n)=x(n)-x(n-1)+0.875*y(n-1)
; 3dB: fs/(Pi*16)  (190Hz)
;

Offset
    ldpk    #FromAD
    lac     FromAD,15   ; x(n)
    ldpk    #OffIn0 
    sub     OffIn0,15   ; x(n)-x(n-1)
    ldpk    #OffOut
    add     OffOut,15   ; x(n)-x(n-1)+y(n-1)
    sub     OffOut,12   ; x(n)-x(n-1)+0.875*y(n-1)
    sach    OffOut
    addh    OffOut      ; renormalize with saturation
    sach    OffOut      ; save result
    ldpk    #FromAD
    lac     FromAD
    ldpk    #OffIn0
    sacl    OffIn0      ; update x(n-1)
    ldp     #OffOut
    lac     OffOut
    ldp     #FromAD
    sacl    FromAD
    ret

        .if     TRACE
;
; C callable trace
; Trace(int T)
        .global _Trace
_Trace
        mar     *-
        out     *+,ADBP
        ret

        .endif

;
; set B0 to 0
; warning: eint
;
    .global _B00, _B01, IB00, IB01
_B00
    dint
    ldpk    0
    lac     BO
    andk    #0fffeh
    sacl    BO
    eint
    ret
; same without dint
IB00
    ldpk    0
    lac     BO
    andk    #0fffeh
    sacl    BO
    ret

;
; set B0 to 1
; warning eint
;

_B01
    dint
    ldpk    0
    lac     BO
    ork     #01
    sacl    BO
    eint
    ret
; same without dint
IB01
    ldpk    0
    lac     BO
    ork     #01
    sacl    BO
    ret

