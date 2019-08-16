;--------------------------------------------------------
;
;       CONTROLLER COMMAND INTERPRETER (CCI)
;
;--------------------------------------------------------
;

    .global CCI
CCI
     ldpk    UartStatus ; test uart mode
     lacc    UartStatus
     andk    #RecOn
     .newblock
     bz      $1      ; not in uart mode
; uart mode
     ldpk    #_speed
     lac    _speed
     sub    #1200
     bnz    $0
; 1200
     call   Get2
     ldpk   #XDATA
     sacl   XDATA
     b      DMOD1
; 2400
$0
     call    Get4    ; call uart and scrambler for 4 bits in accu (dcba)
     ldpk    #XDATA
     sacl    XDATA   ; save uart data
     b       DMOD2

; not in uart mode
$1
; manage command fifo
     LDPK    #Cmd1
     LAC     Cmd1
     ANDK    #07fffh   ; signal command read
     SACL    Cmd1	   ; clear msb
     LDPK    XDATA
     SACL    XDATA
; shift command
     ldpk    #Cmd2
     lac     Cmd2
     bgez    $2
     ldpk    #Cmd1
     sacl    Cmd1
     ldpk    #Cmd2
     zac
     sacl    Cmd2
;
$2
     .newblock
	 ldpk	 #XDATA
     LACK    0F0h
     AND     XDATA   ;MASK OFF 4 LSBS OF COMMAND
     SACL    TxTmp2

     LAC     TxTmp2,12 ;COMMAND BITS TO ACCH LSBS
     SACH    TxTmp2
;
;NOW THE ACCUMULATOR VALUE CORRESPONDS TO THE FOLLOWING
;COMMANDS AND CORRESPONDING SERVICE SUBROUTINES
;
;CHECK FIRST IF RECEIVER IS IN DATA MODE. IN WHICH CASE
;IGNORE ALL COMMANDS EXCEPT >2X,>1X AND >00.
;
     LALK    RMMSK   ;REC. MODE MASK
     AND     STATUS
     SUB     ONE,7   ;CHECK IF BITS 7 AND 6
     SUB     ONE,6   ;ARE ONES
     BNZ     CCI1
;
;REC. IN DATA MODE => IGNORE COMMANDS > 2
;
     LAC     TxTmp2
     SUB     ONE,2
     BLEZ    CCI1    ;IF COMMAND LARGER THAN >2
NONE
     RET             ;EXIT COMMAND INTERPRETER.
;
;CALL THE APPROPRIATE SERVICE SUBROUTINE
;(REFER TO CMDTBL TABLE).
;
CCI1
	 lac	TxTmp2

	 .if	CBacc
	 .newblock
	 blz	$0		; lower than min
	 sub	#0fh
	 bgz	$0		; higher than max
	 add	#0fh
	 b		$1
$0
	 dint
	 b		$		; error
$1
	 .endif

	 add	#CMDTBL
     TBLR    TxTmp2    ;READ ADDRESSS FROM TABLE
     LAC     TxTmp2    ;LOAD SUB. ADDR. INTO ACC.

     BACC            ; call service routine  
;
;------------------------------------------------------;
;------------------------------------------------------;
;                                                      ;
;       COMMAND INTERPRETER SUBROUTINES                ;
;                                                      ;
;------------------------------------------------------;
;------------------------------------------------------;
;
;------------------------------------------------------
;       PROTOCOL SELECT COMMAND
;
PROTO:
;
;EXTRACT TWO LSB'S OF COMMAND
;
     LACK    03h     ;MASK OFF BITS 2 AND 3
     AND     XDATA   ;OF COMMAND
;
;SET SPEED BITS STATUS REGISTER:
;       BITS 1 AND 0 = 00 FOR 300 BPS (FSK)
;                    = 01 FOR 600 BPS
;                    = 10 FOR 1200 BPS
;                    = 11 FOR 2400 BPS
;
     SACL    TxTmp1
     LACK    0FCh
     AND     STATUS  ;ZERO BITS 0 AND 1
     ADD     TxTmp1
;
;CHECK FOR ANSWER/ORIGINATE MODES
;
	 bit	 XDATA,15-3
	 bbz	 PROTO3		; test originate/answer
; set mode to calling
     andk    #~AnswerMask
     sacl    STATUS      
;
     LAC     #DSmC12
     SACL    RXFRQ   ; shift in table
     lac     #DCos12
     sacl    RXPHS
	 ret
PROTO3
; set mode to originate
     ork     #AnswerMask
     sacl    STATUS
;
     LAC     #DSmC24
     SACL    RXFRQ   ; shift in table
     lac     #DCos24
     sacl    RXPHS
     RET
;


;
;----------------------------------------------------------
;       TRANSMITTER MODE SELECT
;
XMODE
     LACK    03h     ;MASK OFF BITS 2 AND 3
     AND     XDATA
     SACL    TxTmp1    ;SAVE MODE BITS TO SET STATUS
;
;SET THE TRANSMITTER MODE BITS IN STATUS REGISTER.
;
     LALK    NTXMSK  
     AND     STATUS      ; ZERO THE TX STATUS BITS
     ADD     TxTmp1,TXSH ;ADD TX STATUS BITS IN RIGHT POS.
     SACL    STATUS
     RET
;
;------------------------------------------------------------
;       RECEIVER MODE SELECT
;
;
;SET THE RECEIVER STATUS BITS (BITS 6 AND 7) OF STATUS
;REGISTER TO;    00 IF RECEIVER IS IDLE
;                01 FOR CALL PROGRESS MONITORING
;                10 FOR DATA MODE
;
RMODE
     LACK    03h     ;MASK OFF BITS 2 AND 3
     AND     XDATA
     SACL    TxTmp1
     LALK    NRCMSK  ;NEG. OF REC. BITS MASK
     AND     STATUS  ;ZERO REC. STATUS BITS
     ADD     TxTmp1,RCSH ;ADD REC STATUS IN RIGHT POS.
     SACL    STATUS
     RET
;
;------------------------------------------------------------
;       DATA MODE 1
;
; CHANGE TO 4-WAY DECISIONING
; STORE TRANSMITTER BITS IN XBITS REGISTER
;
DMOD1
     LACK    0Fh
     AND     XDATA   ;MASK OFF COMMAND BITS
     SACL    XBITS
     LALK    NSPMSK  ;ZERO SPEED BITS OF
     AND     STATUS  ;STATUS REGISTER
     ADD     ONE,1   ;SET SPEED TO 1200
     SACL    STATUS
     RET
;
;------------------------------------------------------------
;       DATA MODE 2
;
; CHANGE TO 16-WAY DECISIONING
; STORE TRANSMITTER BITS IN XBITS REGISTER
;
DMOD2
     LACK    0Fh
     AND     XDATA   ;MASK OFF COMMAND BITS
     SACL    XBITS
     LALK    NSPMSK  ;ZERO SPEED BITS OF
     AND     STATUS  ;STATUS REGISTER
     ADDK    #3		 ;SET SPEED TO 2400
     SACL    STATUS
     RET

;
;------------------------------------------------------------
;
;       Reset and equalizer enable routines
;;
RESET
    lac     #TimeDelay
     SACL    IRCNT   
     RET
;
;
; 2. EQUALIZER TAP COEFF. UPDATE DISABLE/ENABLE.
;       AT40 => disable update (set CNVFL to 0)
;       AT41 => enable upate (set CNVFL to 1)
EQUEN
     LACK    0Fh
     AND     XDATA
     SACL    CNVFL
     RET
;
;------------------------------------------------------------
;------------------------------------------------------------
; END CONTROLLER COMMAND INTERPRETER SUBROUTINES
;------------------------------------------------------------
;------------------------------------------------------------


;
; void SendCmd(int Cmd)
;
    .newblock
    .global _SendCmd
_SendCmd
     POPD    *+      ; save context and set ar0,ar1
     SAR     AR0,*+
     SAR     AR1,*
     LARK    AR0,#0     ; 0 local variable
     LAR     AR0,*0+   ; new ar1

; get argument
    lark    ar2,-3      ; offset of argument
    mar     *,ar2
    mar     *0+         ; argument pointer
    lacc    *,ar3       ; argument
    ork     #08000h     ; set msb
; check for one Cmd empty
$0
    eint				; need 2 instructions before dint (c2xx)
	ldpk    #Cmd1
	nop
    dint
    bit     Cmd1,15-15
    bbnz    $1          ; Cmd1 full
; Cmd1 empty
    sacl    Cmd1
    b       $3          ; end of operation
; Cmd1 full 
$1
    ldpk    #Cmd2
    bit     Cmd2,15-15
    bbnz    $0          ; wait for Cmd empty
; Cmd2 empty
    sacl    Cmd2
; restore
$3
    eint
    MAR     *,AR1   ;
    SBRK    #1
    LAR     AR0,*-  ; restore ar0
    PSHD    *
    ret