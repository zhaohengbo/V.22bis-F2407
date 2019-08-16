;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
INTERP
     LALK    INTTBL
     ADD     TIMIND,2 ;form address for coeff. section
;Read in the four coefficients
     TBLR    TMP3
     ADD     ONE
     TBLR    TMP2
     ADD     ONE
     TBLR    TMP1
     ADD     ONE
     TBLR    TMP0
;Compute the real part and store in TMP4 (coeff. are S.15)
     LARP    AR0
     LRLK    AR0,IR0
     CALL    FILT1
     SACH    TMP4,4  ;TMP4 has same format as input (S4.11)
	 abs
	 add	AVESQR,16
	 sach	AVESQR
;Compute the imag. part and store in TMP5
;FILT1 leaves AR0 pointing to II0
     CALL    FILT1
	 neg
     SACH    TMP5,4  ;TMP5 has same format as input (S4.11)

; ------- debug
; reccord
   .if     TRACE
;   out     TMP4,ADBP
;   out     TMP5,ADBP
;   out     C5R,ADBP
;   out     C5I,ADBP
   .endif
; ------- end debug

	 abs
	 add	AVESQR,16
	 sach	AVESQR
     RET
;
;FILT1 is a simple FIR filter with coeff. in TMP0,...,TMP3
;
FILT1
	 ZAC
     LT      *+
     MPY     TMP0
     LTA     *+
     MPY     TMP1
     LTA     *+
     MPY     TMP2
     LTA     *+
     MPY     TMP3
     APAC
     RET
