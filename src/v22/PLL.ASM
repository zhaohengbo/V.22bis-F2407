;
;       THIS VERSION OF UPCPH INCLUDES
;       THE JITTER TRACKING SUBROUTINE
;
;       DATE            :       7-30-86
;
;       SUBROUTINE      :       UPCPH
;       PURPOSE         :       UPdate Carrier PHase
;
;       TASK            :       SEE DESCRIPTION BELOW.
;
;       ENTRY CONDITION :       THE CURRENT BAUD QUANTIZED
;                               COMPLEX SYMBOL P(m) IS IN
;                               RAM LOCATIONS PREAL AND
;                               PIMAG. THE UNQUANTIZED COMPLEX
;                               SYMBOL Y(m) IS IN RAM LOCATIONS
;                               YREAL AND YIMAG.
;
;       EXIT CONDITION  :       THE COMPLEX CARRIER PHASE
;                               CORRECTION FACTOR J(m) IS
;                               RETURNED IN RAM LOCATIONS
;                               JREAL AND JIMAG.
;
;       ROUTINES USED   :
;
;       NAME            FUNCTION                                OUTPUT
;
;
;       PHDET   :       PHASE DETECTOR                          PHERR
;       PFCOR   :       PHASE/FREQUENCY OFFSET CORRECTOR        PHFREQ
;       JITCOR  :       JITTER TRACKER                          PHJITT
;       COSGEN  :       COSINE GENERATOR                        TMP0
;       SINGEN  :       SINE GENERATOR                          TMP3
;
;
;       DESCRIPTION     :       THE IMPLEMENATION ADDS THE PARAMETERS
;                               PHFREQ AND PHJITT TO UPDATE THE
;               CARRIER PHASE CORRECTION FACTOR. THIS IS THEN USED
;               TO GENERATE THE COMPLEX EXPONENTIAL VIA LOOK-UP.
;               THE REAL AND IMAGINARY PART ARE RETURNED IN LOCATIONS
;               JREAL AND JIMAG RESPECTIVELY.
;
;
UPCPH
     LAC     CNVFL
     BZ      YW27    ; no need of PLL
     ROVM            ;  IN CASE OF OVERFLOW, JUST
;			         GO AROUND THE 2'S COMPLEMENT CIRCLE
;
     CALL    PHDET   ; GENERATE PHASE ERROR APPROXIMATION; stack 1
;			    PHERR IS RETURNED IN PHERR
;
;     CALL    PFCOR   ; COMPUTE THE FIXED PHASE AND THE
;			    FREQUENCY OFFSET CORRECTION TERM
;			    (RETURNED IN PHFREQ)
;
;
;     CALL    JITCOR  ; UPDATE  THE JITTER CORRECTION
     SOVM
;			    TERM PHJITT
     ZAC             ; YW 25nov suppression of jitter correction
; 	LAC	    TMP1,1	  ; JITCOR RETURNS PHJITT  YW 25nov
;			    IN TMP1 IN (2,14)
     ADD     PHFREQ
     SACL    TMP1    ;  PUT AWY TEMPORARILY

     ZALS    TMP1    ; PREPARE FOR SINE LOOK-UP
     CALL    SINGEN  ; GENERATE SINE
     LAC     TMP3    ;
     SACL    JIMAG   ; STORE IN JIMAG

     ZALH    TMP1    ; PREPARE FOR COSINE LOOK-UP
     CALL    COSGEN  ; GENERATE COS
     LAC     TMP0    ;
     SACL    JREAL   ; STORE IN JREAL
YW27
;
