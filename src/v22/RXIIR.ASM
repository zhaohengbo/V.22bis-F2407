;
;
;       SUBROUTINE      :       RXIIR
;       PURPOSE         :       RECEIVE LOWPASS IIR FILTERS
;
;       TASK            :       GIVEN THE BASEBAND TRANSLATED
;                               IN-PHASE (QUADRATURE) COMPONENT
;                               XREAL (XIMAG), PERFORM LOWAPSS
;                               FILTERING TO REDUCE OUT-OF-BAND
;                               NOISE.
;
;       ENTRY CONDITION :       THE AUXILIARY REGISTER AR0 CONTAINS
;                               THE RAM ADDRESS OF THE RECEIVED
;                               IN-PHASE (QUADRATURE) COMPONENT
;                               TIME SHIFTED BY TWO SAMPLING EPOCHS.
;                               SEE DESCRIPTION BELOW.
;
;
;       EXIT CONDITION  :       THE LOWPASS FILTERED VERSION OF XREAL
;                               (XIMAG) IS RETURNED IN THE HIGH ORDER
;                               ACCUMULATOR BITS.
;
;       DESCRIPTION     :       THE TRANSFER FUNCTION OF THE IIR FILTER
;                               USED CAN BE EXPRESSED AS;
;
;
;                       H(z) = F(z) G(z)
;       where :
;
;       F(z) = [ b(0) + b(1) z^-1 + b(2) z^-2 ] / [ 1 + a(1) z^-1 + a(2) z^-2 ]
;
;       G(z) = [ b'(0) + b'(1) z^-1 ] / [ 1 + a'(0) z^-1 ]
;
;       DEFINING THE INTERMEDIATE TIME-DOMAIN VARIABLE w(n) AS ;
;
;    w(n) = b(0) x(n) + b(1) x(n-1) + b(2) x(n-2) - a(1) w(n-1) - a(2) w(n-2)
;
;       WE HAVE :
;
;               u(n) = b'(0) w(n) + b'(1) w(n-1) - a'(1) u(n-1)
;
;       WHERE n REPRESENTS THE 9600 Hz SAMPLING INDEX.
;
;       THE IMPLEMENTATION FIRST COMPUTES w(n) AND THEN u(n). THE COEFFICIENTS
;       ARE REPRESENTED IN 13-BITS TWO'S COMPLEMENT FORMAT WITH 11-BITS FOR
;       FRACTIONAL PART AND 2-BITS FOR INTEGER PART. FOR EFFICIENCY, THE RAM
;       ORGANIZATION IS AS FOLLOWS:
;
;                                       REAL CALL (IMAG CALL)
;
;               |               u(n-1)
;              \|/              w(n)         TMP2 (TMP3)
;       increasing RAM          w(n-1)
;          address              w(n-2)
;                               x(n)         TMP0 (TMP1)
;                               x(n-1)
;       initially AR0 :-->      x(n-2)
;
;       HENCE AT ENTRY TO THIS ROUTINE, AR0 CONTAINS THE RAM ADDRESS OF
;       x(n-2).
;
;       NOTE : THIS ROUTINE IS CALLED TWICE. THE FIRST CALL LOWPASS FILTERS
;       THE IN-PHASE COMPONENT, AND THE SECOND LOWPASS FILTERS THE QUADRATURE
;       COMPONENT. THE TEMPORARY LOCATION ASSIGNMENTS TO x(n) AND w(n)
;       ALLOW THE MOST EFFICIENT RAM USAGE.
;
;
;       REVISION INFO   : MODIFIED 7-21-86 TO ASSIGN TEMP LOCATIONS
;                         x(n) AND w(n).
;                         MODIFIED 7-21-86 TO RETURN THE FILTERED
;                         COMPONENT IN HIGH ORDER ACCUMULATOR.
;
;
; No of cycles: 29
; No of stack levels used: 0
;
;
;       FIRST COMPUTE w(n)
;
;
;
RXIIR
     ZAC             ; CLEAR-UP ACC
;     LARP    0       ; SELECT AR0
;
     LT      *-      ; T = RAM[AR0] = x(n-2)
;			 AR0 = AR0 - 1 HENCE AR0 :--> x(n-1)
;
     MPYK    307     ; P = b(2) x(n-2)
;
     LTD     *-      ; T =RAM[AR0] = x(n-1)
;			  ACC = b(2) x(n-2)
;			  x(n-2) <-- x(n-1)
;			  AR0 = AR0 - 1 HENCE AR0 :--> x(n)
;
     MPYK    48    ; P = b(1) x(n-1)
;
     LTD     *-      ; T = RAM[AR0] = x(n)
;			   ACC = ACC + b(1) x(n-1)
;			   x(n-1) <-- x(n)
;			   AR0 = AR0 - 1 HENCE AR0 :--> w(n-2)
;
     MPYK    307     ; P = b(0) x(n)
;
     LTA     *-      ;T = RAM[AR0] = w(n-2)
;			  ACC = ACC + b(0) x(n)
;			  AR0 = AR0 -1 HENCE AR0 :--> w(n-1)
;
     MPYK    -1418   ;P = -a(2) w(n-2)
;
     LTD     *-      ;T = RAM[AR0] = w(n-1)
;			   ACC = ACC - a(2) w(n-2)
;			   w(n-2) <-- w(n-1)
;			   AR0 = AR0 -1 HENCE AR0 :--> w(n)
;
     MPYK    2906    ; P = -a(1) w(n-1)
;
     APAC            ; ACC = ACC - a(1) w(n-1) = w(n)
;
     SACH    *+,5     ; STORE AWAY w(n)
;			   NOTE THAT w(n) & w(n-1)
;			   HAVN'T BEEN TIME-SHIFTED SINCE
;			   THEY ARE NEEDED FOR CALCULATING u(n)
;			   BUT AR0 = AR0 + 1 HENCE AR0 :--> w(n-1)
;
;       NOW COMPUTE u(n)
;
;
     ZAC             ; CLEAR-UP ACC
;
     LT      *-      ;T = RAM[AR0] = w(n-1)
;			   AR0 = AR0 - 1
;			   HENCE AR0 :--> w(n)
;
;
     MPYK    307     ; P = b'(1) w(n-1)
;
     LTD     *-      ; T = RAM[AR0] = w(n)
;			   ACC = b'(1) w(n-1)
;			   w(n-1) <-- w(n)
;			   AR0 = AR0 - 1 HENCE AR0 :--> u(n-1)
;
     MPYK    307     ;P = b'(0) w(n)
;
     LTA     *       ; T = RAM[AR0] = u(n-1)
;			   ACC = ACC + b'(0) w(n)
;
     MPYK    1331    ; P = -a'(1) u(n-1)
;
     APAC            ;ACC NOW CONTAINS u(n)
     sach	*,5,ar1
;

; ------- debug
; reccord
   .if     TRACE
;	sach	*,5
;   out     *,ADBP,ar1
   .endif
; ------- end debug

     RET
;
;       END OF SUBROUTINE RXIIR
