*******************************************************
* TMS320C2x/C2xx/C5x ANSI C Codegen Version 6.60       
*******************************************************
;	C:\TI_TOOLS\dspac.exe -v2xx v22b C:\WINDOWS\TEMP\v22b.if 
;	C:\TI_TOOLS\dspopt.exe -h0 -p0 -GAR6 -GAR7 -v2xx -s -O3 C:\WINDOWS\TEMP\v22b.if C:\WINDOWS\TEMP\v22b.opt 
;	C:\TI_TOOLS\dspcg.exe -o -GAR6 -GAR7 -v2xx C:\WINDOWS\TEMP\v22b.opt v22b.asm C:\WINDOWS\TEMP\v22b.tmp 
	.port
	.file	"v22b.c"
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
	.file	"v22b.c"
	.globl	_TVGain
	.globl	_mdm_sta
	.globl	_Guard
	.globl	_ALPHA
	.globl	_V22TR1
	.globl	_V22TR2
	.globl	_s1snd
	.globl	_sendmarks
	.globl	_FV22b
	.globl	_FV22
	.globl	_abort
	.globl	_EndOfV22Ans
	.globl	_EndV22Call
	.globl	_SendCmd
	.globl	_SendData
	.globl	_ReadData
	.globl	_FV21
	.globl	_FV23
	.globl	_SendFSK
	.globl	_Print
	.globl	_speed
	.globl	_V22b
	.globl	_FV22b
	.globl	_detectS0
	.globl	_Carrier
	.globl	_s1snd
	.globl	_sendmarks
	.globl	_FV22
	.globl	_abort
	.globl	_EndV22Call
	.globl	_EndOfV22Ans

	.sym	_TVGain,_TVGain,4,2,16
	.globl	_TVGain
	.bss	_TVGain,1,1

	.sym	_speed,_speed,4,2,16
	.globl	_speed
	.bss	_speed,1

	.sym	_V22TR1,_V22TR1,4,2,16
	.globl	_V22TR1
	.bss	_V22TR1,1

	.sym	_V22TR2,_V22TR2,4,2,16
	.globl	_V22TR2
	.bss	_V22TR2,1

	.sym	_sendmarks,_sendmarks,32,2,0
	.globl	_sendmarks

	.func	337
******************************************************
* FUNCTION DEF : _sendmarks
******************************************************
_sendmarks:

LF1	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+

	.sym	_mode,-3+LF1,14,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.sym	_xdibit,1,14,1,16
	.line	2
*** 341	-----------------------    xdibit = scramble(3);
	.line	5
	LACK	3
	SACL	*+
	CALL	_scramble
	MAR	*-,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* ,AR0
*** 342	-----------------------    xdibit *= 4u;
	.line	6
	SACL	* 
	LAC	* ,2,AR2
	SACL	* 
***  	-----------------------    switch ( mode ) {...};
	SBRK	4-LF1
	ZALS	* 
	BZ	L3
	SUBK	1
	BZ	L2
	SUBK	1
	BNZ	L4
***	-----------------------g1:
*** 352	-----------------------    xdibit |= scramble(3);
	.line	16
	MAR	* ,AR1
	LACK	3
	SACL	*+
	CALL	_scramble
	MAR	*-,AR2
	LARK	AR2,1
	MAR	*0+
	OR	* 
	SACL	* 
*** 353	-----------------------    xdibit |= 0x10u;
	.line	17
	ORK	16
	SACL	* 
*** 354	-----------------------    goto g4;
	.line	18
	B	L4
L2:
***	-----------------------g2:
*** 346	-----------------------    xdibit |= 0x21u;
	.line	10
	LACK	33
	ADRK	4-LF1
	OR	* 
	SACL	* 
*** 347	-----------------------    goto g4;
	.line	11
	B	L4
L3:
***	-----------------------g3:
*** 349	-----------------------    xdibit |= 0x11u;
	.line	13
	LACK	17
	ADRK	4-LF1
	OR	* 
	SACL	* 
L4:
***	-----------------------g4:
*** 356	-----------------------    SendCmd(xdibit);
	.line	20
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_SendCmd
	MAR	*-
***  	-----------------------    return;
EPI0_1:
	.line	21
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	357,000000000H,2

	.sym	_s1snd,_s1snd,32,2,0
	.globl	_s1snd

	.func	326
******************************************************
* FUNCTION DEF : _s1snd
******************************************************
_s1snd:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+,AR2

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
***  	-----------------------    L$1 = 30;
	.sym	L$1,1,4,1,16
	LACK	30
	LARK	AR2,1
	MAR	*0+
	SACL	* ,AR1
L6:
***	-----------------------g2:
*** 331	-----------------------    SendCmd(33u);
	.line	6
	LACK	33
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 332	-----------------------    SendCmd(45u);
	.line	7
	LACK	45
	SACL	*+
	CALL	_SendCmd
	MAR	*-,AR2
*** 330	-----------------------    if ( --L$1 ) goto g2;
	.line	5
	SSXM
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* ,AR1
	BNZ	L6
***  	-----------------------    return;
EPI0_2:
	.line	9
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	334,000000000H,2

	.sym	_abort,_abort,36,2,0
	.globl	_abort

	.func	448
******************************************************
* FUNCTION DEF : _abort
******************************************************
_abort:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 450	-----------------------    return ReadData() >= 0;
	.line	3
	CALL	_ReadData
	LARK	AR5,1
	BGEZ	LL5
	LARK	AR5,0
LL5:
	MAR	* ,AR0
	SAR	AR5,*
	SSXM
	LAC	* 
EPI0_3:
	.line	5
	MAR	* ,AR1
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	452,000000000H,1

	.sym	_detectS0,_detectS0,46,2,0
	.globl	_detectS0

	.func	302
******************************************************
* FUNCTION DEF : _detectS0
******************************************************
_detectS0:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 306	-----------------------    SendCmd(246u);
	.line	5
	LACK	246
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 307	-----------------------    SendCmd(114u);
	.line	6
	LACK	114
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 308	-----------------------    Tim0 = 0;
	.line	7
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L8:
***	-----------------------g2:
*** 308	-----------------------    if ( Tim0 < 200 && (mdm_sta&0x10) == 0 ) goto g2;
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	200
	BGEZ	LL8
	LDPK	_mdm_sta
	BIT	_mdm_sta,11
	BBZ	L8
LL8:
*** 311	-----------------------    Tim0 = 0;
	.line	10
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 311	-----------------------    goto g5;
***	-----------------------g4:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
L11:
***	-----------------------g5:
*** 312	-----------------------    if ( Tim0 < 590 ) goto g7;
	.line	11
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	590
	BLZ	L13
*** 314	-----------------------    return 0u;
	.line	13
	LACK	0
	B	EPI0_4
L13:
***	-----------------------g7:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 312	-----------------------    if ( ReadData() < 0 ) goto g4;
	.line	11
	CALL	_ReadData,AR1
	BLZ	L11
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 312	-----------------------    return 2u;
	LACK	2
EPI0_4:
	.line	14
	MAR	* ,AR1
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	315,000000000H,1

	.sym	_EndOfV22Ans,_EndOfV22Ans,36,2,0
	.globl	_EndOfV22Ans

	.func	479
******************************************************
* FUNCTION DEF : _EndOfV22Ans
******************************************************
_EndOfV22Ans:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 484	-----------------------    SendCmd(45u);
	.sym	_i0,1,4,1,16
	.line	6
	LACK	45
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 485	-----------------------    Tim0 = 0;
	.line	7
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 485	-----------------------    goto g2;
***	-----------------------g1:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
L15:
***	-----------------------g2:
*** 486	-----------------------    if ( Tim0 < 270 ) goto g11;
	.line	8
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	270
	BLZ	L24
*** 489	-----------------------    speed = 1200;
	.line	11
	LDPK	_speed
	SPLK	#1200,_speed
*** 491	-----------------------    StartUart();
	.line	13
	CALL	_StartUart,AR1
*** 494	-----------------------    Tim0 = 0;
	.line	16
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 492	-----------------------    i0 = 0;
	.line	14
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
L18:
***	-----------------------g5:
*** 498	-----------------------    if ( Tim0 < 765 ) goto g7;
	.line	20
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	765
	BLZ	L20
*** 500	-----------------------    return Tim0-i0 < 27;
	.line	22
	LAC	_Tim0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SUB	* 
	SUBK	27
	LARK	AR5,1
	BLZ	LL11
	LARK	AR5,0
LL11:
	MAR	* ,AR0
	SAR	AR5,*
	LAC	* 
	B	EPI0_5
L20:
***	-----------------------g7:
*** 495	-----------------------    if ( (GetData()&2) == 0 || Tim0-i0 >= 27 ) goto g9;
	.line	17
	CALL	_GetData,AR1
	ANDK	2
	ANDK	0FFFFh
	BZ	L22
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SUB	* 
	SUBK	27
	BGEZ	L22
*** 496	-----------------------    i0 = Tim0;
	.line	18
	BLKD	#_Tim0,* 
L22:
***	-----------------------g9:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 498	-----------------------    if ( ReadData() >= 0 ) goto g12;
	.line	20
	CALL	_ReadData,AR1
	BGEZ	L25
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 498	-----------------------    goto g5;
	B	L18
L24:
***	-----------------------g11:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 486	-----------------------    if ( ReadData() < 0 ) goto g1;
	.line	8
	CALL	_ReadData,AR1
	BLZ	L15
L25:
***	-----------------------g12:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 498	-----------------------    return 2;
	.line	20
	LACK	2
EPI0_5:
	.line	24
	MAR	* ,AR1
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	502,000000000H,2

	.sym	_EndV22Call,_EndV22Call,36,2,0
	.globl	_EndV22Call

	.func	455
******************************************************
* FUNCTION DEF : _EndV22Call
******************************************************
_EndV22Call:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 461	-----------------------    speed = 1200;
	.sym	_i0,1,4,1,16
	.line	7
	LDPK	_speed
	SPLK	#1200,_speed
*** 463	-----------------------    sendmarks(1u);
	.line	9
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-
*** 464	-----------------------    sendmarks(1u);
	.line	10
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-
*** 465	-----------------------    StartUart();
	.line	11
	CALL	_StartUart
*** 468	-----------------------    Tim0 = 0;
	.line	14
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 467	-----------------------    i0 = 0;
	.line	13
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
*** 468	-----------------------    goto g2;
	.line	14
***	-----------------------g1:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
L27:
***	-----------------------g2:
*** 472	-----------------------    if ( Tim0 < 1035 ) goto g4;
	.line	18
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	1035
	BLZ	L29
*** 474	-----------------------    return Tim0-i0 < 14;
	.line	20
	LAC	_Tim0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SUB	* 
	SUBK	14
	LARK	AR5,1
	BLZ	LL14
	LARK	AR5,0
LL14:
	MAR	* ,AR0
	SAR	AR5,*
	LAC	* 
	B	EPI0_6
L29:
***	-----------------------g4:
*** 469	-----------------------    if ( (GetData()&2) == 0 || Tim0-i0 >= 14 ) goto g6;
	.line	15
	CALL	_GetData,AR1
	ANDK	2
	ANDK	0FFFFh
	BZ	L31
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SUB	* 
	SUBK	14
	BGEZ	L31
*** 470	-----------------------    i0 = Tim0;
	.line	16
	BLKD	#_Tim0,* 
L31:
***	-----------------------g6:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 472	-----------------------    if ( ReadData() < 0 ) goto g1;
	.line	18
	CALL	_ReadData,AR1
	BLZ	L27
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 472	-----------------------    return 2;
	LACK	2
EPI0_6:
	.line	22
	MAR	* ,AR1
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	476,000000000H,2

	.sym	_FV22,_FV22,36,2,0
	.globl	_FV22

	.func	361
******************************************************
* FUNCTION DEF : _FV22
******************************************************
_FV22:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
*  ---  NewAlpha shares AUTO storage with S0Count
*
*** 370	-----------------------    if ( Modul&0x100 ) goto g28;
	.sym	_stat,1,14,1,16
	.sym	_NewAlpha,2,4,1,16
	.line	10
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L59
*** 402	-----------------------    Tim0 = 0;
	.line	42
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L34:
***	-----------------------g3:
*** 402	-----------------------    if ( Tim0 < 17200 ) goto g3;
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	17200
	BLZ	L34
*** 404	-----------------------    SendFSK(17);
	.line	44
	LACK	17
	SACL	*+
	CALL	_SendFSK
	MAR	*-
*** 405	-----------------------    CID = 1;
	.line	45
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 406	-----------------------    InitTot();
	.line	46
	CALL	_InitTot
*** 407	-----------------------    CID = 3;
	.line	47
	LACK	3
	LDPK	_CID
	SACL	_CID
*** 408	-----------------------    Tim0 = 0;
	.line	48
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L37:
***	-----------------------g6:
*** 409	-----------------------    if ( Tim0 < 26400 ) goto g26;
	.line	49
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	26400
	BLZ	L57
*** 412	-----------------------    CID = 1;
	.line	52
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 413	-----------------------    DtmfFlag = 0;
	.line	53
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 414	-----------------------    Tim0 = 0;
	.line	54
	LDPK	_Tim0
	SACL	_Tim0
L40:
***	-----------------------g9:
*** 415	-----------------------    if ( Tim0 < 600 ) goto g24;
	.line	55
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	600
	BLZ	L55
*** 417	-----------------------    modemini();
	.line	57
	CALL	_modemini,AR1
*** 419	-----------------------    SendCmd(48u);
	.line	59
	LACK	48
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 420	-----------------------    SendCmd(254u);
	.line	60
	LACK	254
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 421	-----------------------    SendCmd(114u);
	.line	61
	LACK	114
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 422	-----------------------    SendCmd(130u);
	.line	62
	LACK	130
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 425	-----------------------    Tim0 = 0;
	.line	65
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L43:
***	-----------------------g12:
*** 427	-----------------------    if ( Tim0 < 400 ) goto g22;
	.line	67
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	400
	BLZ	L53
*** 431	-----------------------    NewAlpha = (ALPHA>>1)+(ALPHA>>2);
	.line	71
	LDPK	_ALPHA
	LAC	_ALPHA,13
	MAR	* ,AR1
	SACH	* ,1
	LAC	_ALPHA,14
	ADD	* ,15,AR2
	LARK	AR2,2
	MAR	*0+
	SACH	* ,1
*** 432	-----------------------    Tim0 = 0;
	.line	72
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L46:
***	-----------------------g15:
*** 437	-----------------------    if ( Tim0 >= 24000 ) goto g17;
	.line	77
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	24000
	BGEZ	L48
*** 433	-----------------------    SendCmd(29u);
	.line	73
	MAR	* ,AR1
	LACK	29
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 434	-----------------------    if ( (mdm_sta&0x40) == 0 || ALPHA >= NewAlpha ) goto g20;
	.line	74
	LDPK	_mdm_sta
	BIT	_mdm_sta,9
	BBZ	L51
	SSXM
	LDPK	_ALPHA
	LAC	_ALPHA
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SUB	* 
	BGEZ	L51
L48:
***	-----------------------g17:
*** 439	-----------------------    if ( Tim0 < 24000 ) goto g19;
	.line	79
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	24000
	BLZ	L50
*** 439	-----------------------    return 1;
	LACK	1
	B	EPI0_7
L50:
***	-----------------------g19:
*** 441	-----------------------    SendCmd(67u);
	.line	81
	MAR	* ,AR1
	LACK	67
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 442	-----------------------    return EndOfV22Ans();
	.line	82
	CALL	_EndOfV22Ans
	B	EPI0_7
L51:
***	-----------------------g20:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 437	-----------------------    if ( ReadData() >= 0 ) goto g37;
	.line	77
	CALL	_ReadData,AR1
	BGEZ	L68
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 437	-----------------------    goto g15;
	B	L46
L53:
***	-----------------------g22:
*** 426	-----------------------    SendCmd(29u);
	.line	66
	MAR	* ,AR1
	LACK	29
	SACL	*+
	CALL	_SendCmd
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 427	-----------------------    if ( ReadData() >= 0 ) goto g37;
	.line	67
	CALL	_ReadData
	BGEZ	L68
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 427	-----------------------    goto g12;
	B	L43
L55:
***	-----------------------g24:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 415	-----------------------    if ( ReadData() >= 0 ) goto g37;
	.line	55
	CALL	_ReadData,AR1
	BGEZ	L68
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 415	-----------------------    goto g9;
	B	L40
L57:
***	-----------------------g26:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 409	-----------------------    if ( ReadData() >= 0 ) goto g37;
	.line	49
	CALL	_ReadData,AR1
	BGEZ	L68
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 409	-----------------------    goto g6;
	B	L37
L59:
***	-----------------------g28:
*** 372	-----------------------    modemini();
	.line	12
	CALL	_modemini
*** 374	-----------------------    if ( !(stat = detectS0()) ) goto g30;
	.line	14
	CALL	_detectS0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
	BZ	L61
*** 376	-----------------------    return (int)stat;
	.line	16
	SSXM
	LAC	* 
	B	EPI0_7
L61:
***	-----------------------g30:
*** 378	-----------------------    SendCmd(246u);
	.line	18
	MAR	* ,AR1
	LACK	246
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 379	-----------------------    SendCmd(130u);
	.line	19
	LACK	130
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 382	-----------------------    Tim0 = 0;
	.line	22
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 382	-----------------------    if ( Tim0 >= 1800 ) goto g39;
	SSXM
	LAC	_Tim0
	SUBK	1800
	BGEZ	L70
*** 381	-----------------------    S0Count = 60;
	.line	21
	LACK	60
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* ,AR1
L64:
***	-----------------------g33:
*** 383	-----------------------    sendmarks(1u);
	.line	23
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-
*** 386	-----------------------    if ( mdm_sta&0x10 ) goto g35;
	.line	26
	LDPK	_mdm_sta
	BIT	_mdm_sta,11
	BBNZ	L66
*** 390	-----------------------    if ( --S0Count ) goto g36;
	.line	30
	SSXM
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* 
	BNZ	L67
*** 390	-----------------------    goto g39;
	B	L70
L66:
***	-----------------------g35:
*** 388	-----------------------    S0Count = 60;
	.line	28
	LACK	60
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
L67:
***	-----------------------g36:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 393	-----------------------    if ( ReadData() < 0 ) goto g38;
	.line	33
	CALL	_ReadData,AR1
	BLZ	L69
L68:
***	-----------------------g37:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 393	-----------------------    return 2;
	LACK	2
	B	EPI0_7
L69:
***	-----------------------g38:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 393	-----------------------    if ( Tim0 < 1800 ) goto g33;
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	1800
	BLZ	L64
L70:
***	-----------------------g39:
*** 397	-----------------------    SendCmd(67u);
	.line	37
	MAR	* ,AR1
	LACK	67
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 398	-----------------------    return EndV22Call();
	.line	38
	CALL	_EndV22Call
EPI0_7:
	.line	84
	MAR	* ,AR1
	SBRK	4
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	444,000000000H,3

	.sym	_FV22b,_FV22b,36,2,0
	.globl	_FV22b

	.func	112
******************************************************
* FUNCTION DEF : _FV22b
******************************************************
_FV22b:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
*  ---  L$1 shares AUTO storage with i0
*  ---  L$1 shares AUTO storage with S0Count
*  ---  L$1 shares AUTO storage with NewAlpha
*
*** 122	-----------------------    if ( Modul&0x100 ) goto g46;
	.sym	_stat,1,14,1,16
	.sym	L$1,2,4,1,16
	.line	11
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L116
*** 183	-----------------------    Tim0 = 0;
	.line	72
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
	SSXM ;;;
L73:
***	-----------------------g3:
*** 183	-----------------------    if ( Tim0 < 17200 ) goto g3;
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	17200
	BLZ	L73
*** 185	-----------------------    SendFSK(17);
	.line	74
	LACK	17
	SACL	*+
	CALL	_SendFSK
	MAR	*-
*** 186	-----------------------    CID = 1;
	.line	75
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 187	-----------------------    InitTot();
	.line	76
	CALL	_InitTot
*** 188	-----------------------    CID = 3;
	.line	77
	LACK	3
	LDPK	_CID
	SACL	_CID
*** 189	-----------------------    Tim0 = 0;
	.line	78
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L76:
***	-----------------------g6:
*** 190	-----------------------    if ( Tim0 < 26400 ) goto g44;
	.line	79
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	26400
	BLZ	L114
*** 193	-----------------------    CID = 1;
	.line	82
	LACK	1
	LDPK	_CID
	SACL	_CID
*** 194	-----------------------    DtmfFlag = 0;
	.line	83
	LACK	0
	LDPK	_DtmfFlag
	SACL	_DtmfFlag
*** 195	-----------------------    Tim0 = 0;
	.line	84
	LDPK	_Tim0
	SACL	_Tim0
L79:
***	-----------------------g9:
*** 196	-----------------------    if ( Tim0 < 600 ) goto g42;
	.line	85
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	600
	BLZ	L112
*** 198	-----------------------    modemini();
	.line	87
	CALL	_modemini,AR1
*** 200	-----------------------    SendCmd(48u);
	.line	89
	LACK	48
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 201	-----------------------    SendCmd(255u);
	.line	90
	LACK	255
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 202	-----------------------    SendCmd(114u);
	.line	91
	LACK	114
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 203	-----------------------    SendCmd(130u);
	.line	92
	LACK	130
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 204	-----------------------    Tim0 = 0;
	.line	93
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L82:
***	-----------------------g12:
*** 206	-----------------------    if ( Tim0 < 400 ) goto g40;
	.line	95
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	400
	BLZ	L110
*** 209	-----------------------    NewAlpha = (ALPHA>>1)+(ALPHA>>2);
	.line	98
	LDPK	_ALPHA
	LAC	_ALPHA,13
	MAR	* ,AR1
	SACH	* ,1
	LAC	_ALPHA,14
	ADD	* ,15,AR2
	LARK	AR2,2
	MAR	*0+
	SACH	* ,1
*** 211	-----------------------    Tim0 = 0;
	.line	100
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 211	-----------------------    goto g16;
	B	L86
L84:
***	-----------------------g14:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 217	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	106
	CALL	_ReadData,AR1
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
L86:
***	-----------------------g16:
*** 217	-----------------------    if ( Tim0 >= 24000 ) goto g18;
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	24000
	BGEZ	L88
*** 212	-----------------------    SendCmd(29u);
	.line	101
	MAR	* ,AR1
	LACK	29
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 213	-----------------------    if ( ((mdm_sta&0x40) == 0 || ALPHA >= NewAlpha) && (mdm_sta&0x20) == 0 ) goto g14;
	.line	102
	LDPK	_mdm_sta
	BIT	_mdm_sta,9
	BBZ	LL19
	SSXM
	LDPK	_ALPHA
	LAC	_ALPHA
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SUB	* 
	BLZ	L88
LL19:
	LDPK	_mdm_sta
	BIT	_mdm_sta,10
	MAR	* ,AR1
	BBZ	L84
L88:
***	-----------------------g18:
*** 219	-----------------------    if ( Tim0 >= 24000 ) goto g82;
	.line	108
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	24000
	BGEZ	L152
*** 220	-----------------------    Tim0 = 0;
	.line	109
	LACK	0
	SACL	_Tim0
*** 220	-----------------------    goto g22;
	B	L92
L90:
***	-----------------------g20:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 223	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	112
	CALL	_ReadData,AR1
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
L92:
***	-----------------------g22:
*** 223	-----------------------    if ( Tim0 >= 100 ) goto g24;
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	100
	BGEZ	L94
*** 221	-----------------------    SendCmd(29u);
	.line	110
	MAR	* ,AR1
	LACK	29
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 222	-----------------------    if ( !(mdm_sta&0x20) ) goto g20;
	.line	111
	LDPK	_mdm_sta
	BIT	_mdm_sta,10
	BBZ	L90
L94:
***	-----------------------g24:
*** 226	-----------------------    V22TR1 = 16885;
	.line	115
	LDPK	_V22TR1
	SPLK	#16885,_V22TR1
*** 227	-----------------------    V22TR2 = 16585;
	.line	116
	SPLK	#16585,_V22TR2
*** 228	-----------------------    if ( mdm_sta&0x20 ) goto g26;
	.line	117
	LDPK	_mdm_sta
	BIT	_mdm_sta,10
	BBNZ	L96
*** 231	-----------------------    SendCmd(48u);
	.line	120
	MAR	* ,AR1
	LACK	48
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 232	-----------------------    SendCmd(254u);
	.line	121
	LACK	254
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 233	-----------------------    SendCmd(114u);
	.line	122
	LACK	114
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 234	-----------------------    SendCmd(130u);
	.line	123
	LACK	130
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 235	-----------------------    SendCmd(67u);
	.line	124
	LACK	67
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 237	-----------------------    return EndOfV22Ans();
	.line	126
	CALL	_EndOfV22Ans
	B	EPI0_8
L96:
***	-----------------------g26:
*** 241	-----------------------    Tim0 = 0;
	.line	130
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L98:
***	-----------------------g28:
*** 244	-----------------------    if ( Tim0 >= 100 ) goto g30;
	.line	133
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	100
	BGEZ	L100
*** 242	-----------------------    SendCmd(29u);
	.line	131
	MAR	* ,AR1
	LACK	29
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 243	-----------------------    if ( mdm_sta&0x20 ) goto g38;
	.line	132
	LDPK	_mdm_sta
	BIT	_mdm_sta,10
	BBNZ	L108
L100:
***	-----------------------g30:
*** 248	-----------------------    SendCmd(67u);
	.line	137
	MAR	* ,AR1
	LACK	67
	SACL	*+
	CALL	_SendCmd
	MAR	*-,AR2
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING s1snd()
***  	-----------------------    L$1 = 30;
	LACK	30
	LARK	AR2,2
	MAR	*0+
	SACL	* ,AR1
L102:
***	-----------------------g32:
*** 249	-----------------------    SendCmd(33u);
	.line	138
	LACK	33
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 249	-----------------------    SendCmd(45u);
	LACK	45
	SACL	*+
	CALL	_SendCmd
	MAR	*-,AR2
*** 249	-----------------------    if ( --L$1 ) goto g32;
	SSXM
	LARK	AR2,2
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* ,AR1
	BNZ	L102
*** 252	-----------------------    Tim0 = 0;
	.line	141
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
L105:
***	-----------------------g35:
*** 254	-----------------------    if ( Tim0 >= 500 ) goto g72;
	.line	143
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	500
	BGEZ	L142
*** 253	-----------------------    sendmarks(1u);
	.line	142
	MAR	* ,AR1
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 254	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	143
	CALL	_ReadData
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 254	-----------------------    goto g35;
	B	L105
L108:
***	-----------------------g38:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 244	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	133
	CALL	_ReadData
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 244	-----------------------    goto g28;
	B	L98
L110:
***	-----------------------g40:
*** 205	-----------------------    SendCmd(29u);
	.line	94
	MAR	* ,AR1
	LACK	29
	SACL	*+
	CALL	_SendCmd
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 206	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	95
	CALL	_ReadData
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 206	-----------------------    goto g12;
	B	L82
L112:
***	-----------------------g42:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 196	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	85
	CALL	_ReadData,AR1
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 196	-----------------------    goto g9;
	B	L79
L114:
***	-----------------------g44:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 190	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	79
	CALL	_ReadData,AR1
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 190	-----------------------    goto g6;
	B	L76
L116:
***	-----------------------g46:
*** 124	-----------------------    modemini();
	.line	13
	CALL	_modemini
*** 126	-----------------------    if ( !(stat = detectS0()) ) goto g48;
	.line	15
	CALL	_detectS0
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
	ANDK	0FFFFh
	BZ	L118
*** 128	-----------------------    return (int)stat;
	.line	17
	SSXM
	LAC	* 
	B	EPI0_8
L118:
***	-----------------------g48:
*** 130	-----------------------    SendCmd(246u);
	.line	19
	MAR	* ,AR1
	LACK	246
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 131	-----------------------    SendCmd(130u);
	.line	20
	LACK	130
	SACL	*+
	CALL	_SendCmd
	MAR	*-,AR2
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING s1snd()
***  	-----------------------    L$2 = 30;
	LACK	30
	LARK	AR2,2
	MAR	*0+
	SACL	* ,AR1
L120:
***	-----------------------g50:
*** 133	-----------------------    SendCmd(33u);
	.line	22
	LACK	33
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 133	-----------------------    SendCmd(45u);
	LACK	45
	SACL	*+
	CALL	_SendCmd
	MAR	*-,AR2
*** 133	-----------------------    if ( --L$2 ) goto g50;
	SSXM
	LARK	AR2,2
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* ,AR1
	BNZ	L120
*** 136	-----------------------    Tim0 = 0;
	.line	25
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 136	-----------------------    if ( Tim0 >= 1800 ) goto g60;
	LAC	_Tim0
	SUBK	1800
	BGEZ	L130
*** 135	-----------------------    S0Count = 60;
	.line	24
	LACK	60
	MAR	* ,AR2
	SACL	* ,AR1
L124:
***	-----------------------g54:
*** 137	-----------------------    sendmarks(1u);
	.line	26
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-
*** 140	-----------------------    if ( mdm_sta&0x10 ) goto g56;
	.line	29
	LDPK	_mdm_sta
	BIT	_mdm_sta,11
	BBNZ	L126
*** 144	-----------------------    if ( --S0Count ) goto g57;
	.line	33
	SSXM
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* 
	BNZ	L127
*** 144	-----------------------    goto g60;
	B	L130
L126:
***	-----------------------g56:
*** 142	-----------------------    S0Count = 60;
	.line	31
	LACK	60
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
L127:
***	-----------------------g57:
*** 150	-----------------------    if ( mdm_sta&0x20 ) goto g60;
	.line	39
	BIT	_mdm_sta,10
	BBNZ	L130
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 152	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	41
	CALL	_ReadData,AR1
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 152	-----------------------    if ( Tim0 < 1800 ) goto g54;
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	1800
	BLZ	L124
L130:
***	-----------------------g60:
*** 155	-----------------------    SendCmd(67u);
	.line	44
	MAR	* ,AR1
	LACK	67
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 157	-----------------------    if ( mdm_sta&0x20 ) goto g62;
	.line	46
	LDPK	_mdm_sta
	BIT	_mdm_sta,10
	BBNZ	L132
*** 158	-----------------------    return EndV22Call();
	.line	47
	CALL	_EndV22Call
	B	EPI0_8
L132:
***	-----------------------g62:
*** 162	-----------------------    SendCmd(246u);
	.line	51
	LACK	246
	SACL	*+
	CALL	_SendCmd
	MAR	*-
*** 164	-----------------------    goto g64;
	.line	53
***	-----------------------g63:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
L134:
***	-----------------------g64:
*** 167	-----------------------    if ( Tim0 >= 3000 ) goto g66;
	.line	56
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	3000
	BGEZ	L136
*** 165	-----------------------    sendmarks(1u);
	.line	54
	MAR	* ,AR1
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-
*** 166	-----------------------    if ( mdm_sta&0x20 ) goto g83;
	.line	55
	LDPK	_mdm_sta
	BIT	_mdm_sta,10
	BBNZ	L153
L136:
***	-----------------------g66:
***  	-----------------------    L$3 = 265;
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SPLK	#265,* ,AR1
L138:
***	-----------------------g68:
*** 172	-----------------------    sendmarks(1u);
	.line	61
	LACK	1
	SACL	*+
	CALL	_sendmarks
	MAR	*-,AR2
*** 171	-----------------------    if ( --L$3 ) goto g68;
	.line	60
	SSXM
	LARK	AR2,2
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* ,AR1
	BNZ	L138
***  	-----------------------    L$4 = 85;
	LACK	85
	MAR	* ,AR2
	SACL	* ,AR1
L141:
***	-----------------------g71:
*** 177	-----------------------    sendmarks(0u);
	.line	66
	LACK	0
	SACL	*+
	CALL	_sendmarks
	MAR	*-,AR2
*** 176	-----------------------    if ( --L$4 ) goto g71;
	.line	65
	SSXM
	LARK	AR2,2
	MAR	*0+
	LAC	* 
	SUBK	1
	SACL	* ,AR1
	BNZ	L141
L142:
***	-----------------------g72:
*** 259	-----------------------    speed = 2400;
	.line	148
	LDPK	_speed
	SPLK	#2400,_speed
*** 260	-----------------------    StartUart();
	.line	149
	CALL	_StartUart,AR1
*** 262	-----------------------    Tim0 = 0;
	.line	151
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 262	-----------------------    if ( Tim0 >= 2000 ) goto g82;
	SSXM
	LAC	_Tim0
	SUBK	2000
	BGEZ	L152
*** 261	-----------------------    i0 = 0;
	.line	150
	LACK	0
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
L145:
***	-----------------------g75:
*** 264	-----------------------    if ( !(mdm_sta&0x40) ) goto g82;
	.line	153
	LDPK	_mdm_sta
	BIT	_mdm_sta,9
	BBZ	L152
*** 268	-----------------------    if ( GetData()&2 ) goto g79;
	.line	157
	CALL	_GetData,AR1
	ANDK	2
	ANDK	0FFFFh
	BNZ	L149
*** 273	-----------------------    if ( Tim0-i0 <= 14 || Tim0 <= 200 ) goto g80;
	.line	162
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SUB	* 
	SUBK	14
	BLEZ	L150
	LAC	_Tim0
	SUBK	200
	BLEZ	L150
*** 275	-----------------------    return 0;
	.line	164
	LACK	0
	B	EPI0_8
L149:
***	-----------------------g79:
*** 270	-----------------------    i0 = Tim0;
	.line	159
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	BLKD	#_Tim0,* 
L150:
***	-----------------------g80:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 279	-----------------------    if ( ReadData() >= 0 ) goto g84;
	.line	168
	CALL	_ReadData,AR1
	BGEZ	L154
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 279	-----------------------    if ( Tim0 < 2000 ) goto g75;
	SSXM
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	2000
	BLZ	L145
L152:
***	-----------------------g82:
*** 281	-----------------------    return 1;
	.line	170
	LACK	1
	B	EPI0_8
L153:
***	-----------------------g83:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING abort()
*** 167	-----------------------    if ( ReadData() < 0 ) goto g63;
	.line	56
	CALL	_ReadData
	BLZ	L134
L154:
***	-----------------------g84:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING abort()
*** 279	-----------------------    return 2;
	.line	168
	LACK	2
EPI0_8:
	.line	171
	MAR	* ,AR1
	SBRK	4
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	282,000000000H,3

	.sym	_V22b,_V22b,36,2,0
	.globl	_V22b

	.func	58
******************************************************
* FUNCTION DEF : _V22b
******************************************************
_V22b:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to variable  RetCode
*  ---  temp shares AUTO storage with RetCode
*  ---  temp shares AUTO storage with RetCode
*
*** 66	-----------------------    if ( Guard != 50 || Modul&0x100 ) goto g2;
	.sym	_temp,1,4,1,16
	.line	9
	LDPK	_Guard
	LAC	_Guard
	SUBK	50
	BNZ	L156
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L156
*** 66	-----------------------    TVGain = 4000;
	LDPK	_TVGain
	SPLK	#4000,_TVGain
***  	-----------------------    goto g3;
	B	L157
L156:
***	-----------------------g2:
*** 67	-----------------------    TVGain = 5000;
	.line	10
	LDPK	_TVGain
	SPLK	#5000,_TVGain
*** 67	-----------------------    if ( Modul&0x100 ) goto g4;
	LDPK	_Modul
	BIT	_Modul,7
	BBNZ	L158
L157:
***	-----------------------g3:
*** 75	-----------------------    V22TR1 = 18911;
	.line	18
	LDPK	_V22TR1
	SPLK	#18911,_V22TR1
*** 76	-----------------------    V22TR2 = 18575;
	.line	19
	SPLK	#18575,_V22TR2
*** 76	-----------------------    goto g5;
	B	L159
L158:
***	-----------------------g4:
*** 71	-----------------------    V22TR1 = 16885;
	.line	14
	LDPK	_V22TR1
	SPLK	#16885,_V22TR1
*** 72	-----------------------    V22TR2 = 16585;
	.line	15
	SPLK	#16585,_V22TR2
L159:
***	-----------------------g5:
*** 79	-----------------------    switch ( Modul&0xf ) {...};
	.line	22
	LACK	15
	LDPK	_Modul
	AND	_Modul
	SACL	* 
	SSXM
	LAC	* 
	SUBK	1
	BZ	L165
	SUBK	1
	BZ	L162
	SUBK	1
	BZ	L160
	SUBK	1
	BZ	L161
	B	L172
L160:
***	-----------------------g6:
*** 102	-----------------------    RetCode = FV21();
	.line	45
	CALL	_FV21
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
*** 103	-----------------------    return RetCode;
	.line	46
	SSXM
	LAC	* 
	B	EPI0_9
L161:
***	-----------------------g7:
*** 105	-----------------------    RetCode = FV23();
	.line	48
	CALL	_FV23
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
*** 106	-----------------------    return RetCode;
	.line	49
	SSXM
	LAC	* 
	B	EPI0_9
L162:
***	-----------------------g8:
*** 96	-----------------------    if ( !(temp = FV22()) ) goto g14;
	.line	39
	CALL	_FV22
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
	BZ	L168
*** 98	-----------------------    if ( temp != 1 ) goto g16;
	.line	41
	LAC	* 
	SUBK	1
	BNZ	L170
***  	-----------------------    return 2;
	LACK	2
	B	EPI0_9
L165:
***	-----------------------g11:
*** 81	-----------------------    temp = FV22b();
	.line	24
	CALL	_FV22b
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* ,AR0
*** 83	-----------------------    V22TR2 >>= 2;
	.line	26
	SSXM
	LDPK	_V22TR2
	LAC	_V22TR2,13
	SACH	_V22TR2,1
*** 84	-----------------------    V22TR1 = V22TR1-(V22TR1>>3)-(V22TR1>>4);
	.line	27
	LAC	_V22TR1,12
	SACH	* ,1
	LAC	_V22TR1
	SUB	* ,AR1
	SACL	* ,AR0
	LAC	_V22TR1,11
	SACH	* ,1,AR1
	LAC	* ,AR0
	SUB	* ,AR2
	SACL	_V22TR1
*** 85	-----------------------    if ( temp ) goto g15;
	.line	28
	LAC	* 
	BNZ	L169
*** 87	-----------------------    if ( speed != 2400 ) goto g14;
	.line	30
	LAC	_speed
	SUBK	2400
	BNZ	L168
***  	-----------------------    return 1;
	LACK	1
	B	EPI0_9
L168:
***	-----------------------g14:
*** 90	-----------------------    return 5;
	.line	33
	LACK	5
	B	EPI0_9
L169:
***	-----------------------g15:
*** 92	-----------------------    if ( temp == 1 ) goto g17;
	.line	35
	LAC	* 
	SUBK	1
	BZ	L171
L170:
***	-----------------------g16:
*** 93	-----------------------    return 4;
	.line	36
	LACK	4
	B	EPI0_9
L171:
***	-----------------------g17:
*** 92	-----------------------    RetCode = 2;
	.line	35
	LARK	AR5,2
L172:
***	-----------------------g18:
*** 108	-----------------------    return RetCode;
	.line	51
	MAR	* ,AR0
	SAR	AR5,*
	LAC	* 
EPI0_9:
	.line	52
	MAR	* ,AR1
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	109,000000000H,2

	.sym	_Carrier,_Carrier,36,2,0
	.globl	_Carrier

	.func	319
******************************************************
* FUNCTION DEF : _Carrier
******************************************************
_Carrier:
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 322	-----------------------    return mdm_sta&0x40;
	.line	4
	LACK	64
	LDPK	_mdm_sta
	AND	_mdm_sta
	SACL	* 
	SSXM
	LAC	* 
EPI0_10:
	.line	5
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	323,000000000H,1
*****************************************************
* UNDEFINED REFERENCES                              *
*****************************************************
	.global	_scramble
	.global	_StartUart
	.global	_GetData
	.global	_InitTot
	.global	_modemini
	.global	_detectS0
	.end
