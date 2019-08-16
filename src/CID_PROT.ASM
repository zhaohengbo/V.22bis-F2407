*******************************************************************************
*   File:           cid_prot.asm											  *	
*																			  *
*	Author:			Katrin Matthes April 97									  *									  *
*																			  *
*   Description:    Caller ID protocol										  *
*																			  *
*   Revisions:															  	  *
*																			  *
*   Copyright:      (c)Texas Instruments France							  	  *
*                   All Rights Reserved										  *
*******************************************************************************
		.include    "cid_var.inc"
		
		.ref	CID_Byte	
		.global _FSKREG		 	

		.def	Init_CID			   				 
		.def	Scan_CID
		.def	_Init_Ptrs
		.def	CID_temp


CHARON		.set	0001h

CID_temp	.usect		"CID_Temp",1


*****************************************************************
*																*
*	Caller ID Initialization									*
*																*
*****************************************************************
Init_CID
		call	_Init_Ptrs
		zac
		ldp		#CID_Byte
		sacl	CID_Byte
		sacl	_CID_status		
		sacl	CID_Checksum
		sacl	_CID_ring
		sacl	CID_Len
		sacl	CID_ParmLen
		sacl	MaxParmLen
		sacl	_CID_ret


		call	clear_buffers

		ret

*****************************************************************
*																*
*	Clears all CID buffers										*
*																*
*****************************************************************
clear_buffers
	   	zac
		larp	ar3
		lar		ar3,#_Date_Time_Buf
		rpt		#DATE_TIME_LEN-1
		sacl	*+
		lar		ar3,#_CLIP_Buf
		rpt		#CLIP_LEN-1
		sacl	*+
		lar		ar3,#_FCLIP_Buf
		rpt		#FCLIP_LEN-1
		sacl	*+
		lar		ar3,#_No_CLIP_Buf
		rpt		#NO_CLIP_LEN-1
		sacl	*+
		lar		ar3,#_Call_Name_Buf
		rpt		#CALL_NAME_LEN-1
		sacl	*+
		lar		ar3,#_No_Call_Name_Buf
		rpt		#NO_CALL_NAME_LEN-1
		sacl	*+
		lar		ar3,#_Call_Type_Buf
		rpt		#CALL_TYPE_LEN-1
		sacl	*+
		lar		ar3,#_FCLIP_Type_Buf
		rpt		#FCLIP_TYPE_LEN-1
		sacl	*+
		ret


*****************************************************************
*																*
*	Caller ID Control Routine									*
*																*
*****************************************************************
Scan_CID
		ldp		#_FSKREG
		lac		_FSKREG
		and		#CHARON		;check flag bit
		bz		no_byte
		larp	ar3
		lar		ar3,#CID_temp
		lac		_FSKREG
		and		#~CHARON		;reset flag
		sacl	_FSKREG
		lac		_FSKREG,8
		ldp		#CID_Byte
		sach	CID_Byte
		lac		CID_Byte
		and		#00ffh
		sacl	CID_Byte
		ldp		#_CID_status
		lac		_CID_status
		and		#000fh			;bit0-3 contain function to execute
		add		#CID_functions
		tblr	*
		lac		*
		cala					; branch to function
no_byte
		ret


*****************************************************************
*																*
*	Wait for Channel Seizure									*
*																*
*****************************************************************
Wait_Seiz
		ldp		#CID_Byte
		lac		CID_Byte
		xor		#55h		
		bnz		NoSeiz
		lac		_CID_status
		and		#0fff0h
		or		#WAIT_CID
		sacl	_CID_status		
NoSeiz
		ret


*****************************************************************
*																*
*	Wait for Call Setup Byte									*
*																*
*****************************************************************
Wait_CID
		ldp		#CID_Byte
		lac		CID_Byte
		xor		#55h
		bz		done			; still in seizure
		lac		CID_Byte
		sub		#CALL_SETUP		; first data byte must equal 80h (Call Setup)		  
		bnz		done			; transition seizure/mark		
		lac		_CID_status
		and		#0fff0h			; zero out function to execute next,
		or		#START_CID		; so that 'or' below will work properly
		sacl	_CID_status						
		lac		CID_Byte
		sacl	CID_Checksum
		b		done
		lac		_CID_status
		and		#0fff0h
		sacl	_CID_status
done	ret


*****************************************************************
*																*
*	Start Caller ID Reception									*
*																*
*****************************************************************
Start_CID
		ldp		#CID_Byte			; get global data length
		lac		CID_Byte
		sacl	CID_Len
		add		CID_Checksum
		sacl	CID_Checksum
		sub		#100h
		blz		no_wrap
		sacl	CID_Checksum
no_wrap
		larp	ar3
		lar		ar3,CID_Len		
		lac		_CID_status
		and		#0fff0h
		banz	next
		or		#CHECK_CID
		sacl	_CID_status
		b		done1
next
		or		#GET_CID_PARM
		sacl	_CID_status
done1	ret



*****************************************************************
*																*
*	Read the Caller ID Parameter								*
*																*
*****************************************************************
Get_CID_Parm
		call	CID_update
		bz		abort2			; ACC contains CID_Len
		lac		CID_Byte		; CID_Byte contains service parameter
		ldp		#BufNum
		sub		#1
		bz		date
		sub		#1
		bz		clip
		sub		#2
		bz		no_clip
		sub		#3
		bz		c_name
		sub		#1
		bz		no_name
		sub		#9
		bz		c_type
		sub		#1
		bz		fclip
		sub		#3
		bz		fclip_type
		b		dummy
date
		zac				
		sacl	BufNum
		lac		#DATE_TIME_LEN,1
		sacl	MaxParmLen
		b		done2
clip	
		lac		#1
		sacl	BufNum
		lac		#CLIP_LEN,1
		sacl	MaxParmLen
		b		done2
fclip
		lac		#2
		sacl	BufNum
		lac		#FCLIP_LEN,1
		sacl	MaxParmLen
		b		done2
no_clip
		lac		#3
		sacl	BufNum
		lac		#NO_CLIP_LEN
		sacl	MaxParmLen
		b		done2
c_name
		lac		#4
		sacl	BufNum
		lac		#CALL_NAME_LEN,1
		sacl	MaxParmLen
		b		done2
no_name	
		lac		#5
		sacl	BufNum
		lac		#NO_CALL_NAME_LEN
		sacl	MaxParmLen
		b		done2
c_type
		lac		#6
		sacl	BufNum
		lac		#CALL_TYPE_LEN
		sacl	MaxParmLen
		b		done2
fclip_type
		lac		#7
		sacl	BufNum
		lac		#FCLIP_TYPE_LEN
		sacl	MaxParmLen
		b		done2
dummy
		ldp		#_CID_status			; service parameter not in list
		lac		_CID_status				; -> initiate dummy read
		and		#0fff0h
		or		#GET_CID_DUMMY_LEN
		sacl	_CID_status
		ret
abort2
		ldp		#_CID_status
		lac		_CID_status
		or		#CID_ABORT
		sacl	_CID_status
		ret
done2
		ldp		#BufNum
		lac		#1
		rpt		BufNum
		sfl
		sfr
		ldp		#_CID_ret
		or		_CID_ret
		sacl	_CID_ret
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#GET_CID_PARM_LEN
		sacl	_CID_status
		ret


*****************************************************************
*																*
*	Read the Caller ID parameter length							*
*																*
*****************************************************************
Get_CID_ParmLen
		call	CID_update			; ACC contains CID_Len
		sub		CID_Byte
		blz		abort3				; if parameter length > global length then abort
		lac		CID_Byte			
		sacl	CID_ParmLen
		bz		next2
		ldp		#MaxParmLen			; if parameter length exceeds allocated buffer 
		sub		MaxParmLen			; space then initiate a dummy read
		bgz		dummy_len
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#GET_CID_DATA
		sacl	_CID_status
		b		done3
dummy_len
		ldp		#_CID_status
		and		#0fff0h
		or		#GET_CID_DUMMY_DATA
		sacl	_CID_status
		b		done3
next2	
		ldp		#_CID_status		; Paramter length = 0 and global data length > 0
		lac		_CID_status			; -> get next paramter
		and		#0fff0h				; otherwise do checksum test
		lar		ar3,CID_Len
		banz	nxt_parm,*,ar3
		or		#CHECK_CID
		sacl	_CID_status
		b		done3
nxt_parm
		or		#GET_CID_PARM
		sacl	_CID_status
		b		done3
abort3
		ldp		#_CID_status
		lac		_CID_status
		or		#CID_ABORT
		sacl	_CID_status
		call	clear_buffers
done3
		ret



*****************************************************************
*																*
*	Read the Caller ID parameter data							*
*																*
*****************************************************************
Get_CID_Data
		call	CID_update			; ACC contains CID_Len		
		larp	ar3	
		lac		_CID_status
		and		#BUFFER_INIT		; set Buffer_ptr to buffer start address
		bnz		no_init		
		lac		#_CID_Ptr
		add		BufNum
		sacl	Buffer_ptr
		lar		ar3,Buffer_ptr
		lac		*
		sacl	Buffer_ptr
		lac		_CID_status
		or		#BUFFER_INIT		; set bit, so that init will only be carried out once
		sacl	_CID_status
no_init
		lar		ar3,Buffer_ptr		; points to current data buffer
		lac		_CID_status
		and		#CID_EVEN
		bnz		get_even
		lac		CID_Byte,8
		sacl	*
		b		past_odd
get_even
		lac		CID_Byte
		add		*
		sacl	*+
past_odd
		sar		ar3,Buffer_ptr
		lac		_CID_status
		xor		#CID_EVEN			; toggle bit
		sacl	_CID_status			; same function will be executed next
		lac		CID_Len
		bz		Check_It
		lac		CID_ParmLen		
		sub		#1
		sacl	CID_ParmLen
		bz		NxtParm
		b		done4
NxtParm	
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#GET_CID_PARM
		and		#~BUFFER_INIT		; reset buffer-init bit for next parameter
		and		#~CID_EVEN			; reset toggle bit for next parm
		sacl	_CID_status
		b		done4
Check_It
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#CHECK_CID
		sacl	_CID_status
done4
		ret	
		
		
		
*****************************************************************
*																*
*	Read the dummy parameter length								*
*																*
*****************************************************************
Get_CID_DummyLen
		call	CID_update
		sub		CID_Byte
		blz		abort4				; if parameter length > global length then abort
		lac		CID_Byte			
		sacl	CID_ParmLen
		bz		next4
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#GET_CID_DUMMY_DATA
		sacl	_CID_status
		b		done5
next4	
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		lar		ar3,CID_Len
		banz	nxt_parm2,*,ar3
		or		#CHECK_CID
		sacl	_CID_status
		b		done5
nxt_parm2
		or		#GET_CID_PARM
		sacl	_CID_status
		b		done5
abort4
		ldp		#_CID_status
		lac		_CID_status
		or		#CID_ABORT
		sacl	_CID_status
		call	clear_buffers
done5
		ret



*****************************************************************
*																*
*	Read the Caller ID dummy data								*
*																*
*****************************************************************
Get_CID_DummyData
		call	CID_update			;ACC contains CID_Len
		bz		Chck_Sum
		lac		CID_ParmLen
		bz		Nxt_Parm
		sub		#1
		sacl	CID_ParmLen
		b		done6
Chck_Sum
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#CHECK_CID
		sacl	_CID_status
		b		done6
Nxt_Parm
		ldp		#_CID_status
		lac		_CID_status
		and		#0fff0h
		or		#GET_CID_PARM
		sacl	_CID_status
done6
		ret


	 
*****************************************************************
*																*
*	Caller ID Checksum Test		 								*
*																*
*****************************************************************
Check_CID
		ldp		#CID_Byte		; last byte contains complement of mod 256 sum of all bytes					 
		lac		CID_Byte
;		cmpl
;		add		#0001			; two's complement 
;		and		#00ffh			; checksum in byte format
;		sub		CID_Checksum	; CID_Checksum contains mod 256 sum of all bytes
        add     CID_Checksum
        and     #00ffh
		bz		check_ok
		lac		_CID_status
		or		#CHECK_BAD
		sacl	_CID_status
		b		done7
check_ok
		lac		_CID_status
		or		#CHECK_OK
		sacl	_CID_status
done7
		lac		_CID_status
		and		#~CID_ON
		sacl	_CID_status
		ret					 		
		


*****************************************************************
*																*
*	Update checksum and global data length						*
*																*
*****************************************************************
CID_update
		ldp		#CID_Byte
		lac		CID_Byte
		add		CID_Checksum
		sacl	CID_Checksum
		sub		#100h
		blz		no_wrap1
		sacl	CID_Checksum
no_wrap1
		lac		CID_Len
		sub		#1
		sacl	CID_Len
		ret


*****************************************************************
*																*
*	Init array of pointers to CID buffers						*
*																*
*****************************************************************

_Init_Ptrs
		ldp		#_CID_Ptr
		lac		#_Date_Time_Buf
		sacl	_CID_Ptr
		lac		#_CLIP_Buf
		sacl	_CID_Ptr+1
		lac		#_FCLIP_Buf
		sacl	_CID_Ptr+2
		lac		#_No_CLIP_Buf
		sacl	_CID_Ptr+3
		lac		#_Call_Name_Buf
		sacl	_CID_Ptr+4
		lac		#_No_Call_Name_Buf
		sacl	_CID_Ptr+5
		lac		#_Call_Type_Buf
		sacl	_CID_Ptr+6
		lac		#_FCLIP_Type_Buf
		sacl	_CID_Ptr+7
		ret	


		

*** CID Function Table in ROM ***
		
CID_functions
		.word	Wait_Seiz
		.word  	Wait_CID
		.word	Start_CID
		.word	Get_CID_Parm
		.word	Get_CID_ParmLen
		.word	Get_CID_Data
		.word	Get_CID_DummyLen
		.word	Get_CID_DummyData
		.word	Check_CID