
; V22bis/V22 operation in sample IT
	

	.global Modul, XShape0, XShape1, XShape2
;------------------
;
; modem state
;
;------------------
; put sample in FifoIn
	.if		IsDsk
	in		*+,SDTR,AROut
;
	lac		*
    andk    #0fffch		; mask for AC02
	sacl	*
	out		*+,SDTR
	splk	#CLR_RINT + CLR_XINT,IFR	; block 2nd interrupt

	.else
    lac     SDAD        ; get AD sample
    sacl    *+,AROut
; get sample from FifoOut
    lac     *+           
    sacl    SDDA        ; send sample to DA
	.endif

; manage transmit counter
    lac     FifoOutCnt
    sub     #1
    sacl    FifoOutCnt
    .newblock
    blez    $0          ; enought samples for demodulation

; not enougth samples
; restore
Restore1
    zals    ItPage0+3   ; accl
    addh    ItPage0+2   ; acch

    lst1    ItPage0+1   ; status1
    lst     ItPage0+0   ; status
    eint
    ret
;-----------------
;
; 1 symbole has been transmitted
; transmit is first priority
;
;------------------
$0
; soft timer

    lac     _Tim0
    add     #2				; 2ms corrected to 1 by modulseq
    sacl    _Tim0
;
;------ context save
;
    sar     AROut,P0Tmp1    ; save Pointer FifoOut
    lar     AROut,POsStack
;   mar     *,AROut
    sar     ar0,*+          ; ar0
    sar     ar1,*+          ; ar1
    sar     ar2,*+          ; ar2
    lac     ItPage0+2
    sacl    *+              ; accuh
    lac     ItPage0+3
    sacl    *+              ; accul

    lac     ItPage0+0
    sacl    *+              ; st
    lac     ItPage0+1
    sacl    *+              ; st1

    spm     #0
    sph     *+              ; prh
    spl     *+              ; prl
    mpyk    #1
    spl     *+              ; tr
    popd    *+              ; 0
    popd    *+              ; 1
    popd    *+              ; 2
    popd    *+              ; 3
    popd    *+              ; 4
    popd    *+              ; 5
    popd    *+              ; 6
    popd    *+              ; 7
    sar     AROut,POsStack

    SOVM
    ssxm
	eint

;---------------------
;
;     modulation control
;
;---------------------

    .newblock
	ldpk	#ModulSeq
	bit		ModulSeq,15-15	; test if modulation active
	bbnz	$				; stop if overflow
	lac		ModulSeq
	or		#8000h
	sacl	ModulSeq		; set bit 15 to flag start of modulation
	and		#3				; mask for modulation
	bz		$5				; ModulSeq=0
	lac		ModulSeq
	sub		#1
	sacl	ModulSeq
	ldpk	#P0Tmp1
    lac     P0Tmp1          ; saved pointer on FifoOut
    sub     #FifoOut+14	
	ldp		#ModulSeq
	bit		ModulSeq,15-0
	bbz		$1				; ModulSeq=1 (new=0)
;
; ModulSeq=2
; generate 14 samples
;
; end of FifoOut ?
    bz      $0              ; middle of buffer     
; end of FifoOut
	lac		#FifoOut+1		; previous was 13 samples
	ldp		#P0Tmp1
	sacl	P0Tmp1
	lac		#FifoOut+14
	ldp		#ModemOut
	sacl	ModemOut
	b		WrapSeq2
; restore pointer
$0
	lac		#FifoOut
	ldp		#ModemOut
	sacl	ModemOut
WrapSeq2	
	ldp		#P0Tmp1
	lar		AROut,P0Tmp1

; sample counter
	lac		#13			; previous was 13 samples
	ldpk	#FifoOutCnt
	sacl	FifoOutCnt
	lac		#XShape1
	ldp		#Shape
	sacl	Shape
	lac		#14
	sacl	NbSamp
	call	Modul				; generate 14 samples
	b		DemodTest

;
; ModulSeq=1
; generate 13 samples previous was 14 samples
;
$1
; end of FifoOut ?
    bz      $2              ; middle of buffer     
; end of FifoOut
	lac		#FifoOut		; previous was 14 samples
	ldp		#P0Tmp1
	sacl	P0Tmp1
	lac		#FifoOut+14
	ldp		#ModemOut
	sacl	ModemOut
	b		WrapSeq1
; restore pointer
$2
	lac		#FifoOut+1
	ldp		#ModemOut
	sacl	ModemOut
WrapSeq1
	ldp		#P0Tmp1
	lar		AROut,P0Tmp1
; sample counter
	lac		#14			; previous was 14 samples
	ldpk	#FifoOutCnt
	sacl	FifoOutCnt
	lac		#XShape0
	ldp		#Shape
	sacl	Shape
	lac		#13
	sacl	NbSamp	
	call	Modul				; generate 13 samples
	b		DemodTest

;
; ModulSeq=0
; generate 13 samples previous was 13 samples
;
$5
; new ModulSeq
	lac		ModulSeq
	and		#~3
	add		#2
	sacl	ModulSeq		; new sequence number = 2
; end of FifoOut ?
	ldpk	#P0Tmp1
	lac		_Tim0
	sub		#1
	sacl	_Tim0			; correct Tim0 for 1ms
    lac     P0Tmp1          ; saved pointer on FifoOut
    sub     #FifoOut+14	
    bz      $6              ; middle of buffer     
; end of FifoOut
	lac		#FifoOut+1		; previous was 13 samples
	sacl	P0Tmp1
	lac		#FifoOut+14
	ldp		#ModemOut
	sacl	ModemOut
	b		WrapSeq0
; restore pointer
$6
	lac		#FifoOut+1
	ldp		#ModemOut
	sacl	ModemOut
WrapSeq0
	ldp		#P0Tmp1
	lar		AROut,P0Tmp1
; sample counter
	lac		#13			; previous was 13 samples
	ldpk	#FifoOutCnt
	sacl	FifoOutCnt
	lac		#XShape2
	ldp		#Shape
	sacl	Shape
	lac		#13
	sacl	NbSamp
	call	Modul				; generate 13 samples

;
;-----------------------------------
;
; ----- test for demodulation
;
;-----------------------------------
;
DemodTest
; reset modulation flag
	ldp		#ModulSeq
	lac		ModulSeq
	and		#7fffh
	sacl	ModulSeq
; -------debug
    .if     TMips
    lac     #400
CpuLoad
    sub     #1              ; test of CPU loading
    bnz     CpuLoad			; loop is 4 cycles for C25
    .endif
; ------- end of debug

; check if enought sample
    ldpk    #ETmp1
    sar     ARIn,ETmp1
    lac     ETmp1
    sub     #FifoIn+NB_COEFF+14
    blz     Restore0        ; not enougth sample

; enougth sample for demodulation
; check if demodulation still active

    ldpk    #ModemStat
    bit     ModemStat,15-BitDemod
    bbnz    Restore0        ; demodulation already active
;
;---- activate demodulation
;
    dint
    lac     ModemStat
    or      #1<<BitDemod
    sacl    ModemStat
    eint

    call    DemodSymb		; demodulate one or more symbole
;
; desactivate demodulation
    ldpk    #ModemStat

    dint
    lac     ModemStat
    and     #~(1<<BitDemod)
    sacl    ModemStat
;   eint

;-----------------------
;
; ----- restore context
;
;-----------------------
Restore0
    dint
    ldpk    #P0Tmp1
    sar     AROut,P0Tmp1   ; save buffer pointer
    lar     AROut,POsStack ; get OsStack Pointer
    mar     *,AROut
    mar     *-
; move st1 and st to page 0
    pshd    *-          ; 7
    pshd    *-          ; 6
    pshd    *-          ; 5
    pshd    *-          ; 4
    pshd    *-          ; 3
    pshd    *-          ; 2
    pshd    *-          ; 1
    pshd    *-          ; 0
    mar     *-
    lt      *+
    mpyk    #1          ; prl
    lt      *-          ; tr
    mar     *-
    lph     *-          ; prh
    lac     *-
    sacl    ItPage0+1   ; st1
    lac     *-
    sacl    ItPage0+0   ; st
    zals    *-          ; accul
    addh    *-          ; accuh
    lar     ar2,*-      ; ar2
    lar     ar1,*-      ; ar1
    lar     ar0,*       ; ar0
    sar     AROut,POsStack ; new OsStack Pointer
    lar     AROut,P0Tmp1    ; restore buffer pointer

    lst1    ItPage0+1   ; st1
    lst     ItPage0+0   ; st

    eint
    ret

