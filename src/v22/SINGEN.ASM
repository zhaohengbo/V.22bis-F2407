;
;       SUBROUTINE      :       SINGEN
;       PURPOSE         :       SINE GENERATION
;
;       TASK    :       GIVEN A COSINE TABLE WITH 257 VALUES
;                       AND START ADDRESS COSOFF, AND GIVEN AN
;                       ANGLE INDEX IN THE ACCUMULATOR, DETERMINE
;                       THE SINE OF THE ANGLE.
;
;       ENTRY CONDITION :       THE ANGLE INDEX MUST BE IN THE
;                               LOWER ACCUMULATOR; 0=0  7fff=8000=PI  ffff=2*PI
;
;       EXIT CONDITION  :       THE SINE OF THE ANGLE IS RETURNED
;                               IN TEMPORARY LOCATION TMP3.
;
;       DESCRIPTION     :       THE COSINE LOOKUP TABLE CONTAINS
;                               257 VALUES WITH;
;
;               COS[0] = 1.0    AND     COS[256] = -1.0
;
;       HENCE ANGLE INDEX 0 MAPS TO  ANGLE 0 AND ANGLE INDEX 256 MAPS
;       TO PI.  THE SINE VALUE IS GENERATED BY SUBTRACTING FROM THE ANGLE
;       INDEX THE INDEX CORRESPONDING TO PI/2, TAKING THE ABSOLUTE VALUE,
;       AND HENCE FORMING AN ADDRESS INTO THE LOOKUP TABLE.
;
; No of cycles: 17
; No of stack levels used: 1
;
;
;       THE ANGLE INDEX IS THE LOWER ACCUMULATOR
;
; ANGLE INDEX HAS S15.0 FORMAT. MUST SUBTRACT PI/2 VALUE WHICH LAYS
; AT THE MIDDLE OF THE TABLE AND HAS SS14.0 FORMAT AS VIEWED IN S15.0 FORMAT
;
SINGEN
     SUB     ONE,14  ; SUBTRACT INDEX OF PI/2
     SACL    TMP3    ; PUT AWAY TEMPORARILY
     ZALH    TMP3    ; PREPARE FOR ABSOLUTE VALUE
     ABS             ; TAKE ABSOLUTE VALUE
     SACH    TMP3    ; PUT AWAY BEFORE RIGHT SHIFT
;
; THE VALUE STORED IN TMP3 HAS S15.0 FORMAT -- ALBEIT A POSITIVE NUMBER
;
; A LEFT SHIFT OF 9 BITS CORRESPONDS TO 8S24.0 FORMAT AND SAVING THE
; HIGH ACCUMULATOR HAS A 8S8.0 FORMAT
;
     LAC     TMP3,9  ; ISOLATE 8 MSB'S IN HIGH ACC
     SACH    TMP3    ; PUT AWAY THE 8 MSB'S TEMPORARILY
;
;
;       THE NEXT THREE INSTRUCTIONS ELIMINATE
;       ANY SIGN EXTENSION BITS THAT MIGHT HAVE PROPAGATED
;
     LAC     TMP3
     ABS
     SACL    TMP3
;
;       FORM THE FINAL LOOK-UP ADDRESS
;
; BRING IN THE ADDRESS OFFSET.
;
; THE BASE ADDRESS IS IN 8S8.0 FORMAT, WHILE THE INDEX IS ALSO IN
; 8S8.0 FORMAT.
;
     LALK    COSOFF  ;
     ADD     TMP3    ; FORM FINAL LOOK-UP ADDRESS
     TBLR    TMP3    ; READ SINE VALUE INTO TMP3
     RET
;
