*******************************************************
* TMS320C2x/C2xx/C5x ANSI C Codegen Version 6.60       
*******************************************************
;	C:\TI_TOOLS\dspac.exe -v2xx initfilt C:\WINDOWS\TEMP\initfilt.if 
;	C:\TI_TOOLS\dspopt.exe -h0 -p0 -GAR6 -GAR7 -v2xx -s -O3 C:\WINDOWS\TEMP\initfilt.if C:\WINDOWS\TEMP\initfilt.opt 
;	C:\TI_TOOLS\dspcg.exe -o -GAR6 -GAR7 -v2xx C:\WINDOWS\TEMP\initfilt.opt initfilt.asm C:\WINDOWS\TEMP\initfilt.tmp 
	.port
	.file	"initfilt.c"
	.file	"Filters.h"
	.globl	_InitTot
	.globl	_InitDial
	.globl	_InitBusy
	.globl	_InitAnswer
	.globl	_InitV23
	.globl	_InitV21
	.file	"initfilt.c"
	.globl	_DialFilter
	.globl	_DialThreshold
	.globl	_DialIn
	.globl	_DialOut
	.globl	_TotIn
	.globl	_TotOut
	.globl	_DialShift
	.globl	_DialMin
	.globl	_AnswerFilter
	.globl	_AnswerThreshold
	.globl	_AnswerIn
	.globl	_AnswerOut
	.globl	_AnswerShift
	.globl	_V23Filter
	.globl	_V23Threshold
	.globl	_V23In
	.globl	_V23Out
	.globl	_V23Shift
	.globl	_V21Filter
	.globl	_V21Threshold
	.globl	_V21In
	.globl	_V21Out
	.globl	_V21Shift
	.globl	_MinEng
	.globl	_InitFiltFunc
	.globl	_InitTot
	.globl	_InitDial
	.globl	_InitBusy
	.globl	_InitAnswer
	.globl	_InitV23
	.globl	_InitV21

	.sym	_InitV23,_InitV23,32,2,0
	.globl	_InitV23

	.func	120
******************************************************
* FUNCTION DEF : _InitV23
******************************************************
_InitV23:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 122	-----------------------    V23Filter[0] = 0;
	.line	3
	LACK	0
	LDPK	_V23Filter
	SACL	_V23Filter
*** 123	-----------------------    V23Filter[1] = 0;
	.line	4
	LDPK	_V23Filter+1
	SACL	_V23Filter+1
*** 124	-----------------------    V23Filter[2] = 0;
	.line	5
	LDPK	_V23Filter+2
	SACL	_V23Filter+2
*** 125	-----------------------    V23Filter[3] = 0;
	.line	6
	LDPK	_V23Filter+3
	SACL	_V23Filter+3
*** 126	-----------------------    V23Filter[4] = 660;
	.line	7
	LDPK	_V23Filter+4
	SPLK	#660,_V23Filter+4
*** 127	-----------------------    V23Filter[5] = (-252);
	.line	8
	LDPK	_V23Filter+5
	SPLK	#-252,_V23Filter+5
*** 128	-----------------------    V23Filter[6] = 16139;
	.line	9
	LDPK	_V23Filter+6
	SPLK	#16139,_V23Filter+6
*** 129	-----------------------    V23Filter[7] = (-15913);
	.line	10
	LDPK	_V23Filter+7
	SPLK	#-15913,_V23Filter+7
*** 130	-----------------------    V23Filter[8] = 660;
	.line	11
	LDPK	_V23Filter+8
	SPLK	#660,_V23Filter+8
*** 131	-----------------------    V23Filter[9] = 3214;
	.line	12
	LDPK	_V23Filter+9
	SPLK	#3214,_V23Filter+9
*** 132	-----------------------    V23Filter[10] = (-4803);
	.line	13
	LDPK	_V23Filter+10
	SPLK	#-4803,_V23Filter+10
*** 133	-----------------------    V23Filter[11] = 17611;
	.line	14
	LDPK	_V23Filter+11
	SPLK	#17611,_V23Filter+11
*** 134	-----------------------    V23Filter[12] = (-15928);
	.line	15
	LDPK	_V23Filter+12
	SPLK	#-15928,_V23Filter+12
*** 135	-----------------------    V23Filter[13] = 3214;
	.line	16
	LDPK	_V23Filter+13
	SPLK	#3214,_V23Filter+13
*** 137	-----------------------    V23Threshold = 64;
	.line	18
	LACK	64
	LDPK	_V23Threshold
	SACL	_V23Threshold
*** 138	-----------------------    V23In = 0;
	.line	19
	LACK	0
	LDPK	_V23In
	SACL	_V23In
*** 139	-----------------------    V23Out = 0;
	.line	20
	LDPK	_V23Out
	SACL	_V23Out
*** 140	-----------------------    V23Shift = 14;
	.line	21
	LACK	14
	LDPK	_V23Shift
	SACL	_V23Shift
***  	-----------------------    return;
EPI0_1:
	.line	22
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	141,000000000H,1

	.sym	_InitV21,_InitV21,32,2,0
	.globl	_InitV21

	.func	143
******************************************************
* FUNCTION DEF : _InitV21
******************************************************
_InitV21:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 145	-----------------------    V21Filter[0] = 0;
	.line	3
	LACK	0
	LDPK	_V21Filter
	SACL	_V21Filter
*** 146	-----------------------    V21Filter[1] = 0;
	.line	4
	LDPK	_V21Filter+1
	SACL	_V21Filter+1
*** 147	-----------------------    V21Filter[2] = 0;
	.line	5
	LDPK	_V21Filter+2
	SACL	_V21Filter+2
*** 148	-----------------------    V21Filter[3] = 0;
	.line	6
	LDPK	_V21Filter+3
	SACL	_V21Filter+3
*** 149	-----------------------    V21Filter[4] = 1077;
	.line	7
	LDPK	_V21Filter+4
	SPLK	#1077,_V21Filter+4
*** 150	-----------------------    V21Filter[5] = (-114);
	.line	8
	LDPK	_V21Filter+5
	SPLK	#-114,_V21Filter+5
*** 151	-----------------------    V21Filter[6] = 8292;
	.line	9
	LDPK	_V21Filter+6
	SPLK	#8292,_V21Filter+6
*** 152	-----------------------    V21Filter[7] = (-16087);
	.line	10
	LDPK	_V21Filter+7
	SPLK	#-16087,_V21Filter+7
*** 153	-----------------------    V21Filter[8] = 1076;
	.line	11
	LDPK	_V21Filter+8
	SPLK	#1076,_V21Filter+8
*** 154	-----------------------    V21Filter[9] = 1767;
	.line	12
	LDPK	_V21Filter+9
	SPLK	#1767,_V21Filter+9
*** 155	-----------------------    V21Filter[10] = (-1643);
	.line	13
	LDPK	_V21Filter+10
	SPLK	#-1643,_V21Filter+10
*** 156	-----------------------    V21Filter[11] = 9335;
	.line	14
	LDPK	_V21Filter+11
	SPLK	#9335,_V21Filter+11
*** 157	-----------------------    V21Filter[12] = (-16090);
	.line	15
	LDPK	_V21Filter+12
	SPLK	#-16090,_V21Filter+12
*** 158	-----------------------    V21Filter[13] = 1765;
	.line	16
	LDPK	_V21Filter+13
	SPLK	#1765,_V21Filter+13
*** 160	-----------------------    V21Threshold = 58;
	.line	18
	LACK	58
	LDPK	_V21Threshold
	SACL	_V21Threshold
*** 161	-----------------------    V21In = 0;
	.line	19
	LACK	0
	LDPK	_V21In
	SACL	_V21In
*** 162	-----------------------    V21Out = 0;
	.line	20
	LDPK	_V21Out
	SACL	_V21Out
*** 163	-----------------------    V21Shift = 15;
	.line	21
	LACK	15
	LDPK	_V21Shift
	SACL	_V21Shift
***  	-----------------------    return;
EPI0_2:
	.line	22
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	164,000000000H,1

	.sym	_InitTot,_InitTot,32,2,0
	.globl	_InitTot

	.func	40
******************************************************
* FUNCTION DEF : _InitTot
******************************************************
_InitTot:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 42	-----------------------    MinEng = 88;
	.line	3
	LACK	88
	LDPK	_MinEng
	SACL	_MinEng
*** 43	-----------------------    TotIn = 0;
	.line	4
	LACK	0
	LDPK	_TotIn
	SACL	_TotIn
*** 44	-----------------------    TotOut = 0;
	.line	5
	LDPK	_TotOut
	SACL	_TotOut
*** 45	-----------------------    InitFiltFunc();
	.line	6
	CALL	_InitFiltFunc
***  	-----------------------    return;
EPI0_3:
	.line	7
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	46,000000000H,1

	.sym	_InitDial,_InitDial,32,2,0
	.globl	_InitDial

	.func	49
******************************************************
* FUNCTION DEF : _InitDial
******************************************************
_InitDial:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 51	-----------------------    DialFilter[0] = 0;
	.line	3
	LACK	0
	LDPK	_DialFilter
	SACL	_DialFilter
*** 52	-----------------------    DialFilter[1] = 0;
	.line	4
	LDPK	_DialFilter+1
	SACL	_DialFilter+1
*** 53	-----------------------    DialFilter[2] = 0;
	.line	5
	LDPK	_DialFilter+2
	SACL	_DialFilter+2
*** 54	-----------------------    DialFilter[3] = 0;
	.line	6
	LDPK	_DialFilter+3
	SACL	_DialFilter+3
*** 55	-----------------------    DialFilter[4] = 1201;
	.line	7
	LDPK	_DialFilter+4
	SPLK	#1201,_DialFilter+4
*** 56	-----------------------    DialFilter[5] = (-1977);
	.line	8
	LDPK	_DialFilter+5
	SPLK	#-1977,_DialFilter+5
*** 57	-----------------------    DialFilter[6] = 29988;
	.line	9
	LDPK	_DialFilter+6
	SPLK	#29988,_DialFilter+6
*** 58	-----------------------    DialFilter[7] = (-15785);
	.line	10
	LDPK	_DialFilter+7
	SPLK	#-15785,_DialFilter+7
*** 59	-----------------------    DialFilter[8] = 1201;
	.line	11
	LDPK	_DialFilter+8
	SPLK	#1201,_DialFilter+8
*** 60	-----------------------    DialFilter[9] = 6204;
	.line	12
	LDPK	_DialFilter+9
	SPLK	#6204,_DialFilter+9
*** 61	-----------------------    DialFilter[10] = (-12201);
	.line	13
	LDPK	_DialFilter+10
	SPLK	#-12201,_DialFilter+10
*** 62	-----------------------    DialFilter[11] = 30793;
	.line	14
	LDPK	_DialFilter+11
	SPLK	#30793,_DialFilter+11
*** 63	-----------------------    DialFilter[12] = (-15887);
	.line	15
	LDPK	_DialFilter+12
	SPLK	#-15887,_DialFilter+12
*** 64	-----------------------    DialFilter[13] = 6204;
	.line	16
	LDPK	_DialFilter+13
	SPLK	#6204,_DialFilter+13
*** 66	-----------------------    DialThreshold = 80;
	.line	18
	LACK	80
	LDPK	_DialThreshold
	SACL	_DialThreshold
*** 67	-----------------------    DialIn = 0;
	.line	19
	LACK	0
	LDPK	_DialIn
	SACL	_DialIn
*** 68	-----------------------    DialOut = 0;
	.line	20
	LDPK	_DialOut
	SACL	_DialOut
*** 69	-----------------------    DialShift = 14336;
	.line	21
	LDPK	_DialShift
	SPLK	#14336,_DialShift
*** 70	-----------------------    DialMin = 336;
	.line	22
	LDPK	_DialMin
	SPLK	#336,_DialMin
***  	-----------------------    return;
EPI0_4:
	.line	23
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	71,000000000H,1

	.sym	_InitBusy,_InitBusy,32,2,0
	.globl	_InitBusy

	.func	73
******************************************************
* FUNCTION DEF : _InitBusy
******************************************************
_InitBusy:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 75	-----------------------    DialFilter[0] = 0;
	.line	3
	LACK	0
	LDPK	_DialFilter
	SACL	_DialFilter
*** 76	-----------------------    DialFilter[1] = 0;
	.line	4
	LDPK	_DialFilter+1
	SACL	_DialFilter+1
*** 77	-----------------------    DialFilter[2] = 0;
	.line	5
	LDPK	_DialFilter+2
	SACL	_DialFilter+2
*** 78	-----------------------    DialFilter[3] = 0;
	.line	6
	LDPK	_DialFilter+3
	SACL	_DialFilter+3
*** 79	-----------------------    DialFilter[4] = 1201;
	.line	7
	LDPK	_DialFilter+4
	SPLK	#1201,_DialFilter+4
*** 80	-----------------------    DialFilter[5] = (-1977);
	.line	8
	LDPK	_DialFilter+5
	SPLK	#-1977,_DialFilter+5
*** 81	-----------------------    DialFilter[6] = 29988;
	.line	9
	LDPK	_DialFilter+6
	SPLK	#29988,_DialFilter+6
*** 82	-----------------------    DialFilter[7] = (-15785);
	.line	10
	LDPK	_DialFilter+7
	SPLK	#-15785,_DialFilter+7
*** 83	-----------------------    DialFilter[8] = 1201;
	.line	11
	LDPK	_DialFilter+8
	SPLK	#1201,_DialFilter+8
*** 84	-----------------------    DialFilter[9] = 6204;
	.line	12
	LDPK	_DialFilter+9
	SPLK	#6204,_DialFilter+9
*** 85	-----------------------    DialFilter[10] = (-12201);
	.line	13
	LDPK	_DialFilter+10
	SPLK	#-12201,_DialFilter+10
*** 86	-----------------------    DialFilter[11] = 30793;
	.line	14
	LDPK	_DialFilter+11
	SPLK	#30793,_DialFilter+11
*** 87	-----------------------    DialFilter[12] = (-15887);
	.line	15
	LDPK	_DialFilter+12
	SPLK	#-15887,_DialFilter+12
*** 88	-----------------------    DialFilter[13] = 6204;
	.line	16
	LDPK	_DialFilter+13
	SPLK	#6204,_DialFilter+13
*** 90	-----------------------    DialThreshold = 64;
	.line	18
	LACK	64
	LDPK	_DialThreshold
	SACL	_DialThreshold
*** 91	-----------------------    DialIn = 0;
	.line	19
	LACK	0
	LDPK	_DialIn
	SACL	_DialIn
*** 92	-----------------------    DialOut = 0;
	.line	20
	LDPK	_DialOut
	SACL	_DialOut
*** 93	-----------------------    DialShift = 24576;
	.line	21
	LDPK	_DialShift
	SPLK	#24576,_DialShift
*** 94	-----------------------    DialMin = 336;
	.line	22
	LDPK	_DialMin
	SPLK	#336,_DialMin
***  	-----------------------    return;
EPI0_5:
	.line	23
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	95,000000000H,1

	.sym	_InitAnswer,_InitAnswer,32,2,0
	.globl	_InitAnswer

	.func	97
******************************************************
* FUNCTION DEF : _InitAnswer
******************************************************
_InitAnswer:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 99	-----------------------    AnswerFilter[0] = 0;
	.line	3
	LACK	0
	LDPK	_AnswerFilter
	SACL	_AnswerFilter
*** 100	-----------------------    AnswerFilter[1] = 0;
	.line	4
	LDPK	_AnswerFilter+1
	SACL	_AnswerFilter+1
*** 101	-----------------------    AnswerFilter[2] = 0;
	.line	5
	LDPK	_AnswerFilter+2
	SACL	_AnswerFilter+2
*** 102	-----------------------    AnswerFilter[3] = 0;
	.line	6
	LDPK	_AnswerFilter+3
	SACL	_AnswerFilter+3
*** 103	-----------------------    AnswerFilter[4] = 758;
	.line	7
	LDPK	_AnswerFilter+4
	SPLK	#758,_AnswerFilter+4
*** 104	-----------------------    AnswerFilter[5] = (-524);
	.line	8
	LDPK	_AnswerFilter+5
	SPLK	#-524,_AnswerFilter+5
*** 105	-----------------------    AnswerFilter[6] = (-1450);
	.line	9
	LDPK	_AnswerFilter+6
	SPLK	#-1450,_AnswerFilter+6
*** 106	-----------------------    AnswerFilter[7] = (-15792);
	.line	10
	LDPK	_AnswerFilter+7
	SPLK	#-15792,_AnswerFilter+7
*** 107	-----------------------    AnswerFilter[8] = 756;
	.line	11
	LDPK	_AnswerFilter+8
	SPLK	#756,_AnswerFilter+8
*** 108	-----------------------    AnswerFilter[9] = 2683;
	.line	12
	LDPK	_AnswerFilter+9
	SPLK	#2683,_AnswerFilter+9
*** 109	-----------------------    AnswerFilter[10] = 2555;
	.line	13
	LDPK	_AnswerFilter+10
	SPLK	#2555,_AnswerFilter+10
*** 110	-----------------------    AnswerFilter[11] = (-3596);
	.line	14
	LDPK	_AnswerFilter+11
	SPLK	#-3596,_AnswerFilter+11
*** 111	-----------------------    AnswerFilter[12] = (-15795);
	.line	15
	LDPK	_AnswerFilter+12
	SPLK	#-15795,_AnswerFilter+12
*** 112	-----------------------    AnswerFilter[13] = 2677;
	.line	16
	LDPK	_AnswerFilter+13
	SPLK	#2677,_AnswerFilter+13
*** 114	-----------------------    AnswerThreshold = 26;
	.line	18
	LACK	26
	LDPK	_AnswerThreshold
	SACL	_AnswerThreshold
*** 115	-----------------------    AnswerIn = 0;
	.line	19
	LACK	0
	LDPK	_AnswerIn
	SACL	_AnswerIn
*** 116	-----------------------    AnswerOut = 0;
	.line	20
	LDPK	_AnswerOut
	SACL	_AnswerOut
*** 117	-----------------------    AnswerShift = 20000;
	.line	21
	LDPK	_AnswerShift
	SPLK	#20000,_AnswerShift
***  	-----------------------    return;
EPI0_6:
	.line	22
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	118,000000000H,1
	.end
