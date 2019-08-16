;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                       RTASKS.ASM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;--------------------------------------------------
;                       RTSK12
;--------------------------------------------------
;       Call interpolation subroutine and use the
; generated sample to update the timing function
; Execute the real part of equalizer fir filter.
;
RTSK12
     CALL    INTERP  ; generate interpolated sample; 2 stack
;
; INTERP leaves the real part of the sample in TMP4
; and the imaginary part in TMP5. Form the mag. squarred
; of the sample and and it to TMFUNC
;

     LT      TMP4
     MPY     TMP4    ; TMP4 is S4.11
     PAC
     LT      TMP5
     MPY     TMP5
     APAC            ; Product is S9.22
     SACH    TMP4,1  ; Change to S5.10(S8.7)
     LAC     TMFUNC  ; Add to TMFUNC
     ADD     TMP4
     SACL    TMFUNC

;
; Execute real part of equalizer fir
;
     .copy   "RFIR.ASM"		; 2 stack  
     RET
;
;--------------------------------------------------
;                       RTSK10
;--------------------------------------------------
;       Correct phase of equalizer output
;       yr = wr*jr - wi*ji
;       yi = wr*ji + wi*jr
;   where wr (WREAL) is S4.11 and jr (JREAL)
;   is S.15 => their product is S5.26 =>
;   we need to shift left twice before storing
;   since we would like yr (YREAL) to be S3.12
;
RTSK10
     LT      JREAL
     MPY     WREAL
     PAC
     LT      JIMAG
     MPY     WIMAG
     SPAC
     SACH    YREAL,1
     LAC     YREAL,1
     SACL    YREAL
;
     MPY     WREAL
     PAC
     LT      JREAL
     MPY     WIMAG
     APAC
     SACH    YIMAG,1
     LAC     YIMAG,1
     SACL    YIMAG
;
;Check if 1200 or 2400. If 1200 call QUAN12
;and if 2400 call QUAN24.
;Note that QUAN12 calls QDTER which determines
;in which quaadrant the received point lies, and
;leaves the index of that quadrant in ACC. The
;index is then stored in TMP0, which should not be
;used until after TMP0 is stored in RPQUAD following
;the decoder routines DD12 and DD24.
;
     LACK    03h
     AND     STATUS
     SUB     ONE,1
     BZ      RT101   ; if 0 => 1200 bps
;
;The following lines implemented the 2400 mode
;quantization
;
     LAC     YREAL
     CALL    QUAN24
     SACL    PREAL
;
     LAC     YIMAG
     CALL    QUAN24	 ; 1 stack
     SACL    PIMAG
;
     CALL    QDTER	 ; 1 stack
     SACL    TMP0
     CALL    DD12		; 1 stack
     CALL    DD24		; 1 stack
     B       RT102
;
;Call the 1200 mode quantizer
;
RT101
     CALL    QUAN12		; 2 stack
     CALL    DD12		; 1 stack
     LAC     TMP1,2
     ADD     ONE
     SACL    TMP1
;
;Store the present quadrant index for the
;next baud.
;
RT102
     LAC     TMP0
     SACL    RPQUAD
;
;Output the status word to the controller
;
     LACK    0F0h
     AND     STWRD
     ADD     TMP1
     SACL    STWRD
; new mdm_sta
	 ldpk	 _mdm_sta
;     ORK     #0ff00h
     SACL    _mdm_sta
; test if receive uart is on
     ldpk    UartStatus
     lacc    UartStatus
     andk    #RecOn
     .newblock
     bz      $0
     call    Rec4		; stack 2
$0
     .newblock
	ldpk	#TMP0		; return to page standard
     ret

;--------------------------------------------------
;                       RTSK9
;--------------------------------------------------
;
;       Implement the phase locked loop and phase
; jitter tracker (UPCPH). Call the routine to compute
; the equalizer update error (UPERR)
;       Also determine the gain for the equalizer
; convergence (BETA) and sets it to zero if
; CNVFL = 0 (convergence disabled)
;
RTSK9: .equ  $
     .copy   "PLL.ASM"	 ; 1 stack
;
;Compute the error for equalizer update
;
     CALL    UPERR		 ; 1 stack
;
;Determine if equalizer update is disabled
;
     LAC     ONE,5   ; yw 12mar97
     AND     STAT2
     BZ      RT9E    ; Ret if CNVFL = 0
     LACC    CNVFL   ; YW 29NOV96
     BZ      RT9E    ; Ret if CNVFL = 0
;
;if CNVFL not 0 => determine equalizer BETA
;
     ZALH    BDCNTR  ; Increment baud counter
     ADDH    ONE
     SACH    BDCNTR
;		BV		$+2			; RESET OVERFLOW
; BETA VALUE 16000 IS LIMIT OF STABILITY
     LACC    BDCNTR
	 sfr
	 sfr
	 sfr
; warning "subk n" n<256
     LRLK    AR0,#200 ; BETA VALUE
     SUBK    #2       ; NUMBER OF SAMPLE
     BLZ     RT91
     LRLK    AR0,#4000 ; BETA VALUE
     SUBK    #28
     BLZ     RT91
     LRLK    AR0,#200 ; BETA VALUE
     SUBK    #12
     BLZ     RT91
     LRLK    AR0,#800 ; BETA VALUE
	 subk	 #250
	 blz	 RT91
	 lrlk	 ar0,#400

; STORE BETA
RT91
     SAR     AR0,BETA
RT9E
     RET
;
;--------------------------------------------------
;                       RTSK8
;--------------------------------------------------
;
;       Interpolate the iir output to generate the
; equalizer input .Function INTERP is called also
; in RTSK0 to generate the second sample per baud
; required for T/2 equalization.
;
RTSK8
     CALL    INTERP		; 2 stack
     LAC     TMP4
     SACL    XTMPR
     LAC     TMP5
     SACL    XTMPI

     RET
;
;--------------------------------------------------
;                       RTSK4
;--------------------------------------------------
;       Call interpolation subroutine and use the
; generated sample to update the timing function
; Execute second half of coeff. update
;
;
RTSK4
     CALL    INTERP  ; generate interpolated sample
;
; INTERP leaves the real part of the sample in TMP4
; and the imaginary part in TMP5. Form the mag. squarred
; of the sample and subtract it from TMFUNC
;
     LT      TMP4
     MPY     TMP4    ; TMP4 is S4.11
     PAC
     LT      TMP5
     MPY     TMP5
     APAC            ; Product is S9.22
     SACH    TMP4,1  ; Change to S5.10 (S8.7)
     LAC     TMFUNC  ; Add to TMFUNC
     SUB     TMP4
     SACL    TMFUNC
;
; Execute real part of equalizer fir
;
     CALL    IUPDT2	 ; 2 stack
     RET
;
;--------------------------------------------------
;                       RTSK0
;--------------------------------------------------
; Reset the slewing flag bit of
; register STAT2 (bit 6).
; The task also updates the equalizer delay
; lines with the latest real and imaginary samples
; from  latest INTERP call (RTSK8) and then calls
; INTERP again.
;
; Reset bit 6 of STAT2 so that the adjustment of
; the clock in the slew mode is enabled.
;
RTSK0
     LACK    0BFh
     AND     STAT2
     SACL    STAT2
;
;Update the delay lines
;
     CALL    DLUPDT  ; update delay line
     CALL    INTERP  ; generate second equ. input
     LAC     TMP4
     SACL    XTMPR
     LAC     TMP5
     SACL    XTMPI

     RET
;
;The second equalizer input generated here is stored in
;the delay line in task RSTSK13 of next baud prior to
;the equalizer fir calls.
;-----------------------------------------------------
