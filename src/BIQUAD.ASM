	.def	CPTD
	.ref	RIN,TMP1
	.def	_CptdFilter,_DialFilter,_AnswerFilter, _V23Filter, _V21Filter
	.ref	FromAD,ForDA
	.def	_TotIn, _TotOut
	.def	_MinEng
	.def	_FiltFunc
	.def	_InitFiltFunc
	.def	_DialShift, _DialIn, _DialOut, _DialThreshold, _DialMin
	.def	_AnswerShift, _AnswerIn, _AnswerOut, _AnswerThreshold
	.def	_V23Shift, _V23In, _V23Out, _V23Threshold
	.def	_V21Shift, _V21In, _V21Out, _V21Threshold
	.ref	_DtmfFlag

	.def	BusyFilt

	.ref	notch

	
	.include "msp58c80.i8x"
	.include "common.inc"
	.include "global.inc"
;--------------------------------
;
; BIQUAD
; INDEXED
; y(n)=B0x(n)+d1(n-1)
; d1(n)=B1x(n)-A1y(n)+d2(n-1)
; d2(n)=B2x(n)-A2y(n)			
;
; INPUT:
;	TMP1 contains scaled input sample
;   ARP -> AR1		  AR0 -> DNM1
;   AR1 -> B0		  PM=1 (<<1)
;   SSXM			  
; OUTPUT
;   ARP -> AR1		  AR0 -> DNM1
;	AR1 -> B0
; MODIFIED
;   AR0, AR1
;   
; 42 cycles
;----------------------------------
; DATA ORGANIZATION:
;D1NM1	.BSS	; AR0
;D2NM1	.BSS
;B0		.BSS	; AR1
;B1		.BSS
;A1		.BSS
;A2		.BSS
;B2		.BSS
BIQUAD
; all filter coefficients Q14
;*
;* SECOND-ORDER FILTER SECTION
;*
	ldp		#TMP1
	LT		TMP1		;GET SCALED INPUT
	MPY		*+,ar0		;P = B0 * INPUT
	lac		*+,15,ar1	;AC = Z-1
	MPYA	*+,ar0		;AC = Z-1 + (B0 * INPUT)
;						;P = B1 * INPUT
	ldp		#Output
	SACH	Output,1	;Save in OUTPUT
	LTP		Output		;AC = B1 * INPUT 
	ADD		*-,15,ar1 	;AC = Z-2 + (B1 * INPUT)
	MPY		*+			;P = A1 * OUTPUT
	APAC
	MPY		*+,ar0		;AC = Z-2 + (B1 * INPUT) + (A1 * OUTPUT)
;						;P = A2 * OUTPUT
	SACH	*+,1,ar1	;Save in Z-1
	ldp		#TMP1
	LTP		TMP1		;AC = A2 * OUTPUT
	MPY		*+,ar0		;P = B2 * INPUT
	APAC				;AC = (B2 * INPUT) + (A2 * OUTPUT)
 	SACH	*+,1,ar1	;Save in Z-2

	ldp		#Output
	lac		Output
	ldp		#TMP1
	sacl	TMP1

	LT		TMP1		;GET SCALED INPUT
	MPY		*+,ar0		;P = B0 * INPUT
	lac		*+,15,ar1	;AC = Z-1
	MPYA	*+,ar0		;AC = Z-1 + (B0 * INPUT)
;						;P = B1 * INPUT
	ldp		#Output
	SACH	Output,1	;Save in OUTPUT
	LTP		Output		;AC = B1 * INPUT 
	ADD		*-,15,ar1	;AC = Z-2 + (B1 * INPUT)
	MPY		*+			;P = A1 * OUTPUT
	APAC
	MPY		*+,ar0		;AC = Z-2 + (B1 * INPUT) + (A1 * OUTPUT)
;						;P = A2 * OUTPUT
	SACH	*+,1,ar1	;Save in Z-1
	ldp		#TMP1
	LTP		TMP1		;AC = A2 * OUTPUT
	MPY		*+,ar0		;P = B2 * INPUT
	APAC				;AC = (B2 * INPUT) + (A2 * OUTPUT)
 	SACH	*+,1,ar1	;Save in Z-2

	ret


overfl	b overfl
;------------------
;
; macro for a filter
; 25 cycles
;
;-----------------

Filter	.macro	Name
	.NEWBLOCK
	ldp		#_:Name:Shift
	lt		_:Name:Shift
	LDPK	#FromAD
;	LACT	FromAD		; load input sample with specified shift
	mpy		FromAD
	pac
	LDPK	#TMP1
; MULTIPLY INPUT BY GAIN
	SACH	TMP1

	
; SET POINTERS
	LAR		AR0,#_:Name:Filter
	spm		1
	MAR		*,AR0	; AR0 -> d1(n-1)
	LARK	AR1,#4
	MAR		*,AR1
	MAR		*0+,AR1	; AR1 -> B0

	CALL	BIQUAD

	ldp		#Output
	lac		Output		; accumulate absolute value of 5 input samples
	abs
	ldp		#_:Name:In
	add		_:Name:In
	sacl	_:Name:In
	sub		#MaxVal
	blz		$1
	lac		#MaxVal
	sacl	_:Name:In
$1


	.endm



;------------------
;
; CPTD FILTER
; 85 cycles per filter + 40 cycles
; = 4 * 85 + 40 (max) = 380
;------------------
CPTD
	SPM		1
	sovm	
; DIAL TONE
	ldp		#FromAD
	lac		FromAD,15		; accumulate absolute value of n=3 input samples
	sach	FromAD
	lac		FromAD
	abs
	ldp		#_TotIn
	add		_TotIn
	sacl	_TotIn
	sub		#MaxVal
	blz		no_clip
	lac		#MaxVal
	sacl	_TotIn
no_clip
	eint
	Filter	Dial
	Filter	Answer
;	Filter	V21
;	Filter	V23

	ldp		#_FiltFunc
	lac		_FiltFunc
	cala

	rovm
	ret


;-----------------
; Inits FiltFunc
; called by InitDial()
;-----------------
_InitFiltFunc
	ldp		#_FiltFunc
	lac		#TotExp
	sacl    _FiltFunc
	zac
	sacl	TotMax
	sacl	DialTim
	sacl	Detect
	sacl	DialShFlag	
	ret


;-----------------------------------------------------
; Macro for calculation of the exponential filter based on the 
; sum of 5 ABS(input sample)
; Comparison of the global output to the filtered (biquad) output
; if (global <= factor * filtered) then DETECTION
;
; This comparison is not carried out if 
; 1) the minimum global energy is below the threshold MinEng
; 2) the energy after filtering is below the noise threshold of the filter
; 3) the global energy decreases to 0.5 * Max, indicating a
;		transition on/off
;
; 40 cycles
;-----------------------------------------------------
TestOut	.macro	Name
	.newblock
	ldp		#_:Name:Out
	zalr	_:Name:Out	; ROUNDING
	add		_:Name:In,16-6 ; 1/64							   
	SUB		_:Name:Out,16-6
	SACH	_:Name:Out

	lac		_TotOut			; check min. thres.
	sub		_MinEng
	blez	$4

	lac		_TotOut,1		; TotOut > 0.5*TotMax ?
	sub		TotMax
	blez	$3
			
	lac		_:Name:Out		; noise due to filter
	sub		#:Name:Min
	blez	$4

	lac		_TotOut,4
; Totout<<4 - (factor * FilterOut)<<1
	lt		_:Name:Threshold
	mpy		_:Name:Out
	spac
	BLZ		$1
; UNDER THRESHOLD
$3
	lac		Detect
	and		#:Name:Mask
	bz		$4
	lar		AR0,#_:Name:Filter
	mar		*,ar0
	zac
	sacl	*+			; clear D11(N-1) 
	sacl	*+			; clear D12(N-1)
	sacl	*+			; clear D21(N-1)
	sacl	*			; clear D22(N-1)
	sacl	_:Name:Out
	sacl	TotMax
$4	
	LALK	#~:Name:Mask
	and		Detect
	sacl	Detect
	ldp		#_CptdFilter
	AND		_CptdFilter
	B		$2
; OVER THRESHOLD
$1	
	lac		_TotOut
	sub		TotMax
	blez	$5
	lac		_TotOut			; look for maximum
	sacl	TotMax
$5
	LALK	#:Name:Mask
	or		Detect
	sacl	Detect
	OR		_CptdFilter
;
$2
	SACL	_CptdFilter
	zac		
	sacl	_:Name:In

	.endm


;-------------------
; exponential filter for global signal
;-------------------
TotExp
	lac		#DialExp
	sacl	_FiltFunc
	zalr	_TotOut		; ROUNDING
	ldp		#_TotIn
	add		_TotIn,16-6	; 1/64							   
	LDPK	#_TotOut
	SUB		_TotOut,16-6
	SACH	_TotOut
	ldp		#_TotIn
	zac		
	sacl	_TotIn
	ret

;-------------------
; exponential filter for signal after Dialfilter
;-------------------
DialExp
	lac		#AnswerExp
	sacl	_FiltFunc

	TestOut	Dial

	ret
;	b		no_shift
; increment Shift for input sample (dial filter) when input
; level too low
;	ldp		#DialShFlag
;	lac		DialShFlag
;	and		#0001h
;	bnz		no_shift
;	ldp		#_CptdFilter
;	lac		_CptdFilter
;	and		#DialMask
;	bz		no_DialDet
;	ldp		#_TotOut
;	lac		_TotOut
;	sub		_DialMin
;	bgz 	resetTim
;wait4stableCond	
;	ldp		#DialTim
;	lac		DialTim
;	add		#1
;	sacl	DialTim
;	sub		#480		;60 ms
;	blz		no_shift
;	lac		#1
;	ldp		#DialShFlag
;	sacl	DialShFlag
;;	zalh	_DialShift
;;	add		_DialShift,15
;;	sach	_DialShift
;	lac		_DialShift,1
;	sacl	_DialShift
;resetTim
;	zac
;	ldp		#DialTim
;	sacl	DialTim
;no_shift
;	ret

;no_DialDet
;	ldp		#_DtmfFlag
;	lac		_DtmfFlag
;	bnz		resetTim
;	ldp		#_DialOut
;	lac		_DialOut
;	sub		#DialShiftMin
;	blez 	resetTim
;	lac		_TotOut
;	sub		_DialOut
;	blez	resetTim
;	ldp		#_TotOut
;	lac		_TotOut
;	sub		_DialMin
;	bgz 	resetTim
;	b		wait4stableCond




;-------------------
; exponential filter for signal after Answerfilter
;-------------------
AnswerExp
;	lac		#V23Exp
	ldp		#_FiltFunc
	lac		#TotExp
	sacl	_FiltFunc

	TestOut	Answer
	ret

;-------------------
; exponential filter for signal after V23 filter
;-------------------
V23Exp
	lac		#V21Exp
	sacl	_FiltFunc

	TestOut	V23
	ret

;-------------------
; exponential filter for signal after V21 filter
;-------------------
V21Exp
	lac		#TotExp
	sacl	_FiltFunc

	TestOut	V21
	ret
	

;--------------------------
; Active during emission of calling tone
;--------------------------
BusyFilt
	SPM		1
	sovm	
; BUSY TONE
	call	notch,*,ar1	; 1300 Hz rejection
	ldp		#FromAD
	
	lac		FromAD		; accumulate absolute value of input sample
	abs
	ldp		#_TotIn
	add		_TotIn
	sacl	_TotIn
noClip

	Filter	Dial
	Filter 	Answer

	call	TotExp
	call	DialExp
	call	AnswerExp

	rovm
	ret




_DialFilter		.usect	"Filter",14
_AnswerFilter 	.usect "Filter",14
_V21Filter		.usect	"Filter",14
_V23Filter		.usect	"Filter",14

_DialThreshold 		.usect "Filter",1
_AnswerThreshold	 .usect "Filter",1
_V23Threshold 		.usect "Filter",1
_V21Threshold 		.usect "Filter",1



_CptdFilter	.usect	"Filter",1

Output		.usect	"Filter",1

_TotIn		.usect	"Filter",1
_TotOut		.usect	"Filter",1
_DialIn		.usect	"Filter",1
_DialOut	.usect	"Filter",1
_DialShift	.usect	"Filter",1
_DialMin	.usect	"Filter",1
DialShFlag	.usect	"Filter",1
_AnswerIn 	.usect	"Filter",1
_AnswerOut	.usect	"Filter",1
_AnswerShift	.usect	"Filter",1
_V23In		.usect	"Filter",1
_V23Out		.usect	"Filter",1
_V23Shift	.usect	"Filter",1
_V21In		.usect	"Filter",1
_V21Out		.usect	"Filter",1
_V21Shift	.usect	"Filter",1


_MinEng		.usect	"Filter",1
_FiltFunc	.usect	"Filter",1
Detect		.usect	"Filter",1
TotMax		.usect	"Filter",1
DialTim		.usect	"Filter",1


MaxVal		.set	7fffh

DialShiftMin .set	50h

; residual noise in filters 
DialMin		.set	50h
AnswerMin	.set	2ah
V23Min		.set	30h
V21Min		.set	30h


__