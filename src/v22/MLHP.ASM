;
;
;       SUBROUTINE      :       MLHP
;       PURPOSE         :       MU-LAW TO 16-BIT T/C CONVETER
;                               AND HIGH PASS FILTER
;
;       TASK            :       CONVERT THE DECODED PCM WORD
;                               INTO A 16 BIT T/C, HIGH PASS
;                               FILTERED INPUT SAMPLE.
;
;       ENTRY CONDITION :       NONE
;
;       EXIT CONDITION  :       THE HIGH-PASS FILTERED 16-BIT T/C INPUT SAMPLE
;                               IS RETURNED IN THE HIGH ACCUMULATOR.
;
;       DESCRIPTION     :       PLEASE REFER TO TI TMS32011 USER'S
;                               GUIDE PAGE 4-11 AND THE TMS32020
;                               VOICE ECHO CANCELLER APPLICATION REPORT.
;
;
;       REVISION INFO   :       REVISED 7-21-86 TO MAKE MORE
;                               EFFICIENT USE OF RAM
;
;                               REVISED 5-29-87 TO DISTINGUISH
;                               BETWEEN FSK AND QAM/DPSK MODES
;                               OF OPERATION
; worst case cycles:
;   QAM/DPSK   15 cycles
;   FSK        30 cycles
; No of stack levels used: 0
;
MLHP LAC     TMP1    ; LOAD ACC WITH 14-BIT S/M WORD
     SUB     ONE,5   ; SUBTRACT 32
     SUB     ONE     ; SUBTRACT ONE, HENCE BIAS IS REMOVED
     BGEZ    POSV    ; IF POSITIVE, THEN SAVE
     ADD     ONE,15  ; ELSE DELETE SIGN BY CARRY
     SACL    TMP1    ; SAVE MAGNITUDE VALUE
     ZAC             ; NEGATE THE INPUT BY SUBTRACTING
     SUB     TMP1    ; IT FROM ZERO
POSV SACL    TMP1    ; SAVE FULLY EXPANDED LINEAR DATA IN TMP1
;
;       use high pass filter. Make sure incoming sample
;       has no shift.
;
; MODIFIED 5-27-87  REMOVED HIGHPASS FILTER FOR QAM/DPSK.
     LAC     FSKFLG
     BZ      NOFLT
     LAC     TMP1,0
;
;High pass filter the input
;
     LDPK    X1
     SACL    X1
     ZALS    STLSB
     ADDH    ST
     SUB     ST,TAU
     ADDH    X1
     SUB     X1,TAU-1
     SUBH    X2
     ADD     X2,TAU-1
     SACL    STLSB
     SACH    ST
     DMOV    X1
     LDPK    TMP1
     SACH    TMP1
;
NOFLT RET
;
