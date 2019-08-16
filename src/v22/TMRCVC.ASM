;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                       TMRCV.ASM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       Timing recovery routine. The routine has
; the receiver sample counter clock wit the baud
; interval, and determines the timing index j
; used in the interpolate/decimate function which
; interfaces the receive filters operating at
; 16 times the baud rate with the T/2 equalizer.
;
; In acquisition mode the routine has to align the
; receiver sample counter with the baud interval.
; The aim is to make the peak of the signal during
; a given baud interval correspond to ?
;
;
; input page 4
;
;Determine if the timing error function averaging
;time has counted down to 0.
;
TMRCV
     LAC     AVECNT
     SUB     ONE
     SACL    AVECNT
     BGZ     TMREND  ;If AVECNT > 0 => return
;
;First determine whether in slew mode or tracking
;mode by looking at bit 5 of STAT2 (0 => slewing)
;
     LAC     ONE,5
     AND     STAT2
     BZ      SLEW
;
;Tracking mode
;Reset the averaging counter to 16, then check if
;the error is inside the window (>600 in S5.10)
;
TRACK
     LACK    64
     SACL    AVECNT
	 LAC	 #580H
     SACL    TMP0    ; Window -> TMP0 (for later use)
     ADD     TMFUNC
;
; TMFUNC is the averaged timing function (error) whihc
; is now compared to the window
; IF  TMFUNC < - WINDOW => Retard timing
; IF  TMFUNC > WINDOW => Advance timing
; else leave timing unchanged and return.
;
     BLZ     TRACK2  ; Track2 retards timing
;
; Compute TMFUNC - WINDOW
;
     SUB     TMP0,1
     BLZ     SLEW6   ; If TMFUNC < WINDOW exit
;
; TMFUNC > WINDOW => advance timing by
; decreasing the timing index (less sample).
;
TRACK5
     LAC     TIMIND
     SUB     ONE
     SACL    TIMIND
     B       SLEW6   ;Exit
;
; Following lines retard timing by increasing the
; timing index, and if it is equal to 8 it is
; reset to 0.
;
TRACK2
     LAC     TIMIND
     ADD     ONE
     SACL    TIMIND
     B       SLEW6
;
;Following lines implement slew mode.
;
;Reset AVECNT to 4 and check if TMFUNC is outside
;the window (>A00 in S5.10) - NO WINDOW IN THIS DESIGN
;
SLEW
     LACK    4
     SACL    AVECNT
     LALK    #240h    ; Modified 1/6/87 (ZAC is equiv.)
     SACL    TMP0
     ADD     TMFUNC  ;TMFUNC+WINDOW -> ACC
;
;Check if TMFUNC < -WINDOW
;
     BLZ     SLEW2
;
;If TMFUNC > - WINDOW, check if TMFUNC > WINDOW
;
     SUB     TMP0,1  ;TMFUNC - WINDOW -> ACC
     BLZ     SLEW3
;
;TMFUNC > WINDOW => advance timing (less samples)
;
	 lac	TIMIND
	 sub	#6
     B       SLEW4
; more samples
SLEW2
	lac		TIMIND
	add		#6
;
; Set bit 6 of STAT2 to disable entering the
; clock correction routine more than once in
; this baud
;
SLEW4
	 sacl	TIMIND
     LAC     #2
     SACL	 IRCNT	; Set in range counter to four.
     B       SLEW6
;If following lines are reached, -WINDOW < TMFUNC < WINDOW
;do not adjust the timing. Check if this condition holds
;true for more than 4 consecutine averaging intervals
;in which case set the tracking mode bit (bit 5 of STAT2)
;to 1.
;
SLEW3
;	dint
     LAC     IRCNT
     SUB     ONE
     SACL    IRCNT
;	eint
     BGZ     SLEW6
     LAC     ONE,5   ;Set timing rec. tracking bit on
     OR      STAT2   ;Also enables equalizer convergence
     SACL    STAT2
SLEW6

     ZAC
     SACL    TMFUNC
TMREND
     RET
