;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;              rfir.asm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       The equalizer fir filter convolution.
;
;       WN      = X0*conj(C0)+...+X9*conj(C9)
;
;  ie	WNR  = X0R*C0R+X0I*C0I +... + X9R*C9R+X9I*C9I
;
;       RFIR    computes WNR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RFIR
	 ZAC
     MPYK    0
     LARP    0
     LRLK    AR0,C0R
     LRLK    AR1,X0R
     CALL    CMULT1
     LRLK    AR0,C0I
     LRLK    AR1,X0I
     CALL    CMULT1		; 1 stack
     APAC
     ADD     ONE,15-2	; rounding
     SACH    WREAL,2
