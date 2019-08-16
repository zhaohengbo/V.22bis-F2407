; modul.asm
; transmit function



    .global CCI, ENCODE, Modul
    .global _Guard,_TGGain
    .include "..\msp58c80.i8x"
    .include "..\global.inc"
	.include "cos12_24.tbl"

	.ref	ModulSeq

PGuard  .usect  "mpage4",1  ; pointer for guard tone table

Modul
    ldpk    #begin4
    CALL    CCI         ;CALL   COMMAND INTERPRETER; 3 stacks
    CALL    ENCODE      ;UPDATE TRANSMITTER SAMPLES

    ldpk    #begin4
	lac		NbSamp
	sub		#1
	sacl	NbSamp		; NbSamp-1 for rpt-instruction
    bit     STATUS,15-SBit5
    bbz     IdleModul   ; ******* to be finished  ; idle
    bit     STATUS,15-SBit1
    bbz     EndModul    ; fsk
    bit     STATUS,15-SBit2
    bbnz    MCalling    ; originate

; QAM modulation
; answer 2400 Hz + guard
;       cos 	 sin
; (0)=   .987	-.156
; (1)=   -.453	-.891  
; (2)=   -.707 	.707
; (3)=   .891	.453  
; (4)=   .156	-.987
; (5)=   -.987	.156  
; (6)=   .453	.891
; (7)=   .707	-.707  
; (8)=	 -.891	-.453
; (9)=	 -.156	.987
; 
;---- read 13 or 14 cos	values
	lar		ar1,#CosBuf
	mar		*,ar0

	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		MAnswer1

MAnswer0
    lac     #Tab1800
    sacl    PGuard
;read 14 values
	lar		ar0,#SinBuf+13
	lac		#COSTBL2+6
	rpt		#13
	tblr	*-
	mar		*,ar1
	lac		#COSTBL2
	rpt		#13
	tblr	*+
	b		MULXA
MAnswer1
	bit		ModulSeq,15-1
	bbnz	MAnswer2

	lac		PGuard
	add		#14			; set pointer to Guard tone table
	sacl	PGuard
;read 13 values
	lar		ar0,#SinBuf+12
	lac		#COSTBL2+3
	rpt		#12
	tblr	*-
	mar		*,ar1
	lac		#COSTBL2+4
	rpt		#12
	tblr	*+
	b		MULXA
MAnswer2
	lac		PGuard
	add		#13			; set pointer to Guard tone table
	sacl	PGuard
;read 13 values
	lar		ar0,#SinBuf+12
	lac		#COSTBL2
	rpt		#12
	tblr	*-
	mar		*,ar1
	lac		#COSTBL2+7
	rpt		#12
	tblr	*+

MULXA
	call 	MULX
		
;---- guard tone
    ldpk    #_Guard
    lac     _Guard
    ldpk    #begin4
    sub     #32h    ; at&g2
    bnz     MulGain ; no guard tone
; read table
AGuard
; copy guard values
	lar		ar1,#SinBuf
    lac     PGuard
    mar     *,ar1
    rpt     NbSamp
    tblr    *+
	lar		ar1,#SinBuf
	ldp		#ModemOut
	lar		ar0,ModemOut

; add guard values
    ldpk    #_TGGain
    lt      _TGGain
    			        ; ARC  AR0 AR1
    mar     *,ar0       ;      S0  G0
    lac     *,16,ar1    ; 0 S0
    mpy     *+          ; 1 G0     G1
    mpya    *+,ar0      ; 1 G1     G2
    sach    *+          ; 0 S0 S1
    lac     *,16,ar1    ; 0 S1
    mpya    *+,ar0      ; 1 G2     G3
    sach    *+          ; 0 S1 S2
    lac     *,16,ar1    ; 0	S2
    mpya    *+,ar0      ; 1 G3     G4
    sach    *+          ; 0 S2 S3
    lac     *,16,ar1    ; 0	S3
    mpya    *+,ar0      ; 1 G4     G5
    sach    *+          ; 0 S3 S4
    lac     *,16,ar1    ; 0	S4
    mpya    *+,ar0      ; 1 G5     G6
    sach    *+          ; 0 S4 S5
    lac     *,16,ar1    ; 0	S5
    mpya    *+,ar0      ; 1 G6     G7
    sach    *+          ; 0 S5 S6
    lac     *,16,ar1    ; 0	S6
    mpya    *+,ar0      ; 1 G7     G8
    sach    *+          ; 0 S6 S7
    lac     *,16,ar1    ; 0	S7
    mpya    *+,ar0      ; 1 G8     G9
    sach    *+          ; 0 S7 S8
    lac     *,16,ar1    ; 0	S8
    mpya    *+,ar0      ; 1 G9     G10
    sach    *+          ; 0 S8 S9
    lac     *,16,ar1    ; 0	S9
    mpya    *+,ar0      ; 1 G10    G11
    sach    *+          ; 0 S9 S10
    lac     *,16,ar1    ; 0	S10
    mpya    *+,ar0      ; 1 G11    G12
    sach    *+          ; 0 S10 S11
    lac     *,16,ar1    ; 0	S11
    mpya    *+,ar0      ; 1 G12    G13
    sach    *+          ; 0 S11 S12
    lac     *,16,ar1    ; 0	S12
    mpya    *+,ar0      ; 1 G13    G14
    sach    *+          ; 0 S12 S13
	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		MulGain
    lac     *,16        ; 0	S13
    apac                ; 0	  
    sach    *+          ; 0 S13 S14

;    sbrk    #14
    b       MulGain
    
; QAM modulation
; calling carrier 1200 Hz
;        cos 	 sin
; (0)=   .987	-.156
; (1)=   .453	-.891  
; (2)=   -.453	-.891  
; (3)=   -.987	-.156  
; (4)=   -.707 	.707
; (5)=   .156	.987
; (6)=   .891	.453  
; (7)=	 .891	-.453
; (8)=   .156	-.987
; (9)=   -.707	-.707  
; (10)=   -.987	.156  
; (11)=   -.453	.891
; (12)=   .453	.891
; (13)=   .987	.156
; (14)=   .707	-.707  
; (15)=	 -.156	-.987
; (16)=	 -.891	-.453
; (17)=	 -.891	.453
; (18)=	 -.156	.987
; (19)=   .707	.707  

MCalling
	lar		ar0,#SinBuf
	lar		ar1,#CosBuf
	mar		*,ar0
	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		MCalling1
MCalling0
;read 14 values
	lac		#COSTBL1+1
	rpt		#13
	tblr	*+
	mar		*,ar1
	lac		#COSTBL1+6
	rpt		#13
	tblr	*+
	b		MULXC
MCalling1
	bit		ModulSeq,15-1
	bbnz	MCalling2
;read 13 values
	lac		#COSTBL1+15
	rpt		#12
	tblr	*+
	mar		*,ar1
	lac		#COSTBL1
	rpt		#12
	tblr	*+
	b		MULXC
MCalling2
;read 13 values
	lac		#COSTBL1+8
	rpt		#12
	tblr	*+
	mar		*,ar1
	lac		#COSTBL1+13
	rpt		#12
	tblr	*+
MULXC
   	call	MULX

; ----- appli gain
; ar -> sample 0
    .global _TVGain
MulGain
	ldp		#ModemOut
	lar		ar0,ModemOut
    ldpk    #_TVGain
;   lac     #1900h  ; 1900h -10.1dBm
;   sacl    TxTmp1
;   lt      TxTmp1
    lt      _TVGain
    ldpk    #begin4
    spm     2       ; <<4
    mpy     *
    sph     *+      ; 0
    mpy     *
    sph     *+      ; 1
    mpy     *
    sph     *+      ; 2
    mpy     *
    sph     *+      ; 3
    mpy     *
    sph     *+      ; 4
    mpy     *
    sph     *+      ; 5
    mpy     *
    sph     *+      ; 6
    mpy     *
    sph     *+      ; 7
    mpy     *
    sph     *+      ; 8
    mpy     *
    sph     *+      ; 9
    mpy     *
    sph     *+      ; 10
    mpy     *
    sph     *+      ; 11
    mpy     *
    sph     *+      ; 12
	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		EndModul
    mpy     *
    sph     *+      ; 13
EndModul
    spm     0       ;
    ret

; send sample 0
IdleModul
    ldpk    #ModemOut
    lar     ar0,ModemOut ; pointer on output buffer
    mar     *,ar0
    zac
	ldp		#NbSamp
    rpt     NbSamp
    sacl    *+  
    ret


MULX
;ModemOut[i]=PtCos[i]*CosBuf[i]+PtSin[i]*SinBuf[i],	i=0,1,...,13 or i=0,1,...,12
; first multiply by cosine, store result in CosBuf
	ldp		#ModemOut
	lar		ar0,ModemOut
	mar		*,ar0
	ldp		#PtCos
	lac		PtCos
	rpt		NbSamp
	tblr	*+
	lar		ar1,#CosBuf
	ldp		#ModemOut
	lar		ar0,ModemOut
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;0
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;1
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;2
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;3
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;4
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;5
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;6
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;7
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;8
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;9
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;10
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;11
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;12
	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		ComputeSin
	lt		*+,ar1
	mpy		*
	sph		*+,ar0		;13		only used for ModulSeq=1

;	now compute sine and add cosine, store result in ModemOut
ComputeSin
	spm		0
	ldp		#ModemOut
	lar		ar0,ModemOut
	ldp		#PtSin
	lac		PtSin
	rpt		NbSamp
	tblr	*+
	ldp		#ModemOut
	lar		ar0,ModemOut
	lar		ar1,#SinBuf
	lar		ar2,#CosBuf
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;0
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;1
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;2
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;3
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;4
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;5
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;6
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;7
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;8
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;9
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;10
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;11
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;12
	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		ComputeEnd
	lt		*,ar1
	mpy		*+,ar2
	pac
	addh	*+,ar0
	sach	*+			;13
ComputeEnd
	ret


; table for guard tone
; sampling: 9600Hz   Tone: %.0Hz   Amplitude: %4X
Tab1800
	.word	0
	.word	32363
	.word	10125
	.word	-29195
	.word	-19259
	.word	23169
	.word	26509
	.word	-14875
	.word	-31163
	.word	5125
	.word	32767
	.word	5125
	.word	-31163
	.word	-14875
	.word	26509
	.word	23169
	.word	-19259
	.word	-29195
	.word	10125
	.word	32363
	.word	0
	.word	-32363
	.word	-10125
	.word	29195
	.word	19259
	.word	-23169
	.word	-26509
	.word	14875
	.word	31163
	.word	-5125
	.word	-32767
	.word	-5125
	.word	31163
	.word	14875
	.word	-26509
	.word	-23169
	.word	19259
	.word	29195
	.word	-10125
	.word	-32363
; End of guard tone table
