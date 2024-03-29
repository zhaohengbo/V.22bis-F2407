;
;
;       SUBROUTINE      :       PHDET
;       PURPOSE         :       PHASE DIFFERENCE COMPUTATION
;
;       TASK    :       GIVEN THE RECEIVED UNQUANTIZED COMPLEX POINT
;                       Y = YREAL + j YIMAG, AND THE QUANTIZED POINT
;                       P = PREAL + j PIMAG, COMPUTE THE PHASE
;                       DIFFERENCE BETWEEN THE TWO POINTS.
;
;       ENTRY CONDITION :       AS DESCRIBED IN TASK ABOVE.
;
;       EXIT CONDITION  :       RAM LOCATION PHERR CONTAINS THE
;                               NORMALIZED PHASE ERROR IN Q15
;                               FORMAT.
;
;
;       DESCRIPTION     :       THE PHASE ERROR IS COMPUTED AS;
;
;               PHERR = PHNORMALIZER * Im [ conj(Y(m)) P(m) ]
;
;       WHERE   PHNORMALIZER = 1 / (PI* |P(m)|^2).
;
;       THE PHASE NORMALIZATION IS DONE IN TWO STEPS. FIRST, THE
;       NUMERIC VALUE OF 1/|P(m)^2| IS LOOKED UP FROM A TABLE AND
;       MULTIPLIED BY Im [conj(Y(m) P(m)]. THEN THE NUMERIC VALUE
;       OF 1/PI IS MULTIPLIED TO YIELD THE FINAL RESULT. THE ADVANTAGE
;       OF THIS TWO-STEP PROCESS IS ENHANCED PRECISION.  THE COMPUTED
;       VALUE OF PHERR IS IN Q15, WITH PHERR=1.0 CORRESPONDING TO PI.
;       THIS WILL SIMPLIFY SUBSEQUENT CARRIER RECOVERY/JITTER TRACKING
;       CALCULATIONS AND EASE THE LOOK UP INTO THE FINAL SIN/COS
;       TABLE.
;
;
;       NOTE    :       THE NOTATION (x,y) IS USED TO DENOTE A
;                       NUMBER WITH x INTEGER AND y FRACTIONAL BITS.
;                       THIS IS USEFUL IN TRACKING DECIMAL POINT
;                       ADJUSTMENTS DURING COMPUTATION.
;
;
;       REVISION INFO   :       REVISED 7-28-86 TO REMOVE
;                               IDT/REF/DEF DIRECTIVES
;                               REVISED 7-30-86 TO MAKE MORE
;                               EFFICIENT RAM USAGE.
;                               REVISED 7-30-86 TO IMPROVE
;                               PRECISION IN CALCULATION OF PHERR.
;
;
;
;       FIRST COMPUTE   YREAL * PIMAG - YIMAG * PREAL
;       AND STORE TEMPORARILY IN PHERR
;
PHDET
     ZAC             ;; CLEAR UP THE ACC
;
     LT      YREAL   ; T = YREAL	    (4,12)
     MPY     PIMAG   ; P = YREAL*PIMAG (8,24)

     LTA     YIMAG   ; T = YIMAG	    (4,12)
;			    ACC = YREAL*PIMAG (8,24)
     MPY     PREAL   ;P = YIMAG*PREAL   (8,24)
     SPAC            ;;;	    ACC = ACC - YIMAG*PREAL (8,24)

     SACH    PHERR,4 ; PHERR = IM [ conj(Y(m) P(m) ]
;			  ; PHERR IS IN (4,12) FORMAT
;
;       LOOK UP 1/|P(m)^2| FORM A TABLE WITH START ADDRESS
;       PHNTAB. THE LOOK-UP ADDRESS IS FORMED BY ADDING THE ABSOLUTE
;       VALUES OF PREAL AND PIMAG, AND THEN ADDING THE OFFSET PHNTAB-1.
;
     LAC     PREAL,2 ; BRING IN PREAL
     ABS             ;;;	  ; FOR ABS OPEARTION
     SACL    TMP0    ; STORE TEMPORARILY
     LAC     PIMAG,2 ; BRING IN PIMAG
     ABS             ;;;	  ; FOR ABS OPERATION
     ADDS    TMP0    ; FORM |PREAL| + |PIMAG| IN ACC
     SACH    TMP0,1  ; EXTRACT TWO MSB'S OF
;			  ;  |PREAL| + |PIMAG|
     LALK    PHNTAB-1 ; BRING IN TABLE OFFSET MINUS 1
     ADD     TMP0    ; FORM THE FINAL ADDRESS
     TBLR    TMP0    ; NORMALIZING  TABLE
;			    AND READ INTO PHNORM (1,15)
;
;
;       NOW COMPUTE Im [conj(Y(m)) P(m) ] / |P(m)|^2
;
;
     LT      PHERR   ; PREPARE FOR MULTIPLICATION
     MPY     TMP0    ; P = PHNORM * PHERR (8,24)
;
     PAC             ;; TRANSFER TO ACC
     SACH    PHERR,4 ; STORE IN Q12 (4,12)
;
     LT      PHERR   ; PREPARE FOR NORMALIZING BY PI
     MPYK    INVPI   ; INVPI=1304 IS IN (4,12) FORMAT
;			    HENCE P IS IN (5,27)
     PAC             ;; TRANSFER TO ACC
     SACH    PHERR,4 ; STORE PHERR IN (1,15)
;     RET             ;; RETURN TO CALLING PROGRAM
;
;
;       END OF PHDET SUBROUTINE
;
;	SUBROUTINE	:  PFCOR
;	PURPOSE 	:  PHASE & FREQUENCY OFFSET CORRECTION
;
;       TASK    :       GIVEN THE PHASE ERROR FOR THE CURRENT
;                       BAUD IN RAM LOCATION PHERR (COMPUTED
;                       BY SUBROUTINE PHDET), CALCULATE THE
;                       PHASE AND FREQUENCY OFFSET CORRECTION
;                       FACTOR PHFREQ.
;
;       ENTRY CONDITION :       CURRENT BAUD PHASE ERROR IS IN
;                               RAM LOCATION PHERR.
;
;       EXIT CONDITION  :       THE PHASE/FREQUENCY OFFSET CORRECTION
;                               FACTOR IS RETURNED IN PHFREQ.
;
;
;       DESCRIPTION     :       THE PARAMETER PHFREQ IS UPDATED
;                               VIA ;
;
;               FROFF(m) = FROFF(m-1) + G2 : PHERR(m)
;       AND
;               PHFREQ(m) = PHFREQ(m-1) + FROFF(m) + G1 * PHERR(m)
;
;       WHERE FREQOFF(m) REPRESENTS THE FRQUENCY OFFSET CORRECTION FACTOR,
;       AND G1*PHERR(m) REPRESENTS THE FIXED CAHNNEL PHASE SHIFT
;       CORRECTION FACTOR.
;
;
;
;
;       FIRST UPDATE THE FREQUENCY OFFSET PARAMETER FREQOFF
;
PFCOR
     LAC     FROFF,12 ;  LOAD FROFF FOR ENSUING ACCUMULATION
;			      LEFT SHIFT OF 12 IS NEEDED FOR
;			     DECIMAL POINT ADJUSTMENT
;
     LT      PHERR   ; PREPARE FOR MULTIPLICATION
     MPYK    G2      ; P = G2 * PHERR(m)	     (5,27)
;
     LTA     PHERR   ; T = PHERR(m)
;			     ACC = FROFF(m) IN (5,27)
;
     SACH    FROFF,4 ; STORE UPDATED FROFF IN (1,15)
;
;
;       AT THIS POINT ACC CONTAINS THE UPDATED FREQUENCY OFFSET
;       CORRECTION PARAMETER FROFF(m). THIS CAN BE USED TO
;       UPDATE THE COMBINED PHASE/FREQUNCY CORRECTION TERM PHFREQ(m)
;
;
     MPYK    G1      ; P = G1*PHERR(m) IN (5,27)
     APAC            ;; ACC = FREQOFF(m) + G1*PHERR(m)
     ADD     PHFREQ,12 ; ADD IN PHFREQ(m-1) WITH DECIMAL
;			     POINT ADJUSTMENT
     SACH    PHFREQ,4 ; STORE PHFREQ(m) IN Q15 FORMAT
; verification of no divergence
; FROFF = 2346 for 7Hz frequency shift (2*Pi*7*32000/600)
MaxF .equ    3000
     LAC     FROFF
     SUBK    #MaxF
     BLZ     YW10
     LACC    #MaxF
     SACL    FROFF
     B       YW12
YW10
     ADDK    #2*MaxF
     BGZ     YW12
     LACC    #-MaxF
     SACL    FROFF

;
YW12
;     RET
;
;       END OF SUBROUTINE PFCOR
;
;
;	SUBROUTINE	:   JITCOR
;	PURPOSE 	:   JITTER CORRECTION
;
;       TASK    :       GIVEN THE PHASE ERROR ESTIMATE PHERR,
;                       COMPUTE THE JITTER CORRECTION TERM PHJITT.
;
;	ENTRY CONDITION :   UPDATED PHASE ERROR IS IN RAM
;			    LOCATION PHERR.
;
;	EXIT CONDITION	:   THE UPDATED JITTER CORRECTION TERM
;			    IS IN RAM LOCATION PHJITT
;
;	DESCRIPTION	:   THE PHASE ERROR PHERR IS FILTERED
;			    OUT VIA;
;
;               XXJ0 = G3*PHERR + BJ1*XXJ1 + BJ2*XXJ2
;               PHJITT = XXJ0 + AJ1*XXJ1
;       WHERE;
;               G3  = 0.0396 = 81 IN Q11
;               BJ1 = -1.625273 = -3329	   60 Hertz
;               BJ2 = 0.992113 = 2032
;               AJ1 = -0.800845 = -1640
;
;       AND XXJ0-2 REPREESENT FILTER STATE VARIABLES.
;
;
;	REVISION INFO	:   - MODIFIED 9-12-86 TO
;			      USE TMP0 FOR PHJITT
;			      AND TMP1 FOR XXJ0.
;			      THIS MAKES RAM USAGE MORE EFFICIENT.
;			    - MODIFIED 9-12-86 TO
;			      ELIMINATE USE OF POINTERS
;			      FOR FILTER IMPLEMENTATION.
;			      THIS SAVES CODE
;
;       FIRST COMPUTE XXJ0 AS OUTLINED IN DESCRIPTION ABOVE
;
JITCOR
	 ZAC           ;; CLEAR UP ACC
;
     LT      PHERR   ; PHERR IS IN (1,15)
     MPYK    G3      ;FORM G3*PHERR IN (6,26)
;			  ; G3 = 81 IN (5,11)

     LTA     XXJ2    ; T = RAM[AR0] = XXJ2
;			  ; ACC = G3*PHERR IN (6,26)
;
     MPYK    BJ2     ; P = BJ2*XXJ2 IN (6,26)
;			  ; BJ2 =2032  IN (5,11)
;
     LTA     XXJ1    ; T = XXJ1 IN (1,15)
;			  ; ACC = ACC + BJ2*XXJ2 IN (6,26)
;
     MPYK    BJ1     ; P = BJ1*XXJ1
;			  ; BJ1 =-3329 IN (5,11)
;
     APAC            ;; ACC = ACC + BJ1*XXJ1 IN (6,26)
;
     SACH    TMP0,4  ; STORE IN XXJ0 IN (1,15) FORMAT
;			  ;  STORAGE
;
;       ACC CONTAINS XXJ0 IN (6,26) FORMAT
;       COMPUTE AJ1*XXJ1 AND ADD TO ACC TO FORM PHJITT
;
     LT      XXJ1    ; T = RAM[AR0] = XXJ1 IN (1,15)
     MPYK    AJ1     ; P = AJ1*XXJ1 IN (6,26)
;			  ; AJ1 = -1640 IN Q11
;
     APAC
     SACH    TMP1,4  ; STORE PHJITT IN (2,14) FORMAT
;
;
;       NOW IMPLEMENT THE TIME-SHIFTS
;
     DMOV    XXJ1    ; RAM[AR0+1] = RAM [AR0]
;			  ; HENCE XXJ2 = XXJ1
;
     LAC     TMP0,1  ; ACC = XXJ0
     SACL    XXJ1    ; XXJ1 = XXJ0
     RET
;
;       END OF SUBROUTINE JITCOR
;
