; V14 routines for reception (demodulation)

; definition of:
;   Descram, Rec4, RecUart
;   int GetData(void)
;   int descramble(int )

     .include   "..\msp58c80.i8x"
     .include   "..\global.inc"

;
; ***************
;
; int GetData(void)
;   Get a byte (if available) from the demodulation and V14 function
; return:
;   DDDD DDDD SSSS SSSS
;   D: DATA
;   S: STATUS WITH OVERFLOW (FLAG10) AND DATA PRESENT (FLAG20)
;   CLEAR OVERFLOW FLAG AND RESET POINTER IF OVERFLOW

; warning: eint
; release 0.1
;
; ***************
;
_GetData
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#0
     LAR     AR0,*0+,AR0 ; new ar1
;
     DINT
     ssxm
;
     .newblock
     LDPK    IN
     LACC    IN
     ldpk    OUT
     SUB     OUT
     BNZ     $1      ; DATA PRESENT
; NO DATA OR OVERFLOW
     ldpk    UartStatus
     LACC    UartStatus
     ANDK    #FLAG1
     BNZ     $0      ; OVERFLOW
                     ; NO DATA
     ZAC
     B       $3      ; END
; OVERFLOW
$0
     ldpk    UartStatus
     LACC    UartStatus
     XORK    #FLAG1
     SACL    UartStatus ; RESET OVERFLOW
     LACC    #FLAG10 ; RETURN OVERFLOW FLAG
     B       $3

; DATA
$1
     LAR     AR2,IN
     MAR     *,AR2
     ldpk    IN
     LACC    IN
     ADD     #1
     SACL    IN
     SUB     #LAST_OUT
     BLEZ    $2      ; NO WRAP
                     ; END OF BUFFER: WRAP
     LACC    #FIRST_OUT
     SACL    IN      ; NEW POINTER
$2
                     ; GET DATA AND STATUS
     LACC    #FLAG20 ; DATA VALID
     OR      *       ; ADD DATA
	
$3
     .newblock
     EINT
;
     MAR     *,AR1   ;
     SBRK    #1
     LAR     AR0,*-  ; restore ar0
     PSHD    *
     RET

;
;********************************
;
; uses the 4 bits in _mdm_sta, descrambled them,
; and does uart function
;
; incoming bit are in _mdm_sta : xxxx xxxx xxxx dcba
; a: newest bit (last received)
; d: oldest bit (first received)
;
; modified variables:
;  TMP0, TMP1, variables of descrambler and receive uart
;
; release: 0.0.0
; stack 1
;
;********************************
Rec4
                     ; descramble the bits
     ldpk    _mdm_sta
     lacc    _mdm_sta
     ldpk    #TMP0
     sacl    TMP0
     lacc    TMP0,14
     sach    TMP1
     lacc    TMP1
     call    Descram ; descramble the first 2 bit
     call    RecUart ; do uart function on result
     ldpk    #_speed
     lac    _speed
     sub    #1200
     bnz    rec4bits
     ret

rec4bits
     ldpk    _mdm_sta
     lacc    _mdm_sta
     call    Descram ; descramble last 2 bits
     b       RecUart ; do uart function on result and return



;
;*****************************
;
; receive uart function for 2 bits
;
; input:
;   2 bit in accu in position xxxx xxxx xxxx xxba
;   (a=last received)
; output:
;   8 bit without start and stop in buffer pointed by OUT
;   set bit in UartStatus
;     set FLAG1 if overflow (reset by other routine)
;     in that case OUT is set equal to IN
;
; modified variables:
;  OUT, TMP0, *OUT, STATE, BIT_COUNT, UartStatus
;  AR2
;
; This routine is supposed not to be interrupted by an other
;   routine using IN OUT or UartStatus
;
; **************************
;
RecUart
     .newblock
     ldpk    #TMP0
     sacl    TMP0
     lacc    TMP0,14 ; put bit in msb position
     sacl    TMP0
     LARK    AR2,#2-1 ; init counter for 2 bit
     MAR     *,AR2
; LOOP
$0
     ldpk    STATE
     LACC    STATE

	 .if	CBacc
; debug : check bacc value
	 sub	#RecUartWait
	 bz		RecUartWait
	 lac	STATE
	 sub	#$2
	 bz		$2
	 dint
	 b		$		; error
	 .endif

     BACC            ; GO TO APROPRIATE STATE
; STATE: WAIT START BIT
RecUartWait
     ldpk    #TMP0
     LAC     TMP0,16
     BLZ     $5      ; NO START BIT
     LACC    #$2     ; FIRST BIT
     ldpk    STATE
     SACL    STATE
     LACC    #8      ; WAIT FOR 8 BIT
     ldpk    BIT_COUNT
     SACL    BIT_COUNT ; ZERO BIT RECEIVED
     B       $5      ; NEXT BIT
; STATE: WAIT 8 BIT
$2
                     ; TRANSFER BIT
     ldpk    OUT
     LAR     AR1,OUT
     mar     *,ar1
     ldpk    #TMP0
     LACC    TMP0,16 ; PUT NEW BIT IN MSB
     ROL
     LACC    *,16
     ROR             ; INSERT NEW BIT
     SACH    *,ar2   ; SAVE NEW RESULT
                     ; BIT COUNTER
     ldpk    BIT_COUNT
     LACC    BIT_COUNT
     SUB     #1      ; DECREMENT COUNTER
     SACL    BIT_COUNT
     BNZ     $5      ; IF NOT ENOUGTH BIT
; IT WAS LAST BIT
;$4
	call	UpdatPtr		; update Uart pointers

     LACC    #RecUartWait ; WAIT NEW START
     ldpk    STATE
     SACL    STATE
; END OF UART
$5
     ldpk    #TMP0
     LACC    TMP0,1
     SACL    TMP0    ; NEXT BIT IN MSB
;       mar     *,ar2
     BANZ    $0,*-   ; (ar2) NEXT BIT
     ret

 
UpdatPtr 
     .newblock
                     ; TEST IF IN OVERFLOW MODE
     ldpk    UartStatus
     LACC    UartStatus
     ANDK    #FLAG1
     XORK    #FLAG1
     BZ      $4      ; IN OVERFLOW MODE
                     ; COMPUTE NEXT POINTER POSITION
     ldpk    OUT
     LACC    OUT
     ADD     #1
     SACL    OUT
     SUB     #LAST_OUT
     BLEZ    $3      ; NO WRAP
                     ; END OF BUFFER: WRAP
     LACC    #FIRST_OUT
     SACL    OUT     ; NEW POINTER
                     ; TEST NEW OVERFLOW
$3
     ldpk    OUT
     LACC    OUT
     ldpk    IN
     SUB     IN
     BNZ     $4      ; NO NEW OVERFLOW
                     ; NEW OVERFLOW
     LACC    #FLAG1  ; SET OVERFLOW FLAG
     ldpk    UartStatus
     OR      UartStatus
     SACL    UartStatus ; DO NOT INCREMENT OUT
                     ; NEW STATE
$4
	 ret




;
;*****************************
;
; asm descrambler
; input:
;   2 bit in accumulator  xxxx xxxx xxxx xxba
;   a=last received
; output:
;   2 bit in accu  xxxx xxxx xxxx xxba
;   a=last receive
;
; modified variables:
;   MASK, Descram0, Descram1, CPT64, D1803, D0201, SXM
;
; release 0.2
;
;*****************************
;
Descram
     .newblock       ; for local label
     ssxm
     andk    #3      ; eliminate non usefull bit
     ldpk    #Descram0
     sacl    Descram0    ; save input bit
     ldpk    CPT64
     LACC    CPT64   ; 64 one bit counter
     SUB     #63
     blz     $5      ; CPT64 < 63
     bz      $4      ; CPT64 = 64
                     ; CPT64 = 63
     ldpk    #Descram0
     lacc    Descram0
     andk    #1
     bz      $5      ; no inversion
                     ; inversion
     lacc    #2
     ldpk    MASK
     sacl    MASK    ; mask for inversion
     lacc    #-1
     sacl    CPT64
     b       $6
                     ; CPT64 = 64
$4
     lacc    #1
     ldpk    MASK
     sacl    MASK
     zac
     ldpk    CPT64
     sacl    CPT64
     b       $6
                     ; CPT64 < 63 or no inversion
$5
     zac
     ldpk    MASK
     sacl    MASK
                     ; all CPT64
$6
     ldpk    #Descram0
     bit     Descram0,15-1
     bbz     $7      ; bit 1 = 0
     bit     Descram0,15-0
     bbz     $8      ; bit 0 = 0
                     ; 11
     ldpk    CPT64
     lacc    CPT64
     add     #2
     b       $9
                     ; 10
$7
     lacc    #1
     b       $9
                     ; 0x
$8
     zac
$9
     ldpk    CPT64
     sacl    CPT64
     .newblock       ; for local label
; END OF 64 MANAGEMENT
;
; descramble 2 bit
; previous routine has put in MASK the inversion position controlled
;   by 64 one counter
; do:  X(N) = Y(N-17) XOR Y(N-14) XOR Y(N)
; the two bits are in Descram0    0000 0000 0000 00ba
; a: last received bit
;     ldpk    #4
     ldpk    #Descram0
     lacc    Descram0,13 ; put 2 input bit in position 13-14
     ldpk    D1803
     xor     D1803   ; xor with bit 13-14 of shift register
     sfr             ; put result in position 12-13
     ldpk    #Descram1
     sacl    Descram1    ; save temporary result in position 12-13
     ldpk    D1803
     lacc    D1803,2 ; load bit 10-11 in position 12-13
     ldpk    D0201
     or      D0201   ; add lsb
     ldpk    D1803
     sacl    D1803   ; store new high part of shift register
     ldpk    #Descram1
     xor     Descram1    ; finish xor in position 12-13
     sach    Descram1,4  ; store 2 result bit in lsb position

     lacc    Descram0
     ldpk    D0201
     sacl    D0201   ; store 2 received bit in lsb position


; do inversion with MASK computed before
     ldpk    #Descram1
     lacc    Descram1    ; last 2 descrambled bit
     ldpk    MASK
     XOR     MASK
     ret


;
;***************************
;
; 2 bit descrambler routine
; C callable
; x=descramble(int y)
; input:
;   y= xxxx xxxx xxxx xxba
; output:
;   x= 0... 00ab
; (a=last received)
;
; modified variables:
;   Descram0, Descram1, variables of descrambler
; warning: eint
;
; release 1.0
;  modif in 1.0
;   ldpk
;
;***************************
;
_descramble
NbDescram .SET 0     ; number of local variable
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#NbDescram
     LAR     AR0,*0+,ar2 ; new ar1
                     ; get parameter
;       mar     *,ar2
     lark    ar2,#-2-1 ; parameter 1 in accu
     mar     *0+
     lacc    *
     dint
     call    Descram ; call asm decscrambler
                     ; result in accu
; invert 2 bit for C and clear unusefull bits
     andk    #3      ; clear unused bit
     sfl             ; accu= 0... 0ba0
     ldpk    Descram0
     sacl    Descram0
     lacc    Descram0,16 ; accu= 0000 0000 0000 0ba0 0000 ...0
     add     Descram0,14 ; accu= 0000 0000 0000 0bab a000 ...0
     sach    Descram0
     lacc    Descram0    ; accu= 0... 0bab
     andk    #3      ; accu= 0... 00ab
     eint
;
     MAR     *,AR1   ;
     SBRK    NbDescram+1 ; restore ar1
     LAR     AR0,*-  ; restore ar0
     PSHD    *
     RET

