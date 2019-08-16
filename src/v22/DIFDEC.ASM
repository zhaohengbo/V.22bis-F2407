;
;
; DATE            : 7-14-86
;
; SUBROUTINE      : QDETER
; PURPOSE         : QUADRANT DETERMINATION
;
; TASK            : Given two RAM locations PREAL and PREAL,
;                   determine which quadrant the complex point
;                   P = PREAL + j PIMAG belongs to.  The routine
;                   has applications to 2400 bps and 1200 bps differential
;                   decoding.
;
; ENTRY CONDITION : RAM locations PREAL and PIMAG must hold the real
;                   and imaginary parts of the complex point respectively.
;
; EXIT CONDITION  : The quadrant no. (0,1,2 or 3) is returned in the
;                   accumulator.
;
; DESCRIPTION     : A simple minded algorithm is followed ;
;                     If PREAL >= 0 & PIMAG >= 0 then ACC = 0,
;                     If PREAL <  0 & PIMAG >= 0 then ACC = 1,
;                     If PREAL <  0 & PIMAG <  0 then ACC = 2,
;                     If PREAL >= 0 & PIMAG <  0 then ACC = 3,
;
;
;
QDTER
     LAC     PREAL,0 ; read in RTEMP for sign test
     BLZ     Q1OR2   ; if PREAL < 0 then quad = 1 or quad = 2

     LAC     PIMAG,0 ; else tset sign of PIMAG
     BLZ     Q3      ; if PIMAG < 0 then quad = 3
     LACK    0       ; PREAL >= 0 & PIMAG >= 0 HENCE QUAD = 0
     RET             ; return to calling program

Q3   LACK    3       ; PREAL >= 0 & PIMAG < 0 hence quad = 3
     RET             ; return to calling program

Q1OR2
	 LAC    PIMAG,0 ; read in PIMAG for sign test
     BLZ     Q2      ; if PIMAG < 0 then quad = 2
     LACK    1       ; else quad = 1
     RET             ; return to calling program

Q2
	 LACK    2       ; PREAL < 0 & PIMAG < 0 hence quad = 2
     RET             ; retun to calling program
;
;       END OF SUBROUTINE QDTER
;
;
;
;
; SUBROUTINE      : DD12
; PURPOSE         : 1200 BPS DIFFERENTIAL DECODER
;
; TASK            : GIVEN TWO RAM LOCATIONS:
;
;                   CQUAD =  QUADRANT OCCUPIED BY THE RECEIVED
;                            QUANTIZED COMPLEX POINT DURING THE
;                            CURRENT SYMBOL INTERVAL (BAUD), AND
;
;                   PQUAD =  QUADRANT OCCUPIED BY THE RECEIVED
;                            QUANTIZED COMPLEX POINT DURING THE
;                            PREVIOUS SYMBOL INTERVAL (BAUD)
;
;                   DETERMINE THE RECEIVED DIBITS AND STORE IN THE
;                   RAM LOCATIONS OUTBITS.
;
; ENTRY CONDITION : AS DESCRIBED IN TASK ABOVE.
;
; EXIT CONDITION  : THE RECEIVED DIBITS ARE IN RAM LOCATION OUTBITS
;
; DESCRIPTION     : LET QUADCHANGE = CQUAD - PQUAD
;                   CASE OF QUADCHANGE :
;
;                   3       :       OUTBIT = 11     (270 DEG.)
;                   2       :       OUTBIT = 10     (180 DEG.)
;                   1       :       OUTBIT = 00     ( 90 DEG.)
;                   0       :       OUTBIT = 01     (  0 DEG.)
;          -1       :       OUTBIT = 11     (270 DEG.)
;          -2       :       OUTBIT = 10     (180 DEG.)
;          -3       :       OUTBIT = 00     ( 90 DEG.)
;
;         NOTE THAT QUADCHANGE VALUE SETS {3,-1},{2,-2}
;         AND {1,-3} RESULT IN THE SAME OUTBITS. THE
;         SECOND ELEMENT OF EACH SET CAN BE TURNED EQUAL TO THE
;         FIRST ELEMENT BY SIMPLY ADDING 4 TO IT. IN THIS
;         WAY BOTH POSITIVE AND NEGATIVE VALUES OF QUADCHANGE
;         CAN BE MADE TO MAP TO THE SAME OUTBITS. ONCE THIS IS
;         DONE, WE DEAL ONLY WITH POSITIVE VALUES OF QUADCHANGE.
;         NOTE THAT IF THIS POSITIVE VALUE IS GREATER THAN 2,
;         THEN OUTBITS SIMPLY EQUAL THE VALUE OF QUADCHANGE.
;         FOR QUADCHANGE VALUES LESS THAN 2, WE CAN FIRST
;         SUBTRACT 1 AND THEN TAKE ABSOLUTE VALUE OF THE RESULT.
;         THIS WILL YIELD THE OUTBITS FOR QUADCHANGE VALUES LESS
;         THAN 2.
;
;
;
; REVISION INFO   : MODIFIED 8-8-86 SO THAT THE VARIABLE CQUAD
;                   IS NOW HELD IN TEMPORARY LOCATION TMP0.
;                   SIMILARLY , THE OUTPUT BITS ARE HELD
;                   IN TMP1.
;                   MODIFIED 8-8-86 TO REPLACE PQUAD WITH RPQUAD.
;
;
;       FIRST COMPUTE QUADCHANGE AND DETERMINE IF 4 HAS TO BE ADDED
;
;           QUADCHANGE = CQUAD - PQUAD
;           IF QUADCHANGE < 0 THEN QUADCHANGE = QUADCHANGE + 4
;
;
DD12
     LAC     TMP0    ; LOAD CURRENT QUADRANT NO.
     SUB     RPQUAD  ; FORM QUADCHANGE IN ACC
     BGEZ    NADJST  ; DETERMINE IF 4 HAS TO BE ADDED
     ADD     ONE,2   ;YES : SO ADD 4
;
;       IF QUADCHANGE >= 2 THEN  OUTBIT = QUADCHANGE
;       ELSE                     OUTBIT = |QUADCHANGE-1|
;
;
NADJST
     SUB   ONE,1   ; DETERMINE IF QUADCHANGE >= 2
     BLZ     QCLT2   ; IF SO BRANCH TO APPROPRIATE LOCATION
     ADD     ONE,1   ; RESTORE OUTBITS VALUE IN ACC BY ADDING 2
     SACL    TMP1    ; STORE AWAY IN RAM LOCATION OUTBITS
     RET
;
;       NOTE THAT ACC NOW CONTAINS QUADCHANGE - 2 , SO WE CAN ADD 1
;       TO ACC AND THE TAKE ABSOLUTE VALUE
;
;
QCLT2
	 ADD    ONE     ; AT THIS POINT ACC = QUADCHANGE - 1
     ABS             ; NOW ACC = |QUADCHANGE - 1|
     SACL    TMP1    ; STORE IN OUTBITS
     RET             ; RETURN FROM SUBROUTINE
;
;       END OF SUBROUTINE DIFDEC12
;
;
;
;
; DATE            : 7-15-86
;
; SUBROUTINE      : DD24
; PURPOSE         : 2400 BPS DIFFERENTIAL DECODER
;
; TASK            : GIVEN QUANTIZED COMPLEX POINT
;                   P = PREAL + j PIMAG, DETERMINE THE OUTPUT
;                   QUADBITS AND STORE IN LOCATION OUTBIT.
;
; ENTRY CONDITION : THE TWO MSB'S OF THE QUADBIT ARE DETERMINED
;                   BY THE 1200 BPS DIFFERENTIAL DECODER
;                   SUBROUTINE DD12. HENCE ONLY THE TWO LSB'S
;                   NEED TO BE DETERMINED HERE.
;
; EXIT CONDITION  : THE OUTPUT QUADBITS ARE RETURNED IN RAM
;                   OUTBITS.
;
; DESCRIPTION     : THE IMPLEMENTATION ASSUMES THAT THE CURRENT
;                   QUADRANT NO. (0,1,2 OR 3) IS IN LOCATION
;                   CQUAD, AND THAT THE PREVIOUS QUADRANT
;                   NO. IS IN RAM LOCATION PQUAD.  NOTE FROM
;                   CCITT RECOMMENDATION V22.BIS THAT OUTPUT
;                   AMPLITUDE BITS FOR QUADRANTS 0 AND 2 ARE
;                   IDENTICAL. SIMILARLY, THE OUTPUT AMPLITUDE
;                   BITS FOR QUADRANTS 1 AND 3 ARE IDENTICAL.
;                   FIRST IT IS DETERMINED WETHER THE QUADRANT
;                   NO. IS EVEN (0 OR 2) OR ODD (1 OR 3).
;                   THE AUXILIARY REGISTER AR0 IS MADE 0 FOR
;                   EVEN CASE , AND MADE EQUAL TO 1 FOR THE ODD
;                   CASE. THE EVEN/ODD DECISION IS MADE BY TESTING
;                   THE LSB OF CQUAD. THIS DETERMINATION
;                   ENABLES US TO BE CONCERNED WITH THE ABSOLUTE
;                   VALUES OF PREAL AND PIMAG ONLY.  THE REMAINDER
;                   OF THE IMPPEMENTATIOP ALGORITHM CAN BE
;                   DESCRIBED AS FOLLOWS :
;
;      IF |PREAL| - 2.0 < 0 THEN |PREAL| = 1.0 ELSE |PREAL| = 3.0
;
;      IF |PIMAG| - 2.0 < 0 THEN |PIMAG| = 1.0 ELSE |PIMAG| = 3.0
;
;      CASE OF { |PREAL| , |PIMAG| } :
;
;          { 1.0 , 1.0 }   :       AMP_BITS = 00   ANY QUADRANT
;          { 3.0 , 3.0 }   :       AMP_BITS = 11   ANY QUADRANT
;
;          { 1.0 , 3.0 }   :       AMP_BITS = 10   EVEN QUADRANT
;                                                = 01   ODD QUADRANT
;
;          { 3.0 , 1.0 }   :       AMP_BITS = 01   EVEN QUADRANT
;                                                = 10   ODD  QUADRANT
;
;
; REVISION INFO : MODIFIED 8-8-86 SO THAT :
;                 CQUAD IS NOW IN TMP0,
;                 OUTBIT IS NOW IN TMP1.
;
;
;
;
;       FIRST DETERMINE IF QUDRANT NO. IS ODD OR EVEN
;
;
DD24
	 LARP    0       ; SELECT AR0 AS AUX REG.
     LARK    AR0,0   ; ASSUME EVEN QUADRANT
     ZAC             ;;CLEAR-UP ACC
     ADD     TMP0,15 ; FORCE LSB OF CURRQUAD
;                    INTO BIT 15 OF ACC
     SACL    TMP2    ; PUT AWAY TEMPORARILY
     LAC     TMP2    ; BRING BACK FOR SIGN TEST
     BGEZ    NOADJ   ; IF EVEN QUAD, NO ADJUSTMENT
     LARK    AR0,1   ; ELSE SET AR0 = 1
;
;
;       NOW IMPLEMENT THE ALGORITHM DESCRIBED ABOVE
;       START BY TAKING ABSOLUTE VALUES OF PREAL AND PIMAG
;
NOADJ
	 LAC    PREAL   ; BRING IN THE REAL PART
     ABS             ; TAKE ABSOLUTE VALUE
     SUB     ONE,13  ; SUBTRACT 2.0 IN Q12 FORMAT
     BGZ     PREQ3   ; TEST IF |PREAL| = 3.0
;
     LAC     PIMAG   ; |PREAL| = 1.0 : TEST PIMAG
     ABS             ; TAKE ABSOLUTE VALUE
     SUB     ONE,13  ; TAKE AWAY 2.0 IN Q12 FORMAT
     BGZ     PR1PI3  ; TEST IF |PIMAG| = 3.0
;
     LAC     TMP1,2  ; |PREAL|=1.0 & |PIMAG|=1.0
;              ; HENCE AMP_BITS=00
     SACL    TMP1
     RET             ; RETURN FROM SUBROUTINE
;
PR1PI3
	 BANZ  IS01    ; TEST QUADRANT
     B       IS10    ; QUADRANT MUST BE EVEN
;
PREQ3
	 LAC    PIMAG   ; |PREAL|=3.0 SO TEST |PIMAG|
     ABS
     SUB     ONE,13  ;DECIDE ON |PIMAG|
     BLZ     PR3PI1
;
     LACK    3
     ADD     TMP1,2  ; FORCE 3 INTO LSB'S OF OUTBITS
     SACL    TMP1    ; STORE AWAY
     RET
;
PR3PI1
	 BANZ  IS10    ; TEST QUADRANT
     B       IS01    ; QUADRANT MUST BE EVEN
;
IS01
	 LACK    1       ; AMP_BITS=01
     ADD     TMP1,2  ; FORCE INTO LSB'S OF OUTBITS
     SACL    TMP1    ; STORE AWAY
     RET
;
IS10
	 LACK    2       ;AMP_BITS=10
     ADD     TMP1,2  ;FORCE INTO LSB'S OF OUTBITS
     SACL    TMP1
     RET
;
;
;       END OF SUBROUTINE DD24
