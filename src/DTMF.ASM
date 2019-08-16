            .def    _Phi1, _Phi2, _DeltaPhi1, _DeltaPhi2, _Ampl1, _Ampl2
            .def    _DtmfFlag
            .def    Dtmf
            .def    _ToneTable
            .ref    ForDA
            .ref    SinGenFSK, Sin1, Sin2
            .include "common.inc"

_Phi1       .usect      "DTMF",1
_Phi2       .usect      "DTMF",1
_DeltaPhi1  .usect      "DTMF",1
_DeltaPhi2  .usect      "DTMF",1
_Ampl1      .usect      "DTMF",1
_Ampl2      .usect      "DTMF",1
_DtmfFlag   .usect      "DTMF",1


;________________________________________________________
;       DTMF tone table ; 1st entry represents low freq
;                         2nd entry represents high freq
;
;               DELTA = (F / F ) * 2^16 
;                             S
; WITH N = 256  TABLE SIZE
;      F = 8000 HZ
;       S
;      F = FREQUENCY OF INTEREST
;
;   The low frequency gain is set to -11 dBm, the high frequeny
;   gain to -9 dBm. Emission level on line: -7 dBm
;________________________________________________________
; DATA FORMAT IS S7.8 TO BE AS STEP SIZE. THE TABLE ENTRIES ARE
; HOWEVER, TREATED AS 16 BIT UNSIGNED INTEGERS. A MULTIPLICATION
; OF DELTA BY 256 DOES THE NECESSARY CONVERSION IN FORMATS.

; The table is organized as follows:
; 4 entries for each digit/tone:
;   .word   row frequency step
;   .word   col frequency step
;   .word   row freq. gain
;   .word   col freq. gain

; frequency gain given for pm=0 (spm 0)

_ToneTable
     .word   01e1eh  ;       0 
     .word   02Ac0h  ;
     .word   790h
     .word   8c5h
;;
     .word   0164eh  ;       1
     .word   026b0h  ;
     .word   790h
     .word   8c5h
;;
     .word   0164eh  ;       2
     .word   02ac0h  ;
     .word   790h
     .word   8c5h
;;
     .word   0164eh  ;       3
     .word   02f42h
     .word   790h
     .word   8c5h
;;
     .word   018a3h  ;       4
     .word   026b0h  ;
     .word   790h
     .word   8c5h
;;
     .word   018a3h  ;       5
     .word   02ac0h  ;
     .word   790h
     .word   8c5h
;;
     .word   018a3h  ;       6
     .word   02f42h
     .word   790h
     .word   8c5h
;;
     .word   01b43h  ;       7
     .word   026b0h  ;
     .word   790h
     .word   8c5h
;;
     .word   01b43h  ;       8
     .word   02ac0h  ;
     .word   790h
     .word   8c5h
;;
     .word   01b43h  ;       9
     .word   02f42h
     .word   790h
     .word   8c5h
;;
     .word   01e1eh  ;       *
     .word   026b0h
     .word   790h
     .word   8c5h
;;
     .word   01e1eh  ;       #
     .word   02f42h
     .word   790h
     .word   8c5h
;;
     .word   0164eh  ;       A
     .word   03442h
     .word   790h
     .word   8c5h
;;
     .word   018a3h  ;       B
     .word   03442h
     .word   790h
     .word   8c5h
;;
     .word   01b43h  ;       C
     .word   03442h
     .word   790h
     .word   8c5h
;;
     .word   01e1eh  ;       D
     .word   03442h 
     .word   790h
     .word   8c5h
;;
DtmfLevel	.set	234*GRef   ;
    
     .word  0299ah  ;       1300 Hz, single tone    Calling Tone    
     .word  0299ah  		;8kHz
     .word  DtmfLevel
     .word      0
;;
    
     .word  04333h  ;       2100 Hz, single tone    Answer Tone
     .word  04333h  		;8kHz
     .word  DtmfLevel
     .word      0
;;
    
     .word  01f5ch  ;       980 Hz, single tone     "1", V21, Calling
     .word  01f5ch  ;                               8kHz
     .word  DtmfLevel
     .word      0
;;
    
     .word  034cdh  ;       1650 Hz, single tone    "1", V21, Answering
     .word  034cdh  ;                               8kHz
     .word  DtmfLevel
     .word      0
;;

     .word  0c7bh   ;       390 Hz, single tone     "1", V23, Calling
     .word  0c7bh   ;                               8kHz
     .word  DtmfLevel
     .word      0
;;

     .word  299ah   ;       1300 Hz, single tone    "1", V23, Answering
     .word  299ah   ;                               8kHz
     .word  DtmfLevel
     .word      0


;------------------------------------------------------
; Tone generator for DTMF and single tones (Ampl2=0)
; 42 cycles + 2*18 (SINGEN)=78 cycles
;------------------------------------------------------

Dtmf
    spm     0
    ldp     #_Phi1          ; get value for low frequency
    zals    _Phi1
    call    SinGenFSK
    lac     Sin1,15         ; result returned in Sin1
    sach    Sin2            ; store away in Sin2
    ldp     #_Phi1
    zals    _Phi1           ; update phase1 (phi=phi + deltaPhi)
    adds    _DeltaPhi1
    sacl    _Phi1   

    lac     _Ampl2
    bz      SingleTone

    zals    _Phi2
    ldp     #Sin1
    call    SinGenFSK
    lac     Sin1,15
    sach    Sin1
    ldp     #_Phi2
    zals    _Phi2           ; update phase2
    adds    _DeltaPhi2
    sacl    _Phi2
    ldp     #Sin2           ; calculate low freq. output level
    lt      Sin2
    ldp     #_Ampl1
    mpy     _Ampl1
    ldp     #Sin1
    ltp     Sin1            ; high freq. output level
    ldp     #_Ampl2
    mpy     _Ampl2
    apac
OutputTone
    ldp     #ForDA
    sach    ForDA,4         ; output DTMF sample
    ret

SingleTone
    ldp     #Sin2           ; calculate low freq. output level
    lt      Sin2
    ldp     #_Ampl1
    mpy     _Ampl1
    pac
    b       OutputTone

