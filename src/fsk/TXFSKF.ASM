     .include   "..\msp58c80.i8x"		  
     .include   "..\global.inc"
	 .include	"..\common.inc"


	.def 	TXV21, TXV23
	.def	_InitTXV21, _InitTXV23

	.def 	SinGenFSK, Sin1, Sin2
;	.ref	UartTransmit
	.ref	Bit4
	.def	TXData, TXFreq, TXPhase
	.ref	FromAD,ForDA
	.ref	_Modul

	.ref	V21FIRA, V21FIRC, V23FIRC
	.ref	V21A_D0, V21C_D0
	.ref	V23C_D0
	.ref	V21AOut, V21COut, V23COut

;	.ref	Dtmf
	.def	_TXGain

	.ref	_Ampl2

	.global	V23IN, ENDIN
	.global BandPasCoef
	.global End_V21, End_V23

	.global	StartUart0, _InitScram


FSKCntr		.usect	"FSK",1
FSKFreq		.usect	"FSK",1
TXFreq		.usect	"FSK",1
TXPhase		.usect	"FSK",1
TXData		.usect	"FSK",1
BitMask		.usect	"FSK",1
OldBit		.usect	"FSK",1
ErrFlag		.usect	"FSK",1
_TXGain		.usect	"FSK",1

Sin1		.usect	"SIN",1
Sin2		.usect	"SIN",1
One			.usect	"SIN",1



;TXGain		.set	250h ;920h		; transmit gain -> -12 dBm
;TXGainV21A	.set	450h
;TXGainV21C	.set	450h
;TXGainV23A	.set	800h
;TXGainV23C	.set	450h
FirstBit	.set	0001h
LastBit		.set	0010h


;-------------------------------------------
; Transmit routine for V21 (FSK modulator)
;-------------------------------------------
; mode answering or calling (mode set in InitV21)
TXV21
;	ldp		#UartStatus
;	lac		UartStatus
;	and		#RecOn
;	bz		uart_off1
	ldp		#FSKCntr
	lac		FSKCntr		; counter at 24 kHz
	add		#3
	sacl	FSKCntr
	sub		#80
	blz		FSKEnd
	sacl	FSKCntr		; counter=error (either 0, 1 or 2)
	ldp		#BitMask
	lac		BitMask
	and		#LastBit
	bz		MoreBits
	call	Get1		; get next 4 bits for modulation
	lac		#FirstBit
;	ldp		#BitMask
	sacl	BitMask
MoreBits
	call	SetFSK		; init delta freq. for bit 0 or 1
;	ldp		#BitMask
	lac		BitMask		; update BitMask for next bit to send
	sfl
	sacl	BitMask
FSKEnd
	call	TXFSK		; generate tone	
	b		V21Filt
;uart_off1
;	call	Dtmf		; carrier emission during protocol
V21Filt
	ldp		#_Modul
	lac		_Modul
	and		#MCalling
	ldp		#ForDA
	bnz		V21Call
	lac		ForDA,14
	call	V21FIRA		; bandpass filter at transmission for upper band
	b		V21End
V21Call
	lac		ForDA,14
	call	V21FIRC		; bandpass filter for lower band
V21End		
	ldp		#ForDA
	sach	ForDA,0
;	ret	
	b		End_V21


;---------------------------------
; extract bits from UART
; 4 bits are extracted: ....dcba
; a (LSB) is the first bit to send
; d is the last bit to send
;---------------------------------
Get1
	call	UartTransmit		; UartTransmit uses ar2
	ldp		#Bit4
	lac		Bit4
	ldp		#TXData
	sacl	TXData
	dint
	ret



;--------------------------------------------------
; init delta f (f0, f1) depending on extracted bit
;--------------------------------------------------
SetFSK
	ldp		#BitMask
	lac		BitMask		; extracted bit is contained in bit
 ;	ldp		#TXData		; specified by BitMask (either 0,1,2 or 3)
	and		TXData	 
 ;	ldp		#FSKFreq
	bz		SendB0
	lac		FSKFreq
 ;	ldp		#TXFreq
	tblr	TXFreq
	ret
SendB0
	lac		FSKFreq
	add		#1
 ;	ldp		#TXFreq
	tblr	TXFreq
	ret



;-----------------------------
; Init V21 modem
;-----------------------------
_InitTXV21
	dint
	zac
	ldp		#_Ampl2
	sacl	_Ampl2
	ldp		#TXPhase
	sacl	TXPhase
;	ldp		#UartStatus
;enable Uart
;    lacc    UartStatus
;    andk    #0ffffh - FLAG1 ; reset overflow
;    ork     #RecOn          ; enable uart	
;
;	sacl	UartStatus
	lac		#77			; 77+3=80, Get1 called immediately
	ldp		#FSKCntr
	sacl	FSKCntr
	ldp		#BitMask
	lac		#LastBit	; Get1 must be called immediately
	sacl	BitMask		; BitMask=1 (first bit to send)
	MAR		*,AR3
	LAR		AR3,#V21A_D0	;POINTER TO DELAY MEMORY
	ZAC			
	RPTK	037
	SACL	*+				;CLEAR DELAY MEMORY
	LAR		AR3,#V21C_D0	;POINTER TO DELAY MEMORY
	ZAC			
	RPTK	037
	SACL	*+				;CLEAR DELAY MEMORY
	ldp		#_Modul
	lac		_Modul
	and		#MCalling
	ldp		#FSKFreq
	bz		V21Answer
	lac		#V21FRQ		; init FSKFreq with pointer to table
	sacl	FSKFreq		; for V21 calling
;	lac		#TXGainV21C
;	ldp		#_TXGain
;	sacl	_TXGain
	b		EndInit		
V21Answer
	lac		#V21FRQ+2	; table offset for V21 answering
	sacl	FSKFreq
;	lac		#TXGainV21A
;	ldp		#_TXGain
;	sacl	_TXGain
EndInit
    call    StartUart0
    call    _InitScram  ; warning eint
	eint
	ret


; frequency table V21 calling and answering at 8kHz
V21FRQ
	.word	1f5ch		;  980 Hz -> "1" Calling
	.word	25c2h		; 1180 Hz -> "0" Calling
	.word	34cch		; 1650 Hz -> "1" Answering
	.word	3b33h		; 1850 Hz -> "0" Answering


;-----------------------------------------------------------------------------


;-------------------------------------------
; Transmit routine for V23 (FSK modulator)
;-------------------------------------------

TXV23
;	ldp		#UartStatus
;	lac		UartStatus
;	and		#RecOn
;	bz		uart_off2	
	ldp		#_Modul
	lac		_Modul
	and		#MCalling
	bnz		TXV23Call	; branch to calling
; V23 answering 1200 bauds
	ldp		#FSKCntr
	lac		FSKCntr		; counter at 24 kHz
	add		#3
	sacl	FSKCntr
	sub		#20
	blz		V23End
	sacl	FSKCntr		; counter=error (either 0, 1 or 2)
	ldp		#BitMask
	lac		BitMask
	sfl
	sacl	BitMask
	lac		BitMask
	and		#LastBit
	bz		More_Bits
	call	Get1		; get next 4 bits for modulation
	lac		#FirstBit
	ldp		#BitMask
	sacl	BitMask
More_Bits
	call	SetFSK		; init delta freq. for bit 0 or 1
V23End
	call	TXFSK		; generate tone
no_correct
	ldp		#ForDA
	lac		ForDA,14

	LDP		#V23IN
    sach	V23IN
;    LRLK    AR2,ENDIN     ; Compute Pass Band filter
;	LARP	AR2	      ;
;    MPYK    0             ;
;    ZAC                   ;
;    RPTK    30            ;
;    MACD    BandPasCoef,*-;
;    APAC                  ;
    LRLK    AR2,V23IN+19     ; Compute Pass Band filter
	LARP	AR2	      ;
    MPYK    0             ;
    ZAC                   ;
    RPTK    19            ;
    MACD    BP_TXV23_H,*-;
    APAC                  ;
	ldp		#ForDA
    SACH    ForDA,1          ;

;	ret	
	b		End_V23



; V23 calling 75 bauds
TXV23Call
	ldp		#FSKCntr
	lac		FSKCntr		; counter at 24 kHz
	add		#3
	sacl	FSKCntr
	sub		#320
	blz		FSKEndC
	sacl	FSKCntr		; counter=error (either 0, 1 or 2)
	ldp		#BitMask
	lac		BitMask
	sfl
	sacl	BitMask
	lac		BitMask
	and		#LastBit
	bz		MoreBitsC
	call	Get1		; get next 4 bits for modulation
	lac		#FirstBit
	ldp		#BitMask
	sacl	BitMask
MoreBitsC
	call	SetFSK	; init delta freq. for bit 0 or 1
	ldp		#BitMask
	lac		BitMask		; update BitMask for next bit to send
	ldp		#TXData
	and		TXData
FSKEndC
	call	TXFSK		; generate tone
FilterC
	ldp		#ForDA
	lac		ForDA,14
;	call	V23FIRC		; bandpass filter for lower band
 	ldp		#V23C_D0
	sach	V23C_D0
    LRLK    AR2,V23C_D0+33     ; Compute Pass Band filter
	LARP	AR2	      ;
    MPYK    0             ;
    ZAC                   ;
    RPTK    33            ;
    MACD    BP_TXV23_L,*-;
    APAC                  ;
	ldp		#ForDA
    SACH    ForDA,1          ;
	ldp		#ForDA
	sach	ForDA,0
;	ret	
	b		End_V23

;uart_off2				; if Uart off do carrier emission by tone generation
;	call	Dtmf
;	ldp		#_Modul
;	lac		_Modul
;	and		#MCalling
;	bz		no_correct		; branch to bandpass filter for upper band
;	b		FilterC			; branch to bandpass filter for lower band



;-----------------------------
; Init V23 modem
;-----------------------------
_InitTXV23
	dint
	zac
	ldp		#_Ampl2
	sacl	_Ampl2
	ldp		#TXPhase
	sacl	TXPhase
	ldp		#ErrFlag
	sacl	ErrFlag
;enable UART
;	ldp		#UartStatus
;    lacc    UartStatus
;    andk    #0ffffh - FLAG1 ; reset overflow
;    ork     #RecOn          ; enable uart	
;	sacl	UartStatus
;
	MAR		*,AR3
;	LAR		AR3,#V23IN	;POINTER TO DELAY MEMORY
;	ZAC			
;	RPTK	030
;	SACL	*+				;CLEAR DELAY MEMORY
	LAR		AR3,#V23C_D0	;POINTER TO DELAY MEMORY
	ZAC			
	RPTK	041
	SACL	*+				;CLEAR DELAY MEMORY
	ldp		#_Modul
	lac		_Modul
	and		#MCalling
	bz		InitV23Ans
	lac		#V23FRQ	; table offset for V23 calling
	ldp		#FSKFreq
	sacl	FSKFreq
;	lac		#TXGainV23C
;	ldp		#_TXGain
;	sacl	_TXGain
	lac		#317			; init sample counter so that no error at beginning
	b		ContV23Ini
InitV23Ans	
	lac		#V23FRQ+2	; table offset for V23 answering
	ldp		#FSKFreq
	sacl	FSKFreq
;	lac		#TXGainV23A
;	ldp		#_TXGain
;	sacl	_TXGain
	lac		#17
ContV23Ini
	ldp		#FSKCntr
	sacl	FSKCntr
	ldp		#BitMask
	lac		#0008h
	sacl	BitMask		; BitMask=1000b (get next bits to send)
    call    StartUart0
    call    _InitScram  ; warning eint
	eint
	ret


V23FRQ
; V23 frequency table calling at 8kHz
	.word	0c7bh	; 390 Hz
	.word	0e66h	; 450 Hz
; V23 frequency table answering at 8kHz
	.word	299ah	; 1300 Hz	
	.word	4333h	; 2100 Hz

;V23ERR1
;	.word	3222h	; 1567 Hz	Error correction for bit=1
;	.word	3aabh	; 1833 Hz

;V23ERR0
;	.word	3aabh	; 1833 Hz	Error correction for bit=0
;	.word	3222h	; 1567 Hz





;---------------------------------------------------------------
; generate tone according to bit value (common routine V21, V23)
;---------------------------------------------------------------
TXFSK
	spm		1
	ldp		#TXPhase
	zals	TXPhase
	call	SinGenFSK	; result in TMP3

	lac		Sin1,15
	ldp		#ForDA
	sach	ForDA
	lt		ForDA	; multiply by transmit gain
	ldp		#_TXGain
	mpy		_TXGain
	pac
	ldp		#ForDA
	sach	ForDA,4


	ldp		#TXPhase	; update phase
	zals	TXPhase
	adds	TXFreq
	sacl	TXPhase
	ret


;________________________________________________________________________________
;
;       SUBROUTINE      :       SinGenFSK
;       PURPOSE         :       SINE GENERATION
;
;       TASK    :       GIVEN A COSINE TABLE WITH 257 VALUES
;                       AND START ADDRESS COSOFF, AND GIVEN AN
;                       ANGLE INDEX IN THE ACCUMULATOR, DETERMINE
;                       THE SINE OF THE ANGLE.
;
;       ENTRY CONDITION :       THE ANGLE INDEX MUST BE IN THE
;                               LOWER ACCUMULATOR; 0=0  7fff=8000=PI  ffff=2*PI
;
;       EXIT CONDITION  :       THE SINE OF THE ANGLE IS RETURNED
;                               IN TEMPORARY LOCATION TMP3.
;
;       DESCRIPTION     :       THE COSINE LOOKUP TABLE CONTAINS
;                               257 VALUES WITH;
;
;               COS[0] = 1.0    AND     COS[256] = -1.0
;
;       HENCE ANGLE INDEX 0 MAPS TO  ANGLE 0 AND ANGLE INDEX 256 MAPS
;       TO PI.  THE SINE VALUE IS GENERATED BY SUBTRACTING FROM THE ANGLE
;       INDEX THE INDEX CORRESPONDING TO PI/2, TAKING THE ABSOLUTE VALUE,
;       AND HENCE FORMING AN ADDRESS INTO THE LOOKUP TABLE.
;
; No of cycles: 17
; No of stack levels used: 1
;
;
;       THE ANGLE INDEX IS THE LOWER ACCUMULATOR
;
; ANGLE INDEX HAS S15.0 FORMAT. MUST SUBTRACT PI/2 VALUE WHICH LAYS
; AT THE MIDDLE OF THE TABLE AND HAS SS14.0 FORMAT AS VIEWED IN S15.0 FORMAT
;________________________________________________________________________________


SinGenFSK
	 ldp	 #One
     SUB     One,14  ; SUBTRACT INDEX OF PI/2
	 ldp	 #Sin1
     SACL    Sin1    ; PUT AWAY TEMPORARILY
     ZALH    Sin1    ; PREPARE FOR ABSOLUTE VALUE
     ABS             ; TAKE ABSOLUTE VALUE
     SACH    Sin1    ; PUT AWAY BEFORE RIGHT SHIFT
;
; THE VALUE STORED IN Sin1 HAS S15.0 FORMAT -- ALBEIT A POSITIVE NUMBER
;
; A LEFT SHIFT OF 9 BITS CORRESPONDS TO 8S24.0 FORMAT AND SAVING THE
; HIGH ACCUMULATOR HAS A 8S8.0 FORMAT
;
     LAC     Sin1,9  ; ISOLATE 8 MSB'S IN HIGH ACC
     SACH    Sin1    ; PUT AWAY THE 8 MSB'S TEMPORARILY
;
;
;       THE NEXT THREE INSTRUCTIONS ELIMINATE
;       ANY SIGN EXTENSION BITS THAT MIGHT HAVE PROPAGATED
;
     LAC     Sin1
     ABS
     SACL    Sin1
;
;       FORM THE FINAL LOOK-UP ADDRESS
;
; BRING IN THE ADDRESS OFFSET.
;
; THE BASE ADDRESS IS IN 8S8.0 FORMAT, WHILE THE INDEX IS ALSO IN
; 8S8.0 FORMAT.
;
     LALK    COSOFF  ;
     ADD     Sin1    ; FORM FINAL LOOK-UP ADDRESS
     TBLR    Sin1    ; READ SINE VALUE INTO Sin1
     RET
;




BP_TXV23_H
	.word	   -792	;C019
	.word	   -145	;C018
	.word	   -277	;C017
	.word	  -1532	;C016
	.word	   2350	;C015
	.word	   8031	;C014
	.word	   -475	;C013
	.word	 -15752	;C012
	.word	  -7967	;C011
	.word	  16269	;C010
	.word	  16269	;C009
	.word	  -7967	;C008
	.word	 -15752	;C007
	.word	   -475	;C006
	.word	   8031	;C005
	.word	   2350	;C004
	.word	  -1532	;C003
	.word	   -277	;C002
	.word	   -145	;C001
	.word	   -792	;C000


BP_TXV23_L
	.word	  1157	;C033
	.word	   290	;C032
	.word	  -132	;C031
	.word	  -936	;C030
	.word	 -2083	;C029
	.word	 -3431	;C028
	.word	 -4748	;C027
	.word	 -5747	;C026
	.word	 -6133	;C025
	.word	 -5674  ;C024
	.word	 -4263	;C023
	.word	 -1965	;C022
	.word	   986	;C021
	.word	  4199	;C020
	.word	  7204	;C019
	.word	  9528	;C018
	.word	 10795	;C017
	.word	 10795	;C016
	.word	  9528	;C015
	.word	  7204	;C014
	.word	  4199	;C013
	.word	   986	;C012
	.word	 -1965	;C011
	.word	 -4263	;C010
	.word	 -5674	;C009
	.word	 -6133	;C008
	.word	 -5747	;C007
	.word	 -4748	;C006
	.word	 -3431	;C005
	.word	 -2083	;C004
	.word	  -936	;C003
	.word	  -132	;C002
	.word	   290	;C001
	.word	  1157	;C000
