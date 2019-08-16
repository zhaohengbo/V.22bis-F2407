;
; uart.asm
; release 0.4 11july 97
; Copyright Texas Instruments 97
; this program is the soft uart implementation
; oversampling 8 (TSample, RSample)
; overspeed 7/8 stop
; 8bit, no parity, 1 stop
; buffer in and out of 16 words (TBuffr, RBuffr)


     .include "msp58c80.i8x"
     .include "global.inc"

    .global     Timer, AUInit
    .global     _RBuffr, _RLast, _RPtOut
    .global     _CUInit, _ReadData, _SendData

	.global		It2Sst,It2Sst1,It2Save

;
;*** constant ****
;
TSample .set    8       ; oversampling factor for transmission
                        ; must multiple of 8 for 7/8 stop bit
RSample .set    8       ; oversampling factor for reception
RThres1 .set    8       ; min word in buffer for CTS off
RThres2 .set    7       ; max word in buffer for CTS on
CTSTest .set    1       ; 1=CTS managed

;
;*** variable ****
;
; transmit (RX line)
TMode   .usect  "SUart",1   ; address for transmission
TCptIt  .usect  "SUart",1   ; it counter for transmission
TCptBit .usect  "SUart",1   ; bit counter for transmission
TBuffr  .usect  "SUart",16-1 ; buffer for transmission
TLast   .usect  "SUart",1   ; last word of buffer
TPtIn   .usect  "SUart",1   ; pointer to free place in TBuffr
TPtOut  .usect  "SUart",1   ; pointer to next data to get out of TBuffr
                            ; TPtIn=TPtOut -> buffer empty
; receive (TX line)
RMode   .usect  "SUart",1   ; address for reception
RCptIt  .usect  "SUart",1   ; it counter for reception
RCptBit .usect  "SUart",1   ; bit counter for reception
RSize   .set    32          ; size of receive buffer
_RBuffr .usect  "SUart",RSize-1 ; buffer for reception
_RLast  .usect  "SUart",1   ; last word of buffer
RPtIn   .usect  "SUart",1   ; pointer to free place in _RBuffr
_RPtOut .usect  "SUart",1   ; pointer to next data to get out of RBbuffr
                            ; RPtIn=RPtOut -> buffer empty
; miscealenous
tmp1    .usect  "SUart",1   ; local dummy variable
ItTmp1  .usect  "SUart",1   ; interrupt local dummy variable
; Interrupt context
ItSst1  .usect  "TStat",1   ; save of status register1 for Int (page 0)
ItSst   .usect  "TStat",1   ; save of status register for Int (page 0)
It2Sst1  .usect  "TStat",1   ; save of status register1 for Int (page 0)
It2Sst   .usect  "TStat",1   ; save of status register for Int (page 0)
It2Save  .usect  "TSave",13  ; Int save zone 
                            ; ar0-ar7, acc, pr, t
        .if UseTim19
Tim19   .usect  "TSave",1   ; Timer at 19.2kHz
        .endif
;
;*** macro ******
;

Send0   .macro          ; set RX to 0
        ldpk    #0
        lac     BO      ; read port B
        andk    #0FFFFh-RX ; FD pour B1
        sacl    BO
        .endm

Send1   .macro          ; set RX to 1
        ldpk    #0
        lac     BO      ; read port B
        ork     #RX     ; 
        sacl    BO
        .endm
    
TestBit .macro          ; put TX bit in TC flag
        ldpk    #0
        bit     BI,15-TXPos ; test TX
        .endm


;-------------------
; void CUInit(void)
; 
; UART intialisation in C
; release 0.2 26june97
;
;-------------------
_CUInit
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#0     ; 0 local variable
     LAR     AR0,*0+   ; new ar1
;
     CALL    AUInit  ; call uart init in ASM
; restore
     MAR     *,AR1   ;
     SBRK    #1
     LAR     AR0,*-  ; restore ar0
     PSHD    *
     ret

;-------------------
; CUInit
; 
; UART intialisation in ASM
; release 0.2 26june97
; modify: Accu, DP
;-------------------
AUInit
; init transmit
    lac     #TWait
    ldpk    #TMode  ; init Transmit address
    sacl    TMode
    zac
    ldpk    #TCptIt ; init Transmission it counter
    sacl    TCptIt
    lac     #TBuffr ; init buffer pointers
    ldpk    #TPtIn
    sacl    TPtIn
    ldpk    #TPtOut
    sacl    TPtOut
    ldpk    #0      ; init RX, CTS, DSR (active low)
    lac     BO
    andk    #0FFFFh-RX-CTS-DSR-CD-RI
    sacl    BO
    Send1           ; set RX to 1
; init receive
    lac     #RWait
    ldpk    #RMode
    sacl    RMode
    zac
    ldpk    #RCptIt
    sacl    RCptIt
    lac     #_RBuffr
    ldpk    #RPtIn
    sacl    RPtIn
    ldpk    #_RPtOut
    sacl    _RPtOut

; ----- debug
    .if     UseTim19
    zac
    ldpk    #Tim19      ; init Timer 19kHz
    sacl    Tim19
    .endif
; ----- end debug

    ret


;-------------------------
;
; timer interrupt
; this interrupt is at 9600hz
; release 0.1 13june97
; modify:
;  ItTmp1
;
;--------------------------
Timer
;
;**** save context ****
;
    sst     It2Sst       ; status
    sst1    It2Sst1      ; status 1
    ldpk    #It2Save     ; ar0
    sar     ar0,It2Save  ; ar0 +0    
    lar     ar0,#It2Save+1    
    mar     *,ar0
    sach    *+          ; accuh +1
    sacl    *+          ; accul +2

; ----- debug
    .if     UseTim19
    ldpk    #Tim19
    lac     Tim19
    add     #1
    sacl    Tim19
    .endif
; ----- end debug

    ssxm

;----------------
;
; transmission (RX)
; ressources
; DP, accu, arp, status, ar0
;
;----------------

    .newblock

    ldpk    #TMode
    lac     TMode   ; switch on TMode
	
	.if		CBacc
	sub		#TWait
	bz		TWait
	lac		TMode
	sub		#TSend
	bz		TSend
	dint
	b		$		; error
	.endif

    bacc
;
;**** transmission wait mode ******
;
TWait
    ldpk    #TCptIt
    lac     TCptIt
    bz      $0
; TCptIt>0
    sub     #1      ; decrement TCptIt
    sacl    TCptIt
    b       EndT
; TCptIt=0
$0
    ldpk    #TPtIn
    lac     TPtIn
    ldpk    #TPtOut
    sub     TPtOut
    bz      EndT    ; no data available
; new data to send

; ------- debug
; reccord data send to user
;   .if     TRACE
;   lar     ar0,TPtOut
;   mar     *,ar0
;   out     *,ADBP
;   .endif
; ------- end debug

    lac     #TSend
    ldpk    #TMode
    sacl    TMode   ; mode TSend
; send 
    Send0           ; send bit 0    
    lac     #TSample
    ldpk    #TCptIt
    sacl    TCptIt  ; TCptIt=samples
    zac
    ldpk    #TCptBit
    sacl    TCptBit ; TCptBit=0
    b       EndT
;
;***** transmission send mode *******
;
TSend
    ldpk    #TCptIt
    lac     TCptIt
    sub     #1
    sacl    TCptIt
    bnz     EndT    ; wait for end of bit
; is there bit to send
    lac     #TSample
    sacl    TCptIt
    ldpk    #TCptBit
    lac     TCptBit
    add     #1
    sacl    TCptBit
    sub     #8+1
    bgez    $2      ; 8 bit send
; send bit
    ldpk    #TPtOut
    lar     ar0,TPtOut
    mar     *,ar0
    bit     *,15-0  ; test lsb
    lac     *,15    ; shift
    sach    *
    bbz     $1
; send 1
    Send1
    b       EndT
; send 0
$1
    Send0
    b       EndT
; send stop
$2
    Send1   ; send stop
    lac     #(TSample*7)/8-1  ; 7/8 of a stop bit
    ldpk    #TCptIt
    sacl    TCptIt
    lac     #TWait
    ldpk    #TMode
    sacl    TMode   ; go in wait mode    
    ldpk    #TPtOut ; new pointer
    lac     TPtOut
    add     #1
    sub     #TLast+1
    blz     $3
; after end of buffer
    lac     #TBuffr-(TLast+1) ; go to begin of buffer
$3
    add     #TLast+1
    sacl    TPtOut
; end of transmission routine
EndT

;--------------
;
; reception
;
;--------------
    .newblock

    ldpk    #RMode
    lac     RMode   ; switch on RMode
	
	.if		CBacc
	sub		#RWait
	bz		RWait
	lac		RMode
	sub		#RReceive
	bz		RReceive
	dint
	b		$		; error
	.endif

    bacc
;
; *** reception wait mode ******
;
RWait
    ldpk    #RCptIt
    lac     RCptIt
    bz      $0
; RCptIt
    sub     #1      ; decrement RCptIt
    sacl    RCptIt
    b       EndR
; RCptIt=0
$0
    TestBit         ; TC = value of TX
    bbnz    EndR    ; no start bit
; start bit detected
    lac     #RReceive   ; set mode to receive
    ldpk    #RMode
    sacl    RMode
    lac     #RSample+RSample/2 ; shift of 1.5 bit
    ldpk    #RCptIt
    sacl    RCptIt
    zac             ; zero RCptBit
    ldpk    #RCptBit
    sacl    RCptBit
    ldpk    #RPtIn
    lar     ar0,RPtIn ; zero received data
    mar     *,ar0
    sacl    *
    b       EndR
;
; **** reception data mode *******
;
RReceive
    ldpk    #RCptIt ; is it sampling position
    lac     RCptIt
    sub     #1
    sacl    RCptIt
    bnz     EndR    ; not sampling position
; sampling position
    lac     #RSample    ; waiting time for new sample
;   ldpk    #RCptIt
    sacl    RCptIt
    TestBit         ; TC = value of TX
    ldpk    #RPtIn
    lar     ar0,RPtIn
    lacc    *,15    ; get previous bit
    bbz     $1
    ork     #0100h,15 ; insert a 1
$1
    sach    *       ; store data shifted right
    ldpk    #RCptBit
    lac     RCptBit
    addk    #1
    sacl    RCptBit
    sub     #8
    blz     EndR    ; not enought bit
; it was last bit
    lac     #RWait  ; mode = wait
    ldpk    #RMode
    sacl    RMode
    ldpk    #RPtIn
    lac     RPtIn
    add     #1
    sub     #_RLast
    blez    $2      ; not reach end of buffer
; wrap on end of buffer
    lac     #_RBuffr-_RLast
$2
    add     #_RLast  ; new pointer position
    ldpk    #ItTmp1
    sacl    ItTmp1
    andk    #0FFFFh ; avoid sign extension
    ldpk    #_RPtOut ; compare to RPtIn
    sub     _RPtOut
    bz      EndR    ; overflow
; no overflow
    ldpk    #ItTmp1
    lac     ItTmp1
    ldpk    #RPtIn
    sacl    RPtIn
;
    .if CTSTest = 1
; CTS management
    ldpk    #RPtIn  ; compute number of sample in buffer
    lac     RPtIn
    ldpk    #_RPtOut
    sub     _RPtOut
    bgez    $3
; wrap
    addk    #RSize  ; add buffer size
$3
    subk    #RThres1
    blz     EndR    ; threshold not reached
; reset CTS (stop communication)
    ldpk    #0
;    dint   ; no need because we are under interrupt
    lac     BO
    ork     #CTS    ; (CTS active low)
    sacl    BO
;    eint   ; no need because we are under interrupt
    .endif
;
; end of reception
EndR

;
;**** restore context ****
;
    lar     ar0,#It2Save+2
    mar     *,ar0       
    zals    *-          ; accl +2
    addh    *-          ; acch +1
    lar     ar0,*       ; ar0 +0
    ldpk    #0
    lst1    It2Sst1       ; status1
    lst     It2Sst        ; status
    eint
    ret

;---------------------
;
; int SendData(int data)
; input:
;   data= data to send with UART
; return:
;   0 if OK     ; 1 if buffer full
;
; use AR0,1,2,3,tmp1
; release 0.1 25june97
; 
;---------------------

    .newblock

_SendData
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#0     ; 0 local variable
     LAR     AR0,*0+   ; new ar1
;
    ssxm
    ldpk    #TPtIn      ; compute value of next pointer
    lac     TPtIn
    lar     ar3,TPtIn
    add     #1
    sub     #TLast
    blez    $0
; wrap
    lac     #TBuffr-TLast
$0
    add     #TLast      ; next pointer
    ldpk    #tmp1
    sacl    tmp1        ; save next pointer
    and     #0ffffh     ; clean sign extension
    ldpk    #TPtOut
    sub     TPtOut
    bz      $5          ; no space
; space available, put data in the buffer
; get argument
    lark    ar2,-3      ; offset of argument
    mar     *,ar2
    mar     *0+
    lacc    *,ar3       ; get argument

    sacl    *           ; put data at ar3=TPtIn  

             
    ldpk    #tmp1
    lac     tmp1        ; get new pointer value
    ldpk    #TPtIn
    sacl    TPtIn       ; store new pointer value
    zac                 ; return 0
    b       $6
; no space
$5
    lacc    #0ffffh      ; return -1
; restore
$6
    MAR     *,AR1   ;
    SBRK    #1
    LAR     AR0,*-  ; restore ar0
    PSHD    *
    ret


;---------------------
;
; int ReadData(void)
; return
;  data (>=0) if available  ; -1 if empty
;
; warning: eint
; release 0.2 25june97
; use: ar0,ar1,tmp1
; 
;---------------------

    .newblock

_ReadData
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#0
     LAR     AR0,*0+,AR0 ; new ar1
;
    ssxm
    ldpk    #_RPtOut ; test if available data
    lac     _RPtOut
    ldpk    #RPtIn
    sub     RPtIn
    bz      $4      ; no data available
; data available
    mar     *,ar0   ; get data
    ldpk    #_RPtOut
    lar     ar0,_RPtOut
    lacc    *
    ldpk    #tmp1
    sacl    tmp1    ; save data
    ldpk    #_RPtOut ; compute new pointer
    lacc    _RPtOut
    add     #1
    sub     #_RLast
    blez    $0      ; if not after buffer end
; wrap
    lac     #_RBuffr-_RLast
$0
    add     #_RLast
    sacl    _RPtOut  ; store new pointer
;
    .if     CTSTest = 1
; CTS management
    ldpk    #RPtIn  ; compute nb of sample in buffer
    lac     RPtIn
    ldpk    #_RPtOut
    sub     _RPtOut
    bgez    $1      ; if In after Out
; wrap
    add     #RSize
$1
    sub     #RThres2
    bgz     $2      ; too much data
; CTS enable
    ldpk    #0      ; set CTS to 1
    dint
    lac     BO
    andk    #0FFFFh-CTS
    sacl    BO
    eint
    .endif
;
$2
    ldpk    #tmp1
    lacc    tmp1    ; return data
    andk    #0ffh   ; return positive data
    b       $6      
; no data
$4
    lacc    #0ffffh ; return -1
; restore
$6
     MAR     *,AR1   ;
     SBRK    #1
     LAR     AR0,*-  ; restore ar0
     PSHD    *
    ret