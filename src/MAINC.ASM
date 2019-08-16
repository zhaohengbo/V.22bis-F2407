*******************************************************
* TMS320C2x/C2xx/C5x ANSI C Codegen Version 6.60       
*******************************************************
;	C:\TI_TOOLS\dspac.exe -v2xx mainc C:\WINDOWS\TEMP\mainc.if 
;	C:\TI_TOOLS\dspopt.exe -h0 -p0 -GAR6 -GAR7 -v2xx -s -O3 C:\WINDOWS\TEMP\mainc.if C:\WINDOWS\TEMP\mainc.opt 
;	C:\TI_TOOLS\dspcg.exe -o -GAR6 -GAR7 -v2xx C:\WINDOWS\TEMP\mainc.opt mainc.asm C:\WINDOWS\TEMP\mainc.tmp 
	.port
	.file	"mainc.c"
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
	.file	"mainc.c"
	.globl	_s98
	.globl	_s99

	.sect	".cinit"
	.word	1,_s0
	.word	0
	.text

	.sym	_s0,_s0,4,2,16
	.globl	_s0
	.bss	_s0,1,1

	.sect	".cinit"
	.word	1,_V14NbStop
	.word	8
	.text

	.sym	_V14NbStop,_V14NbStop,4,2,16
	.globl	_V14NbStop
	.bss	_V14NbStop,1
	.globl	_scan

	.sect	".cinit"
	.word	1,_Modul
	.word	257
	.text

	.sym	_Modul,_Modul,4,2,16
	.globl	_Modul
	.bss	_Modul,1
	.globl	_AS
	.globl	_Mode
	.globl	_Loop

	.sect	".cinit"
	.word	1,_Connect
	.word	1
	.text

	.sym	_Connect,_Connect,4,2,16
	.globl	_Connect
	.bss	_Connect,1

	.sect	".cinit"
	.word	1,_Command
	.word	0
	.text

	.sym	_Command,_Command,4,2,16
	.globl	_Command
	.bss	_Command,1

	.sect	".cinit"
	.word	1,_RPtOut0
	.word	_RBuffr+0
	.text

	.sym	_RPtOut0,_RPtOut0,20,2,16
	.globl	_RPtOut0
	.bss	_RPtOut0,1

	.sect	".cinit"
	.word	1,_Guard
	.word	50
	.text

	.sym	_Guard,_Guard,4,2,16
	.globl	_Guard
	.bss	_Guard,1

	.sect	".cinit"
	.word	1,_TGGain
	.word	4000
	.text

	.sym	_TGGain,_TGGain,4,2,16
	.globl	_TGGain
	.bss	_TGGain,1
	.globl	_transfer_buf
	.globl	_GetData
	.globl	_Carrier
	.globl	_SendData
	.globl	_ReadData
	.globl	_FConnect
	.globl	_FDisConnect
	.globl	_modemini
	.globl	_StartUart
	.globl	_InitScram
	.globl	_V22b
	.globl	_Manage_CID
	.globl	_reset_imp
	.globl	_abort
	.globl	_InitNotch
	.globl	_Calling
	.globl	_ModemFSK
	.globl	_V14Send
	.globl	_V14Stat
	.globl	_AnalyseOn
	.globl	_AnalyseOff
	.globl	_GetNext
	.globl	_GetPrevious
	.globl	_isdigit
	.globl	_ManageUart
	.globl	_Print
	.globl	_PrintOk
	.globl	_PrintError
	.globl	_tolower
	.globl	_Dial
	.globl	_ReadTable
	.globl	_OK
	.globl	_NoCarrier
	.globl	_Error
	.globl	_Connect1200
	.globl	_Connect2400
	.globl	_CidRing
	.globl	_CidDT
	.globl	_NoDial
	.globl	_Busy
	.globl	_V22BIS
	.globl	_V22
	.globl	_V21
	.globl	_V23
	.globl	_CONNECT
	.globl	_CON1275
	.globl	_CON7512
	.globl	_main
	.globl	_ManageUart
	.globl	_AnalyseOn
	.globl	_AnalyseOff
	.globl	_F_ATA
	.globl	_scan
	.globl	_Print
	.globl	_GetNext
	.globl	_GetPrevious
	.globl	_PrintOk
	.globl	_PrintError
	.globl	_tolower
	.globl	_isdigit
	.globl	_ReadTable
	.globl	_PrintTab
	.globl	_PrintFSK

	.sym	_transfer_buf,_transfer_buf,52,2,512,,32
	.globl	_transfer_buf
	.bss	_transfer_buf,32

	.sym	_Loop,_Loop,4,2,16
	.globl	_Loop
	.bss	_Loop,1

	.sym	_s98,_s98,4,2,16
	.globl	_s98
	.bss	_s98,1

	.sym	_s99,_s99,4,2,16
	.globl	_s99
	.bss	_s99,1

	.sym	_Mode,_Mode,4,2,16
	.globl	_Mode
	.bss	_Mode,1

	.sym	_AS,_AS,4,2,16
	.globl	_AS
	.bss	_AS,1

	.sym	_tolower,_tolower,36,2,0
	.globl	_tolower

	.func	601
******************************************************
* FUNCTION DEF : _tolower
******************************************************
_tolower:

LF1	.set	1

	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+,AR2

	.sym	_Data,-3+LF1,4,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.line	3
*** 604	-----------------------    if ( Data < 65 || Data > 90 ) goto g2;
	.line	4
	SSXM
	LARK	AR2,-3+LF1
	MAR	*0+
	LAC	* 
	SUBK	65
	BLZ	L2
	LAC	* 
	SUBK	90
	BGZ	L2
*** 604	-----------------------    Data += 32;
	LAC	* 
	ADDK	32
	SACL	* 
L2:
***	-----------------------g2:
*** 605	-----------------------    return Data;
	.line	5
	LAC	* 
EPI0_1:
	.line	6
	MAR	* ,AR1
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	606,000000000H,1

	.sym	_scan,_scan,36,2,0
	.globl	_scan

	.func	536
******************************************************
* FUNCTION DEF : _scan
******************************************************
_scan:

LF2	.set	1

	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+,AR2

	.sym	_Buf,-3+LF2,20,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to parameter Buf
* AR5	assigned to temp var  U$9
*
	.sym	_Ret,1,4,1,16
	.line	3
	LARK	AR2,-3+LF2
	MAR	*0+
	LAR	AR5,* 
*** 541	-----------------------    Ret = 0;
	.line	6
	LACK	0
	ADRK	4-LF2
	SACL	* ,AR5
*** 543	-----------------------    if ( !*Buf ) goto g4;
	.line	8
	LAC	* 
	BZ	L6
***  	-----------------------    U$9 = Buf;
	MAR	* ,AR2
L5:
***	-----------------------g3:
*** 544	-----------------------    Ret = Ret*10+*U$9++-48;
	.line	9
	LT	* ,AR5
	MPYK	10
	PAC
	SUBK	48
	ADD	*+,AR2
	SACL	* ,AR5
*** 543	-----------------------    if ( *U$9 ) goto g3;
	.line	8
	LAC	* ,AR2
	BNZ	L5
L6:
***	-----------------------g4:
*** 547	-----------------------    return Ret;
	.line	12
	SSXM
	MAR	* ,AR2
	LAC	* 
EPI0_2:
	.line	13
	MAR	* ,AR1
	SBRK	3
	LAR	AR0,* 
	RET

	.endfunc	548,000000000H,2

	.sym	_Print,_Print,32,2,0
	.globl	_Print

	.func	550
******************************************************
* FUNCTION DEF : _Print
******************************************************
_Print:

LF3	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

	.sym	_Pt,-3+LF3,20,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.line	5
L8:
***	-----------------------g2:
*** 555	-----------------------    if ( SendData(13) < 0 ) goto g2;
	.line	6
	LACK	13
	SACL	*+
	CALL	_SendData
	MAR	*-
	BLZ	L8
L10:
***	-----------------------g4:
*** 556	-----------------------    if ( SendData(10) < 0 ) goto g4;
	.line	7
	LACK	10
	SACL	*+
	CALL	_SendData
	MAR	*-
	BLZ	L10
*** 557	-----------------------    if ( !*Pt ) goto g8;
	.line	8
	MAR	* ,AR2
	LARK	AR2,-3+LF3
	MAR	*0+
	LAR	AR5,* ,AR5
	LAC	* 
	BZ	L14
	MAR	* ,AR2
L13:
***	-----------------------g7:
*** 558	-----------------------    if ( SendData(*Pt) < 0 || *(++Pt) ) goto g7;
	.line	9
	LARK	AR2,-3+LF3
	MAR	*0+
	LAR	AR4,* ,AR4
	LAC	* ,AR1
	SACL	*+
	CALL	_SendData
	MAR	*-,AR2
	BLZ	L13
	LARK	AR2,-3+LF3
	MAR	*0+
	LAR	AR3,* ,AR3
	MAR	*+,AR2
	SAR	AR3,* ,AR3
	LAC	* ,AR2
	BNZ	L13
L14:
L15:
***	-----------------------g8:
***	-----------------------g9:
*** 561	-----------------------    if ( SendData(13) < 0 ) goto g9;
	.line	12
	MAR	* ,AR1
	LACK	13
	SACL	*+
	CALL	_SendData
	MAR	*-
	BLZ	L15
L17:
***	-----------------------g11:
*** 562	-----------------------    if ( SendData(10) < 0 ) goto g11;
	.line	13
	LACK	10
	SACL	*+
	CALL	_SendData
	MAR	*-
	BLZ	L17
***  	-----------------------    return;
EPI0_3:
	.line	14
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	563,000000000H,1

	.sym	_ReadTable,_ReadTable,36,2,0
	.globl	_ReadTable

	.func	618
******************************************************
* FUNCTION DEF : _ReadTable
******************************************************
_ReadTable:

LF4	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,4
	LAR	AR0,*0+,AR2

	.sym	_table,-3+LF4,20,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to temp var  C$1
*
	.sym	_temp,1,4,1,16
	.sym	_i,2,4,1,16
	.sym	U$13,3,20,1,16
	.line	2
***  	-----------------------    U$13 = &transfer_buf[0];
	LALK	_transfer_buf+0
	LARK	AR2,3
	MAR	*0+
	SACL	*-
*** 620	-----------------------    i = 0;
	.line	3
	LACK	0
	SACL	* 
	SSXM ;;;
L19:
***	-----------------------g2:
*** 624	-----------------------    if ( !(temp = table_read((i>>1)+table)) ) goto g5;
	.line	7
	LAC	* ,14
	SBRK	5-LF4
	ADD	* ,15,AR1
	SACH	*+,1
	CALL	_table_read
	MAR	*-,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
	BZ	L22
*** 627	-----------------------    *U$13++ = temp>>8;
	.line	10
	SSXM
	LAC	* ,7
	ADRK	2
	LAR	AR5,* ,AR5
	SACH	*+,1,AR2
	SAR	AR5,*-
*** 628	-----------------------    ++i;
	.line	11
	LAC	* 
	ADDK	1
	SACL	*-
*** 630	-----------------------    if ( !(C$1 = temp&0xff) ) goto g5;
	.line	13
	LACK	255
	AND	* ,AR0
	SACL	* 
	LAR	AR5,* ,AR5
	BANZ	$+4,*
	B	L22
*** 631	-----------------------    *U$13++ = C$1;
	.line	14
	MAR	* ,AR2
	ADRK	2
	LAR	AR4,* ,AR4
	SAR	AR5,*+,AR2
	SAR	AR4,*-
*** 632	-----------------------    if ( (++i) < 32 ) goto g2;
	.line	15
	LAC	* 
	ADDK	1
	SACL	* 
	SUBK	32
	BLZ	L19
L22:
***	-----------------------g5:
*** 636	-----------------------    *U$13 = 0;
	.line	19
	MAR	* ,AR2
	LARK	AR2,3
	MAR	*0+
	LAR	AR3,*-,AR3
	LACK	0
	SACL	* ,AR2
*** 638	-----------------------    return i;
	.line	21
	SSXM
	LAC	* 
EPI0_4:
	.line	22
	MAR	* ,AR1
	SBRK	5
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	639,000000000H,4

	.sym	_PrintTab,_PrintTab,32,2,0
	.globl	_PrintTab

	.func	643
******************************************************
* FUNCTION DEF : _PrintTab
******************************************************
_PrintTab:

LF5	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+,AR2

	.sym	_table,-3+LF5,20,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to parameter table
*
	.line	2
	LARK	AR2,-3+LF5
	MAR	*0+
	LAR	AR5,* ,AR1
*** 645	-----------------------    ReadTable(table);
	.line	3
	SAR	AR5,*+
	CALL	_ReadTable
	MAR	*-
*** 646	-----------------------    Print(&transfer_buf);
	.line	4
	LALK	_transfer_buf+0
	SACL	*+
	CALL	_Print
	MAR	*-
***  	-----------------------    return;
EPI0_5:
	.line	5
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	647,000000000H,1

	.sym	_GetNext,_GetNext,36,2,0
	.globl	_GetNext

	.func	566
******************************************************
* FUNCTION DEF : _GetNext
******************************************************
_GetNext:

LF6	.set	1

	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+,AR2

	.sym	_Pt,-3+LF6,84,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to parameter Pt
*  ---  c0 shares AUTO storage with Data
*
	.sym	_c0,1,4,1,16
	.line	3
	LARK	AR2,-3+LF6
	MAR	*0+
	LAR	AR5,* ,AR5
*** 571	-----------------------    c0 = *(*Pt)++;
	.line	6
	LAR	AR4,* ,AR4
	LAC	*+,AR5
	SAR	AR4,* ,AR2
	ADRK	4-LF6
	SACL	* ,AR5
*** 572	-----------------------    if ( *Pt <= &RLast ) goto g2;
	.line	7
	ZALS	* 
	RSXM
	SBLK	_RLast+0,0
	BLEZ	L24
*** 572	-----------------------    *Pt = &RBuffr;
	LALK	_RBuffr+0
	SACL	* 
L24:
***	-----------------------g2:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING tolower()
*** 573	-----------------------    if ( (Data = c0) < 65 || Data > 90 ) goto g4;
	.line	8
	SSXM
	MAR	* ,AR2
	LAC	* 
	SUBK	65
	BLZ	L26
	LAC	* 
	SUBK	90
	BGZ	L26
*** 573	-----------------------    Data += 32;
	LAC	* 
	ADDK	32
	SACL	* 
L26:
***	-----------------------g4:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING tolower()
*** 573	-----------------------    return Data;
	LAC	* 
EPI0_6:
	.line	9
	MAR	* ,AR1
	SBRK	3
	LAR	AR0,* 
	RET

	.endfunc	574,000000000H,2

	.sym	_PrintError,_PrintError,32,2,0
	.globl	_PrintError

	.func	594
******************************************************
* FUNCTION DEF : _PrintError
******************************************************
_PrintError:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 597	-----------------------    PrintTab(&Error);
	.line	4
	LALK	_Error+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
***  	-----------------------    return;
EPI0_7:
	.line	5
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	598,000000000H,1

	.sym	_isdigit,_isdigit,36,2,0
	.globl	_isdigit

	.func	608
******************************************************
* FUNCTION DEF : _isdigit
******************************************************
_isdigit:

LF8	.set	1

	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+,AR2

	.sym	_Data,-3+LF8,4,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.line	3
*** 611	-----------------------    if ( Data < 48 ) goto g3;
	.line	4
	SSXM
	LARK	AR2,-3+LF8
	MAR	*0+
	LAC	* 
	SUBK	48
	BLZ	L29
*** 611	-----------------------    if ( Data < 58 ) goto g5;
	LAC	* 
	SUBK	58
	BLZ	L31
*** 612	-----------------------    if ( Data >= 97 ) goto g4;
	.line	5
	LAC	* 
	SUBK	97
	BGEZ	L30
L29:
***	-----------------------g3:
*** 613	-----------------------    if ( Data == 42 || Data == 35 ) goto g5;
	.line	6
	LAC	* 
	SUBK	42
	BZ	L31
	LAC	* 
	SUBK	35
	BZ	L31
*** 613	-----------------------    goto g6;
	B	L32
L30:
***	-----------------------g4:
*** 612	-----------------------    if ( Data > 100 ) goto g6;
	.line	5
	LAC	* 
	SUBK	100
	BGZ	L32
L31:
***	-----------------------g5:
*** 612	-----------------------    return 1;
	LACK	1
	B	EPI0_8
L32:
***	-----------------------g6:
*** 614	-----------------------    return 0;
	.line	7
	LACK	0
EPI0_8:
	.line	8
	MAR	* ,AR1
	SBRK	2
	LAR	AR0,* 
	RET

	.endfunc	615,000000000H,1

	.sym	_PrintOk,_PrintOk,32,2,0
	.globl	_PrintOk

	.func	588
******************************************************
* FUNCTION DEF : _PrintOk
******************************************************
_PrintOk:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 591	-----------------------    PrintTab(&OK);
	.line	4
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
***  	-----------------------    return;
EPI0_9:
	.line	5
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	592,000000000H,1

	.sym	_F_ATA,_F_ATA,32,2,0
	.globl	_F_ATA

	.func	491
******************************************************
* FUNCTION DEF : _F_ATA
******************************************************
_F_ATA:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 494	-----------------------    FConnect();
	.line	4
	CALL	_FConnect
*** 496	-----------------------    Modul &= 0xfeff;
	.line	6
	LACK	65279
	LDPK	_Modul
	AND	_Modul
	SACL	_Modul
***  	-----------------------    switch ( V22b() ) {...};
	CALL	_V22b
	SUBK	1
	BZ	L37
	SUBK	1
	BZ	L36
	SUBK	2
	BZ	L36
	SUBK	1
	BZ	L35
	SUBK	1
	BZ	L34
	SUBK	1
	BNZ	EPI0_10
***	-----------------------g1:
*** 511	-----------------------    PrintTab(&CONNECT);
	.line	21
	LALK	_CONNECT+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 512	-----------------------    Connect = 0;
	.line	22
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 513	-----------------------    Command = 1;
	.line	23
	LACK	1
	SACL	_Command
*** 514	-----------------------    goto g6;
	.line	24
	B	EPI0_10
L34:
***	-----------------------g2:
*** 517	-----------------------    PrintTab(&CON1275);
	.line	27
	LALK	_CON1275+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 518	-----------------------    Connect = 0;
	.line	28
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 519	-----------------------    Command = 1;
	.line	29
	LACK	1
	SACL	_Command
*** 520	-----------------------    goto g6;
	.line	30
	B	EPI0_10
L35:
***	-----------------------g3:
*** 505	-----------------------    PrintTab(&Connect1200);
	.line	15
	LALK	_Connect1200+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 506	-----------------------    Connect = 0;
	.line	16
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 507	-----------------------    Command = 1;
	.line	17
	LACK	1
	SACL	_Command
*** 508	-----------------------    goto g6;
	.line	18
	B	EPI0_10
L36:
***	-----------------------g4:
*** 523	-----------------------    PrintTab(&NoCarrier);
	.line	33
	LALK	_NoCarrier+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 524	-----------------------    FDisConnect();
	.line	34
	CALL	_FDisConnect
*** 525	-----------------------    goto g6;
	.line	35
	B	EPI0_10
L37:
***	-----------------------g5:
*** 499	-----------------------    PrintTab(&Connect2400);
	.line	9
	LALK	_Connect2400+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 500	-----------------------    Connect = 0;
	.line	10
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 501	-----------------------    Command = 1;
	.line	11
	LACK	1
	SACL	_Command
***	-----------------------g6:
***  	-----------------------    return;
EPI0_10:
	.line	43
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	533,000000000H,1

	.sym	_AnalyseOff,_AnalyseOff,32,2,0
	.globl	_AnalyseOff

	.func	213
******************************************************
* FUNCTION DEF : _AnalyseOff
******************************************************
_AnalyseOff:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,14
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
*  ---  L$1 shares AUTO storage with c0
*  ---  L$1 shares AUTO storage with c0
*  ---  L$1 shares AUTO storage with c0
*  ---  L$1 shares AUTO storage with i0
*  ---  L$1 shares AUTO storage with i0
*  ---  L$1 shares AUTO storage with i1
*  ---  i0 shares AUTO storage with i1
*
*** 225	-----------------------    c0 = GetNext(&RPtOut0);
	.sym	_i2,1,4,1,16
	.sym	U$22,2,20,1,16
	.sym	_i0,3,4,1,16
	.sym	L$1,4,4,1,16
	.sym	K$1,5,84,1,16
	.sym	_cBuff0,6,52,1,128,,8
	.line	13
	LALK	_RPtOut0+0
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	*+
*** 225	-----------------------    K$1 = &RPtOut0;
	LALK	_RPtOut0+0
	SACL	*-
L40:
***	-----------------------g2:
*** 227	-----------------------    if ( c0 == 97 ) goto g6;
	.line	15
	LAC	* 
	SUBK	97
	BZ	L44
L42:
***	-----------------------g4:
*** 230	-----------------------    if ( c0 == 13 ) goto g75;
	.line	18
	LAC	* 
	SUBK	13
	BZ	L113
*** 231	-----------------------    if ( (c0 = GetNext(K$1)) != 97 ) goto g4;
	.line	19
	MAR	*+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
	SUBK	97
	BNZ	L42
L44:
***	-----------------------g6:
*** 228	-----------------------    if ( (c0 = GetNext(K$1)) != 116 ) goto g2;
	.line	16
	MAR	*+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
	SUBK	116
	BNZ	L40
*** 236	-----------------------    switch ( GetNext(K$1) ) {...};
	.line	24
	MAR	*+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-
	SUBK	13
	BZ	L112
	SUBK	25
	BZ	L110
	SUBK	59
	BZ	L109
	SUBK	2
	BZ	L105
	SUBK	1
	BZ	L82
	SUBK	4
	BZ	L79
	SUBK	1
	BZ	L78
	SUBK	3
	BZ	L77
	SUBK	2
	BZ	L65
	SUBK	1
	BZ	L63
	SUBK	4
	BNZ	L106
***	-----------------------g8:
***  	-----------------------    U$22 = &cBuff0[0];
	MAR	* ,AR5
	LARK	AR5,6
	MAR	*0+,AR2
	LARK	AR2,2
	MAR	*0+
	SAR	AR5,* 
***  	-----------------------    L$1 = 3;
	LACK	3
	ADRK	2
	SACL	*+
L48:
***	-----------------------g10:
*** 432	-----------------------    i0 = GetNext(K$1);
	.line	220
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,3
	MAR	*0+
	SACL	* 
*** 433	-----------------------    if ( !isdigit(i0) ) goto g12;
	.line	221
	LAC	* ,AR1
	SACL	*+
	CALL	_isdigit
	MAR	*-
	BZ	L50
*** 434	-----------------------    *U$22++ = i0;
	.line	222
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	LAR	AR4,*+
	LAC	*-,AR4
	SACL	*+,AR2
	SAR	AR4,* 
*** 431	-----------------------    if ( --L$1 ) goto g10;
	.line	219
	SSXM
	ADRK	2
	LAC	* 
	SUBK	1
	SACL	*+
	BNZ	L48
L50:
***	-----------------------g12:
*** 436	-----------------------    *U$22 = 0;
	.line	224
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	LAR	AR3,* ,AR3
	LACK	0
	SACL	* ,AR5
*** 437	-----------------------    i2 = scan(&cBuff0);
	.line	225
	LARK	AR5,6
	MAR	*0+,AR1
	SAR	AR5,*+
	CALL	_scan
	MAR	*-,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
***  	-----------------------    switch ( i0 ) {...};
	SSXM
	ADRK	2
	LAC	* 
	SUBK	61
	BZ	L55
	SUBK	2
	BNZ	L106
***	-----------------------g13:
*** 440	-----------------------    if ( i2 ) goto g75;
	.line	228
	SBRK	2
	LAC	* 
	BNZ	L113
*** 442	-----------------------    if ( s0 ) goto g16;
	.line	230
	LDPK	_s0
	LAC	_s0
	BNZ	L54
*** 442	-----------------------    Print("0");
	LRLK	AR4,SL0
	MAR	* ,AR1
	SAR	AR4,*+
	CALL	_Print
	MAR	*-
***  	-----------------------    goto g75;
	B	L113
L54:
***	-----------------------g16:
*** 443	-----------------------    Print("1");
	.line	231
	LRLK	AR3,SL1
	MAR	* ,AR1
	SAR	AR3,*+
	CALL	_Print
	MAR	*-
*** 443	-----------------------    goto g75;
	B	L113
L55:
***	-----------------------g17:
***  	-----------------------    U$22 = &cBuff0[0];
	MAR	*-,AR5
	LARK	AR5,6
	MAR	*0+,AR2
	SAR	AR5,* 
***  	-----------------------    L$2 = 7;
	LACK	7
	ADRK	2
	SACL	*+
L57:
***	-----------------------g19:
*** 454	-----------------------    i0 = GetNext(K$1);
	.line	242
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,3
	MAR	*0+
	SACL	* 
*** 455	-----------------------    if ( !isdigit(i0) ) goto g21;
	.line	243
	LAC	* ,AR1
	SACL	*+
	CALL	_isdigit
	MAR	*-
	BZ	L59
*** 456	-----------------------    *U$22++ = i0;
	.line	244
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	LAR	AR4,*+
	LAC	*-,AR4
	SACL	*+,AR2
	SAR	AR4,* 
*** 453	-----------------------    if ( --L$2 ) goto g19;
	.line	241
	SSXM
	ADRK	2
	LAC	* 
	SUBK	1
	SACL	*+
	BNZ	L57
L59:
***	-----------------------g21:
*** 458	-----------------------    *U$22 = 0;
	.line	246
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	LAR	AR3,* ,AR3
	LACK	0
	SACL	* ,AR5
*** 459	-----------------------    i1 = scan(&cBuff0);
	.line	247
	LARK	AR5,6
	MAR	*0+,AR1
	SAR	AR5,*+
	CALL	_scan
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
***  	-----------------------    switch ( i2 ) {...};
	SSXM
	SBRK	3
	LAC	* 
	BZ	L62
	SUBK	98
	BZ	L61
	SUBK	1
	BNZ	L112
***	-----------------------g22:
*** 468	-----------------------    s99 = i1;
	.line	256
	ADRK	3
	LAC	* 
	LDPK	_s99
	SACL	_s99
*** 469	-----------------------    goto g74;
	.line	257
	B	L112
L61:
***	-----------------------g23:
*** 465	-----------------------    s98 = i1;
	.line	253
	ADRK	3
	LAC	* 
	LDPK	_s98
	SACL	_s98
*** 466	-----------------------    goto g74;
	.line	254
	B	L112
L62:
***	-----------------------g24:
*** 462	-----------------------    s0 = i1;
	.line	250
	ADRK	3
	LAC	* 
	LDPK	_s0
	SACL	_s0
*** 463	-----------------------    goto g74;
	.line	251
	B	L112
L63:
***	-----------------------g25:
*** 422	-----------------------    if ( Connect ) goto g68;
	.line	210
	LDPK	_Connect
	LAC	_Connect
	BNZ	L106
*** 423	-----------------------    PrintTab(&CONNECT);
	.line	211
	LALK	_CONNECT+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 424	-----------------------    Command = 1;
	.line	212
	LACK	1
	LDPK	_Command
	SACL	_Command
***  	-----------------------    goto g75;
	B	L113
L65:
***	-----------------------g27:
*** 373	-----------------------    if ( (i0 = GetNext(K$1)) == 63 ) goto g33;
	.line	161
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
	SUBK	63
	BZ	L71
*** 398	-----------------------    switch ( i0-48 ) {...};
	.line	186
	LAC	* 
	SUBK	48
	BZ	L70
	SUBK	1
	BZ	L69
	SUBK	1
	BZ	L68
	SUBK	1
	BNZ	L106
***	-----------------------g29:
*** 412	-----------------------    Modul = Modul&0xfff0|4;
	.line	200
	LACK	65520
	LDPK	_Modul
	AND	_Modul
	ORK	4
	SACL	_Modul
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 413	-----------------------    PrintTab(&OK);
	.line	201
	LALK	_OK+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 414	-----------------------    goto g75;
	.line	202
	B	L113
L68:
***	-----------------------g30:
*** 408	-----------------------    Modul = Modul&0xfff0|3;
	.line	196
	LACK	65520
	LDPK	_Modul
	AND	_Modul
	ORK	3
	SACL	_Modul
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 409	-----------------------    PrintTab(&OK);
	.line	197
	LALK	_OK+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 410	-----------------------    goto g75;
	.line	198
	B	L113
L69:
***	-----------------------g31:
*** 404	-----------------------    Modul = Modul&0xfff0|2;
	.line	192
	LACK	65520
	LDPK	_Modul
	AND	_Modul
	ORK	2
	SACL	_Modul
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 405	-----------------------    PrintTab(&OK);
	.line	193
	LALK	_OK+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 406	-----------------------    goto g75;
	.line	194
	B	L113
L70:
***	-----------------------g32:
*** 400	-----------------------    Modul = Modul&0xfff0|1;
	.line	188
	LACK	65520
	LDPK	_Modul
	AND	_Modul
	ORK	1
	SACL	_Modul
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 401	-----------------------    PrintTab(&OK);
	.line	189
	LALK	_OK+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 402	-----------------------    goto g75;
	.line	190
	B	L113
L71:
***	-----------------------g33:
*** 375	-----------------------    switch ( Modul&0xf ) {...};
	.line	163
	LACK	15
	LDPK	_Modul
	AND	_Modul
	MAR	* ,AR1
	SACL	* 
	SSXM
	LAC	* 
	SUBK	1
	BZ	L76
	SUBK	1
	BZ	L75
	SUBK	1
	BZ	L74
	SUBK	1
	BZ	L73
***	-----------------------g34:
*** 393	-----------------------    Print("Unimplemented modulation");
	.line	181
	LRLK	AR4,SL2
	SAR	AR4,*+
	CALL	_Print
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 394	-----------------------    PrintTab(&OK);
	.line	182
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 395	-----------------------    goto g75;
	.line	183
	B	L113
L73:
***	-----------------------g35:
*** 389	-----------------------    PrintTab(&V23);
	.line	177
	LALK	_V23+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 390	-----------------------    PrintTab(&OK);
	.line	178
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 391	-----------------------    goto g75;
	.line	179
	B	L113
L74:
***	-----------------------g36:
*** 385	-----------------------    PrintTab(&V21);
	.line	173
	LALK	_V21+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 386	-----------------------    PrintTab(&OK);
	.line	174
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 387	-----------------------    goto g75;
	.line	175
	B	L113
L75:
***	-----------------------g37:
*** 381	-----------------------    PrintTab(&V22);
	.line	169
	LALK	_V22+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 382	-----------------------    PrintTab(&OK);
	.line	170
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 383	-----------------------    goto g75;
	.line	171
	B	L113
L76:
***	-----------------------g38:
*** 377	-----------------------    PrintTab(&V22BIS);
	.line	165
	LALK	_V22BIS+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 378	-----------------------    PrintTab(&OK);
	.line	166
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 379	-----------------------    goto g75;
	.line	167
	B	L113
L77:
***	-----------------------g39:
*** 368	-----------------------    Loop = Loop != 1;
	.line	156
	LDPK	_Loop
	LAC	_Loop
	SUBK	1
	LARK	AR3,1
	BNZ	LL13
	LARK	AR3,0
LL13:
	SAR	AR3,_Loop
***  	-----------------------    goto g74;
	B	L112
L78:
***	-----------------------g40:
*** 357	-----------------------    Print("Ver V67b");
	.line	145
	LRLK	AR5,SL3
	SAR	AR5,*+
	CALL	_Print
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 365	-----------------------    PrintTab(&OK);
	.line	153
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 366	-----------------------    goto g75;
	.line	154
	B	L113
L79:
***	-----------------------g41:
*** 348	-----------------------    if ( GetNext(K$1) == 49 ) goto g43;
	.line	136
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-
	SUBK	49
	BZ	L81
*** 351	-----------------------    FDisConnect();
	.line	139
	CALL	_FDisConnect
*** 352	-----------------------    Connect = 1;
	.line	140
	LACK	1
	LDPK	_Connect
	SACL	_Connect
*** 352	-----------------------    goto g74;
	B	L112
L81:
***	-----------------------g43:
*** 349	-----------------------    FConnect();
	.line	137
	CALL	_FConnect
***  	-----------------------    goto g74;
	B	L112
L82:
***	-----------------------g44:
*** 269	-----------------------    Modul |= 0x100;
	.line	57
	LACK	256
	LDPK	_Modul
	OR	_Modul
	SACL	_Modul
*** 272	-----------------------    if ( (c0 = GetNext(K$1)) != 116 ) goto g46;
	.line	60
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
	SUBK	116
	BNZ	L84
*** 273	-----------------------    c0 = GetNext(K$1);
	.line	61
	MAR	*+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
L84:
***	-----------------------g46:
*** 275	-----------------------    if ( c0 == 44 ) goto g50;
	.line	63
	LAC	* 
	SUBK	44
	BZ	L88
*** 290	-----------------------    if ( isdigit(c0) ) goto g49;
	.line	78
	LAC	* ,AR1
	SACL	*+
	CALL	_isdigit
	MAR	*-
	BNZ	L87
*** 292	-----------------------    if ( c0 == 13 ) goto g55;
	.line	80
	MAR	* ,AR2
	LARK	AR2,4
	MAR	*0+
	LAC	* 
	SUBK	13
	BZ	L93
*** 292	-----------------------    goto g68;
	B	L106
L87:
***	-----------------------g49:
*** 291	-----------------------    i0 = Calling(1, c0);
	.line	79
	MAR	* ,AR2
	LARK	AR2,4
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	LACK	1
	SACL	*+
	CALL	_Calling
	SBRK	2
	MAR	* ,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
***  	-----------------------    goto g56;
	B	L94
L88:
***	-----------------------g50:
*** 276	-----------------------    c0 = GetNext(K$1);
	.line	64
	MAR	*+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	*-
*** 277	-----------------------    Tim0 = 0;
	.line	65
	LACK	0
	LDPK	_Tim0
	SACL	_Tim0
*** 278	-----------------------    i1 = 0;
	.line	66
	SACL	* 
	SSXM ;;;
L90:
***	-----------------------g52:
*** 280	-----------------------    if ( Tim0 <= 9600 ) goto g54;
	.line	68
	LDPK	_Tim0
	LAC	_Tim0
	SUBK	9600
	BLEZ	L92
*** 281	-----------------------    Tim0 = 0;
	.line	69
	LACK	0
	SACL	_Tim0
*** 282	-----------------------    ++i1;
	.line	70
	MAR	* ,AR2
	LARK	AR2,3
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
L92:
***	-----------------------g54:
*** 285	-----------------------    if ( abort() == 0 && i1 < 6 ) goto g52;
	.line	73
	CALL	_abort,AR1
	BNZ	L93
	SSXM
	MAR	* ,AR2
	LARK	AR2,3
	MAR	*0+
	LAC	* 
	SUBK	6
	BLZ	L90
L93:
***	-----------------------g55:
*** 288	-----------------------    i0 = Calling(0, c0);
	.line	76
	MAR	* ,AR2
	LARK	AR2,4
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	LACK	0
	SACL	*+
	CALL	_Calling
	SBRK	2
	MAR	* ,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
L94:
***	-----------------------g56:
*** 299	-----------------------    if ( i0 != 8 ) goto g58;
	.line	87
	LAC	* 
	SUBK	8
	BNZ	L96
*** 300	-----------------------    i0 = V22b();
	.line	88
	CALL	_V22b,AR1
	MAR	* ,AR2
	LARK	AR2,4
	MAR	*0+
	SACL	* 
L96:
***	-----------------------g58:
*** 303	-----------------------    switch ( i0 ) {...};
	.line	91
	SSXM
	LAC	* ,AR0
	SUBK	7
	BGZ	L97
	ADDK	7
	BLZ	L97
	ADLK	LL15
	TBLR	*
	LAC	*
	BACC
	.sect	".switch"
LL15:
	.word	L104
	.word	L103
	.word	L101
	.word	L102
	.word	L101
	.word	L100
	.word	L99
	.word	L98
	.text
L97:
***	-----------------------g59:
*** 341	-----------------------    FDisConnect();
	.line	129
	CALL	_FDisConnect,AR1
*** 342	-----------------------    Print("Unknown code");
	.line	130
	LRLK	AR4,SL4
	SAR	AR4,*+
	CALL	_Print
	MAR	*-
*** 343	-----------------------    goto g75;
	.line	131
	B	L113
L98:
***	-----------------------g60:
*** 315	-----------------------    PrintTab(&CONNECT);
	.line	103
	LALK	_CONNECT+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 316	-----------------------    Connect = 0;
	.line	104
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 317	-----------------------    Command = 1;
	.line	105
	LACK	1
	SACL	_Command
*** 318	-----------------------    goto g75;
	.line	106
	B	L113
L99:
***	-----------------------g61:
*** 320	-----------------------    PrintTab(&CON7512);
	.line	108
	LALK	_CON7512+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 321	-----------------------    Connect = 0;
	.line	109
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 322	-----------------------    Command = 1;
	.line	110
	LACK	1
	SACL	_Command
*** 323	-----------------------    goto g75;
	.line	111
	B	L113
L100:
***	-----------------------g62:
*** 310	-----------------------    PrintTab(&Connect1200);
	.line	98
	LALK	_Connect1200+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 311	-----------------------    Connect = 0;
	.line	99
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 312	-----------------------    Command = 1;
	.line	100
	LACK	1
	SACL	_Command
*** 313	-----------------------    goto g75;
	.line	101
	B	L113
L101:
***	-----------------------g63:
*** 333	-----------------------    PrintTab(&NoCarrier);
	.line	121
	LALK	_NoCarrier+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 334	-----------------------    FDisConnect();
	.line	122
	CALL	_FDisConnect
*** 335	-----------------------    goto g75;
	.line	123
	B	L113
L102:
***	-----------------------g64:
*** 329	-----------------------    PrintTab(&Busy);
	.line	117
	LALK	_Busy+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 330	-----------------------    FDisConnect();
	.line	118
	CALL	_FDisConnect
*** 331	-----------------------    goto g75;
	.line	119
	B	L113
L103:
***	-----------------------g65:
*** 305	-----------------------    PrintTab(&Connect2400);
	.line	93
	LALK	_Connect2400+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 306	-----------------------    Connect = 0;
	.line	94
	LACK	0
	LDPK	_Connect
	SACL	_Connect
*** 307	-----------------------    Command = 1;
	.line	95
	LACK	1
	SACL	_Command
*** 308	-----------------------    goto g75;
	.line	96
	B	L113
L104:
***	-----------------------g66:
*** 325	-----------------------    PrintTab(&NoDial);
	.line	113
	LALK	_NoDial+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 326	-----------------------    FDisConnect();
	.line	114
	CALL	_FDisConnect
*** 327	-----------------------    goto g75;
	.line	115
	B	L113
L105:
***	-----------------------g67:
*** 249	-----------------------    switch ( GetNext(K$1) ) {...};
	.line	37
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-
	SUBK	48
	BZ	L108
	SUBK	1
	BZ	L107
L106:
***	-----------------------g68:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintError()
*** 263	-----------------------    PrintTab(&Error);
	.line	51
	LALK	_Error+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 264	-----------------------    goto g75;
	.line	52
	B	L113
L107:
***	-----------------------g69:
*** 257	-----------------------    AS = 1;
	.line	45
	LACK	1
	LDPK	_AS
	SACL	_AS
*** 258	-----------------------    reset_imp();
	.line	46
	CALL	_reset_imp
*** 259	-----------------------    PrintTab(&CidDT);
	.line	47
	LALK	_CidDT+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 260	-----------------------    PrintTab(&OK);
	.line	48
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 261	-----------------------    goto g75;
	.line	49
	B	L113
L108:
***	-----------------------g70:
*** 251	-----------------------    AS = 0;
	.line	39
	LACK	0
	LDPK	_AS
	SACL	_AS
*** 252	-----------------------    reset_imp();
	.line	40
	CALL	_reset_imp
*** 253	-----------------------    PrintTab(&CidRing);
	.line	41
	LALK	_CidRing+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 254	-----------------------    PrintTab(&OK);
	.line	42
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 255	-----------------------    goto g75;
	.line	43
	B	L113
L109:
***	-----------------------g71:
*** 246	-----------------------    F_ATA();
	.line	34
	CALL	_F_ATA
*** 247	-----------------------    goto g75;
	.line	35
	B	L113
L110:
***	-----------------------g72:
*** 238	-----------------------    if ( GetNext(K$1) != 103 ) goto g75;
	.line	26
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-
	SUBK	103
	BNZ	L113
*** 240	-----------------------    Guard = GetNext(K$1);
	.line	28
	MAR	* ,AR2
	LARK	AR2,5
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_GetNext
	MAR	*-
	LDPK	_Guard
	SACL	_Guard
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 241	-----------------------    PrintTab(&OK);
	.line	29
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 242	-----------------------    goto g75;
	.line	30
	B	L113
L112:
***	-----------------------g74:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 480	-----------------------    PrintTab(&OK);
	.line	268
	LALK	_OK+0
	MAR	* ,AR1
	SACL	*+
	CALL	_PrintTab
	MAR	*-
L113:
***	-----------------------g75:
*** 488	-----------------------    RPtOut0 = RPtOut;
	.line	276
	LDPK	_RPtOut0
	BLKD	#_RPtOut,_RPtOut0
***  	-----------------------    return;
EPI0_11:
	.line	277
	MAR	* ,AR1
	SBRK	15
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	489,000000000H,14

	.sym	_GetPrevious,_GetPrevious,36,2,0
	.globl	_GetPrevious

	.func	577
******************************************************
* FUNCTION DEF : _GetPrevious
******************************************************
_GetPrevious:

LF12	.set	1

	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+,AR2

	.sym	_Pt,-3+LF12,84,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to parameter Pt
* AR5	assigned to temp var  C$2
*
	.sym	C$3,1,20,1,16
	.sym	_Data,2,4,1,16
	.line	3
	LARK	AR2,-3+LF12
	MAR	*0+
	LAR	AR5,* ,AR5
*** 582	-----------------------    C$3 = --(*Pt);
	.line	6
	LAC	* 
	SUBK	1
	SACL	* ,AR2
	ADRK	4-LF12
	SACL	* 
*** 583	-----------------------    if ( C$3 >= &RBuffr ) goto g2;
	.line	7
	ZALS	* 
	RSXM
	SBLK	_RBuffr+0,0
	BGEZ	L115
*** 583	-----------------------    *Pt = &RLast;
	LALK	_RLast+0
	MAR	* ,AR5
	SACL	* 
L115:
***	-----------------------g2:
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING tolower()
*** 584	-----------------------    if ( (Data = C$2 = **Pt) < 65 || Data > 90 ) goto g4;
	.line	8
	MAR	* ,AR5
	LAR	AR4,* ,AR4
	LAR	AR5,* ,AR2
	MAR	*+
	SAR	AR5,* ,AR0
	SAR	AR5,*
	SSXM
	LAC	* 
	SUBK	65
	BLZ	L117
	MAR	* ,AR2
	LAC	* 
	SUBK	90
	BGZ	L117
*** 584	-----------------------    Data += 32;
	LAC	* 
	ADDK	32
	SACL	* 
L117:
***	-----------------------g4:
* <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LEAVING tolower()
*** 584	-----------------------    return Data;
	MAR	* ,AR2
	LAC	* 
EPI0_12:
	.line	9
	MAR	* ,AR1
	SBRK	4
	LAR	AR0,* 
	RET

	.endfunc	585,000000000H,3

	.sym	_AnalyseOn,_AnalyseOn,32,2,0
	.globl	_AnalyseOn

	.func	188
******************************************************
* FUNCTION DEF : _AnalyseOn
******************************************************
_AnalyseOn:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+,AR2

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 195	-----------------------    Pt1 = RPtOut;
	.sym	_Pt1,1,20,1,16
	.line	8
	LARK	AR2,1
	MAR	*0+
	BLKD	#_RPtOut,* ,AR5
*** 196	-----------------------    if ( GetPrevious(&Pt1) != 13 || GetPrevious(&Pt1) != 116 || (GetPrevious(&Pt1) != 97 || GetP...
	.line	9
	LARK	AR5,1
	MAR	*0+,AR1
	SAR	AR5,*+
	CALL	_GetPrevious
	MAR	*-
	SUBK	13
	BNZ	EPI0_13
	MAR	* ,AR4
	LARK	AR4,1
	MAR	*0+,AR1
	SAR	AR4,*+
	CALL	_GetPrevious
	MAR	*-
	SUBK	116
	BNZ	EPI0_13
	MAR	* ,AR3
	LARK	AR3,1
	MAR	*0+,AR1
	SAR	AR3,*+
	CALL	_GetPrevious
	MAR	*-
	SUBK	97
	BNZ	EPI0_13
	MAR	* ,AR5
	LARK	AR5,1
	MAR	*0+,AR1
	SAR	AR5,*+
	CALL	_GetPrevious
	MAR	*-
	SUBK	43
	BNZ	EPI0_13
	MAR	* ,AR4
	LARK	AR4,1
	MAR	*0+,AR1
	SAR	AR4,*+
	CALL	_GetPrevious
	MAR	*-
	SUBK	43
	BNZ	EPI0_13
	MAR	* ,AR3
	LARK	AR3,1
	MAR	*0+,AR1
	SAR	AR3,*+
	CALL	_GetPrevious
	MAR	*-
	SUBK	43
	BNZ	EPI0_13
*** 206	-----------------------    Command = 0;
	.line	19
	LACK	0
	LDPK	_Command
	SACL	_Command
*** 207	-----------------------    RPtOut0 = RPtOut;
	.line	20
	BLKD	#_RPtOut,_RPtOut0
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ENTERING PrintOk()
*** 208	-----------------------    PrintTab(&OK);
	.line	21
	LALK	_OK+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
***	-----------------------g2:
***  	-----------------------    return;
EPI0_13:
	.line	22
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	209,000000000H,2

	.sym	_ManageUart,_ManageUart,32,2,0
	.globl	_ManageUart

	.func	108
******************************************************
* FUNCTION DEF : _ManageUart
******************************************************
_ManageUart:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,2
	LAR	AR0,*0+

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*** 115	-----------------------    if ( CID != 2 ) goto g2;
	.sym	_LastC,1,4,1,16
	.line	8
	LDPK	_CID
	LAC	_CID
	SUBK	2
	BNZ	L121
*** 116	-----------------------    Manage_CID();
	.line	9
	CALL	_Manage_CID
L121:
***	-----------------------g2:
*** 120	-----------------------    if ( Command != 1 ) goto g10;
	.line	13
	LDPK	_Command
	LAC	_Command
	SUBK	1
	BNZ	L129
*** 120	-----------------------    if ( Connect ) goto g15;
	LAC	_Connect
	BNZ	L134
*** 121	-----------------------    LastC = GetData();
	.line	14
	CALL	_GetData
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
*** 122	-----------------------    if ( !(LastC&2) ) goto g10;
	.line	15
	BIT	* ,14
	BBZ	L129
*** 123	-----------------------    LastC = LastC>>8&0xff;
	.line	16
	SSXM
	LAC	* ,7
	ANDK	255,15
	SACH	* ,1
*** 124	-----------------------    if ( Loop ) goto g8;
	.line	17
	LDPK	_Loop
	LAC	_Loop
	BNZ	L127
L126:
***	-----------------------g7:
***  	-----------------------    if ( V14Send(LastC) == 1 ) goto g7;
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_V14Send
	MAR	*-,AR2
	SUBK	1
	BZ	L126
***  	-----------------------    goto g10;
	B	L129
L127:
L128:
***	-----------------------g8:
***	-----------------------g9:
*** 128	-----------------------    if ( SendData(LastC) < 0 ) goto g9;
	.line	21
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_SendData
	MAR	*-,AR2
	BLZ	L128
L129:
***	-----------------------g10:
*** 133	-----------------------    if ( Connect ) goto g15;
	.line	26
	LDPK	_Connect
	LAC	_Connect
	BNZ	L134
*** 134	-----------------------    if ( CID == 4 || CID == 5 ) goto g13;
	.line	27
	LDPK	_CID
	LAC	_CID
	SUBK	4
	BZ	L132
	LAC	_CID
	SUBK	5
	BZ	L132
*** 144	-----------------------    if ( !Carrier() ) goto g14;
	.line	37
	CALL	_Carrier,AR1
	BZ	L133
*** 144	-----------------------    goto g15;
	B	L134
L132:
***	-----------------------g13:
*** 135	-----------------------    if ( !ModemFSK() ) goto g15;
	.line	28
	CALL	_ModemFSK,AR1
	BZ	L134
L133:
***	-----------------------g14:
*** 136	-----------------------    FDisConnect();
	.line	29
	CALL	_FDisConnect
*** 137	-----------------------    Connect = 1;
	.line	30
	LACK	1
	LDPK	_Connect
	SACL	_Connect
*** 138	-----------------------    PrintTab(&NoCarrier);
	.line	31
	LALK	_NoCarrier+0
	SACL	*+
	CALL	_PrintTab
	MAR	*-
*** 139	-----------------------    Command = 0;
	.line	32
	LACK	0
	LDPK	_Command
	SACL	_Command
*** 139	-----------------------    goto g16;
	B	L135
L134:
***	-----------------------g15:
*** 154	-----------------------    if ( Command == 1 ) goto g21;
	.line	47
	LDPK	_Command
	LAC	_Command
	SUBK	1
	BZ	L140
L135:
***	-----------------------g16:
*** 170	-----------------------    if ( (LastC = ReadData()) < 0 ) goto g27;
	.line	63
	CALL	_ReadData,AR1
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
	BLZ	EPI0_14
*** 172	-----------------------    SendData(LastC);
	.line	65
	LAC	* ,AR1
	SACL	*+
	CALL	_SendData
	MAR	*-
*** 173	-----------------------    if ( RPtOut0 != RPtOut ) goto g19;
	.line	66
	LDPK	_RPtOut0
	LAC	_RPtOut0
	LDPK	_RPtOut
	SUB	_RPtOut
	BNZ	L138
*** 175	-----------------------    GetNext(&RPtOut0);
	.line	68
	LALK	_RPtOut0+0
	SACL	*+
	CALL	_GetNext
	MAR	*-
L138:
***	-----------------------g19:
*** 178	-----------------------    if ( LastC != 13 ) goto g27;
	.line	71
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	SUBK	13
	BNZ	EPI0_14
*** 180	-----------------------    AnalyseOff();
	.line	73
	CALL	_AnalyseOff,AR1
*** 181	-----------------------    goto g27;
	.line	74
	B	EPI0_14
L140:
***	-----------------------g21:
*** 155	-----------------------    if ( V14Stat() || (LastC = ReadData()) < 0 ) goto g27;
	.line	48
	CALL	_V14Stat,AR1
	BNZ	EPI0_14
	CALL	_ReadData
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	SACL	* 
	BLZ	EPI0_14
*** 160	-----------------------    if ( LastC != 13 ) goto g24;
	.line	53
	LAC	* 
	SUBK	13
	BNZ	L143
*** 162	-----------------------    AnalyseOn();
	.line	55
	CALL	_AnalyseOn,AR1
L143:
L144:
***	-----------------------g24:
***	-----------------------g25:
*** 165	-----------------------    if ( V14Send(LastC) == 1 ) goto g25;
	.line	58
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* ,AR1
	SACL	*+
	CALL	_V14Send
	MAR	*-,AR2
	SUBK	1
	BZ	L144
*** 166	-----------------------    RPtOut0 = RPtOut;
	.line	59
	LDPK	_RPtOut0
	BLKD	#_RPtOut,_RPtOut0
***	-----------------------g27:
***  	-----------------------    return;
EPI0_14:
	.line	78
	MAR	* ,AR1
	SBRK	3
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	185,000000000H,2

	.sym	_main,_main,36,2,0
	.globl	_main

	.func	98
******************************************************
* FUNCTION DEF : _main
******************************************************
_main:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+

*** 100	-----------------------    Print("Hello world.");
	.line	3
	LRLK	AR5,SL5
	SAR	AR5,*+
	CALL	_Print
	MAR	*-
*** 101	-----------------------    Loop = 1;
	.line	4
	LACK	1
	LDPK	_Loop
	SACL	_Loop
L148:
***	-----------------------g2:
*** 103	-----------------------    ManageUart();
	.line	6
	CALL	_ManageUart,AR1
*** 104	-----------------------    goto g2;
	.line	7
	B	L148
	.endfunc	105,000000000H,1

	.sym	_PrintFSK,_PrintFSK,32,2,0
	.globl	_PrintFSK

	.func	650
******************************************************
* FUNCTION DEF : _PrintFSK
******************************************************
_PrintFSK:

LF16	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,1
	LAR	AR0,*0+,AR2

	.sym	_Pt,-3+LF16,20,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
	.line	4
*** 654	-----------------------    if ( !*Pt ) goto g3;
	.line	5
	LARK	AR2,-3+LF16
	MAR	*0+
	LAR	AR5,* ,AR5
	LAC	* 
	BZ	EPI0_16
	MAR	* ,AR2
L150:
***	-----------------------g2:
*** 655	-----------------------    if ( SendData(*Pt) < 0 || *(++Pt) ) goto g2;
	.line	6
	LARK	AR2,-3+LF16
	MAR	*0+
	LAR	AR4,* ,AR4
	LAC	* ,AR1
	SACL	*+
	CALL	_SendData
	MAR	*-,AR2
	BLZ	L150
	LARK	AR2,-3+LF16
	MAR	*0+
	LAR	AR3,* ,AR3
	MAR	*+,AR2
	SAR	AR3,* ,AR3
	LAC	* ,AR2
	BNZ	L150
***	-----------------------g3:
***  	-----------------------    return;
EPI0_16:
	.line	9
	MAR	* ,AR1
	SBRK	2
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	658,000000000H,1
******************************************************
* DEFINE STRING CONSTANTS                            *
******************************************************
	.sect	".const"
SL0:	.byte	"0",0
SL1:	.byte	"1",0
SL2:	.byte	"Unimplemented modulation",0
SL3:	.byte	"Ver V67b",0
SL4:	.byte	"Unknown code",0
SL5:	.byte	"Hello world.",0
*****************************************************
* UNDEFINED REFERENCES                              *
*****************************************************
	.global	_PrintTab
	.end
