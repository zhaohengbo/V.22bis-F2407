	 .include "msp58c80.i8x"
     .include "cid.inc"

	 .def	_CallerID
	 .def	_reset_imp
	 .ref	_CID_status,_CID_ret
	 .ref	Scan_CID,Init_CID,resV23,_InitRXV23,_Init_V23
	 .ref	_Tim0
	 .ref	CID_temp
	 .global	_FSKREG
	 .global	_Modul

MCalling 	.set	0100h 
CARRIERON	.set	0002h

;--------------------------------------------------------
;	Main caller ID routine:
;	checks ring, if short ring enables CID reception,
;	switches clock to 8 kHz, initializes all CID routines
;--------------------------------------------------------
	
_CallerID
	 	POPD    *+      ; save context and set ar0,ar1
     	SAR     AR0,*+
    	SAR     AR1,*
    	LARK    AR0,#0     ; 0 local variable
     	LAR     AR0,*0+   ; new ar1
	
;
; get argument
    	lark    ar2,-3      ; offset of argument
    	mar     *,ar2
   		mar     *0+    

		.if		IsDsk
		b		no_ring		; no ring detection function
		.endif

		lac		*
	   	bnz		short_ring			
check_ring
; check if ring present

        ldp     #0
        lac     BI
        and     #RING_MASK ; b6

        bnz     no_ring
        
		ldp		#_Tim0	; reset timer for ring count
		zac		
		sacl	_Tim0

;wait for end of ring
Ring_on
        ldp     #0
        lac     BI
        and     #RING_MASK

        bz      Ring_on

;check min. ring length
        ldp     #_Tim0
        lac     _Tim0
        sub     #RING_MIN
        blz     no_ring
;check max. ring length        
        sub     #RING_MAX	 ; value RING_MAX=RING_MIN+(max. ring - min. ring)
        blez    short_ring
		ldp		#_CID_status
		lac		_CID_status
		or		#RING

		sacl	_CID_status
        b		no_ring

; valid short ring has been detected => start CID reception
short_ring	
        larp	ar2
		lac		*			; check if we want to receive DT_AS
		bz		ring_init

		ldp		#_CID_status
		lac		_CID_status
		and		#CID_ON
		bnz		no_as_init

ring_init
        dint
        ldp		#0
        lac     BO			; switch impedance
        and     #~SWITCH_IMP	;b11 
        sacl    BO
		eint

		dint
    	ldp		#_Modul		;set this for V23
		lac	    _Modul
		or		#MCalling
		sacl	_Modul
			
    	call	Init_CID	; init cid routines:
    	call	resV23 		; FSK receive and protocol
		call	_InitRXV23
		call	_InitDCD	; init Carrier detection thresholds

    	ldp		#_CID_status    			
    	lac		_CID_status
    	or		#CID_ON
    	sacl	_CID_status
      	eint			;enable interrupts

		larp	ar2
		lac		*			; check if we want to receive DT_AS
		bz		no_AS

no_as_init		
		lac		_CID_status
		and		#AS_ON
		bz		no_ring

no_AS
		zac
		ldp		#_Tim0
		sacl	_Tim0	; reset timer for DCD timeout

no_DCD
		ldp     #_FSKREG
        lac     _FSKREG
        and     #CARRIERON		; check if data carrier detected
        bnz     dcd_on

        ldp     #_Tim0
        lac     _Tim0
        sub     #DCD_TO
        blez	no_DCD
timeout1
        
        dint
		ldp		#0
        lac     BO
        or	    #SWITCH_IMP
        sacl    BO
		eint

		ldp		#_CID_status
		lac		_CID_status
		and		#~CID_ON	; reset bit	CID_ON
		sacl	_CID_status

        b       no_ring
	
dcd_on
		ldp		#_Tim0	; reset timer for ring count
		zac		
		sacl	_Tim0
		
loop_CID
		call	Scan_CID		
		ldp     #_Tim0
        lac     _Tim0
        sub     #CID_TO		
        bgz		timeout1			
		ldp		#_CID_status		  
		lac		_CID_status
		and		#0600h
   		bnz		check_ret_stat
		b		loop_CID							 
		
check_ret_stat
		
		ldp		#0
		dint
		lac     BO
		or	    #SWITCH_IMP ;reswitch impedance
		sacl    BO
		eint

		ldp		#_CID_status
		lac		_CID_status
		and		#~CID_ON	; reset bit
		sacl	_CID_status
		and		#0600h
		sub		#0200h
		bz		no_ring		; abort, error during transmission
		sub		#0200h
		bz		no_ring		; crc bad
		sub		#0200h
		bnz		no_ring
crc_ok
		ldp		#_CID_ret
		lac		_CID_ret
		b		exit1
		; transmit valid data to UART buffer


no_ring
	 zac
exit1
	 MAR     *,AR1   ;
     SBRK    #1
     LAR     AR0,*-  ; restore ar0
     PSHD    *
	ret



_reset_imp
		ldp		#0
		dint
		lac		BO
		or	    #SWITCH_IMP ;reswitch impedance
		sacl    BO
		eint
		zac
		ldp		#_CID_status
		sacl	_CID_status
		ret


_InitDCD
		ldp		#_AGCTHRESL
		lac		#DCDon
		sacl	_AGCTHRESL
		lac		#DCDoff
		sacl	_AGCTHRESH
		ret
		
