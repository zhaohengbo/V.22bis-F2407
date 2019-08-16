
LPV23LEN	.set	14		; LPF length low band
V23ZONE		.set	50h		; dead zone for slicer
B1COEF		.set	-3356	; Q14, coef. for FIR (1+b1(z-1))
LPLEN		.set	18		; LPF length high band
BPLEN		.set	30		; BPF length high band

		.global	_AGCV23L, _AGCV23H
		.global	V23IN, ENDIN
		.global BandPasCoef
		.global	TXV23

; zone of 5 variables to avoid overlay with mpage4_1
xxxx1	.usect		"X51",5
xxxx2	.usect		"X52",5
xxxx3	.usect		"X53",5
xxxx4	.usect		"X54",5

*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³  Variables                                              ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CID_PAGE         .usect "V23",0	 ; Start of page jlma
TEMP2			 .usect "V23",1	 ;jlma
OUTCHAR         .usect "V23",1  ; 
OUT_SAMPLE      .usect "V23",1  ; 
TEMP            .usect "V23",1  ; 
TEMP1           .usect "V23",1  ; 
OUT1            .usect "V23",1  ; 
OUT2            .usect "V23",1  ; 
OUT3            .usect "V23",1  ; 
Y               .usect "V23",1  ; 
L               .usect "V23",2  ; 
X               .usect "V23",1  ; 
IN_SAMPLE       .usect "V23",1  ; 
XN              .usect "V23",LPLEN ;   low pass filter upper band
ENDXN           .usect "V23",2  ; 
TEMPON1         .usect "V23",1  ; 
TEMPON2         .usect "V23",1  ; 
TN              .usect "V23",1  ; 
TN1             .usect "V23",1  ; 
TN2             .usect "V23",1  ; 
V23IN           .usect "V23",BPLEN ; band pass filter upper band 
ENDIN           .usect "V23",2  ; 
V23DELAY		.usect "V23",5  ; delay line V23 75 demodulator
V23DEL5			.usect "V23",1
SAMPLC			.usect "V23",1	; undersampling counter
V23LP0			.usect "V23",LPV23LEN ; low pass filter delay lower band
V23LPL			.usect "V23",2


; Constant use for the bit manipulation in the V23REG register
CHARON          .set    0001h
CARRIERON       .set    0002h
OLDCARON        .set    0004h
STARTON         .set    0008h
STOPON          .set    0010h
MEMON           .set    0020h

CHAROFF         .set    0FFFEh
CARRIEROFF      .set    0FFFDh
OLDCAROFF       .set    0FFFBh
STARTOFF        .set    0FFF7h
STOPOFF         .set    0FFEFh
MEMOFF          .set    0FFDFh



        .text

BandPasCoef:
        .word   139
        .word   516           ;  Band Pass filter coefficients
        .word   -62           ;  quantitizied coeff Q15
        .word   -396          ;  Characteristic of this filter
        .word   150           ;  in file BPV232.FLT
        .word   -574
        .word   -1563
        .word    666
        .word   2397
        .word   306
        .word   482
        .word   1876
        .word   -4287
        .word   -8446
        .word   2744
        .word   12394
        .word   2744
        .word   -8446
        .word   -4287
        .word   1876
        .word   482
        .word   306
        .word   2397
        .word   666
        .word   -1563
        .word   -574
        .word   150
        .word   -396
        .word   -62
        .word   516
        .word   139




; low pass filter low band
LPV23Coef:
	.word	   617	;C014
	.word	  1782	;C013
	.word	  3804	;C012
	.word	  6596	;C011
	.word	  9802	;C010
	.word	 12829	;C009
	.word	 15004	;C008
	.word	 15796	;C007
	.word	 15004	;C006
	.word	 12829	;C005
	.word	  9802	;C004
	.word	  6596	;C003
	.word	  3804	;C002
	.word	  1782	;C001
	.word	   617	;C000


;	.word	   238	;C038
;	.word	   671	;C037
;	.word	   793	;C036
;	.word	  1357	;C035
;	.word	  1881	;C034
;	.word	  2617	;C033
;	.word	  3444	;C032
;	.word	  4416	;C031
;	.word	  5490	;C030
;	.word	  6659	;C029
;	.word	  7889	;C028
;	.word	  9149	;C027
;	.word	 10399	;C026
;	.word	 11599	;C025
;	.word	 12704	;C024
;	.word	 13675	;C023
;	.word	 14474	;C022
;	.word	 15069	;C021
;	.word	 15436	;C020
;	.word	 15560	;C019
;	.word	 15436	;C018
;	.word	 15069	;C017
;	.word	 14474	;C016
;	.word	 13675	;C015
;	.word	 12704	;C014
;	.word	 11599	;C013
;	.word	 10399	;C012
;	.word	  9149	;C011
;	.word	  7889	;C010
;	.word	  6659	;C009
;	.word	  5490	;C008
;	.word	  4416	;C007
;	.word	  3444	;C006
;	.word	  2617	;C005
;	.word	  1881	;C004
;	.word	  1357	;C003
;	.word	   793	;C002
;	.word	   671	;C001
;	.word	   238	;C000


; low pass filter high band
LPCoef					
	.word	  -250	;C018
	.word	  -958	;C017
	.word	 -1899	;C016
	.word	 -2624	;C015
	.word	 -2125	;C014
	.word	   307	;C013
	.word	  4721	;C012
	.word	 10015	;C011
	.word	 14379	;C010
	.word	 16064	;C009
	.word	 14379	;C008
	.word	 10015	;C007
	.word	  4721	;C006
	.word	   307	;C005
	.word	 -2125	;C004
	.word	 -2624	;C003
	.word	 -1899	;C002
	.word	  -958	;C001
	.word	  -250	;C000
