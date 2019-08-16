;
; DATE            : 7-14-86
;
; SUBROUTINE      : QUAN24
; PURPOSE         : V22.bis 2400 bps Quantizer
;
; TASK: Given the real (or imaginary) part of the
;       complex received point  Y = YREAL + j YIMAG,
;       quantize the part to the nearest constellation
;       point.
;
; ENTRY CONDITION:
;    1) The value of the real (or imaginary) part
;	must be in the ACC prior to calling this routine			.
;
;    2) The RAM location ONE is assumed to contain
;       the numeral 1.
;
;    3) YREAL and YIMAG are represented in Q12 format.
;
; EXIT CONDITION:
;   The quantized value of the real (or imaginary)
;   part is returned in the ACC.
;
; DESCRIPTION:
;   The routine is entered with YREAL (or YIMAG) in the
;   ACC. The auxiliary register AR1 is used to hold the
;   sign of YREAL (or YIMAG). The magnitude of the part
;   is then quantized by subtractiong 2.0 (in Q12 format)
;   from it. If the result of this subtraction is negative,
;   then the decision is 1.0 (in Q12 format). Otherwise,
;   the decision is 3.0 (in Q12) format. AR1 is then used
;   to force the sign into the decision.
;
; NOTES:   1) This routine must be called twice per baud.
;             The first call quantizes the real part and the second
;             quantizes the imaginary part.
;
;
;       first decide on sign of YREAL
;
QUAN24
	 LARP  1       ; select AR0
     LARK    AR1,0   ; assume YREAL is positive
     BGEZ    LOC1    ; test above assumption
     LARK    AR1,1   ; false assumption : adjust the sign
;
LOC1
	 ABS             ; take magnitude of YREAL (YIMAG)
     SUB     ONE,13  ; subtract 2.0 in Q12 format
     BLZ     DECP1   ; test for magnitude of decision
     ZAC             ; clear-up ACC : magnitude of decision is
;                                       3.0
     BANZ    DECM3   ; test for sign of decision
     ADD     ONE,12  ; decision is +3.0 : first add a 1.0
     ADD     ONE,13  ; and then a 2.0
     RET             ; ACC = 3.0 : return to calling program
;
DECM3
	 SUB    ONE,12  ; decision is -3.0 : first subtract a 1.0
     SUB     ONE,13  ; and then a 2.0
     RET
;
DECP1
	 ZAC            ; magnitude of decision must be 1.0
     BANZ    DECM1   ; test for sign
     ADD     ONE,12  ; decision is +1.0
     RET             ; return to calling program
;
DECM1
	 SUB    ONE,12  ; decision is -1.0
     RET             ; return to calling program
;
;       END OF SUBROUTINE QUAN24
;
