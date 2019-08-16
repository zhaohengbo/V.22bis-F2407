*******************************************************
* TMS320C2x/C2xx/C5x ANSI C Codegen Version 6.60       
*******************************************************
;	C:\TI_TOOLS\dspac.exe -v2xx call C:\WINDOWS\TEMP\call.if 
;	C:\TI_TOOLS\dspopt.exe -h0 -p0 -GAR6 -GAR7 -v2xx -s -O3 C:\WINDOWS\TEMP\call.if C:\WINDOWS\TEMP\call.opt 
;	C:\TI_TOOLS\dspcg.exe -o -GAR6 -GAR7 -v2xx C:\WINDOWS\TEMP\call.opt call.asm C:\WINDOWS\TEMP\call.tmp 
	.port
	.file	"call.c"
	.file	"common.h"

	.etag	_EOnOff,16
	.member	_ON,0,4,16,16
	.member	_OFF,1,4,16,16
	.eos

	.etag	.fake0,16
	.member	_RNoDial,0,4,16,16
	.member	_RV22b,1,4,16,16
	.member	_RNoCarrier,2,4,16,16
	.member	_RBusy,3,4,16,16
	.member	_RAbort,4,4,16,16
	.member	_RV22,5,4,16,16
	.member	_RV23,6,4,16,16
	.member	_RV21,7,4,16,16
	.member	_RAnswer,8,4,16,16
	.eos
	.globl	_Modul
	.globl	_CID
	.globl	_s0
	.globl	_RPtOut
	.globl	_RBuffr
	.globl	_RLast
	.globl	_Tim0
	.globl	_CptdFilter
	.globl	_B00
	.globl	_B01
	.globl	_table_read
	.globl	_F_ATA
	.file	"dtmf.h"
	.globl	_Phi1
	.globl	_Phi2
	.globl	_DeltaPhi1
	.globl	_DeltaPhi2
	.globl	_Ampl1
	.globl	_Ampl2
	.globl	_DtmfFlag
	.globl	_ToneTable
	.file	"Filters.h"
	.globl	_InitTot
	.globl	_InitDial
	.globl	_InitBusy
	.globl	_InitAnswer
	.globl	_InitV23
	.globl	_InitV21
	.file	"call.c"
	.globl	_GetNext
	.globl	_RPtOut0
	.globl	_InitRXV23
	.globl	_InitTXV23
	.globl	_InitTXV21
	.globl	_ResetFSK
	.globl	_StartUart
	.globl	_Calling
	.globl	_Dial
	.globl	_Send1300
	.globl	_InitDTMF

	.sym	_Send1300,_Send1300,32,2,0
	.globl	_Send1300

	.func	311
******************************************************
* FUNCTION DEF : _Send1300
******************************************************
_Send1300:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 317	-----------------------    Phi1 = 0;
	.line	7
	LACK	0
	LDPK	_Phi1
	SACL	_Phi1
*** 318	-----------------------    Phi2 = 0;
	.line	8
	LDPK	_Phi2
	SACL	_Phi2
*** 320	-----------------------    DeltaPhi1 = table_read(&ToneTable+64);
	.line	10
	LALK	_ToneTable+64
	SACL	*+
	CALL	_table_read
	MAR	*-
	LDPK	_DeltaPhi1
	SACL	_DeltaPhi1
*** 321	-----------------------    DeltaPhi2 = table_read(&ToneTable+65);
	.line	11
	LALK	_ToneTable+65
	SACL	*+
	CALL	_table_read
	MAR	*-
	LDPK	_DeltaPhi2
	SACL	_DeltaPhi2
*** 323	-----------------------    Ampl1 = table_read(&ToneTable+66);
	.line	13
	LALK	_ToneTable+66
	SACL	*+
	CALL	_table_read
	MAR	*-
	LDPK	_Ampl1
	SACL	_Ampl1
*** 324	-----------------------    Ampl2 = 0;
	.line	14
	LACK	0
	LDPK	_Ampl2
	SACL	_Ampl2
***  	-----------------------    return;
EPI0_1:
	.line	15
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	325,000000000H,1

	.sym	_InitDTMF,_InitDTMF,32,2,0
	.globl	_InitDTMF

	.func	329
******************************************************
* FUNCTION DEF : _InitDTMF
******************************************************
_InitDTMF:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 331	-----------------------    DtmfFlag = 0;
	.line	3
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 332	-----------------------    Ampl1 = 0;
	.line	4
	LDPK	_Ampl1
	SACL	_Ampl1
*** 333	-----------------------    Ampl2 = 0;
	.line	5
	LDPK	_Ampl2
	SACL	_Ampl2
***  	-----------------------    return;
EPI0_2:
	.line	6
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	334,000000000H,1

	.sym	_Dial,_Dial,32,2,0
	.globl	_Dial

	.func	267
******************************************************
* FUNCTION DEF : _Dial
******************************************************
_Dial:

LF3	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+,AR2

	.sym	_Digit,-3+LF3,4,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.sym	C$1,1,20,1,16
	.sym	_temp,2,4,1,16
	.line	2
*** 271	-----------------------    temp = (Digit == 42) ? 10 : (Digit == 35) ? 11 : (Digit >= 97) ? Digit-85 : Digit&0xf;
	.line	5
	LARK	AR2,-3+LF3
	MAR	*0+
	LAC	* 
	SUBK	42
	BNZ	LL5
	LACK	10
	B	LL6
LL5:
	LAC	* 
	SUBK	35
	BNZ	LL7
	LACK	11
	B	LL6
LL7:
	SSXM
	LAC	* 
	SUBK	97
	BLZ	LL9
	LAC	* 
	SUBK	85
	B	LL6
LL9:
	LACK	15
	AND	* ,AR1
	SACL	* 
	LAC	* 
LL6:
	MAR	* ,AR2
	ADRK	5-LF3
	SACL	* 
*** 282	-----------------------    Phi1 = 0;
	.line	16
	LACK	0
	LDPK	_Phi1
	SACL	_Phi1
*** 283	-----------------------    Phi2 = 0;
	.line	17
	LDPK	_Phi2
	SACL	_Phi2
*** 285	-----------------------    C$1 = &ToneTable[(temp *= 4)];
	.line	19
	LAC	* ,2
	SACL	*-
	ADLK	_ToneTable+0,0
	SACL	* ,AR1
*** 285	-----------------------    DeltaPhi1 = table_read(C$1);
	SACL	*+
	CALL	_table_read
	MAR	*-,AR2
	LDPK	_DeltaPhi1
	SACL	_DeltaPhi1
*** 286	-----------------------    DeltaPhi2 = table_read(C$1+1);
	.line	20
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	ADDK	1
	SACL	*+
	CALL	_table_read
	MAR	*-,AR2
	LDPK	_DeltaPhi2
	SACL	_DeltaPhi2
*** 288	-----------------------    Ampl1 = table_read(C$1+2);
	.line	22
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	ADDK	2
	SACL	*+
	CALL	_table_read
	MAR	*-,AR2
	LDPK	_Ampl1
	SACL	_Ampl1
*** 289	-----------------------    Ampl2 = table_read(C$1+3);
	.line	23
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	ADDK	3
	SACL	*+
	CALL	_table_read
	MAR	*-
	LDPK	_Ampl2
	SACL	_Ampl2
*** 290	-----------------------    DtmfFlag = 1;
	.line	24
	LACK	1
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 298	-----------------------    Tim0 = 0;
	.line	32
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L2:
***	-----------------------g2:
*** 299	-----------------------    if ( Tim0 < 520 ) goto g2;
	.line	33
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	520
	BLZ	L2
*** 301	-----------------------    DtmfFlag = 0;
	.line	35
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 302	-----------------------    Ampl1 = 0;
	.line	36
	LDPK	_Ampl1
	SACL	_Ampl1
*** 303	-----------------------    Ampl2 = 0;
	.line	37
	LDPK	_Ampl2
	SACL	_Ampl2
*** 305	-----------------------    Tim0 = 0;
	.line	39
	LDPK	_Tim0
	SACL	_Tim0
L5:
***	-----------------------g5:
*** 306	-----------------------    if ( Tim0 < 520 ) goto g5;
	.line	40
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	520
	BLZ	L5
***  	-----------------------    return;
EPI0_3:
	.line	41
	SBRK	4
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	307,000000000H,3

	.sym	_Calling,_Calling,36,2,0
	.globl	_Calling

	.func	32
******************************************************
* FUNCTION DEF : _Calling
******************************************************
_Calling:

LF4	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,6
	LAR	AR0,*0+

	.sym	_WDial,-3+LF4,4,9,16
	.sym	_Digit,-4+LF4,4,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
*  ---  Digit shares AUTO storage with c0
*  ---  Digit shares AUTO storage with i0
*  ---  L$1 shares AUTO storage with i1
*  ---  WDial shares AUTO storage with i2
*  ---  time shares AUTO storage with ton
*  ---  WDial shares AUTO storage with toff
*
	.sym	_time,1,4,1,16
	.sym	_toff,2,4,1,16
	.sym	_onflag,3,4,1,16
	.sym	_ton,4,4,1,16
	.sym	L$1,5,4,1,16
	.line	2
*** 42	-----------------------    c0 = Digit;
	.line	11
*** 43	-----------------------    CID = 1;
	.line	12
	LACK	1
	LDPK	_CID
	SACL	_CID
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING InitDTMF()
*** 44	-----------------------    Ampl2 = Ampl1 = DtmfFlag = 0;
	.line	13
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
	LDPK	_Ampl1
	SACL	_Ampl1
	LDPK	_Ampl2
	SACL	_Ampl2
*** 45	-----------------------    InitTot();
	.line	14
	CALL	_InitTot
*** 46	-----------------------    InitDial();
	.line	15
	CALL	_InitDial
*** 47	-----------------------    InitV23();
	.line	16
	CALL	_InitV23
*** 48	-----------------------    InitV21();
	.line	17
	CALL	_InitV21
*** 49	-----------------------    InitAnswer();
	.line	18
	CALL	_InitAnswer
*** 50	-----------------------    CptdFilter = 0;
	.line	19
	LACK	0
	LDPK	_CptdFilter
	SACL	_CptdFilter
*** 51	-----------------------    FConnect();
	.line	20
	CALL	_FConnect
*** 52	-----------------------    Tim0 = 0;
	.line	21
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 53	-----------------------    CID = 3;
	.line	22
	LACK	3
	LDPK	_CID
	SACL	_CID
*** 71	-----------------------    if ( !WDial ) goto g15;
	.line	40
	MAR	* ,AR2
	LARK	AR2,-3+LF4
	MAR	*0+
	LAC	* 
	BZ	L20
*** 72	-----------------------    ton = 0;
	.line	41
	LACK	0
	ADRK	4-LF4
	SACL	* 
*** 73	-----------------------    toff = 0;
	.line	42
	SBRK	4-LF4
	SACL	* 
***  	-----------------------    L$1 = 600;
	ADRK	8-LF4
	SPLK	#600,* 
L8:
***	-----------------------g3:
*** 76	-----------------------    Tim0 = 0;
	.line	45
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L10:
***	-----------------------g5:
*** 76	-----------------------    if ( Tim0 < 80 ) goto g5;
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLZ	L10
*** 77	-----------------------    if ( CptdFilter&1 ) goto g9;
	.line	46
	LDPK	_CptdFilter
	BIT	_CptdFilter,15
	BBNZ	L14
*** 81	-----------------------    if ( (++toff) < 4 ) goto g10;
	.line	50
	MAR	* ,AR2
	LARK	AR2,-3+LF4
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
	SUBK	4
	BLZ	L15
*** 82	-----------------------    ton = 0;
	.line	51
	LACK	0
	ADRK	4-LF4
	SACL	* 
*** 82	-----------------------    goto g11;
	B	L16
L14:
***	-----------------------g9:
*** 78	-----------------------    ++ton;
	.line	47
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
*** 79	-----------------------    toff = 0;
	.line	48
	LACK	0
	SBRK	4-LF4
	SACL	* 
L15:
***	-----------------------g10:
*** 84	-----------------------    if ( ton >= 160 ) goto g13;
	.line	53
	ADRK	4-LF4
	LAC	* 
	SUBK	160
	BGEZ	L18
L16:
***	-----------------------g11:
*** 85	-----------------------    if ( abort() ) goto g74;
	.line	54
	CALL	_abort,AR1
	BNZ	L79
*** 75	-----------------------    if ( --L$1 ) goto g3;
	.line	44
	SSXM
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* 
	BNZ	L8
L18:
***	-----------------------g13:
*** 87	-----------------------    if ( ton >= 160 ) goto g15;
	.line	56
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	160
	BGEZ	L20
*** 87	-----------------------    return 0;
	LACK	0
	B	EPI0_4
L20:
***	-----------------------g15:
*** 91	-----------------------    if ( !isdigit(c0) ) goto g19;
	.line	60
	LARK	AR2,-4+LF4
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_isdigit
	MAR	*-
	BZ	L24
	MAR	* ,AR2
L23:
***	-----------------------g18:
*** 92	-----------------------    Dial(c0);
	.line	61
	LARK	AR2,-4+LF4
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_Dial
	MAR	*-
*** 93	-----------------------    c0 = GetNext(&RPtOut0);
	.line	62
	LALK	_RPtOut0+0
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,-4+LF4
	MAR	*0+
	SACL	* 
*** 91	-----------------------    if ( isdigit(c0) ) goto g18;
	.line	60
	LAC	* ,AR1
	SACL	*+
	CALL	_isdigit
	MAR	*-,AR2
	BNZ	L23
L24:
***	-----------------------g19:
*** 96	-----------------------    Tim0 = 0;
	.line	65
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 97	-----------------------    InitTot();
	.line	66
	CALL	_InitTot,AR1
*** 98	-----------------------    InitBusy();
	.line	67
	CALL	_InitBusy
*** 99	-----------------------    InitAnswer();
	.line	68
	CALL	_InitAnswer
*** 100	-----------------------    InitNotch();
	.line	69
	CALL	_InitNotch
*** 101	-----------------------    Send1300();
	.line	70
	CALL	_Send1300
*** 107	-----------------------    Tim0 = 0;
	.line	76
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 115	-----------------------    DtmfFlag = 0;
	.line	84
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 108	-----------------------    i0 = 0;
	.line	77
	MAR	* ,AR2
	LARK	AR2,-4+LF4
	MAR	*0+
	SACL	*+
*** 110	-----------------------    i2 = 0;
	.line	79
	SACL	* 
*** 111	-----------------------    ton = 0;
	.line	80
	ADRK	7-LF4
	SACL	* 
*** 112	-----------------------    toff = 0;
	.line	81
	SBRK	2
	SACL	*-
*** 113	-----------------------    time = 0;
	.line	82
	SACL	* 
*** 114	-----------------------    onflag = 0;
	.line	83
	ADRK	2
	SACL	* 
*** 109	-----------------------    i1 = 0;
	.line	78
	ADRK	2
	SACL	* 
L26:
***	-----------------------g21:
*** 117	-----------------------    if ( CptdFilter&1 ) goto g30;
	.line	86
	LDPK	_CptdFilter
	BIT	_CptdFilter,15
	BBNZ	L35
*** 145	-----------------------    if ( !CptdFilter ) goto g24;
	.line	114
	LAC	_CptdFilter
	BZ	L29
*** 145	-----------------------    goto g39;
	B	L44
L28:
***	-----------------------g23:
*** 147	-----------------------    DtmfFlag = (i2 > 180) ? 1300 : 0;
	.line	116
	LARK	AR2,-3+LF4
	MAR	*0+
	LAC	* 
	SUBK	180
	BLEZ	LL13
	LACK	1300
	B	LL14
LL13:
	LACK	0
LL14:
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
L29:
***	-----------------------g24:
*** 146	-----------------------    if ( Tim0 < 80 ) goto g23;
	.line	115
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	MAR	* ,AR2
	BLZ	L28
*** 154	-----------------------    Tim0 = 0;
	.line	123
	LACK	0
	SACL	_Tim0
*** 155	-----------------------    ++i1;
	.line	124
	LARK	AR2,5
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
*** 156	-----------------------    ++i2;
	.line	125
	SBRK	8-LF4
	LAC	* 
	ADDK	1
	SACL	* 
*** 157	-----------------------    ++toff;
	.line	126
	ADRK	5-LF4
	LAC	* 
	ADDK	1
	SACL	*+
*** 159	-----------------------    if ( !(onflag&1) ) goto g39;
	.line	128
	BIT	* ,15
	BBZ	L44
*** 160	-----------------------    if ( toff >= 4 ) goto g28;
	.line	129
	MAR	*-
	LAC	* 
	SUBK	4
	BGEZ	L33
*** 169	-----------------------    ++ton;
	.line	138
	ADRK	2
	LAC	* 
	ADDK	1
	SACL	* 
*** 169	-----------------------    goto g39;
	B	L44
L33:
***	-----------------------g28:
*** 161	-----------------------    onflag = 0;
	.line	130
	LACK	0
	MAR	*+
	SACL	*+
*** 162	-----------------------    i0 = (ton < 30 || ton > 60) ? 0 : i0+1;
	.line	131
	LAC	* 
	SUBK	30
	BLZ	LL16
	LAC	* 
	SUBK	60
	BLEZ	LL15
LL16:
	LACK	0
	B	LL17
LL15:
	SBRK	8-LF4
	LAC	* 
	ADDK	1
LL17:
	LARK	AR2,-4+LF4
	MAR	*0+
	SACL	* 
*** 165	-----------------------    ton = 0;
	.line	134
	LACK	0
	ADRK	8-LF4
	SACL	* 
***  	-----------------------    goto g39;
	B	L44
L34:
***	-----------------------g29:
*** 119	-----------------------    DtmfFlag = (i2 > 180) ? 1300 : 0;
	.line	88
	LARK	AR2,-3+LF4
	MAR	*0+
	LAC	* 
	SUBK	180
	BLEZ	LL18
	LACK	1300
	B	LL19
LL18:
	LACK	0
LL19:
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
L35:
***	-----------------------g30:
*** 118	-----------------------    if ( Tim0 < 80 ) goto g29;
	.line	87
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	MAR	* ,AR2
	BLZ	L34
*** 127	-----------------------    Tim0 = 0;
	.line	96
	LACK	0
	SACL	_Tim0
*** 128	-----------------------    ++i1;
	.line	97
	LARK	AR2,5
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
*** 129	-----------------------    ++i2;
	.line	98
	SBRK	8-LF4
	LAC	* 
	ADDK	1
	SACL	* 
*** 130	-----------------------    ++ton;
	.line	99
	ADRK	7-LF4
	LAC	* 
	ADDK	1
	SACL	*-
*** 132	-----------------------    if ( onflag ) goto g39;
	.line	101
	LAC	* 
	BNZ	L44
*** 133	-----------------------    if ( ton >= 4 ) goto g34;
	.line	102
	MAR	*+
	LAC	* 
	SUBK	4
	BGEZ	L39
*** 142	-----------------------    ++toff;
	.line	111
	SBRK	2
	LAC	* 
	ADDK	1
	SACL	* 
*** 142	-----------------------    goto g39;
	B	L44
L39:
***	-----------------------g34:
*** 134	-----------------------    onflag = 1;
	.line	103
	LACK	1
	MAR	*-
	SACL	*-
*** 135	-----------------------    if ( toff < 30 || toff > 60 ) goto g36;
	.line	104
	LAC	* 
	SUBK	30
	BLZ	L41
	LAC	* 
	SUBK	60
	BGZ	L41
*** 136	-----------------------    ++i0;
	.line	105
	SBRK	6-LF4
	LAC	* 
	ADDK	1
	SACL	* 
***  	-----------------------    goto g38;
	B	L43
L41:
***	-----------------------g36:
*** 137	-----------------------    if ( toff < 4 ) goto g38;
	.line	106
	LAC	* 
	SUBK	4
	BLZ	L43
*** 138	-----------------------    i0 = 0;
	.line	107
	LACK	0
	SBRK	6-LF4
	SACL	* 
L43:
***	-----------------------g38:
*** 140	-----------------------    toff = 0;
	.line	109
	LACK	0
	LARK	AR2,2
	MAR	*0+
	SACL	* 
L44:
***	-----------------------g39:
*** 173	-----------------------    if ( i2 > 240 ) goto g48;
	.line	142
	SSXM
	MAR	* ,AR2
	LARK	AR2,-3+LF4
	MAR	*0+
	LAC	* 
	SUBK	240
	BGZ	L53
*** 176	-----------------------    if ( i2 < 150 ) goto g49;
	.line	145
	LAC	* 
	SUBK	150
	BLZ	L54
*** 238	-----------------------    if ( !(CptdFilter&0xe) ) goto g63;
	.line	207
	LACK	14
	LDPK	_CptdFilter
	AND	_CptdFilter
	ANDK	0FFFFh
	BZ	L68
*** 239	-----------------------    CptdFilter = 0;
	.line	208
	LACK	0
	SACL	_CptdFilter
L49:
***	-----------------------g44:
*** 240	-----------------------    if ( Tim0 < 80 ) goto g44;
	.line	209
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLZ	L49
*** 241	-----------------------    Tim0 = 0;
	.line	210
	LACK	0
	SACL	_Tim0
*** 242	-----------------------    if ( time > 30 ) goto g70;
	.line	211
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BGZ	L75
***  	-----------------------    if ( i0 >= 6 ) goto g65;
	SBRK	5-LF4
	LAC	* 
	SUBK	6
	BGEZ	L70
*** 242	-----------------------    ++i2;
	MAR	*+
	LAC	* 
	ADDK	1
	SACL	* 
***  	-----------------------    goto g66;
	B	L71
L53:
***	-----------------------g48:
*** 173	-----------------------    i2 = 0;
	.line	142
	LACK	0
	SACL	* 
L54:
***	-----------------------g49:
*** 178	-----------------------    DtmfFlag = 0;
	.line	147
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 177	-----------------------    time = 0;
	.line	146
	ADRK	4-LF4
	SACL	* 
L56:
***	-----------------------g51:
*** 184	-----------------------    if ( !(CptdFilter&2) ) goto g55;
	.line	153
	LDPK	_CptdFilter
	BIT	_CptdFilter,14
	BBZ	L60
*** 185	-----------------------    if ( Tim0 <= 80 ) goto g54;
	.line	154
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L59
*** 186	-----------------------    Tim0 = 0;
	.line	155
	LACK	0
	SACL	_Tim0
*** 187	-----------------------    ++time;
	.line	156
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
*** 188	-----------------------    ++i2;
	.line	157
	SBRK	4-LF4
	LAC	* 
	ADDK	1
	SACL	* 
L59:
***	-----------------------g54:
*** 191	-----------------------    if ( time <= 30 ) goto g51;
	.line	160
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BLEZ	L56
L60:
***	-----------------------g55:
*** 194	-----------------------    if ( time > 30 ) goto g57;
	.line	163
	SSXM
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BGZ	L62
*** 195	-----------------------    time = 0;
	.line	164
	LACK	0
	SACL	* 
L62:
L63:
***	-----------------------g57:
***	-----------------------g58:
*** 197	-----------------------    if ( CptdFilter&0x8 ) goto g82;
	.line	166
	LDPK	_CptdFilter
	BIT	_CptdFilter,12
	BBNZ	L87
*** 215	-----------------------    if ( time > 30 ) goto g61;
	.line	184
	SSXM
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BGZ	L66
*** 216	-----------------------    time = 0;
	.line	185
	LACK	0
	SACL	* 
L66:
L67:
***	-----------------------g61:
***	-----------------------g62:
*** 218	-----------------------    if ( CptdFilter&4 ) goto g75;
	.line	187
	LDPK	_CptdFilter
	BIT	_CptdFilter,13
	BBNZ	L80
L68:
***	-----------------------g63:
*** 245	-----------------------    if ( time > 30 ) goto g70;
	.line	214
	SSXM
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BGZ	L75
*** 247	-----------------------    if ( i0 < 6 ) goto g66;
	.line	216
	SBRK	5-LF4
	LAC	* 
	SUBK	6
	BLZ	L71
L70:
***	-----------------------g65:
*** 248	-----------------------    return 3;
	.line	217
	LACK	3
	B	EPI0_4
L71:
***	-----------------------g66:
*** 250	-----------------------    if ( abort() ) goto g74;
	.line	219
	CALL	_abort,AR1
	BNZ	L79
*** 253	-----------------------    if ( i1 <= 6000 ) goto g21;
	.line	222
	SSXM
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* 
	SUBK	6000
	BLEZ	L26
*** 256	-----------------------    if ( time > 30 ) goto g70;
	.line	225
	SBRK	4
	LAC	* 
	SUBK	30
	BGZ	L75
*** 262	-----------------------    return 2;
	.line	231
	LACK	2
	B	EPI0_4
L75:
L76:
***	-----------------------g70:
***	-----------------------g71:
*** 257	-----------------------    if ( CptdFilter&2 ) goto g73;
	.line	226
	LDPK	_CptdFilter
	BIT	_CptdFilter,14
	BBNZ	L78
*** 260	-----------------------    return 8;
	.line	229
	LACK	8
	B	EPI0_4
L78:
***	-----------------------g73:
*** 258	-----------------------    if ( !abort() ) goto g71;
	.line	227
	CALL	_abort,AR1
	BZ	L76
L79:
***	-----------------------g74:
*** 258	-----------------------    return 4;
	LACK	4
	B	EPI0_4
L80:
***	-----------------------g75:
*** 219	-----------------------    if ( Tim0 <= 80 ) goto g77;
	.line	188
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L82
*** 220	-----------------------    Tim0 = 0;
	.line	189
	LACK	0
	SACL	_Tim0
*** 221	-----------------------    ++time;
	.line	190
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
*** 222	-----------------------    ++i2;
	.line	191
	SBRK	4-LF4
	LAC	* 
	ADDK	1
	SACL	* 
L82:
***	-----------------------g77:
*** 224	-----------------------    if ( time <= 50 ) goto g62;
	.line	193
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	50
	BLEZ	L67
*** 225	-----------------------    CID = 1;
	.line	194
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 226	-----------------------    InitRXV21();
	.line	195
	CALL	_InitRXV21,AR1
*** 227	-----------------------    InitTXV21();
	.line	196
	CALL	_InitTXV21
*** 228	-----------------------    CID = 5;
	.line	197
	LACK	5
	LDPK	_CID
	SACL	_CID
*** 229	-----------------------    Tim0 = 0;
	.line	198
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L85:
***	-----------------------g80:
*** 230	-----------------------    if ( Tim0 < 120 ) goto g80;
	.line	199
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	120
	BLZ	L85
*** 231	-----------------------    StartUart();
	.line	200
	CALL	_StartUart,AR1
*** 232	-----------------------    ResetFSK();
	.line	201
	CALL	_ResetFSK
*** 233	-----------------------    return 7;
	.line	202
	LACK	7
	B	EPI0_4
L87:
***	-----------------------g82:
*** 198	-----------------------    if ( Tim0 <= 80 ) goto g84;
	.line	167
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L89
*** 199	-----------------------    Tim0 = 0;
	.line	168
	LACK	0
	SACL	_Tim0
*** 200	-----------------------    ++time;
	.line	169
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
*** 201	-----------------------    ++i2;
	.line	170
	SBRK	4-LF4
	LAC	* 
	ADDK	1
	SACL	* 
L89:
***	-----------------------g84:
*** 203	-----------------------    if ( time <= 50 ) goto g58;
	.line	172
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	50
	BLEZ	L63
*** 204	-----------------------    CID = 1;
	.line	173
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 205	-----------------------    InitRXV23();
	.line	174
	CALL	_InitRXV23,AR1
*** 206	-----------------------    InitTXV23();
	.line	175
	CALL	_InitTXV23
*** 207	-----------------------    CID = 4;
	.line	176
	LACK	4
	LDPK	_CID
	SACL	_CID
*** 208	-----------------------    Tim0 = 0;
	.line	177
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L92:
***	-----------------------g87:
*** 209	-----------------------    if ( Tim0 < 120 ) goto g87;
	.line	178
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	120
	BLZ	L92
*** 210	-----------------------    StartUart();
	.line	179
	CALL	_StartUart,AR1
*** 211	-----------------------    ResetFSK();
	.line	180
	CALL	_ResetFSK
*** 212	-----------------------    return 6;
	.line	181
	LACK	6
EPI0_4:
	.line	232
	MAR	* ,AR1
	SBRK	7
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	263,000000000H,6
*****************************************************
* UNDEFINED REFERENCES                              *
*****************************************************
	.global	_FConnect
	.global	_abort
	.global	_isdigit
	.global	_Dial
	.global	_InitNotch
	.global	_Send1300
	.global	_InitRXV21
	.end
