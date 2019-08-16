*******************************************************
* TMS320C2x/C2xx/C5x ANSI C Codegen Version 6.60       
*******************************************************
;	C:\TI_TOOLS\dspac.exe -v2xx v21v23 C:\WINDOWS\TEMP\v21v23.if 
;	C:\TI_TOOLS\dspopt.exe -h0 -p0 -GAR6 -GAR7 -v2xx -s -O3 C:\WINDOWS\TEMP\v21v23.if C:\WINDOWS\TEMP\v21v23.opt 
;	C:\TI_TOOLS\dspcg.exe -o -GAR6 -GAR7 -v2xx C:\WINDOWS\TEMP\v21v23.opt v21v23.asm C:\WINDOWS\TEMP\v21v23.tmp 
	.port
	.file	"v21v23.c"
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
	.file	"Param.h"
	.globl	_AGCTHRESL
	.globl	_AGCTHRESH
	.globl	_TXGain
	.file	"v21v23.c"
	.globl	_PrintFSK
	.globl	_InitRXV23
	.globl	_InitTXV23
	.globl	_InitTXV21
	.globl	_ResetFSK
	.globl	_StartUart
	.globl	_transfer_buf
	.globl	_FSKREG
	.globl	_Command
	.globl	_FV21
	.globl	_V21Cont
	.globl	_FV23
	.globl	_V23Cont
	.globl	_SendFSK
	.globl	_ModemFSK
	.globl	_Init_V21
	.globl	_Init_V23

	.sym	_Init_V23,_Init_V23,32,2,0
	.globl	_Init_V23

	.func	258
******************************************************
* FUNCTION DEF : _Init_V23
******************************************************
_Init_V23:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 260	-----------------------    if ( Modul&0x100 ) goto g2;
	.line	3
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L2
*** 269	-----------------------    AGCTHRESL = 22528;
	.line	12
	LDPK	_AGCTHRESL
	SPLK	#22528,_AGCTHRESL
*** 270	-----------------------    AGCTHRESH = 23552;
	.line	13
	LDPK	_AGCTHRESH
	SPLK	#23552,_AGCTHRESH
*** 271	-----------------------    TXGain = 640;
	.line	14
	LDPK	_TXGain
	SPLK	#640,_TXGain
*** 271	-----------------------    goto g3;
	B	EPI0_1
L2:
***	-----------------------g2:
*** 262	-----------------------    AGCTHRESL = 27136;
	.line	5
	LDPK	_AGCTHRESL
	SPLK	#27136,_AGCTHRESL
*** 263	-----------------------    AGCTHRESH = 28672;
	.line	6
	LDPK	_AGCTHRESH
	SPLK	#28672,_AGCTHRESH
*** 264	-----------------------    TXGain = 770;
	.line	7
	LDPK	_TXGain
	SPLK	#770,_TXGain
***	-----------------------g3:
***  	-----------------------    return;
EPI0_1:
	.line	17
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	274,000000000H,1

	.sym	_V23Cont,_V23Cont,36,2,0
	.globl	_V23Cont

	.func	161
******************************************************
* FUNCTION DEF : _V23Cont
******************************************************
_V23Cont:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 165	-----------------------    Tim0 = 0;
	.sym	_time,1,4,1,16
	.sym	_i1,2,4,1,16
	.line	5
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 168	-----------------------    CID = 1;
	.line	8
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 169	-----------------------    InitRXV23();
	.line	9
	CALL	_InitRXV23
*** 170	-----------------------    InitTXV23();
	.line	10
	CALL	_InitTXV23
*** 171	-----------------------    Init_V23();
	.line	11
	CALL	_Init_V23
*** 172	-----------------------    CID = 4;
	.line	12
	LACK	4
	LDPK	_CID
	SACL	_CID
*** 163	-----------------------    i1 = time = 0;
	.line	3
	LACK	0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	*+
	SACL	* 
L5:
***	-----------------------g2:
*** 175	-----------------------    if ( FSKREG&2 ) goto g9;
	.line	15
	LDPK	_FSKREG
	BIT	_FSKREG,14
	BBNZ	L12
	SSXM ;;;
L7:
***	-----------------------g4:
*** 192	-----------------------    if ( Tim0 <= 80 ) goto g4;
	.line	32
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L7
*** 193	-----------------------    Tim0 = 0;
	.line	33
	LACK	0
	SACL	_Tim0
*** 196	-----------------------    if ( !abort() ) goto g7;
	.line	36
	CALL	_abort,AR1
	BZ	L10
*** 196	-----------------------    return 4;
	LACK	4
	B	EPI0_2
L10:
***	-----------------------g7:
*** 190	-----------------------    time = 0;
	.line	30
	LACK	0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	*+
*** 194	-----------------------    if ( (++i1) < 1500 ) goto g2;
	.line	34
	SSXM
	LAC	* 
	ADDK	1
	SACL	* 
	SUBK	1500
	BLZ	L5
*** 199	-----------------------    return 2;
	.line	39
	LACK	2
	B	EPI0_2
L12:
L13:
***	-----------------------g9:
***	-----------------------g10:
*** 176	-----------------------    if ( Tim0 <= 80 ) goto g12;
	.line	16
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L15
*** 177	-----------------------    Tim0 = 0;
	.line	17
	LACK	0
	SACL	_Tim0
*** 178	-----------------------    ++time;
	.line	18
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
L15:
***	-----------------------g12:
*** 181	-----------------------    if ( time <= 30 ) goto g10;
	.line	21
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BLEZ	L13
*** 183	-----------------------    Tim0 = 0;
	.line	23
	LACK	0
	SACL	_Tim0
L18:
***	-----------------------g15:
*** 184	-----------------------    if ( Tim0 < 160 ) goto g15;
	.line	24
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	160
	BLZ	L18
*** 185	-----------------------    ResetFSK();
	.line	25
	CALL	_ResetFSK,AR1
*** 186	-----------------------    StartUart();
	.line	26
	CALL	_StartUart
*** 187	-----------------------    return 6;
	.line	27
	LACK	6
EPI0_2:
	.line	40
	MAR	* ,AR1
	SBRK	4
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	200,000000000H,3

	.sym	_Init_V21,_Init_V21,32,2,0
	.globl	_Init_V21

	.func	240
******************************************************
* FUNCTION DEF : _Init_V21
******************************************************
_Init_V21:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 242	-----------------------    if ( Modul&0x100 ) goto g2;
	.line	3
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L20
*** 250	-----------------------    AGCTHRESL = 20480;
	.line	11
	LDPK	_AGCTHRESL
	SPLK	#20480,_AGCTHRESL
*** 251	-----------------------    AGCTHRESH = 22528;
	.line	12
	LDPK	_AGCTHRESH
	SPLK	#22528,_AGCTHRESH
*** 252	-----------------------    TXGain = 550;
	.line	13
	LDPK	_TXGain
	SPLK	#550,_TXGain
*** 252	-----------------------    goto g3;
	B	EPI0_3
L20:
***	-----------------------g2:
*** 244	-----------------------    AGCTHRESL = 25856;
	.line	5
	LDPK	_AGCTHRESL
	SPLK	#25856,_AGCTHRESL
*** 245	-----------------------    AGCTHRESH = 27648;
	.line	6
	LDPK	_AGCTHRESH
	SPLK	#27648,_AGCTHRESH
*** 246	-----------------------    TXGain = 550;
	.line	7
	LDPK	_TXGain
	SPLK	#550,_TXGain
***	-----------------------g3:
***  	-----------------------    return;
EPI0_3:
	.line	15
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	254,000000000H,1

	.sym	_V21Cont,_V21Cont,36,2,0
	.globl	_V21Cont

	.func	75
******************************************************
* FUNCTION DEF : _V21Cont
******************************************************
_V21Cont:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 79	-----------------------    Tim0 = 0;
	.sym	_time,1,4,1,16
	.sym	_i1,2,4,1,16
	.line	5
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 81	-----------------------    CID = 1;
	.line	7
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 82	-----------------------    InitRXV21();
	.line	8
	CALL	_InitRXV21
*** 83	-----------------------    InitTXV21();
	.line	9
	CALL	_InitTXV21
*** 84	-----------------------    Init_V21();
	.line	10
	CALL	_Init_V21
*** 85	-----------------------    CID = 5;
	.line	11
	LACK	5
	LDPK	_CID
	SACL	_CID
*** 77	-----------------------    i1 = time = 0;
	.line	3
	LACK	0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	*+
	SACL	* 
L23:
***	-----------------------g2:
*** 88	-----------------------    if ( FSKREG&2 ) goto g9;
	.line	14
	LDPK	_FSKREG
	BIT	_FSKREG,14
	BBNZ	L30
	SSXM ;;;
L25:
***	-----------------------g4:
*** 105	-----------------------    if ( Tim0 <= 80 ) goto g4;
	.line	31
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L25
*** 106	-----------------------    Tim0 = 0;
	.line	32
	LACK	0
	SACL	_Tim0
*** 109	-----------------------    if ( !abort() ) goto g7;
	.line	35
	CALL	_abort,AR1
	BZ	L28
*** 109	-----------------------    return 4;
	LACK	4
	B	EPI0_4
L28:
***	-----------------------g7:
*** 103	-----------------------    time = 0;
	.line	29
	LACK	0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	*+
*** 107	-----------------------    if ( (++i1) < 1500 ) goto g2;
	.line	33
	SSXM
	LAC	* 
	ADDK	1
	SACL	* 
	SUBK	1500
	BLZ	L23
*** 112	-----------------------    return 2;
	.line	38
	LACK	2
	B	EPI0_4
L30:
L31:
***	-----------------------g9:
***	-----------------------g10:
*** 89	-----------------------    if ( Tim0 <= 80 ) goto g12;
	.line	15
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	80
	BLEZ	L33
*** 90	-----------------------    Tim0 = 0;
	.line	16
	LACK	0
	SACL	_Tim0
*** 91	-----------------------    ++time;
	.line	17
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
L33:
***	-----------------------g12:
*** 94	-----------------------    if ( time <= 30 ) goto g10;
	.line	20
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	30
	BLEZ	L31
*** 96	-----------------------    Tim0 = 0;
	.line	22
	LACK	0
	SACL	_Tim0
L36:
***	-----------------------g15:
*** 97	-----------------------    if ( Tim0 < 160 ) goto g15;
	.line	23
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	160
	BLZ	L36
*** 98	-----------------------    ResetFSK();
	.line	24
	CALL	_ResetFSK,AR1
*** 99	-----------------------    StartUart();
	.line	25
	CALL	_StartUart
*** 100	-----------------------    return 7;
	.line	26
	LACK	7
EPI0_4:
	.line	39
	MAR	* ,AR1
	SBRK	4
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	113,000000000H,3

	.sym	_SendFSK,_SendFSK,32,2,0
	.globl	_SendFSK

	.func	203
******************************************************
* FUNCTION DEF : _SendFSK
******************************************************
_SendFSK:

LF5	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+,AR2

	.sym	_temp,-3+LF5,4,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.sym	C$1,1,20,1,16
	.line	2
*** 207	-----------------------    Phi1 = 0;
	.line	5
	LACK	0
	LDPK	_Phi1
	SACL	_Phi1
*** 208	-----------------------    Phi2 = 0;
	.line	6
	LDPK	_Phi2
	SACL	_Phi2
*** 210	-----------------------    C$1 = &ToneTable[(temp *= 4)];
	.line	8
	LARK	AR2,-3+LF5
	MAR	*0+
	LAC	* ,2
	SACL	* 
	ADLK	_ToneTable+0,0
	ADRK	4-LF5
	SACL	* ,AR1
*** 210	-----------------------    DeltaPhi1 = table_read(C$1);
	SACL	*+
	CALL	_table_read
	MAR	*-,AR2
	LDPK	_DeltaPhi1
	SACL	_DeltaPhi1
*** 211	-----------------------    DeltaPhi2 = table_read(C$1+1);
	.line	9
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	ADDK	1
	SACL	*+
	CALL	_table_read
	MAR	*-,AR2
	LDPK	_DeltaPhi2
	SACL	_DeltaPhi2
*** 213	-----------------------    Ampl1 = table_read(C$1+2);
	.line	11
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	ADDK	2
	SACL	*+
	CALL	_table_read
	MAR	*-
	LDPK	_Ampl1
	SACL	_Ampl1
*** 214	-----------------------    Ampl2 = 0;
	.line	12
	LACK	0
	LDPK	_Ampl2
	SACL	_Ampl2
*** 216	-----------------------    DtmfFlag = 1;
	.line	14
	LACK	1
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
***  	-----------------------    return;
EPI0_5:
	.line	15
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	217,000000000H,2

	.sym	_ModemFSK,_ModemFSK,36,2,0
	.globl	_ModemFSK

	.func	221
******************************************************
* FUNCTION DEF : _ModemFSK
******************************************************
_ModemFSK:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 223	-----------------------    return (FSKREG>>1^1)&1;
	.line	3
	SSXM
	LDPK	_FSKREG
	LAC	_FSKREG,14
	XORK	1,15
	ANDK	1,15
	SACH	* ,1
	LAC	* 
EPI0_6:
	.line	17
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	237,000000000H,1

	.sym	_FV23,_FV23,36,2,0
	.globl	_FV23

	.func	118
******************************************************
* FUNCTION DEF : _FV23
******************************************************
_FV23:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 121	-----------------------    Tim0 = 0;
	.line	4
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 123	-----------------------    if ( Modul&0x100 ) goto g13;
	.line	6
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L49
*** 129	-----------------------    Tim0 = 0;
	.line	12
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L39:
***	-----------------------g3:
*** 130	-----------------------    if ( Tim0 < 17200 ) goto g3;
	.line	13
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	17200
	BLZ	L39
*** 132	-----------------------    SendFSK(17);
	.line	15
	LACK	17
	SACL	*+
	CALL	_SendFSK
	MAR	*-
*** 133	-----------------------    CID = 1;
	.line	16
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 134	-----------------------    InitTot();
	.line	17
	CALL	_InitTot
*** 135	-----------------------    CID = 3;
	.line	18
	LACK	3
	LDPK	_CID
	SACL	_CID
*** 136	-----------------------    Tim0 = 0;
	.line	19
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L42:
***	-----------------------g6:
*** 137	-----------------------    if ( Tim0 < 24000 ) goto g16;
	.line	20
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	24000
	BLZ	L52
*** 141	-----------------------    Tim0 = 0;
	.line	24
	LACK	0
	SACL	_Tim0
L45:
***	-----------------------g9:
*** 142	-----------------------    if ( Tim0 < 2400 ) goto g15;
	.line	25
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	2400
	BLZ	L51
*** 148	-----------------------    DtmfFlag = 0;
	.line	31
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 149	-----------------------    Tim0 = 0;
	.line	32
	LDPK	_Tim0
	SACL	_Tim0
L48:
***	-----------------------g12:
*** 150	-----------------------    if ( Tim0 < 600 ) goto g14;
	.line	33
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	600
	BLZ	L50
L49:
***	-----------------------g13:
*** 156	-----------------------    return V23Cont();
	.line	39
	CALL	_V23Cont,AR1
	B	EPI0_7
L50:
***	-----------------------g14:
*** 152	-----------------------    if ( !abort() ) goto g12;
	.line	35
	CALL	_abort,AR1
	BZ	L48
*** 152	-----------------------    goto g17;
	B	L53
L51:
***	-----------------------g15:
*** 144	-----------------------    if ( !abort() ) goto g9;
	.line	27
	CALL	_abort,AR1
	BZ	L45
*** 144	-----------------------    goto g17;
	B	L53
L52:
***	-----------------------g16:
*** 138	-----------------------    if ( !abort() ) goto g6;
	.line	21
	CALL	_abort,AR1
	BZ	L42
L53:
***	-----------------------g17:
*** 153	-----------------------    return 2;
	.line	36
	LACK	2
EPI0_7:
	.line	41
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	158,000000000H,1

	.sym	_FV21,_FV21,36,2,0
	.globl	_FV21

	.func	31
******************************************************
* FUNCTION DEF : _FV21
******************************************************
_FV21:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 34	-----------------------    Tim0 = 0;
	.line	4
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 37	-----------------------    if ( Modul&0x100 ) goto g13;
	.line	7
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L66
*** 43	-----------------------    DtmfFlag = 0;
	.line	13
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 44	-----------------------    Tim0 = 0;
	.line	14
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L56:
***	-----------------------g3:
*** 45	-----------------------    if ( Tim0 < 17200 ) goto g3;
	.line	15
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	17200
	BLZ	L56
*** 47	-----------------------    SendFSK(17);
	.line	17
	LACK	17
	SACL	*+
	CALL	_SendFSK
	MAR	*-
*** 48	-----------------------    CID = 1;
	.line	18
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 49	-----------------------    InitTot();
	.line	19
	CALL	_InitTot
*** 50	-----------------------    CID = 3;
	.line	20
	LACK	3
	LDPK	_CID
	SACL	_CID
*** 51	-----------------------    Tim0 = 0;
	.line	21
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L59:
***	-----------------------g6:
*** 52	-----------------------    if ( Tim0 < 24000 ) goto g16;
	.line	22
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	24000
	BLZ	L69
*** 56	-----------------------    Tim0 = 0;
	.line	26
	LACK	0
	SACL	_Tim0
L62:
***	-----------------------g9:
*** 57	-----------------------    if ( Tim0 < 2400 ) goto g15;
	.line	27
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	2400
	BLZ	L68
*** 63	-----------------------    DtmfFlag = 0;
	.line	33
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 64	-----------------------    Tim0 = 0;
	.line	34
	LDPK	_Tim0
	SACL	_Tim0
L65:
***	-----------------------g12:
*** 65	-----------------------    if ( Tim0 < 600 ) goto g14;
	.line	35
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	600
	BLZ	L67
L66:
***	-----------------------g13:
*** 70	-----------------------    return V21Cont();
	.line	40
	CALL	_V21Cont,AR1
	B	EPI0_8
L67:
***	-----------------------g14:
*** 67	-----------------------    if ( !abort() ) goto g12;
	.line	37
	CALL	_abort,AR1
	BZ	L65
*** 67	-----------------------    goto g17;
	B	L70
L68:
***	-----------------------g15:
*** 59	-----------------------    if ( !abort() ) goto g9;
	.line	29
	CALL	_abort,AR1
	BZ	L62
*** 59	-----------------------    goto g17;
	B	L70
L69:
***	-----------------------g16:
*** 53	-----------------------    if ( !abort() ) goto g6;
	.line	23
	CALL	_abort,AR1
	BZ	L59
L70:
***	-----------------------g17:
*** 68	-----------------------    return 2;
	.line	38
	LACK	2
EPI0_8:
	.line	42
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	72,000000000H,1
*****************************************************
* UNDEFINED REFERENCES                              *
*****************************************************
	.global	_Init_V23
	.global	_abort
	.global	_InitRXV21
	.global	_Init_V21
	.global	_SendFSK
	.global	_V23Cont
	.global	_V21Cont
	.end
