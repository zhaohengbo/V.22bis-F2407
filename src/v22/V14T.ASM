; v14 transmit (towards modulation) routines

; definition of:
;   Get4, Get2, Scramble0, UartTransmit
;   int UartSend(int )
;   int scramble(int )

     .include   "..\msp58c80.i8x"
     .include   "..\global.inc"


;
;****************************
;
; TRANSMIT UART
; DO THE TRANSMIT UART BUFFERING
; send a byte if possible toward V14 and modulation
;
; C callable function
;
; Int V14Send(int Data)
; return:
;   0 if OK, 1 if buffer full
; warning: eint
;
;****************************
;
_V14Send
     POPD    *+      ; STANDARD C START
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#1
     LAR     AR0,*0+,AR0

     dint
     ssxm
     .newblock
;
     LDPK    SEND_IN
     LACC    SEND_IN
     ADD     #1
     SACL    *       ; *ar0, save new SEND_IN
     SUB     #BufferTransLast
     BLEZ    $0      ; no wrap
                     ; WRAP ADDRESS
     LACC    #BufferTrans
     SACL    *       ; *AR0
$0
     LACC    *       ; *AR0
     ldpk    SEND_OUT
     SUB     SEND_OUT
     BNZ     $1      ; OK NOT FULL
     LACC    #1      ; BUFFER FULL
     B       $2      ; END
; BUFFER NOT FULL
$1
                     ; STORE DATA IN BUFFER
     LAR     AR2,#-2-1 ; take 1st argument
     MAR     *,AR2
     MAR     *0+     ; AR2 POINT ON ARGUMENT 1
     LACC    *


     ldpk    SEND_IN
     LAR     AR2,SEND_IN
     SACL    *,AR0   ; put data in buffer
                     ; STORE NEW POINTER
     LACC    *
     SACL    SEND_IN
     ZAC             ; RETURN CODE OK
                     ; END
$2
     .newblock
     eint

     MAR     *,AR1   ; STANDARD C RETURN
     SBRK    #2
     LAR     AR0,*-
     PSHD    *
     RET

;
;***************************
; C callable function
;
; int V14Stat(void)
; return:
;   0 if OK, 1 if buffer full
;
;****************************
;
    .global _V14Stat    
_V14Stat
     .newblock
;
     LDPK    SEND_IN
     LACC    SEND_IN
     ADD     #1
     SUB     #BufferTransLast
     BLEZ    $0      ; no wrap
                     ; WRAP ADDRESS
     LACC    #BufferTrans
     B       $3      
$0
     ADD     #BufferTransLast
$3
     ldpk    SEND_OUT
     SUB     SEND_OUT
     BNZ     $1      ; OK NOT FULL
     LACC    #1      ; BUFFER FULL
     B       $2      ; END
                     ; BUFFER NOT FULL
$1
     ZAC             ; RETURN CODE OK
                     ; END
$2
     RET


;
;*********************
;
; get 4 bit for modulation
; input:
;   nothing
; output:
;   accu = 4 bit  0... badc
;   a=first bit send
;   d=last bit send
;
;*********************
;
Get4
     call    UartTransmit ; get 4 bit from uart in Bit4
                     ; (right, lsb=first to send)
     ldpk    Bit4
     lacc    Bit4
     call    Scramble0
     ldpk    Bit4
     lacc    Bit4
     sfr
     sfr
     call    Scramble0
     ldpk    ScShift1
     lacc    ScShift1
     ldpk    ScShift0
     add     ScShift0,2
     andk    #0fh

     ret

;*********************
;
; get 2 bit for modulation V22
; uses Uart function (4 bit)
; transmits 2x2bits sequentially
; input:
;   nothing
; output:
;   accu = 2 bit  0... ba
;   a=first bit send
;   b=last bit send
;
;*********************
;
Get2
     ldp    #Bit4_V22
     lac    Bit4_V22
     and    #0ff00h         ;mask upper 8 bits => flag
     bnz    next2bits
     call    UartTransmit ; get 4 bits from uart in Bit4
                     ; (right, lsb=first to send)
     ldpk    Bit4
     lacc    Bit4


     ldp    #Bit4_V22
     or     #0ff00h
     sacl   Bit4_V22
     and    #00ffh      ; take Bit0,1 and scramble
     call    Scramble0  
     b      ret2bits
next2bits
     ldp    #Bit4_V22
     lac    Bit4_V22
     and    #00ffh
     sacl   Bit4_V22
     sfr                ; take Bit2,3 and scramble
     sfr     
     call    Scramble0
ret2bits     
     ldpk    ScShift1
     lacc    ScShift1,2
;     andk    #0fh

     ret

;
;********************************
;
; TRANSMIT UART
; DO UART FUNCTION for modulation
;
; Takes 8bits data from buffer (SEND_OUT),
;  adds start and stop and sends 4 bits to modulation (Bit4)
;
; input:
;   nothing
; output:
;   Bit4 with 4 bit (right position, lsb to send first)
;       (x... xxxx dcba)
; modified variables
;  ar2, TxTmp0, SEND_OUT
;  TransCount,
;
;********************************
;
UartTransmit
;
     ldpk    TransCount
     lacc    TransCount
     bnz     Ad108   ; bit remain
;
; no more bit to send
;
     ; look for new data
     ldpk    SEND_IN
     lacc    SEND_IN
     ldpk    SEND_OUT
     sub     SEND_OUT
     bz      Ad106   ; no new data
;
; start new word
;
     lar     ar2,SEND_OUT
     mar     *,ar2
     lacc    *,1     ; add start bit and useful bit
     ork     #0fe00h ; add stop bits
	 b	     Ad116
;
; no new data
;
Ad106
     lacc    #0fh
     ldpk    Bit4
     sacl    Bit4    ; send 1111
     ret
;
; bit remain to send
; Accu=TransCount
;
Ad108
     sub     #4
     bgz     Ad117   ; more than 4 bits remain
;
; less or equal to 4 bit
;
     ; compute new pointer in TxTmp0
     ldpk    #SEND_OUT
     lacc    SEND_OUT
     addk    #1
     ldpk    #TxTmp0
     sacl    TxTmp0
     sub     #BufferTransLast
     blez    Ad109   ; no wrap
     ; wrap pointer
     lacc    #BufferTrans
     ldpk    TxTmp0
     sacl    TxTmp0    ; go to begin of buffer
     ; look for new data
     ; compare SEND_OUT and SEND_IN
Ad109
     ldpk    #SEND_OUT
     lar     ar2,SEND_OUT
     mar     *,ar2
     ldpk    #TxTmp0
     lacc    TxTmp0
     ldpk    SEND_OUT
     sacl    SEND_OUT
     ldpk    SEND_IN
     sub     SEND_IN
     bz      Ad114   ; no new data
;
; start new word
;
     ldpk    #TransCount

	 .if	 CBacc
	 .newblock
     lac     TransCount
	 blz	 $0			; value lower than min
	 sub 	 #4			; max value
	 blez	 $1			; ok
$0
	 dint
	 b		 $			; error
$1
	 .endif

     lac     TransCount
     add     #TransTab1 ; compute address of branch
     ldpk    #TxTmp1
     tblr    TxTmp1
     lacc    TxTmp1
     bacc            ; ar2 = SEND_OUT, larp = ar2
TransTab1
     .word   Ad111   ; no bit = error
     .word   Ad111   ; 1 bit
     .word   Ad112   ; 2 bit
     .word   Ad113   ; 3 bit
     .word   Ad114   ; 4 bit = no new data

MacShift .macro NbBit
; ar2 = SEND_OUT, larp = ar2
     lacc    *       ; (*ar2)
     andk    #( 0ffh >> (8-NbBit) ) ; put other bit to 0
     ldpk    #TxTmp0
     lar     ar2,TxTmp0 ; new pointer value
     sacl    TxTmp0    ; temporary save
     lacc    *,NbBit+1 ; take start bit and new useful bit
     ldpk    #TxTmp0
     or      TxTmp0
     ork     #0ffffh & (0ffffh << (NbBit + 9)) ; add stop bits
     .endm
Ad111
     MacShift 1      ; 1 bit remaining
     b       Ad116
Ad112
     MacShift 2      ; 2 bit remaining
     b       Ad116
Ad113
     MacShift 3      ; 3 bit remaining
; after variable length
Ad116
     .newblock
     sacl    *       ; temporary save
     ldpk    Bit4
     sacl    Bit4    ; save 4 bit for next action
     lacc    *,16-4  ; save other bit
     sach    *
	 ldpk	 #_CID
	 lac	 _CID
	 bnz	 $2		 ; not in V22/V22bis
; check for overspeed
     ldpk    #V14TCpt8
     lac     V14TCpt8
     ldpk    #_V14NbStop
     sub     _V14NbStop
     bgez    $3			; overspeed
; wait for counter
     add     #1
     add     _V14NbStop
     ldpk    V14TCpt8
     sacl    V14TCpt8
; no overspeed
$2   
     ldpk    TransCount
     lacc    TransCount
     add     #9+NbStop-4
     sacl    TransCount
     ret
; overspeed
$3
     ldpk    #V14TCpt8
     zac
     sacl    V14TCpt8   ; clear counter
     ldpk    TransCount
     lacc    TransCount
     add     #9+NbStop-5 ; suppress one stop
     sacl    TransCount
     ret
     
; no new data and number of bit <=4 or 4 bit
; arp=ar2, ar2=SEND_OUT, TxTmp0=next SEND_OUT
Ad114
     lacc    *       ; take remaining bit (with enought stop bit)
     ldpk    Bit4
     sacl    Bit4
     ldpk    #TxTmp0
     lacc    TxTmp0
     ldpk    SEND_OUT
     sacl    SEND_OUT
     zac
     ldpk    TransCount
     sacl    TransCount
     ret
; more than 5 bit
Ad117
     ldpk    SEND_OUT
     lar     ar2,SEND_OUT
     mar     *,ar2
     lacc    *,16-4
     ldpk    Bit4
     sach    Bit4,4  ; save 4 bit to be transmitted
     sach    *       ; save remaining bits
     ldpk    TransCount
     lacc    TransCount
     sub     #4
     sacl    TransCount
     RET

;
;***************************
;
; 2 bit scrambler routine
; C callable
; x=scramble(int y)
; input:
;   y= xxxx xxxx xxxx xxba
; output:
;   x= 0... 00ab
; (a=first transmitted)
;
; modified variables:
;   variables of Scrambler
;
; warning: eint
; release 1.0
;  modif in 1.0
;   ldpk
;
;***************************
;
_scramble
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#0
     LAR     AR0,*0+,ar2 ; new ar1
                     ; get parameter
;       mar     *,ar2
     lark    ar2,#-2-1 ; parameter 1 in accu
     mar     *0+
     lacc    *

;     dint            ; to avoid multiple use of TxTmp0
     call    Scramble0 ; call asm scrambler
;     eint

     ldpk    ScShift1
     lacc    ScShift1
                     ; result in accu
;
     MAR     *,AR1   ;
     SBRK    #1      ; restore ar1
     LAR     AR0,*-  ; restore ar0
     PSHD    *
     RET

;
;***************************
;
; scramble 2 bit with 64 counter
;
; input:
;   2 bit in accu (right position, lsb=first send)
; output:
;   2 bit in ScShift1 (right position, lsb=last send)
; variable modified
;   Scram0, ScShift0, ScShift1
;
;***************************
;
Scramble0
;
; invert 2 bit
;
     andk    #3
     sfl
                     ; accu= 0... 0ba0
     ldpk    #Scram0
     sacl    Scram0
     lacc    Scram0,16 ; accu= 0000 0000 0000 0ba0 0000 ...0
     add     Scram0,14 ; accu= 0000 0000 0000 0bab a000 ...0
     sach    Scram0    ; 0... 0bab
;
; scrambler
;
     lacc    Scram0,13 ; put 2 input bit in position 13-14
     ldpk    ScShift0
     xor     ScShift0 ; xor with bit 13-14 of shift register
     sfr             ; put result in position 12-13
     ldpk    #Scram0
     sacl    Scram0    ; save temporary result in position 12-13
     ldpk    ScShift0
     lacc    ScShift0,2 ; load bit 10-11 in position 12-13
     ldpk    ScShift1
     or      ScShift1 ; add lsb
     ldpk    ScShift0
     sacl    ScShift0 ; store new high part of shift register
     ldpk    #Scram0
     xor     Scram0    ; finish xor in position 12-13
     andk    #03000h ; clear non usefull bit
     ldpk    ScShift1
     sach    ScShift1,4 ; store 2 result bit in lsb position

     ret

