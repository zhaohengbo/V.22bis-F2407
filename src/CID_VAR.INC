*********************************************************
*														*
* Definition of caller Id constants						*
*														*
*********************************************************

	.def	_Date_Time_Buf, _CLIP_Buf, _FCLIP_Buf, _No_CLIP_Buf
	.def	_Call_Name_Buf, _No_Call_Name_Buf, _Call_Type_Buf, _FCLIP_Type_Buf

	.def	_CID_ring,  CID_Checksum
	.def	CID_Len, CID_ParmLen, MaxParmLen, BufNum
	.def	_CID_Ptr
	.def	_CID_status
	.def	Buffer_ptr
	.def	_CID_ret

_Date_Time_Buf		.usect	"CID_Buf",4,1
_CLIP_Buf			.usect	"CID_Buf",10,1
_FCLIP_Buf			.usect	"CID_Buf",10,1
_No_CLIP_Buf   		.usect	"CID_Buf",1,1
_Call_Name_Buf		.usect	"CID_Buf",10,1
_No_Call_Name_Buf	.usect	"CID_Buf",1,1
_Call_Type_Buf		.usect	"CID_Buf",1,1
_FCLIP_Type_Buf		.usect	"CID_Buf",1,1

_CID_ring			.usect 	"CID_Var",1
_CID_status			.usect 	"CID_Var",1
CID_Checksum		.usect 	"CID_Var",1
CID_Len				.usect 	"CID_Var",1
CID_ParmLen			.usect 	"CID_Var",1
MaxParmLen			.usect 	"CID_Var",1
BufNum				.usect 	"CID_Var",1
_CID_ret			.usect	"CID_Var",1

_CID_Ptr			.usect	"CID_Var",8
Buffer_ptr			.usect	"CID_Var",1



***CID-Functions***

WAIT_SEIZ			.set	   0
WAIT_CID			.set	   1		   ; CID function to execute is
START_CID			.set	   2		   ; contained in bit 0-3 of
GET_CID_PARM		.set	   3		   ; the CID status register
GET_CID_PARM_LEN	.set	   4	
GET_CID_DATA		.set	   5	
GET_CID_DUMMY_LEN	.set	   6	
GET_CID_DUMMY_DATA	.set	   7	
CHECK_CID			.set	   8	


***CID Return Status***

CID_ABORT			.set		0200h	; return status in bits 9,10
CHECK_BAD			.set		0400h	; of CID status register
CHECK_OK			.set		0600h


***CID Service Parameters***

CALL_SETUP			.set		80h
DATE_TIME			.set		01h
CLIP				.set		02h
FCLIP				.set		12h
NO_CLIP				.set		04h
CALL_NAME			.set		07h
NO_CALL_NAME		.set		08h
CALL_TYPE			.set		11h
FLIP_TYPE			.set		15h


***Buffer Lengths for CID Data Storage***

DATE_TIME_LEN		.set		4
CLIP_LEN			.set		10
FCLIP_LEN			.set		10
NO_CLIP_LEN			.set		1
CALL_NAME_LEN		.set		10
NO_CALL_NAME_LEN	.set		1
CALL_TYPE_LEN		.set		1
FCLIP_TYPE_LEN		.set		1


***Misc***

MAX_BUF				.set		8
CID_TIMEOUT			.set		16000	; 2s
MAX_CID_LEN			.set		72
CID_ON				.set		100h	; bit 8 in CID status register
CID_FLAG			.set		800h	; bit 11 - - - 
CID_EVEN			.set		010h	; bit 4  - - - 
BUFFER_INIT			.set		020h	; bit 5  - - - 
	