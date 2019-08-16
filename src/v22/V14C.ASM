; v14 common 

     .include   "..\msp58c80.i8x"
     .include   "..\global.inc"
;
;**************
;
; void InitScram(void)
; Initialize scrambler, descrambler and uart
; warning: eint
;
;**************
;
_InitScram
;
     dint
;
     zac
     ldpk    D1803   ; receive shift register = 0
     SACL    D1803   ; high part of shift register
     ldpk    D0201
     SACL    D0201   ; low part of shift register
     ldpk    CPT64
     sacl    CPT64
     ldpk    UartStatus
     SACL    UartStatus ; not in uart mode
     ldpk    ScShift0
     sacl    ScShift0
     ldpk    ScShift1
     sacl    ScShift1
     ldpk    ScCount64
     sacl    ScCount64

     LACC    #BufferTrans
     ldpk    SEND_IN
     SACL    SEND_IN
     ldpk    SEND_OUT
     SACL    SEND_OUT
     ldpk    #V14TCpt8
     sacl    V14TCpt8
;
     eint
     RET

;
;**************
;
; Start and initialize receive uart
; void StartUart(void)
; warning: eint
;
;**************
;
_StartUart
;
     dint
     call    StartUart0
;
     ldpk    UartStatus
     lacc    UartStatus
     andk    #0ffffh - FLAG1 ; reset overflow
     ork     #RecOn          ; enable uart
     sacl    UartStatus
;
     eint
;
     RET


;
;**************
;
; Start and initialize receive uart
; no DINT
;
;**************
;

StartUart0
;
     ZAC
     ldpk    TransCount
     sacl    TransCount

     ldpk    Bit4_V22
     sacl    Bit4_V22

     LACC    #RecUartWait ; receive uart wait for start bit
     ldpk    STATE
     SACL    STATE

     LACC    #FIRST_OUT
     ldpk    OUT
     SACL    OUT
     ldpk    IN
     SACL    IN
;
     RET


