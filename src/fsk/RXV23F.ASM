*==========================================================
* File name:  RX23F.ASM
*----------------------------------------------------------
* Copyright: (c) Copyright Texas Instruments France
*----------------------------------------------------------
*    AR2, AR3 are modified by this routine.
*==========================================================

        .global _InitRXV23,RXV23,_ResetV23			 
        .global _V23REG
        .def    TRIGGER

		.global	V23CCoef

  	  	.global _FSKREG, FSKCOUNT, FSKCHAR, FSKC, AGCTEMP, AGCGAIN, AGCSamp
		.global	_AGCTHRESL, _AGCTHRESH, AGCGAIN, DecCOUNT

		.global AgcFSK, FSKDec

;GAINCL	.set	6100h	; Gain for Calling -44
;GAINCH	.set	6500h	; -47

;GAINAL	.set	5300h	; Gain for Answering -44
;GAINAH	.set	5700h   ; -47


        .include "..\V23.inc"
     	.include "..\msp58c80.i8x"
		.include "..\common.inc"
		.include "..\global.inc"

		.ref	_Modul


        .text
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³  V23 initialisation                                ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_InitRXV23:
		dint
		LDP     #AGCGAIN     ; Initialisation of the page
        ZAC                   ; Initialisation of variables
		SACL    AGCGAIN		  ; gain=0
		SACL	AGCGAIN+1
        SACL    FSKCOUNT         ; count=0
        SACL    FSKC             ; c=0
        LACC    #MEMON        ;
        SACL    _FSKREG        ; mem=1
        LDP		#CID_PAGE
        LRLK    AR3,V23IN     ; Initialisation of BPF upper band
		LARP	AR3	      ;
        RPTK    #BPLEN            ;
        SACL    *+            ;
        LRLK    AR3,ENDXN     ; Initialisation of i(n)
        RPTK    #LPLEN            ;
        SACL    *-            ;
		LAR		AR3,#V23DELAY
		RPT		#5
		SACL	*+				;Init delay line of dephasor
        ldp		#_Modul
        lac		_Modul        ;
		and		#MCalling
		bz		RV23A
;		ldp		#_AGCTHRESL
;		LAC		#GAINCL
;		SACL	_AGCTHRESL
;		LAC		#GAINCH
;		SACL	_AGCTHRESH
		lac		#10
		ldp		#DecCOUNT
		sacl	DecCOUNT		; bit count>>1
		B		EndIniV23
RV23A
        ldp		#SAMPLC
        ZAC
		SACL	SAMPLC
        LAR		AR3,#V23LP0	  ; init LP filter 
		RPT		#LPV23LEN
		SACL	*+
		LDP		#CID_PAGE
		LAC		#V23ZONE
		SACL	TEMPON1
;		ldp		#_AGCTHRESL
;		LAC		#GAINAL
;		SACL	_AGCTHRESL
;		LAC		#GAINAH
;		SACL	_AGCTHRESH
		lac		#40
		ldp		#DecCOUNT
		sacl	DecCOUNT		; bit count>>1
EndIniV23
        eint
        RET                   ;



*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³  V23 reception Routine                                  ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RXV23:	; input sample in ACC
		eint
		ldp		#FromAD
		lac		FromAD
        rsxm
        LDP     #CID_PAGE     ; Initialisation of the page
        SACL    V23IN    
        ldp		#_Modul
        lac		_Modul        ;
		and		#MCalling
		bz		RXV23_75
		LDP		#CID_PAGE
        LRLK    AR2,ENDIN     ; Compute Pass Band filter
		LARP	AR2	      ;
        MPYK    0             ;
        ZAC                   ;
        RPTK    #BPLEN            ;
        MACD    BandPasCoef,*-;
        APAC                  ;
        ldp		#AGCSamp
        SACH    AGCSamp,1          ;

		call	AgcFSK
					  
; End agc	
		ldp		#AGCSamp
		lac		AGCSamp
		ldp		#TN
		sacl	TN

	    MPYK    0             ; Compute the dephasor filter
        ZAC                   ;
        LAC     TN2,12        ;
        LTD     TN1           ; tempo(n)=A1.t(n)+A2.t(n-1)+t(n-2)
        MPY     #2317         ;     - A2.tempo(n-1) - A1.tempo(n-2)
        LTD     TN            ;
        MPY     #655          ;
        LTA     TEMPON2       ;
        MPY     #-655         ;
        LTD     TEMPON1       ;
        MPY     #-2317        ;
        APAC                  ;
        SACH    TEMPON1,4     ;
        LT      TEMPON1       ;
        MPY     TN            ;
        PAC                   ; x(n)=tempo(n)*t(n)
        SACH    XN            ;
                              ;
;        LRLK    AR2,ENDXN     ; Compute the low pass filter
;	LARP	AR2	      ; This same filter perform an oversampling
;        MPYK    0             ; The sampling frequency is 3 times the original
;        ZAC                   ; one.
;        RPTK    14            ;
;        MAC     FirstArray,*- ;
;        APAC                  ;
;        CALL    TRIGGER       ;
;        SACL    OUT1          ;
;        BZ      B6            ;
;        ldp		#_FSKREG
;        LAC     _FSKREG        ;
;        OR      #MEMON        ;
;        B       E6            ;
;B6      ldp		#_FSKREG
;		LAC     _FSKREG        ;
;        AND     #MEMOFF       ;
;E6      SACL    _FSKREG        ;
;        ldp		#CID_PAGE
;        LRLK    AR2,ENDXN     ;
;        MPYK    0             ;
;        ZAC                   ;
;        RPTK    14            ;
;        MAC     SecondArray,*-;
;        APAC                  ;
;        CALL    TRIGGER       ;
;        SACL    OUT2          ;
;        BZ      B7            ;
;        ldp		#_FSKREG
;        LAC     _FSKREG        ;
;        OR      #MEMON        ;
;        B       E7            ;
;B7      ldp		#_FSKREG
;		LAC     _FSKREG        ;
;        AND     #MEMOFF       ;
;E7      SACL    _FSKREG        ;
;                              ;
;        ldp		#CID_PAGE
;        LRLK    AR2,ENDXN     ;
;        MPYK    0             ;
;        ZAC                   ;
;        RPTK    14            ;
;        MACD    ThirdArray,*- ;
;        APAC                  ;
;        CALL    TRIGGER       ;
;        SACL    OUT3          ;
;        BZ      B8            ;
;        ldp		#_FSKREG
;        LAC     _FSKREG        ;
;        OR      #MEMON        ;
;        B       E8            ;
;B8      ldp		#_FSKREG
;		LAC     _FSKREG        ;
;        AND     #MEMOFF       ;
;E8      SACL    _FSKREG        ;

        ldp		#CID_PAGE
        LRLK    AR2,ENDXN     ;
        MPYK    0             ;
        ZAC                   ;
        RPTK    LPLEN            ;
        MACD    LPCoef,*- ;
        APAC                  ;
;debug
;		sach	OUT_SAMPLE,1
;		out		OUT_SAMPLE,ADBP
;end debug        
        CALL    TRIGGER       ;
        SACL    OUT2          ;
        BZ      B8            ;
        ldp		#_FSKREG
        LAC     _FSKREG        ;
        OR      #MEMON        ;
        B       E8            ;
B8      ldp		#_FSKREG
		LAC     _FSKREG        ;
        AND     #MEMOFF       ;
E8      SACL    _FSKREG        ;

; Decision Unit
        SSXM
        LRLK    AR3,OUT2      ;for(i=0;i<3;i++) {
		call	FSKDec

        ssxm
        RET                   ;
;		B	TXV23


TRIGGER:SACH    L             ;
        SACL    L+1           ;
        SSXM                  ;
        SUB     #-100         ;
        RSXM                  ;
        BGZ     B4            ;
        LAC     #0            ;
        RET                   ;
B4:     ZALH    L+0           ;
        ADDS    L+1           ;
        SUB     #100          ;
        BLZ     B5            ;
        LAC     #1            ;
        RET                   ;
B5		ldp		#_FSKREG
	    BIT     _FSKREG,10     ; Test mem bit
        BBZ     B9            ; return this bit value
        LAC     #1            ;
        ldp		#CID_PAGE        
        RET                   ;
B9      ZAC                   ;
        ldp		#CID_PAGE
        RET                   ;
*-----------------------------------------------------------------------

		.ref	V23FIRC, V23COut
RXV23_75:	; input sample in ACC
       .newblock
	   ssxm
        LDP     #CID_PAGE     ; Initialisation of the page
		LAC		V23IN,14

;debug
	.if		TRACE
; 	out		V23IN,ADBP
	.endif
;debug

		CALL	V23FIRC
        ldp		#AGCSamp
        SACH    AGCSamp,0          ;

		call	AgcFSK					  
; End agc
		ldp		#AGCSamp
		lac		AGCSamp
		ldp		#TN
		sacl	TN

		SPM		1	
        LT		TN             ; compute x(n)*x(n-5)
 		MPY		V23DEL5
		PAC
		SACH	V23LP0,1		; dephasor output


;;
;; GENERATE THE EXACT DELAY REQUIRED FOR RECEIVER.
;;
     LAC     TN,15 ; prepare for FIR accumulation
     LT      V23DELAY   ; State of one zero FIR filter
     MPY     #B1COEF   ; Mult by coefficient
     APAC            ;; output of one zero FIR filter
     BV      RSOVFLAG  ;; RESET OVERFLOW FLAG
RSOVFLAG: .equ $       ;;
     SACH    V23DELAY,1 ; store at next stage of delay line


;update delay line
		LAR		AR2, #V23DELAY+4
		MAR		*, AR2
		RPT		#4
		DMOV	*-			    ; x(n-i)=x(n-i+1), i=2,3,4,5,6
		LAC		TN
		SACL	V23DELAY		; x(n-1)=x(n)

; undersampling 2 kHz
		LAC		SAMPLC
		ADD		#1
		SACL	SAMPLC
		SUB		#4
		BLZ		V23EndD
		ZAC
		SACL	SAMPLC

		
; compute low pass filter 
		SPM		0
		LAR		AR2,#V23LPL
		MPYK	0				;P = 0
   		ZAC						;ACC = 0
		RPTK	LPV23LEN
		MACD	LPV23Coef,*-	;MULTIPLY, ACCUM. and  DELAY
		APAC					;FORM RESULT
		SACH    OUT_SAMPLE,0	;SAVE OUTPUT


;Decision;  Slicer with dead zone in middle (window comparator)


     LAC	OUT_SAMPLE
     ABS             ;
     SUB     TEMPON1   ;
     BLZ     DDONE    ;
;;
;;
;; FOR V.23, NEGATIVE SIGNAL MEANS THAT WE HAVE RECEIVED A 0
;; AND A POSITIVE SIGNAL MEANS THAT WE HAVE A 1.
;;
ITSV23       ;
     LAC     OUT_SAMPLE  ;
     BLEZ    LOW0     ;
     LACK    1       ; SET BAUD_DATA TO 1
     B       StoreBit    ;
LOW0 LACK    0       ; SET BAUD_DATA TO 0
     B       StoreBit
DDONE
     ldp	 #_FSKREG     
     BIT     _FSKREG,10     ; Test mem bit
     BBZ     B0_0            ; return this bit value
     LAC     #1            ;
     B       StoreBit                   ;
B0_0 ZAC                   ;
StoreBit
     ldp	 #CID_PAGE     
     SACL    OUT1  ;
;
     BZ      BIT_0            ;
     ldp	 #_FSKREG     
     LAC     _FSKREG        ;
     OR      #MEMON        ;
     B       BIT_1            ;
BIT_0
     ldp	 #_FSKREG     
     LAC     _FSKREG        ;
     AND     #~MEMON       ;
BIT_1
	 SACL    _FSKREG        ;

     LRLK    AR3,OUT1      ;

	call	FSKDec

V23EndD
     
     RET                   ;
     
     ;	B	TXV23


