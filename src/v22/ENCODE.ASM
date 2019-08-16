;*************************************************;
;
;              ENCODE.ASM
;
;*************************************************;
;
;The routine implements both the encoder and the
;update of the transmitter delay line.
;
;The four bits to be transmitted are stored by
;the CCI routine (called immediatly before this
;routine) in RAM location XBITS.
;The corresponding constellation point is first
;determined and then the in-phase and quadrature
;delay lines are updated
;The encoder operates in the same fashion regardless
;of the particular bit rate (FSK is handled s
;separately). Bits 3 and 2 of XBITS determine the
;phase increment according to Table 1 of V.22 bis
;CCITT recomm. . Bits 1 and 0 determine the amplitude
;of the constellation according to Figure 2 of the
;the recomm.
;
;Determine new quadrant.
;LASTQ contains the previous quadrant index:
;      LASTQ = 0 for quadrant 1
;            = 4 for quadrant 2
;            = 8 for quadrant 3
;            = 12 for quadrant 4
;the content of LASTQ also corresponds to the
;address in the constellation table of the four
;points corresponding to that quadrant.
;In the constellation table each point in the
;contellation is stored in 1 table entry, with
;its real part in the 8 LSB's and its imaginary
;part in the 8 MSB's.
;
;Firts take bits 2 and 3 of XBITS and determine
;by table lookup the phase increment for the
;diff. phase encoding.

	.global	ENCODE
ENCODE
     LAC     XBITS,14 ;
     SACH    TxTmp0    ;
     LALK    XPHDEC  ; beginning of phase dec. table
     ADD     TxTmp0    ;
     TBLR    TxTmp1    ;
;TxTmp1 now contains 0,4,8 or 12 which correspond to phase
;increments of 0,90,180 and 270 degrees respectively. If we
;add TxTmp1 to LASTQ modulo 16, we obtain the quadrant index
;(immediatly stored in LASTQ) which also corresponds to the
;relative constellation table address for the four points
;in that quadrant. The relative address of the constellation
;point is determined by adding the value of bits 0 and 1 of
;XBITS to LASTQ. Tha absolute table address is then obtained
;by adding the absolute address of the beginning of the
;constellation table XCONST.
     LAC     TxTmp1    ;  TxTmp1 -00h ACC
     ADD     LASTQ   ;
     SACL    TxTmp1    ;
     LACK    0Fh     ;
     AND     TxTmp1    ;
     SACL    LASTQ   ;
;
;Determine the speed (1200 or 2400)
;
     LACK    03h     ;
     AND     STATUS  ;
     SUB     ONE,1   ;
     BZ      ENC2    ; if zero 1200
     LACK    03h     ;
     AND     XBITS   ;
     B       ENC3    ;
ENC2
     LACK    01h     ;
ENC3
     SACL    TxTmp0    ;
    lalk    #NewConst   ; constellation table
    add     TxTmp0,1
    add     LASTQ,1
    tblr    TxTmp0        ; Real value
    add     ONE
    tblr    TxTmp1        ; Imaginary value
; compute Real pointer
    lac     ShiftR,2    ; previous constellations
    add     TxTmp0        ; new constellation
    and     #03Fh
    sacl    ShiftR
    lt	    ShiftR
	mpy		NbSamp
	pac				 ; (pm=0)
    add     Shape     ; table
    sacl    PtSin
; compute Imaginary pointer
    lac     ShiftI,2    ; previous constellations
    add     TxTmp1        ; new constellation
    and     #03Fh
    sacl    ShiftI
    lt	    ShiftI
	mpy		NbSamp
	pac
    add     Shape     ; table
    sacl    PtCos

     RET             ;

