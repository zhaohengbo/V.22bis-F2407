	.include "..\cid.inc"
	.include "..\global.inc"
	.mmregs

        .global resV23,CheckCPE
		.def	CID_Byte			; Mod. Katrin Matthes Feb.97

        .ref _CID_status

		.ref _AS	;=1->DT Alerting Signal, =0->Ring
		.ref FromAD

*
* Allocate space for V23 variables
*
CID_Byte	.usect	"CID_Var",1,1	; received valid data byte

rptz    .macro  arg1
        	zac
        	mpyk    0
        	rpt     arg1
        .endm

        .text
;
; initialize V23
;
resV23 
		dint
		cnfd
;
        larp    ar3
        zac
		lar		ar3,#iir6_a1
		rpt		#CPE_delay-iir6_a1+1
		sacl	*+
 		ldp		#_AS
		lac		_AS
		bz		no_CPE0
        lacl    #200            ;INITIALIZE CPE threshold
		ldp		#CPE_thr
        sacl    CPE_thr
		lac		#NoCPE
		b		end0
no_CPE0
		lac		#EndCPE
end0
		ldp		#CPEstat
		sacl	CPEstat
		eint
		ret
;


;
;	NoCPE	if CPE			StCPE	;wait for start of CPE
;		else 			NoCPE
;	StCPE	if !CPE & OnHook	WSeiz	;wait for end of CPE
;		elseif !CPE & OffHook	EndCPE
;		else			StCPE
;	EndCPE  if 160 samples here	AckCPE	;wait 20mS
;		else			EndCPE
;	AckCPE  if 400 samples here	WSeiz	;send 50mS DTMF 'D'
;		else			AckCPE
;	WaitV23 if DCD			Seiz	;wait 200mS max for V23 data
;		else if 1600 samps here	NoCPE
;		else 			WaitV23
;	WSeiz	if Seizure		Seiz	;wait indefinitly for V23 data
;		else			WSeiz	
;	Seiz	if !DCD	& CPEmode	NoCPE	;wait for end of seizure
;		else if !DCD & !CPEmode WSeiz
;		else if Seizure		Seiz
;		else			CIDmsg
;	CIDmsg	if !DCD	& CPEmode	NoCPE	;process the message
;		else if !DCD & !CPEmode WSeiz
;		else			CIDmsg
;
CheckCPE
		ldp		#CPEstat
		lac		CPEstat
		
		.if		CBacc
		sub		#NoCPE
		bz		NoCPE
		lac		CPEstat
		sub		#StCPE
		bz		StCPE
		lac		CPEstat
		sub		#EndCPE
		bz		EndCPE
		dint
		b		$			; error
		.endif

		bacc
NoCPE   call    CPE
        bit     CPE_tim,7
		bbz		EndCPE			; wait for start of alerting signal
		ldp		#CPEstat
		lac		#StCPE
		sacl	CPEstat
		b		EndCPE
StCPE   call    CPE
        bit     CPE_tim,7
		bbnz	EndCPE			; wait for end of alerting signal
		ldp		#_CID_status
		lac		_CID_status
		or		#AS_ON
		sacl	_CID_status
		lac		#EndCPE
		ldp		#CPEstat
		sacl	CPEstat
EndCPE
		ret
;
*****************************************************************
*																*
*  Sub-routine CPE												*
*    This subroutine detects the CPE alerting signal			*
*	Entry														*
*	  Acc=Q15 PCM input											*
*	Exit														*
*	  If CPE present Acc=256									*
*	  Else Acc<0												*
*																*
*****************************************************************
CPE     ldp		#FromAD
		lacc    FromAD
		ldp		#iir1_b1
        sacl    iir1_b1         ;input for low freq filter
		sacl	iir4_b1		;input for high freq filter
;
; 1st bi-quad for low frequency filter
;
        lar     ar3,#iir1_b3    ;point to data

		larp	ar3
		rptz	#4
		macd	#IIR_LF1,*-	;filter with params
        lta     *-              ;apac & dec ar
        sach    iir1_a1,1       ;save feedback terms
        sach    iir2_b1,1       ;input to next stage
;
; 2nd bi-quad for low frequency filter
;
		rptz	#4
		macd	#IIR_LF2,*-	;filter with params
        lta     *-              ;apac & dec ar
        sach    iir2_a1,1       ;save feedback terms
        sach    iir3_b1,1       ;input to next stage
;
; 3rd bi-quad for low frequency filter
;
		rptz	#4
		macd	#IIR_LF3,*-	;filter with params
        lta     *-              ;apac & dec ar
        sach    iir3_a1,1       ;save feedback terms
;
; measure signal strength
;
		abs			;convert to amplitude
        sub     Low_En,15       ;add in old low energy filter
		sfr
		sfr
		sfr
		addh	Low_En
		sach	Low_En
;
; 1st bi-quad for high frequency filter
;
		rptz	#4
		macd	#IIR_HF1,*-	;filter with params
        lta     *-              ;apac & dec ar
        apac                    ;last parameter is div 2
        sach    iir4_a1,1       ;save feedback terms
        sach    iir5_b1,1       ;input to next stage
;
; 2nd bi-quad for high frequency filter
;
		rptz	#4
		macd	#IIR_HF2,*-	;filter with params
        lta     *-              ;apac & dec ar
        apac                    ;last parameter is div 2
        sach    iir5_a1,1       ;save feedback terms
        sach    iir6_b1,1       ;input to next stage
;
; 3rd bi-quad for high frequency filter
;
		rptz	#4
		macd	#IIR_HF3,*-	;filter with params
        lta     *-              ;apac & dec ar
        apac                    ;last parameter is div 2
        sach    iir6_a1,1       ;save feedback terms
;
; measure signal strength
;
		abs			;convert to amplitude
        sub     High_En,15      ;add in old low energy filter
		sfr
		sfr
		sfr
		addh	High_En
		sach	High_En
;
; test for valid signal levels
;
        sub     CPE_thr,15      ;High_En > 100 = present
		blez	no_CPE
        lacc    Low_En,1        ;Low_En > 100 = present
        sub     CPE_thr
		blez	no_CPE
		lacc	Low_En,3	;check Low_En*9-High_En*4>0 
		add	Low_En		;(7.0dB Signal difference)
        sub     High_En,2
		blez	no_CPE
		lacc	High_En,3	;check High_En*9-Low_En*4>0 
		add	High_En		;(7.0dB Signal difference)
        sub     Low_En,2
		blez	no_CPE
;
; adapt CPE threshold detection
;
        lacc    Low_En
        sub     CPE_thr,2
        blz     Low_OK
        lac     Low_En,14
        sach    CPE_thr
;
; CPE present
;
Low_OK  lacc    CPE_tim         ;increment CPE frame count
        sub     #255            ;test for CPE valid 256 frames
		blez	CPE_ret
CPE_det lacl    #0
CPE_ret add     #256            ;0<acc<256 CPE present but invalid
        sacl    CPE_tim
        ret                     ;acc=256 CPE present
no_CPE  lacl    #200            ;CPE default threshold
        sacl    CPE_thr
        lacl    #0              ;acc=0 no CPE signal
        sacl    CPE_tim
        ret
*
* Allocate space for CPE detection filters
*
;
; all 6 iir's must be kept in this order in data space
;
iir6_a1 .usect "CIDb0",1
iir6_a2 .usect "CIDb0",1
iir6_b1 .usect "CIDb0",1
iir6_b2 .usect "CIDb0",1
iir6_b3 .usect "CIDb0",1
dummy6	.usect "CIDb0",1	;dummy for macd dmov
iir5_a1 .usect "CIDb0",1
iir5_a2 .usect "CIDb0",1
iir5_b1 .usect "CIDb0",1
iir5_b2 .usect "CIDb0",1
iir5_b3 .usect "CIDb0",1
dummy5	.usect "CIDb0",1	;dummy for macd dmov
iir4_a1 .usect "CIDb0",1
iir4_a2 .usect "CIDb0",1
iir4_b1 .usect "CIDb0",1
iir4_b2 .usect "CIDb0",1
iir4_b3 .usect "CIDb0",1
dummy4	.usect "CIDb0",1	;dummy for macd dmov
iir3_a1 .usect "CIDb0",1
iir3_a2 .usect "CIDb0",1
iir3_b1 .usect "CIDb0",1
iir3_b2 .usect "CIDb0",1
iir3_b3 .usect "CIDb0",1
dummy3	.usect "CIDb0",1	;dummy for macd dmov
iir2_a1 .usect "CIDb0",1
iir2_a2 .usect "CIDb0",1
iir2_b1 .usect "CIDb0",1
iir2_b2 .usect "CIDb0",1
iir2_b3 .usect "CIDb0",1
dummy2	.usect "CIDb0",1	;dummy for macd dmov
iir1_a1 .usect "CIDb0",1
iir1_a2 .usect "CIDb0",1
iir1_b1 .usect "CIDb0",1
iir1_b2 .usect "CIDb0",1
iir1_b3 .usect "CIDb0",1
dummy1	.usect "CIDb0",1	;dummy for macd dmov
Low_En  .usect "CIDb0",1    ;low frequency energy
High_En	.usect "CIDb0",1	;high frequency energy
CPE_thr .usect "CIDb0",1    ;CPE detection threshold
CPE_tim .usect "CIDb0",1    ;CPE active time
CPEstate .usect "CIDb0",1   ;state of CPE
CPE_delay .usect "CIDb0",1   ;delay time in CPE state machine
;
CPEstat		.usect  "CIDb0",1,1

        .sect	"RomData"
*****************************************************************
*								*
*	CPE Alerting Signal Tables Follow			*
*								*
*****************************************************************
*;
*; 6th order IIR filter as bi-quads for detecting CPE alerting signal
*;   signal order is b3,b2,b1,a2,a1
*;
*; Low frequency filter
*;
IIR_LF1 .word   1003,-911,1107,-31343,-4427     ;pass 2.088, stop 1.430
IIR_LF2 .word   2002,0,-2002,-31664,-8530       ;pass 2.169, stop 0.0 & 4.0
IIR_LF3 .word   7950,5389,7950,-29884,-6092     ;pass 2.124, stop 2.440
*;
*; High frequency filter
*;				
IIR_HF1 .word   1094,0,-1094,-31726,-33453/2    ;pass 2.694, stop 0.0 & 4.0
IIR_HF2 .word   1094,0,-1094,-31536,-37867/2    ;pass 2.802, stop 0.0 & 4.0
IIR_HF3 .word   7950,5389,7950,-30514,-34855/2  ;pass 2.743, stop 2.440

