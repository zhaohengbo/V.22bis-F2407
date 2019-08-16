;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;               update.asm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       Update the equalizer coefficients.
; It consists of 4 subroutines, rupdt1 rupdt2,
; iupdt1 and iupdt2. rupdt1 updates the real
; part of coeff. c0,c1,...c4 and iupdt1 the imag.
; part of those same coeff. . rupdt2 and iupdt2
; updet the real and imag parts of coeff. c5,...,c9
; The reason for subdividing the coefficient update
; in four parts is the limitations on the number of
; cycles per receiver task to approxiamtely 160 cycles.

RUPDT1
     LRLK    AR0,C0R
     LRLK    AR1,X0R
     SAR     AR1,TMP0
     LRLK    AR1,X0I
     SAR     AR1,TMP1
     LARP    AR1
     CALL    RUPD
     CALL    RUPD
     CALL    RUPD
     CALL    RUPD
     CALL    RUPD
     RET

RUPDT2
     LRLK    AR0,C5R
     LRLK    AR1,X5R
     SAR     AR1,TMP0
     LRLK    AR1,X5I
     SAR     AR1,TMP1
     LARP    AR1
     CALL    RUPD
     CALL    RUPD
     CALL    RUPD
     CALL    RUPD
     CALL    RUPD
     RET

RUPD
     LAR     AR1,TMP0 ; XNR*EREAL -> ACC
     LT      *+
     SAR     AR1,TMP0
     MPY     EREAL
     PAC
     LAR     AR1,TMP1 ; ACC - XNI*EIMAG -> ACC
     LT      *+,AR0
     SAR     AR1,TMP1
     MPY     EIMAG
     SPAC
     ADD     ONE,15-4 ; ROUNDING
     SACH    TMP2,4
     LT      TMP2
     MPY     BETA
     ZALH    *       ; CNR -> ACCH
     SPAC            ; CNR - BETA*RE(XN*EN) -> ACC
     ADD     ONE,15  ; roundoff
     SACH    *+,0,AR1
     RET

IUPDT1
     LRLK    AR0,C0I
     LRLK    AR1,X0R
     SAR     AR1,TMP0
     LRLK    AR1,X0I
     SAR     AR1,TMP1
     LARP    AR1
     CALL    IUPD
     CALL    IUPD
     CALL    IUPD
     CALL    IUPD
     CALL    IUPD
     RET

IUPDT2
     LRLK    AR0,C5I
     LRLK    AR1,X5R
     SAR     AR1,TMP0
     LRLK    AR1,X5I
     SAR     AR1,TMP1
     LARP    AR1
     CALL    IUPD
     CALL    IUPD
     CALL    IUPD
     CALL    IUPD
     CALL    IUPD
;     ZAC
;     SACL    C5I     ; YW
     RET

IUPD
     LAR     AR1,TMP0 ; XNR*EIMAG -> ACC
     LT      *+
     SAR     AR1,TMP0
     MPY     EIMAG
     PAC
     LAR     AR1,TMP1 ; ACC - XNI*EREAL -> ACC
     LT      *+,AR0
     SAR     AR1,TMP1
     MPY     EREAL
     APAC
     ADD     ONE,15-4 ; ROUNDING
     SACH    TMP2,4
     LT      TMP2
     MPY     BETA
     ZALH    *       ; CNI -> ACCH
     SPAC            ; CNI - BETA*IM(XN*EN) -> ACC
     ADD     ONE,15  ; roundoff
     SACH    *+,0,AR1

     RET
