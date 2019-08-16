*******************************************************
* TMS320C2x/C2xx/C5x ANSI C Codegen Version 6.60       
*******************************************************
;	C:\TI_TOOLS\dspac.exe -v2xx cid C:\WINDOWS\TEMP\cid.if 
;	C:\TI_TOOLS\dspopt.exe -h0 -p0 -GAR6 -GAR7 -v2xx -s -O3 C:\WINDOWS\TEMP\cid.if C:\WINDOWS\TEMP\cid.opt 
;	C:\TI_TOOLS\dspcg.exe -o -GAR6 -GAR7 -v2xx C:\WINDOWS\TEMP\cid.opt cid.asm C:\WINDOWS\TEMP\cid.tmp 
	.port
	.file	"cid.c"
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
	.file	"cid.c"
	.globl	_CallerID
	.globl	_Print
	.globl	_Init_Ptrs
	.globl	_ReadTable
	.globl	_CID_status
	.globl	_CID_ret
	.globl	_CID_Ptr
	.globl	_AS
	.globl	_transfer_buf
	.globl	_CLI0
	.globl	_CLI1
	.globl	_CLI2
	.globl	_CLI3
	.globl	_CLI4
	.globl	_CLI5
	.globl	_CLI6
	.globl	_CLI7
	.globl	_Manage_CID
	.globl	_transfer_data

	.sym	_transfer_data,_transfer_data,32,2,0
	.globl	_transfer_data

	.func	48
******************************************************
* FUNCTION DEF : _transfer_data
******************************************************
_transfer_data:

LF1	.set	0

	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,6
	LAR	AR0,*0+,AR2

	.sym	_number,-3+LF1,4,9,16
*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
* AR5	assigned to temp var  K$34
* AR5	assigned to variable  tmp_ptr
*  ---  L$1 shares AUTO storage with BufferLen
*
	.sym	_i,1,4,1,16
	.sym	_count,2,4,1,16
	.sym	U$50,3,20,1,16
	.sym	L$1,4,4,1,16
	.sym	_toggle,5,4,1,16
	.line	2
*** 51	-----------------------    toggle = 0;
	.line	4
	LACK	0
	LARK	AR2,5
	MAR	*0+
	SACL	* 
***  	-----------------------    switch ( number ) {...};
	SSXM
	SBRK	8-LF1
	LAC	* ,AR0
	SUBK	7
	BGZ	L1
	ADDK	7
	BLZ	L1
	ADLK	LL3
	TBLR	*
	LAC	*
	BACC
	.sect	".switch"
LL3:
	.word	L9
	.word	L8
	.word	L7
	.word	L6
	.word	L5
	.word	L4
	.word	L3
	.word	L2
	.text
L1:
***	-----------------------g1:
*** 51	-----------------------    count = 1;
	LACK	1
	MAR	* ,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
***  	-----------------------    goto g10;
	B	L10
L2:
***	-----------------------g2:
*** 77	-----------------------    count = ReadTable(&CLI7);
	.line	30
	LALK	_CLI7+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 78	-----------------------    BufferLen = 1;
	.line	31
	LACK	1
	ADRK	2
	SACL	* 
*** 79	-----------------------    goto g10;
	.line	32
	B	L10
L3:
***	-----------------------g3:
*** 74	-----------------------    count = ReadTable(&CLI6);
	.line	27
	LALK	_CLI6+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 75	-----------------------    BufferLen = 1;
	.line	28
	LACK	1
	ADRK	2
	SACL	* 
*** 76	-----------------------    goto g10;
	.line	29
	B	L10
L4:
***	-----------------------g4:
*** 71	-----------------------    count = ReadTable(&CLI5);
	.line	24
	LALK	_CLI5+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 72	-----------------------    BufferLen = 1;
	.line	25
	LACK	1
	ADRK	2
	SACL	* 
*** 73	-----------------------    goto g10;
	.line	26
	B	L10
L5:
***	-----------------------g5:
*** 68	-----------------------    count = ReadTable(&CLI4);
	.line	21
	LALK	_CLI4+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 69	-----------------------    BufferLen = 10;
	.line	22
	LACK	10
	ADRK	2
	SACL	* 
*** 70	-----------------------    goto g10;
	.line	23
	B	L10
L6:
***	-----------------------g6:
*** 65	-----------------------    count = ReadTable(&CLI3);
	.line	18
	LALK	_CLI3+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 66	-----------------------    BufferLen = 1;
	.line	19
	LACK	1
	ADRK	2
	SACL	* 
*** 67	-----------------------    goto g10;
	.line	20
	B	L10
L7:
***	-----------------------g7:
*** 62	-----------------------    count = ReadTable(&CLI2);
	.line	15
	LALK	_CLI2+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 63	-----------------------    BufferLen = 10;
	.line	16
	LACK	10
	ADRK	2
	SACL	* 
*** 64	-----------------------    goto g10;
	.line	17
	B	L10
L8:
***	-----------------------g8:
*** 59	-----------------------    count = ReadTable(&CLI1);
	.line	12
	LALK	_CLI1+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 60	-----------------------    BufferLen = 10;
	.line	13
	LACK	10
	ADRK	2
	SACL	* 
*** 61	-----------------------    goto g10;
	.line	14
	B	L10
L9:
***	-----------------------g9:
*** 56	-----------------------    count = ReadTable(&CLI0);
	.line	9
	LALK	_CLI0+0
	MAR	* ,AR1
	SACL	*+
	CALL	_ReadTable
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
*** 57	-----------------------    BufferLen = 4;
	.line	10
	LACK	4
	ADRK	2
	SACL	* 
L10:
***	-----------------------g10:
*** 85	-----------------------    tmp_ptr = CID_Ptr[number];
	.line	38
	LARK	AR2,-3+LF1
	MAR	*0+
	LAC	* ,AR0
	ADLK	_CID_Ptr+0,0
	SACL	* 
	LAR	AR4,* ,AR4
	LAR	AR5,* ,AR2
*** 87	-----------------------    if ( BufferLen >= 2 ) goto g12;
	.line	40
	SSXM
	ADRK	7-LF1
	LAC	* 
	SUBK	2
	BGEZ	L12
*** 105	-----------------------    C$4 = &transfer_buf[count];
	.line	58
	SBRK	2
	LAC	*+
	ADLK	_transfer_buf+0,0
	SACL	* 
*** 105	-----------------------    *C$4 = *tmp_ptr;
	LAR	AR3,* ,AR5
	LAC	* ,AR3
	SACL	* ,AR2
*** 106	-----------------------    C$4[1] = 0;
	.line	59
	LAR	AR5,* ,AR5
	MAR	*+
	LACK	0
	SACL	* 
*** 106	-----------------------    K$34 = &transfer_buf[0];
	LRLK	AR5,_transfer_buf
*** 106	-----------------------    goto g18;
	B	L18
L12:
***	-----------------------g12:
*** 89	-----------------------    if ( BufferLen*2 <= 0 ) goto g16;
	.line	42
	LAC	* ,1,AR1
	SACL	* 
	LAC	* 
	BLEZ	L16
***  	-----------------------    U$50 = &transfer_buf[count];
	MAR	* ,AR2
	SBRK	2
	LAC	*+
	ADLK	_transfer_buf+0,0
	SACL	*+
*** 89	-----------------------    i = BufferLen*2;
	LAC	* ,1
	SBRK	3
	SACL	* 
***  	-----------------------    L$1 = i;
	ADRK	3
	SACL	*+
L15:
***	-----------------------g15:
*** 91	-----------------------    *U$50 = toggle ? *tmp_ptr++&0xff : *tmp_ptr>>8;
	.line	44
	LAC	* 
	BZ	LL4
	LACK	255
	MAR	* ,AR5
	AND	*+,AR1
	SACL	* 
	LAC	* 
	B	LL5
LL4:
	SSXM
	MAR	* ,AR5
	LAC	* ,7,AR1
	SACH	* ,1
	LAC	* 
LL5:
	MAR	* ,AR2
	SBRK	2
	LAR	AR4,* ,AR4
	SACL	* ,AR2
*** 96	-----------------------    toggle ^= 1;
	.line	49
	LACK	1
	ADRK	2
	XOR	* 
	SACL	* 
*** 89	-----------------------    ++U$50;
	.line	42
	SBRK	2
	LAC	* 
	ADDK	1
	SACL	*+
*** 89	-----------------------    if ( --L$1 ) goto g15;
	SSXM
	LAC	* 
	SUBK	1
	SACL	*+
	BNZ	L15
*** 89	-----------------------    goto g17;
	B	L17
L16:
***	-----------------------g16:
*** 89	-----------------------    i = 0;
	LACK	0
	MAR	* ,AR2
	SBRK	3
	SACL	* 
L17:
***	-----------------------g17:
*** 101	-----------------------    transfer_buf[count+i] = 0;
	.line	54
	LARK	AR2,1
	MAR	*0+
	LAC	*+
	ADD	* ,AR0
	ADLK	_transfer_buf+0,0
	SACL	* 
	LAR	AR3,* ,AR3
	LACK	0
	SACL	* 
*** 101	-----------------------    K$34 = &transfer_buf[0];
	LRLK	AR5,_transfer_buf
L18:
***	-----------------------g18:
*** 110	-----------------------    Print(K$34);
	.line	63
	MAR	* ,AR1
	SAR	AR5,*+
	CALL	_Print
	MAR	*-
***  	-----------------------    return;
EPI0_1:
	.line	65
	SBRK	7
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	112,000000000H,6

	.sym	_Manage_CID,_Manage_CID,32,2,0
	.globl	_Manage_CID

	.func	22
******************************************************
* FUNCTION DEF : _Manage_CID
******************************************************
_Manage_CID:
	POPD	*+
	SAR	AR0,*+
	SAR	AR1,*
	LARK	AR0,3
	LAR	AR0,*0+,AR2

*
* AR6	reserved for global variable AR6
* AR7	reserved for global variable AR7
*
*  ---  i shares AUTO storage with temp
*
*** 26	-----------------------    temp = AS;
	.sym	_i,1,4,1,16
	.sym	_status,2,4,1,16
	.line	5
	LARK	AR2,1
	MAR	*0+
	BLKD	#_AS,* 
*** 28	-----------------------    if ( CID != 2 ) goto g10;
	.line	7
	LDPK	_CID
	LAC	_CID
	SUBK	2
	BNZ	EPI0_2
*** 30	-----------------------    if ( status = CallerID(temp) ) goto g5;
	.line	9
	LAC	* ,AR1
	SACL	*+
	CALL	_CallerID
	MAR	*-,AR2
	LARK	AR2,2
	MAR	*0+
	SACL	* 
	BNZ	L23
*** 33	-----------------------    if ( !(CID_status&0x2000) ) goto g10;
	.line	12
	LDPK	_CID_status
	BIT	_CID_status,2
	BBZ	EPI0_2
*** 34	-----------------------    CID_status &= 0xdfff;
	.line	13
	LACK	57343
	AND	_CID_status
	SACL	_CID_status
*** 35	-----------------------    Print("RING");
	.line	14
	LRLK	AR5,SL0
	MAR	* ,AR1
	SAR	AR5,*+
	CALL	_Print
	MAR	*-
*** 36	-----------------------    if ( !s0 ) goto g10;
	.line	15
	LDPK	_s0
	LAC	_s0
	BZ	EPI0_2
*** 36	-----------------------    F_ATA();
	CALL	_F_ATA
*** 36	-----------------------    goto g10;
	B	EPI0_2
L23:
***	-----------------------g5:
*** 39	-----------------------    i = 0;
	.line	18
	LACK	0
	MAR	*-
	SACL	* 
L25:
***	-----------------------g7:
*** 40	-----------------------    if ( !(status&1<<i) ) goto g9;
	.line	19
	LT	*+,AR0
	LACK	1
	SACL	* 
	LACT	* ,AR2
	AND	* 
	ANDK	0FFFFh
	BZ	L27
*** 41	-----------------------    transfer_data(i);
	.line	20
	MAR	*-
	LAC	* ,AR1
	SACL	*+
	CALL	_transfer_data
	MAR	*-
L27:
***	-----------------------g9:
*** 39	-----------------------    if ( (++i) < 8 ) goto g7;
	.line	18
	SSXM
	MAR	* ,AR2
	LARK	AR2,1
	MAR	*0+
	LAC	* 
	ADDK	1
	SACL	* 
	SUBK	8
	BLZ	L25
***	-----------------------g10:
***  	-----------------------    return;
EPI0_2:
	.line	24
	MAR	* ,AR1
	SBRK	4
	LAR	AR0,*-
	PSHD	*
	RET

	.endfunc	45,000000000H,3
******************************************************
* DEFINE STRING CONSTANTS                            *
******************************************************
	.sect	".const"
SL0:	.byte	"RING",0
*****************************************************
* UNDEFINED REFERENCES                              *
*****************************************************
	.global	_transfer_data
	.end
