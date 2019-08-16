;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                       AGC.ASM
;
;       Front end AGC function.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
    .global _V22TR1,_V22TR2
        
; The average signal squared is computed by the main
; program and stored in AVESQR, which is cleared by this
; routine after using it.
; The routine uses a window whose width depends on the
; modulation (1200,2400) and a error weighting which
; also depends on that rate.
;
AGC
;
;Check if 2400 and change those values
;

     LACK    3
     AND     STATUS  ;If STATUS bits 0 and 1 > 2 => 2400
     SUB     ONE,1
     BLEZ    AGC0    ;If <= 2 , do not modify TMP0 and TMP1
;
;For 2400 , 2 -> TMP0 and 1320 -> TMP1
;
     LACK    2       ; IT IS 2400
     SACL    TMP0
     LALK    1024
     SACL    TMP1
     B       AGC1
;
AGC0
     LACK    1       ; IT IS 1200
     SACL    TMP0    ;Weighting factor -> TMP0
     LALK    950
     SACL    TMP1    ;Window -> TMP1
;
;Now subtract reference from baud energy to get error
;The baud energy is in S10.5 format. The AGC maintains
;that level at 2.86;16 = 46.7  (H'5B6 in S10.5).
;The AGCREF is therefore H'5B6
;
AGC1
     LAC     AVESQR
     subk    #AGCREF
;
;Compare the error to window (TMP1).
; If error > window => error - window -> error
; If -window < error < window => 0 -> error
; If error < -window  => TMP0 ; (error + window) -> error
; If the avreage baud energy is A, the peak baud energy
; for QAM signals is 1.8 A and the minimum is 0.2 A.
; The window is therefore chosen to be 0.8 A in either
; direction. With AGCREF = H'5B6 the window is H'492
; For DPSK signals the variations in baud energy are
; entirely due to ISI and distortion and therfore the
; window is much smaller (H'A).
; First check if error > window
;
     SUB     TMP1
     SACL    TMP3    ;error - window -> TMP3
     BGEZ    AGC2
;
; Error < window => check if error > -window
; in which case zero the error. First zero the
; error (i.e. assume error > -window) and modify
; if wrong assumption.
;
     LARK    AR1,0
     SAR     AR1,TMP3 ;Assume error > -window
;
;Check asumption
;
     ADD     TMP1,1  ;error + window -> ACC
     BGEZ    AGC2    ;assumption is right
;
;Error < -window => TMP0;(error+window) -> TMP3
;
     SACL    TMP3
     LT      TMP3
     MPY     TMP0
     PAC
     SACL    TMP3
;
;At this point, the weighted windowed error is
;contained in TMP3. We consider it an S.15 number
;and use it to update the AGC gain ALPHA. First
;we determine whether to slew or not. If error is
;larger than >1EA6 or smaller than >F5E7, go into
;slewing mode by setting error to >7FFF or >8000
;respectively. Otherwise leave it unchanged.
;
;
AGC2
     LAC     TMP3
     SUB     #PSM
     BLEZ    AGC3    ;do not slew
;
     lac     #7FFFh
     SACL    TMP3    ;TMP3 <- 7FFF
     B       AGC4
;
AGC3
     ADD     #PSM   ;ACC <- TMP3
     ADD     #NSM
     BGEZ    AGC4    ;do not slew
;
     lac     #8001h
     SACL    TMP3    ;TMP3 <- 8000
;
;
;The following lines update the gain ALPHA using
;an exponential integrator
;       ALPHA = ALPHA(1-K;ERROR)   (ERROR = TMP3)
; where ALPHA is of format S7.8 and ERROR is S0.15
; and K = 0.5.
; ALPHA ; ERROR : S7.8 ; S.15 = S7.24. By keeping
; ACCH without left shift the multiplication by K
; is accomplished.
; ALPHA is upperbounded to 35.73 in S7.8
;
AGC4
     ZALR    _ALPHA
     LT      TMP3    ;ERROR -> T
     MPY     _ALPHA
     SPAC            ; ALPHA (1 - 0.5;ERROR) -> ACC
     SACH    _ALPHA
;
;Zero baud energy register
;
AGC5:
     ZAC
     SACL    AVESQR


;
;;;;;;;;;;;;;;;;;;;;;;
;       Energy detect 
;;;;;;;;;;;;;;;;;;;;;;
;Start by reading in hysterisis counter increment
;constant
;
    .newblock
    lac     _ALPHA

    ldpk    #_V22TR1
    sub     _V22TR1
    bgz     $0              ; carrier lost
    add     _V22TR1
    ldpk    #_V22TR2
    sub     _V22TR2
    ldpk    #STWRD
    bgz     $1              ; do nothing
; carrier detect
    lac     STWRD
    or      #1<<BitEne
    sacl    STWRD
$1
    ret
; carrier lost
$0
    ldpk    #STWRD
    lac     STWRD
    and     #~(1<<BitEne)
    sacl    STWRD
    ret



