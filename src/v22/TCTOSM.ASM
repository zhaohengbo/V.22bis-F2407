;
;
;       SUBROUTINE      :       TCTOSM
;       PURPOSE         :       2`s COMPLEMENT TO SIGN/MAGNITUDE
;                               CONVERSION
;
;
;       IDT     'TCTOSM'
;       DEF     TCTOSM
;
;       REF     ONE,TMP0
;
;
;       THE 16-BIT T/C NO. IS IN ACC
;       THE CURRENT AUX REG IS AR0
;
;       PSEG
;
TCTOSM LARP  0
     LARK    AR0,1   ;  ASSUME NO. IS POSITIVE
     BGEZ    CONT    ;  TEST ASSUMPTION
     LARK    AR0,0   ;  FALSE : ADJUST SIGN

CONT ABS
     ADD     ONE,5
     ADD     ONE
     SACL    TMP0    ;  PUT AWAY TEMPORARILY

     SUB     ONE,13  ;  TEST FOR OVERLOAD
     ADD     ONE     ;
     BLZ     OK      ; TEST IF NO. IS LESS THAN MAX

     LAC     ONE,13
     SUB     ONE
     SACL    TMP0    ;  SATURATE NO. TO MAX VALUE

OK   BANZ    POS     ;  TEST IF SIGN BIT NEEDS TO
;			      BE FORCED IN
     LAC     ONE,15  ;  YES : BRING IN THE SIGN
     ADD     TMP0
     SACL    TMP0
POS  RET             ;  S/M NO. IS RETURNED IN TMP0

;       PEND
