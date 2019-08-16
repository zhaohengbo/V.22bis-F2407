*************************************************
*    ASPI TMS32020 DIGITAL FILTER REALIZATION   *
*************************************************
*           INTERNAL DELAY MEMORY
*          COEF. in PROGRAM MEMORY
*
*                PARK-MCCLELLAN
*               42-TAP FIR FILTER->V21 low band and high band
*               52-TAP FIR FILTER->V23 low band
*
*           Wed Oct 08 14:40:41 1997
*
*   Filter type: BANDPASS
* Sampling freq: 8000 HZ
*
*************************************************
************************************************
*         ASPI CARD INITIALIZATION CODE        *
************************************************
*	ROVM			*2S COMPLEMENT
*	SSXM			*SIGN EXTEND MODE
*	SPM	1		*P output is shifted left 1 bit
*************************************************
*           DATA MEMORY DEFINITION              *
*************************************************
*     CONTAINS:
*          STORAGE FOR FILTER INPUT AND OUTPUT
*          STORAGE FOR COEFFICIENTS
*          STORAGE FOR DELAY ELEMENTS
*************************************************
	
		.include	"..\common.inc"

		.ref	FromAD
		.def	V21FIRA, V21FIRC, V23FIRC
*
* FILTER INPUT and OUTPUT STORAGE
*
*
*  FIR COEFFICIENTS: Upper band
*
V21ACoef
	.word     311	;C037
	.word     281	;C036
	.word    -754	;C035
	.word   -1066	;C034
	.word     965	;C033
	.word    2645	;C032
	.word    -400	;C031
	.word   -4618	;C030
	.word   -1638	;C029
	.word    6166	;C028
	.word    5179	;C027
	.word   -6059	;C026
	.word   -9473	;C025
	.word    3507	;C024
	.word   12959	;C023
	.word    1341	;C022
	.word  -14050	;C021
	.word   -7143	;C020
	.word   11934	;C019
	.word   11934	;C018
	.word   -7143	;C017
	.word  -14050	;C016
	.word    1341 	;C015
	.word   12959	;C014
	.word    3507	;C013
	.word   -9473	;C012
	.word   -6059	;C011
	.word    5179	;C010
	.word    6166	;C009
	.word   -1638	;C008
	.word   -4618	;C007
	.word    -400	;C006
	.word    2645	;C005
	.word     965	;C004
	.word   -1066	;C003
	.word    -754	;C002
	.word     281	;C001
	.word     311	;C000

;.word     -35	;C043
;.word    -272	;C042
;.word     -24	;C041			   
;.word     696	;C040
;.word     482	;C039
;.word   -1205	;C038
;.word   -1589	;C037
;.word    1342	;C036
;.word    3367	;C035
;.word    -491	;C034
;.word   -5364	;C033
;.word   -1803	;C032
;.word    6666	;C031
;.word    5431	;C030
;.word   -6240	;C029
;.word   -9523	;C028
;.word    3489	;C027
;.word   12663	;C026
;.word    1282	;C025
;.word  -13484	;C024
;.word   -6815	;C023
;.word   11367	;C022
;.word   11367	;C021
;.word   -6815	;C020
;.word  -13484	;C019
;.word    1282	;C018
;.word   12663	;C017
;.word    3489	;C016
;.word   -9523 	;C015
;.word   -6240	;C014
;.word    5431	;C013
;.word    6666	;C012
;.word   -1803	;C011
;.word   -5364	;C010
;.word    -491	;C009
;.word    3367	;C008
;.word    1342	;C007
;.word   -1589	;C006
;.word   -1205	;C005
;.word     482	;C004
;.word     696	;C003
;.word     -24	;C002
;.word    -272	;C001
;.word     -35	;C000

* Lower band
V21CCoef
	.word    -311	;C037
	.word    -392	;C036
	.word      45	;C035
	.word    1077	;C034
	.word    1922	;C033
	.word    1328	;C032
	.word   -1184	;C031
	.word   -4230	;C030
	.word   -5018	;C029
	.word   -1616	;C028
	.word    4683	;C027
	.word    9349	;C026
	.word    7809	;C025
	.word    -352	;C024
	.word   -9978	;C023
	.word  -13675	;C022
	.word   -7716	;C021
	.word    4373	;C020
	.word   13983	;C019
	.word   13983	;C018
	.word    4373	;C017
	.word   -7716	;C016
	.word  -13675 	;C015
	.word   -9978	;C014
	.word    -352	;C013
	.word    7809	;C012
	.word    9349	;C011
	.word    4683	;C010
	.word   -1616	;C009
	.word   -5018	;C008
	.word   -4230	;C007
	.word   -1184	;C006
	.word    1328	;C005
	.word    1922	;C004
	.word    1077	;C003
	.word      45	;C002
	.word    -392	;C001
	.word    -311	;C000

;.word     118	;C045
;.word     142	;C044
;.word      43	;C043
;.word    -390	;C042
;.word    -907	;C041
;.word    -843	;C040
;.word     254	;C039
;.word    1960	;C038
;.word    2909	;C037
;.word    1671	;C036
;.word   -1785	;C035
;.word   -5325	;C034
;.word   -5773	;C033
;.word   -1560	;C032
;.word    5270	;C031
;.word    9803	;C030
;.word    7792	;C029
;.word    -556	;C028
;.word   -9865	;C027
;.word  -13153	;C026
;.word   -7266	;C025
;.word    4203	;C024
;.word   13201	;C023
;.word   13201	;C022
;.word    4203	;C021
;.word   -7266	;C020
;.word  -13153	;C019
;.word   -9865	;C018
;.word    -556	;C017
;.word    7792	;C016
;.word    9803 	;C015
;.word    5270	;C014
;.word   -1560	;C013
;.word   -5773	;C012
;.word   -5325	;C011
;.word   -1785	;C010
;.word    1671	;C009
;.word    2909	;C008
;.word    1960	;C007
;.word     254	;C006
;.word    -843	;C005
;.word    -907	;C004
;.word    -390	;C003
;.word      43	;C002
;.word     142	;C001
;.word     118	;C000


;
V23CCoef
	.word	   196	;C041
	.word	   477	;C040
	.word	   923	;C039
	.word	  1473	;C038
	.word	  1999	;C037
	.word	  2311	;C036
	.word	  2184	;C035
	.word	  1429	;C034
	.word	   -41	;C033
	.word	 -2143	;C032
	.word	 -4596	;C031
	.word	 -6945	;C030
	.word	 -8640	;C029
	.word	 -9157	;C028
	.word	 -8142	;C027
	.word	 -5524	;C026
	.word	 -1576	;C025
	.word	  3108  ;C024
	.word	  7718	;C023
	.word	 11401	;C022
	.word	 13444	;C021
	.word	 13444	;C020
	.word	 11401	;C019
	.word	  7718	;C018
	.word	  3108	;C017
	.word	 -1576	;C016
	.word	 -5524	;C015
	.word	 -8142	;C014
	.word	 -9157	;C013
	.word	 -8640	;C012
	.word	 -6945	;C011
	.word	 -4596	;C010
	.word	 -2143	;C009
	.word	   -41	;C008
	.word	  1429	;C007
	.word	  2184	;C006
	.word	  2311	;C005
	.word	  1999	;C004
	.word	  1473	;C003
	.word	   923	;C002
	.word	   477	;C001
	.word	   196	;C000
	
		.def	V21A_D0, V21AOut, V21C_D0, V21COut
		.def	V23C_D0, V23COut, V23C_D0
*
* DELAY STORAGE
*
;V21 Answering
V21A_D0	.usect	"V21FIR",37
V21A_DL	.usect	"V21FIR",2	;Extra storage: MACD destroys second Location.
V21AOut	.usect	"V21FIR",1
;V21 Calling
V21C_D0	.usect	"V21FIR",37
V21C_DL	.usect	"V21FIR",2	;Extra storage: MACD destroys second Location.
V21COut	.usect	"V21FIR",1

;V23 Calling
V23C_D0	.usect	"V23FIR",41
V23C_DL	.usect	"V23FIR",2	;Extra storage: MACD destroys second Location.
V23COut	.usect	"V23FIR",1



*************************************************
*              FILTER SUBROUTINE                *
*************************************************
* ASSUMPTIONS:
*     COEFFICIENTS are located at 'V21ACoef'.
*     DELAY elements are located at 'V21A_D0'.
*
*	  AR0 points to delays
*
*     AR0 is destroyed by filter routine.
*     P output shift is set to 1.
*     SIGN EXTEND mode is ON.
*     Two's Complement Arithmetic.
*	
*	  Input: shifted sample in ACC
*************************************************
*
* Upper passband: 1650-1850 Hz
* Filter at emission in mode = Answering
* Filter at reception in mode = Calling
*
V21FIRA
	SPM		1
	LAR		AR0,#V21A_D0
	MAR		*,AR0
	SACH	*
	MPYK	0				;P = 0
	ZAC						;AC = 0
	LAR		AR0,#V21A_DL	;set up AR0 to last element of delay array
	RPTK	37
	MACD	V21ACoef,*-		;MULTIPLY, ACCUM. and  DELAY
	APAC					;FORM RESULT
	RET			


*************************************************
*
* Lower passband: 980-1080 Hz
* Filter at reception in mode = Answering
* Filter at emission in mode = Calling
*
V21FIRC
	SSXM
	SPM		1
	LAR		AR0,#V21C_D0
	MAR		*,AR0
	SACH	*
	MPYK	0				;P = 0
	ZAC						;AC = 0
	LAR		AR0,#V21C_DL	;set up AR0 to last element of delay array
	RPTK	37
	MACD	V21CCoef,*-		;MULTIPLY, ACCUM. and  DELAY
	APAC					;FORM RESULT
	RET			



V23FIRC
	SPM		1
	SSXM
	LAR		AR0,#V23C_D0
	MAR		*,AR0
	SACH	*
	MPYK	0				;P = 0
	ZAC						;AC = 0
	LAR		AR0,#V23C_DL	;set up AR0 to last element of delay array
	RPTK	41
	MACD	V23CCoef,*-		;MULTIPLY, ACCUM. and  DELAY
	APAC					;FORM RESULT
	RET			



V21InFIR	.usect	"V21FIR",1
V21OutFIR	.usect	"V21FIR",1
V23InFIR	.usect	"V23FIR",1
V23OutFIR	.usect	"V23FIR",1
























































































