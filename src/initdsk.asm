; initdsk.asm
; 24 juil 98 v0.5


    .include    "pathway.inc"

	.global		It2Sst,It2Sst1,It2Save




PMST    .set    0ffe4h      ; memory control register
PON     .set    2           ; PON bit
DON     .set    4           ; DON bit

SSPCFG1 .set    04000h      ; settings for the SSPCR (in reset)
SSPCFG2 .set    04030h      ; settings for the SSPCR (out of reset)


AicFlag .usect  "Aic",1     ; 0 no command to send
                            ; 1 command to send wait for 1st transmit int
                            ; 2 wait for 2nd transmit int
AicCmd  .usect  "Aic",1     ; command to send to AIC
Y1      .usect  "Aic",1
Y2      .usect  "Aic",1


; Init of C2xx after reset
InitDsk
    dint
    ssxm
    sovm


    ldp     #TMP1
    splk    #PON | DON,TMP1 ; enable internal 4K ram
	out		TMP1,PMST
    splk    #0000h, TMP1    ; 
    out     TMP1, WSGR      ; Set all wait states to zero

    ; uart
	splk	#208h,TMP1
	out		TMP1,BRD		; baud rate for 2400bit/s
	splk	#188h,TMP1
	out		TMP1,ASPCR		; reset serial
	splk	#2088h,TMP1
	out		TMP1,ASPCR		; start serial
	splk	#66f8h,TMP1
	out		TMP1,IOSR		; set misc. bit

    ; set up the Sync Serial Port
    splk    #0, TMP1  		; place the ssp into reset and set it
    out     TMP1, SSPCR     ; up for continuous mode operation.
    splk    #XRST+RRST, TMP1
    out     TMP1, SSPCR     ; take the ssp out of reset
    
    ; reset the AIC so any old setting get wiped out
    in      TMP1, IOSR      ; read IOSR
    lacl    TMP1            ; acc = TMP1
    and     #0fff7h         ; make IO3 = 0
    sacl    TMP1            ; store acc to TMP1
    out     TMP1, IOSR      ; write to IOSR, put AIC in reset

    in      TMP1, IOSR      ; read IOSR
    lacl    TMP1            ; acc = TMP1
    or      #08h            ; make IO3 = 1
    sacl    TMP1            ; store acc to TMP1
    out     TMP1, IOSR      ; write to IOSR, take AIC out of reset
    ldp     #AicFlag
    zac
    sacl    AicFlag         ; no command to send
        
    ; timer
    ldp     #TMP1
    splk    #10h,TMP1
    out     TMP1,TCR        ; stop timer
    splk    #2000-1,TMP1    ; 2000-1 ->1ms
    out     TMP1,PRD
    splk    #0029h,TMP1     ; 0029 free=0 soft=0 trb=1 tddr=9 ->2Mhz
    out     TMP1,TCR

    ; second table vector
    ldp     #10h            ; page for 800h
    splk    #07980h,06h
    splk    #TintIsr,07h    ; Tint
    splk    #07980h,08h
    splk    #RintIsr,09h    ; Rint

    ; interrupt
    ldp     #0
;   lacc    #EN_TINT| EN_RINT| EN_XINT  ; XINT RINT TINT enabled

    lacc    #EN_TINT| EN_RINT        ; RINT enabled

    sacl    IMR
	b		Reset



;Xint


; TintIsr   Timer
TintIsr
; context saving

    sst     It2Sst       ; status
    sst1    It2Sst1      ; status 1
    ldpk    #It2Save     ; ar0
    sar     ar0,It2Save  ; ar0 +0    
    lar     ar0,#It2Save+1    
    mar     *,ar0
    sach    *+          ; accuh +1
    sacl    *+          ; accul +2

;
; ----- transmit asynchronous serial
;

	ldp		#Y2
	in		Y2,IOSR
	bit		Y2,15-11		; THRE bit
	bcnd	Tint10,NTC		; transmit not empty
; transmit empty
    ldpk    #TPtIn
    lac     TPtIn
    ldpk    #TPtOut
    sub     TPtOut
    bz      Tint10    ; no data available
; send a data
	ldp		#TPtOut
	lar		ar0,TPtOut
	mar		*,ar0
	out		*,ADTR	
; new pointer
    lac     TPtOut
    add     #1
    sub     #TLast+1
    blz     Tint3
; after end of buffer
;    lac     #TBuffr-(TLast+1) ; go to begin of buffer
	lac		#TBuffr
	sub		#TLast
	sub		#1
Tint3
    add     #TLast+1
    sacl    TPtOut
; end of transmission routine
Tint10

;
; ----- receive asynchronous serial
;
	ldp		#Y2
	in		Y2,IOSR
	bit		Y2,15-8			; DR bit
	bcnd	Tint20,NTC		; no data received
; get data
	ldp		#RPtIn
	lar		ar0,RPtIn
	mar		*,ar0
	in		*,ADTR			; get data
; pointer management
    lac     RPtIn
    add     #1
    sub     #_RLast
    blez    Tint12      ; not reach end of buffer
; wrap on end of buffer
;    lac     #_RBuffr-_RLast
    lac     #_RBuffr
    sub		#_RLast
Tint12
    add     #_RLast  ; new pointer position
    ldpk    #ItTmp1
    sacl    ItTmp1
    andk    #0FFFFh ; avoid sign extension
    ldpk    #_RPtOut ; compare to RPtIn
    sub     _RPtOut
    bz      Tint20    ; overflow
; no overflow
    ldpk    #ItTmp1
    lac     ItTmp1
    ldpk    #RPtIn
    sacl    RPtIn
;
Tint20


; restore context
    lar     ar0,#It2Save+2
    mar     *,ar0       
    zals    *-          ; accl +2
    addh    *-          ; acch +1
    lar     ar0,*       ; ar0 +0
    ldpk    #0
    lst1    It2Sst1       ; status1
    lst     It2Sst        ; status

    clrc    intm            ; re-enable global interrupts
    ret                     ; return to caller



