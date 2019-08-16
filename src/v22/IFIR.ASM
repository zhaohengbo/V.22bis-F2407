;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;              ifir.asm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       The equalizer fir filter convolution.
;
;       WN      = X0*conj(C0)+...+X9*conj(C9)
;
;  i.e. WNI = X0I*C0R - X0R*C0I +... + X9I*C9R- X9R*C9I
;
;       IFIR computes WNI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IFIR ZAC
     MPYK    0
     LARP    0
     LRLK    AR0,C0I
     LRLK    AR1,X0R
     CALL    CMULT1
     APAC
     NEG
     MPYK    0
     LRLK    AR0,C0R
     LRLK    AR1,X0I
     CALL    CMULT1
     APAC
     ADD     ONE,15-2
     SACH    WIMAG,2
     RET

CMULT1
     LTA     *+,AR1  ;1
     MPY     *+,AR0
     LTA     *+,AR1  ;2
     MPY     *+,AR0
     LTA     *+,AR1  ;3
     MPY     *+,AR0
     LTA     *+,AR1  ;4
     MPY     *+,AR0
     LTA     *+,AR1  ;5
     MPY     *+,AR0
     LTA     *+,AR1  ;6
     MPY     *+,AR0
     LTA     *+,AR1  ;7
     MPY     *+,AR0
     LTA     *+,AR1  ;8
     MPY     *+,AR0
     LTA     *+,AR1  ;9
     MPY     *+,AR0
     LTA     *+,AR1  ;10
     MPY     *+,AR0
     RET
