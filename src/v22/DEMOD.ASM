
     .include   "..\msp58c80.i8x"
     .include   "..\global.inc"

; v1.2 20mar98

;----------------------
;
; demodulate one symbol
; 
;----------------------

DemodSymb
    lac     #FifoIn
    ldpk    #ModemIn
    sacl    ModemIn     ; address of first sample
    .newblock
; If receiver in idle mode return to wait state
     LALK    RMMSK
	 ldpk	 #STATUS
     AND     STATUS
     BNZ     $1
; receiver idle
     ldpk    #ModemIn   ; suppress 14 samples
     lac     ModemIn
     add     #14
     sacl    ModemIn
	 b		Move
;
; receive not idle
;
$1
;
; update sine/cosine pointer
;
	bit		STATUS,15-SBit2
	bbz		$3
;2400Hz carrier originate
	lac		RXPHS
	sub		#DCos24+20	; check for looping in table
	blz		$2			; not far enough for looping
	add		#DCos24		; 
	sacl	RXPHS		;cosine
	b		$2
;1200Hz carrier
$3
	lac		RXPHS
	sub		#DCos12+20	; check for looping in table
	blz		$2			; not far enough for looping
	add		#DCos12
	sacl	RXPHS		;cosine
;
; do time recovery
;
$2
     LACK    040h
     AND     STAT2
     BNZ     $5
     LAC     CNVFL
     BZ      $5
     CALL    TMRCV		;
;
$5
	call	Demod1Samp	; demodulate 1 sample

    call    DLUPDT       ; update equalizer
    call    RTSK12       ; interpolate(time) , real equalizer
    call    IFIR         ; imaginary equalizer
    call    RTSK10       ; phase correct and decision 
    call    RTSK9        ; pll, update error

	call	Demod1Samp	; demodulate 1 sample

    call    RTSK8        ; interpolate( equalizer)
;
    call    RUPDT1      ; update equalizer
    call    RUPDT2      ; update equalizer
    call    IUPDT1      ; update equalizer

	call	Demod1Samp	; demodulate 1 sample

    call    RTSK4       ; interpolate(time), update
    call    SXDET       ; sx detect
    call    AGC         ; agc
    call    S1DET       ; s1 detect

	call	Demod1Samp	; demodulate 1 sample

    call    RTSK0       ; update interpolate(equalizer)

;-----------------------
;
; shift sample in buffer
;
;-----------------------
Move
	.newblock
    dint
	ldpk	#0
    sar     ARIn,P0Tmp1 ; save ARIn
    lac     P0Tmp1
    ldpk    #ModemIn
    sub     ModemIn
    sub     #1
    ldpk    #0
    sacl    P0Tmp1		; number of sample to move
    lar     ARIn,#FifoIn ; pointer for destination
    mar     *,ARIn
	ldpk	#ModemIn
	lac		ModemIn
	ldpk	#P0Tmp1
	sub		#FifoIn+13		; number of sample used
;	sub		#13
	blz		$2			; 12 samples
	bz		$1			; 13 samples
; 14 samples
    rpt     P0Tmp1
    blkd    FifoIn+14,*+
	b		$3
; 13 samples
$1
    rpt     P0Tmp1
    blkd    FifoIn+13,*+
	b		$3
; 12 samples
$2
    rpt     P0Tmp1
    blkd    FifoIn+12,*+
; check if enough data available to demodulate again
;
$3
    sar     ARIn,P0Tmp1 ; save ARIn
    lac     P0Tmp1
    sub     #FifoIn+NB_COEFF+14 ; number of sample to transfer -1
    eint
    bgez    DemodSymb      ; enough samples
;
	ret

;----------------------
;
; get one demodulate sample
;
;----------------------
Demod1Samp
	 ldpk	 #ModemIn
	 lar	 ar1,ModemIn
     LARP    AR1
	 ldpk	#TIMIND
	lacc	TIMIND
	add		#3
	blz		IndexNeg	; TIMIND<0
	SACL	TIMIND
	SUB		#9
	BLZ		Index0		; TIMIND<9
;--------------------------
;
; TIMIND >8
; DEMODULATE 4 SAMPLES
;
;--------------------------
	SACL	TIMIND
     bit     STATUS,15-2    ; test originate/answer
	 .newblock
     bbz	$1				; answer
; originate
	call	sOrigin4		; filter
	b		$2
;
$1
	call	sAnswer4		; filter
$2
	sbrk	#4				; back to first sample

;-------------------------
;
;------ demodulate 0
;
;-------------------------

DemoSamp0
; cosine
	lac		RXPHS
	tblr	TMP0			; read cosine
	add		#1
	sacl	RXPHS
	add		RXFRQ
	tblr	TMP4			; read sine
	lt		TMP0
	mpy		*,ar0
	pac
	sach	TMP0,3

	lrlk	ar0,XRM2		; restore filter context
	call	RXIIR			; do filtering
	sach	IR0,5
; sin
     LT      TMP4    ; PREPARE FOR MULTIPLICATION
     MPY     *+,ar0      ; COMPUTE THE QUAD SIGNAL
     PAC             ; TRANSFER TO ACC
     SACH    TMP1,3  ; STORE QUAD COMPONENT IN
;
     LRLK    AR0,XIM2; PREPARE FOR IMAGINARY FILTER
     CALL    RXIIR   ; LOWPASS FILTER THE QUAD
;               COMPONENT
;Update the interpolator imag. delay line
;
	sach	II0,5
;
;------ demodulate 1
;
DemodSamp1
; cosine
	lac		RXPHS
	tblr	TMP0			; read cosine
	add		#1
	sacl	RXPHS
	add		RXFRQ
	tblr	TMP4			; read sine	
	lt		TMP0
	mpy		*,ar0
	pac
	sach	TMP0,3

	lrlk	ar0,XRM2		; restore filter context
	call	RXIIR			; do filtering
	sach	IR1,5
; sin
     LT      TMP4    ; PREPARE FOR MULTIPLICATION
     MPY     *+,ar0      ; COMPUTE THE QUAD SIGNAL
     PAC             ; TRANSFER TO ACC
     SACH    TMP1,3  ; STORE QUAD COMPONENT IN
;
     LRLK    AR0,XIM2; PREPARE FOR IMAGINARY FILTER
     CALL    RXIIR   ; LOWPASS FILTER THE QUAD
;               COMPONENT
;Update the interpolator imag. delay line
;
	sach	II1,5
;
;------ demodulate 2
;
DemodSamp2
; cosine
	lac		RXPHS
	tblr	TMP0			; read cosine
	add		#1
	sacl	RXPHS
	add		RXFRQ
	tblr	TMP4			; read sine	
	lt		TMP0
	mpy		*,ar0
	pac
	sach	TMP0,3

	lrlk	ar0,XRM2		; restore filter context
	call	RXIIR			; do filtering
	sach	IR2,5
; sin
     LT      TMP4    ; PREPARE FOR MULTIPLICATION
     MPY     *+,ar0      ; COMPUTE THE QUAD SIGNAL
     PAC             ; TRANSFER TO ACC
     SACH    TMP1,3  ; STORE QUAD COMPONENT IN
;
     LRLK    AR0,XIM2; PREPARE FOR IMAGINARY FILTER
     CALL    RXIIR   ; LOWPASS FILTER THE QUAD
;               COMPONENT
;Update the interpolator imag. delay line
;
	sach	II2,5
;
;------ demodulate 3
;

; cosine
	lac		RXPHS
	tblr	TMP0			; read cosine
	add		#1
	sacl	RXPHS
	add		RXFRQ
	tblr	TMP4			; read sine	
	lt		TMP0
	mpy		*,ar0
	pac
	sach	TMP0,3

	lrlk	ar0,XRM2		; restore filter context
	call	RXIIR			; do filtering
	sach	IR3,5
; sin
     LT      TMP4    ; PREPARE FOR MULTIPLICATION
     MPY     *+,ar0      ; COMPUTE THE QUAD SIGNAL
     PAC             ; TRANSFER TO ACC
     SACH    TMP1,3  ; STORE QUAD COMPONENT IN
;
     LRLK    AR0,XIM2; PREPARE FOR IMAGINARY FILTER
     CALL    RXIIR   ; LOWPASS FILTER THE QUAD
;               COMPONENT
;Update the interpolator imag. delay line
;
	sach	II3,5
;
	ret


;------------------------
;
; TIMIND <9
; DEMODULATE 3 SAMPLES
;
;------------------------

Index0
     bit     STATUS,15-2    ; test originate/answer
	 .newblock
     bbz	$1
	call	sOrigin3		; filter
	b		$2
;
$1
	call	sAnswer3		; filter
$2
	sbrk	#3				; back to first sample
	lac		IR3
	sacl	IR0
	lac		II3
	sacl	II0
; demodulate 3 samples
	b		DemodSamp1

;-----------------------
;
; TIMIND <0
; DEMODULATE 2 SAMPLES
;
;------------------------

IndexNeg
	ADD		#9
	SACL	TIMIND
     bit     STATUS,15-2    ; test originate/answer
	 .newblock
     bbz	$1				; answer
	call	sOrigin2		; filter
	b		$2
;
$1
	call	sAnswer2		; filter
$2
	sbrk	#2				; back to first sample
	lac		IR2
	sacl	IR0
	lac		IR3
	sacl	IR1
	lac		II2
	sacl	II0
	lac		II3
	sacl	II1
; demodulate 2 samples
	b		DemodSamp2

;--------------
;
; SUBROUTINE FOR FILTERING 4,3,2 SAMPLES
; and AGC, originate filter
; INPUT:
;   PM=0, SIGN EXTENSION ON
;   ar1 ON INPUT SAMPLES
;   DP on ONE
; OUTPUT:
;   ModemIn updated
;   DP on IR0
;
;--------------
sOrigin4
     .newblock
; 0
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cOrigin,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
sOrigin3
; 1
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cOrigin,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
sOrigin2
; 2
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cOrigin,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
; 3
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cOrigin,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
; update modemIn
	ldpk	#ModemIn
	sar		ar1,ModemIn
	ldpk	#IR0

	RET



;--------------
;
; SUBROUTINE FOR FILTERING 4,3,2 SAMPLES
; and AGC, answer filter
; INPUT:
;   PM=0, SIGN EXTENSION ON
;   CURRENT AR ON INPUT SAMPLES
; OUTPUT:
;	CURRENT AR FOR NEXT INPUT SAMPLE
;
;--------------
sAnswer4
     .newblock
; 0
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cAnswer,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
sAnswer3
; 1
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cAnswer,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
sAnswer2
; 2
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cAnswer,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
; 3
     MPYK    0          ;P = 0
     LACC    ONE,15     ;ACCU = rounding
     RPTK    NB_COEFF-1
     MAC     cAnswer,*+  ;MULTIPLY, ACCUM. and  DELAY
     APAC               ;FORM RESULT
     sbrk    #NB_COEFF
	 sach	 *
	 lt		 _ALPHA
	 mpy	 *
	 pac
     sach	 *+,4         ;SAVE OUTPUT
; update modemIn
	ldpk	#ModemIn
	sar		ar1,ModemIn
	ldpk	#IR0

	RET

	.include	"cos.asm"
; 1200 filter 11mar98
cAnswer
     .word     -556
     .word     -437
     .word     -229
     .word      605
     .word      791
     .word      323
     .word     -273
     .word     -376
     .word      130
     .word      231
     .word     -373
     .word     -803
     .word     -380
     .word      401
     .word      190
     .word     -864
     .word     -567
     .word     2148
     .word     4759
     .word     3013
     .word    -3639
     .word    -9438
     .word    -7602
     .word     1841
     .word    10822
     .word    10822
     .word     1841
     .word    -7602
     .word    -9438
     .word    -3639
     .word     3013
     .word     4759
     .word     2148
     .word     -567
     .word     -864
     .word      190
     .word      401
     .word     -380
     .word     -803
     .word     -373
     .word      231
     .word      130
     .word     -376
     .word     -273
     .word      323
     .word      791
     .word      605
     .word     -229
     .word     -437
     .word     -556
; 2400 filter 11mar98
cOrigin
     .word     -321
     .word      231
     .word      187
     .word     -278
     .word     -133
     .word      258
     .word      365
     .word     -324
     .word     -545
     .word      868
     .word      394
     .word    -1029
     .word      242
     .word      337
     .word      139
     .word      737
     .word    -2324
     .word      145
     .word     4978
     .word    -4181
     .word    -4713
     .word     9265
     .word     -142
     .word   -10945
     .word     7076
     .word     7076
     .word   -10945
     .word     -142
     .word     9265
     .word    -4713
     .word    -4181
     .word     4978
     .word      145
     .word    -2324
     .word      737
     .word      139
     .word      337
     .word      242
     .word    -1029
     .word      394
     .word      868
     .word     -545
     .word     -324
     .word      365
     .word      258
     .word     -133
     .word     -278
     .word      187
     .word      231
     .word     -321
