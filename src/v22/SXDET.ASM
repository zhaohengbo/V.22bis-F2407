;
;       DATE            :       6-25-87
;
;       SUBROUTINE      :       SXDET
;       PURPOSE         :       S0/(1/2)S1 PATTERN  DETECTOR
;
;
;       DESCRIPTION     :
;
;       S0 DETECTION ALGORITHM :
;
;       THE IN-PHASE SYMBOL x(m) AT THE BAUD RATE IS FILTERED VIA :
;
;       H(z) = GAINSX [ (1 - z^-2 ) / (1 - COFSX z^-2) ]
;
;
;       WHERE   GAINS0 = 0.056967 = 233
;       AND     COFS0  = -0.903412 = -3700
;
;
;       THE FILTER HAS A NARROW-BAND CHARACTER FOR S0 AND A
;       BANDSTOP CHARACTER FOR S1.
;
;       THE SHORT-TERM ENERGY OF THE FILTERED SIGNAL y(m) IS ACCUMULATED VIA ;
;
;       sigmay(m) = (1-betax)*sigmay(m-1) + betax*y(m)^2
;
;       THIS ENERGY IS THEN COMPARED TO A THRESHOLD VALUE AND, IF IT
;       EXCEEDS THE THRESHOLD, THE SX PATTERN HAS BEEN DETECTED.
;
;       S1 DETECTION ALGORITHM :
;
;       THE S1 DETECTOR IS CALLED TWICE PERT BAUD AND HENCE RUNS
;       AT 1200 HZ. THE IN-PHASE AND QUADRATURE COMPONENTS ARE
;       FILTERED OUT VIA A NARROW-BAND LOWPASS FILTER. THIS IS
;       A SINGLE BI-QUAD WITH COEFFICIENTS :
;
;               Numerator :             b0 = 0.026535
;                                       b1 = -0.049547
;                                       b2 = 0.026535
;
;               Denominator :           a1 = 1.930664
;                                       a2 = -0.934387
;       THE ENERGY OF THE COMPLEX SIGNAL IS ACCUMULATED AS WITH
;       THE S0 DETECTOR AND COMPARED TO THE THRESHOLD. THE S1
;       DETECTION FLAG IS THEN SET UPON EXCEEDING THE THRESHOLD
;       20 CONSECUTIVE TIMES.
;
;
;       REVISION INFO   :       MODIFIED TO AVERAGE THE INPUT
;                               SIGNAL TO THE FILTERS.
;
;
;
SXDET
     LARP    AR0
;
;       -------------------
;       S0 PATTERN DETECTOR
;       -------------------
;
;       FILTER THE IN-PHASE COMPONENT FOR 150 HZ
;       (LOOK FOR THE 150 HZ COMPONENT OF S0)
;
;
     LAC     X0R     ; SHIFT OF 12 REQUIRED FOR
			         ; ENSUING DECIMAL POINT ADJUSTMENT
			         ; X0R IN S4.11
     ADD     X0R+1   ; FORM x(m)+x(m-1/2)
			         ; (AVERAGE INPUT SAMPLES TO THE FILTER)
     SUB     X0R+4   ; FORM x(m) - x(m-2)
     SUB     X0R+5   ; (AVERAGE INPUT SAMPLES TO THE FILTER)
     SACL    TMP0    ; PUT AWAY TEMPORARILY

     LT      TMP0    ; TMP0 IS IN Q11
     MPYK    GAINS0  ; GAINS0 = 0.056967 = 233 IN Q12
     PAC

     LT      Y0DEL2  ; T = y(k-2)
     MPYK    COFS0   ; COFS0 = -0.903412 = -3700 IN Q12
     APAC            ; COMPUTE FILTER OUTPUT

     LAR     AR1,Y0DEL1 ;
     SAR     AR1,Y0DEL2 ; Y0DEL2 <-- Y0DEL1
;
     SACH    Y0DEL1,4 ; STORE YODEL1 IN Q11
;
;       COMPUTE SHORT-TIME ENERGY SIGS0
;
     LT      Y0DEL1  ;
     MPY     Y0DEL1  ;
     PAC             ;  P IS IN (10,22)
     SUB     SIGS0,12 ; ADD SIGS0 WITH SHIFT OF 12
     SACH    TMP0,4  ; STORE TEMPORARILY IN (6,10)
     LT      TMP0    ; TMP0 IS IN   (6,10)
     MPYK    BETAS0  ; BETAS0 IS IN (4,12)
     PAC             ; P IS IN	  (10,22)
     ADD     SIGS0,12 ;
     SACH    SIGS0,4 ; STORE SIGS0 IN (6,10)
;
;       COMPARE THE ENERGY ESTIMATE TO THE DETECTION THRESHOLD
;

     LAC     SIGS0
     SUB     #LEVEL0	; compare to threshold
     BLZ     NOS0

     LACK    1<<BitSt4
     OR      STWRD   ; SET THE S0 DETECTION FLAG
     SACL    STWRD
     B       SXDET2  ; CONTINUE WITH S1 DETECTION
;
NOS0
     LACK    ~(1<<BitSt4)   ; RESET THE S0 DETECT BIT
     AND     STWRD
     SACL    STWRD
;
;       -------------------------------
;       PERFORM 1/2 OF THE S1 DETECTION
;       -------------------------------
;
SXDET2
     ZAC
     SACL    TMP0    ; CLEAR UP TMP0
;
     LRLK    AR0,X0R+1 ; AR0:-> x(k-1)
     LRLK    AR1,YRLP2 ; AR1:-> y(k-2)
     CALL    S1FILT  ; S1 FILTER

     LRLK    AR0,X0I+1 ; AR0:-> x(k-1)
     LRLK    AR1,YILP2 ; AR1:-> y(k-2)
     CALL    S1FILT  ; S1 FILTER

     CALL    UPENER  ; UPDATE SHORT-TERM S1
;			       ENERGY
     RET
;
;       -------------------
;       S1 PATTERN DETECTOR
;       -------------------
;
;
;       IMPLEMENT THE LOWPASS FILTER
;
;
;       FIRST IMPLEMENT THE NUMERATOR
;       REMEMBER CURRENT AUX REG IS AR0:-> x(k-1) for 1st call
;                                      :-> x(k)   for 2nd call
;
;
S1FILT
     ZAC             ; CLEAR ACCUMULATOR
     LT      *+      ;
     MPYK    B0LP    ; B0LP=0.026535=54  IN Q11
     LTA     *+      ;
     MPYK    B1LP    ; B1LP=-0.049547=-101 IN Q11
     LTA     *,AR1   ;
     MPYK    B2LP    ; B2LP=0.026535=54  IN Q11
;
;       NOW DO THE DENOMINATOR
;
     LTA     *-      ; COMPUTE A2LP*y(k-2)
;			         ; AR0 = AR0-1 :-> y(k-1)
     MPYK    A2LP    ; A2LP=-0.934387=-1914 IN Q11
     DMOV    *       ; y(k-2) <-- y(k-1)
;
     LTA     *
     MPYK    A1LP    ; A1LP=1.930664=3954 IN Q11
     APAC
;
     SACH    *,4
     LAC     *,1     ; ADDITIONAL SHIFT REQUIRED TO
     SACL    *       ; STORE y(k-1) IN Q11
;
;       COMPUTE THE ENERGY THE THE LOWPASS FILTERD COMPONENT
;       AND ACCUMULATE THIS IN TMP0
;

     ZALH    TMP0    ; BRING IN TMP0  IN S9.22
     LT      *       ; COMPUTE y(k-1)^2
     MPY     *
     APAC
     SACH    TMP0    ; STORE ACC ENERGY  IN S9.6
     LARP    AR0     ; REMEMBER TO SELECT AR0 AS AUX REG
     RET

;
;
;       -------------------------------------------
;       UPDATE THE SHORT-TIME ENERGY ESTIMATE OF
;       THE FILTERED SIGNAL SIGMAY FOR S1 DETECTION
;       -------------------------------------------
;
;
UPENER
     LAC     TMP0    ; TMP0 in S9.6
     SUB     SIGS1   ; ACC= TMP0-SIGS1
     SACL    TMP0
     LT      TMP0
     MPYK    BETAS1  ; BETAS1 in 4S.12
     PAC             ;	ACC = BETAS1 [TMP0-SIGS1]
     ADD     SIGS1,12 ; bring SIGS1 in 5S9.18
     SACH    SIGS1,4 ; STORE SIGS1 IN S9.6
     RET
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     THIS TASK IMPLEMENTS THE REST OF THE S1             ;;;
;;;     DETECTION ALGORITHM                                 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
S1DET
     ZAC
     SACL    TMP0    ; CLEAR-UP TMP0
;
     LARP    0
     LRLK    AR0,X0R ; AR0:-> x(k)
     LRLK    AR1,YRLP2 ; AR0:-> y(k-2)
     CALL    S1FILT
     LRLK    AR0,X0I ; AR0:-> x(k)
     LRLK    AR1,YILP2 ; AR1:-> y(k-2)
     CALL    S1FILT
     CALL    UPENER  ; UPDATE SHORT-TERM S1
;			       ENERGY
;
     LAC     SIGS1

; ------- debug
; reccord
   .if     TRACE
;   out     STWRD,ADBP
   .endif
; ------- end debug

     SUB     #LEVEL1	; compare to threshold
     BLZ     NOS1
;
     LAC     S1CNT   ; increment S1 detection flag
     ADD     ONE
     SACL    S1CNT
;
     LACK    0Ah     ; enable timing recovery after
     SUB     S1CNT   ; 21 bauds.
     BGZ     NOCNT
;
     LACK    025h    ; compare to the value of counter
     SUB     S1CNT   ; for communicating to the controller
     BGZ     NOCNT   ; check if COUNTER S1 indications
;
     LACK    (1<<BitSt5)
     OR      STWRD   ; SET THE S1 DETECTION FLAG
     SACL    STWRD   ; to the controller

     LALK    0ffdfh  ; yw 24avr97
     AND     STAT2
     SACL    STAT2
;
NOCNT
     RET

NOS1
     LACK    ~(1<<BitSt5)  ; RESET THE S1 DETECT BIT
     AND     STWRD
     SACL    STWRD
;
     ZAC             ; clear the S1 hysterisis counter
     SACL    S1CNT
     RET
