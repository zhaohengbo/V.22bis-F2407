     .include   "..\msp58c80.i8x"         
     .include   "..\global.inc"
     .include   "..\common.inc"



CHARON          .set    0001h
CARRIERON       .set    0002h
OLDCARON        .set    0004h
STARTON         .set    0008h
STOPON          .set    0010h
MEMON           .set    0020h

AGCTHRES1C      .set    6500h
AGCTHRES2C      .set    6C00h		  

AGCTHRES1A      .set    5000h
AGCTHRES2A      .set    5800h

B1_C            .set    3400;3491    ; coeff. B1 for 1750Hz (Q14)

B1_A            .set    -2522   ; coeff. B1 for 1080Hz (Q14)


ZONE            .set    10h
LPLEN			.set	14		; LP filter length=15            


    .ref    FromAD,ForDA
    .ref    _Modul

    .ref    V21FIRA, V21FIRC 
    .ref    V21AOut, V21COut
	.global	TXV21


    .def    RXV21
    .global _FSKREG, FSKCOUNT, FSKCHAR, FSKC, AGCTEMP, AGCGAIN, AGCSamp
	.global	_AGCTHRESL, _AGCTHRESH, FSKGAIN, DecCOUNT
    .global _InitRXV21, _ResetFSK

	.global AgcFSK, FSKDec

	.global	OUT

V21PAGE     .usect  "V21",0
AGCOUT      .usect  "V21",1     ; AGC output 
PDEL0       .usect  "V21",1     ; delay line for dephasor pi/2
PDEL1       .usect  "V21",1
PDEL2       .usect  "V21",1
LPFOUT      .usect  "V21",1
LPGAIN      .usect  "V21",1
B1FSK       .usect  "V21",1
V21BIT      .usect  "V21",1     ; bit value after decision
PROD        .usect  "V21",1
OAFLAG      .usect  "V21",1     ; Flag for mode=originate(0) or mode=answer(1)
DZONE       .usect  "V21",1
LPV210		.usect	"V21",LPLEN	; delay line for FIR LPF
LPV21L		.usect	"V21",2

_FSKREG		.usect	"FSK",1
_AGCTHRESL  .usect  "FSK",1     ; AGC threshold for hysteresis
_AGCTHRESH  .usect  "FSK",1
FSKCOUNT    .usect  "FSK",1
FSKCHAR     .usect  "FSK",1
FSKC        .usect  "FSK",1
AGCSamp     .usect  "FSK",1
AGCGAIN     .usect  "FSK",2
AGCTEMP		.usect	"FSK",1
DecCOUNT	.usect	"FSK",1


_InitRXV21
    .newblock
    dint
    ldp     #_Modul
    lac     _Modul
    and     #MCalling
    bz      $0
    ldp     #OAFLAG
    zac
    sacl    OAFLAG      ; flag=0, mode=originate
    lac     #B1_C
    sacl    B1FSK
; 	ldp		#_AGCTHRESL
;    lac     #AGCTHRES1C
;    sacl    _AGCTHRESL
;    lac     #AGCTHRES2C
;    sacl    _AGCTHRESH

    b       $1
$0  ldp     #OAFLAG
    lac     #1
    sacl    OAFLAG      ; flag=1, mode=answer
    lac     #B1_A
    sacl    B1FSK
; 	ldp		#_AGCTHRESL
;    lac     #AGCTHRES1A
;    sacl    _AGCTHRESL
;    lac     #AGCTHRES2A
;    sacl    _AGCTHRESH
$1
    ldp		#DZONE
    lac     #ZONE
    sacl    DZONE
    lar     ar3,#AGCOUT     ;init dephasor delay lines
    mar     *,ar3
    zac
    rpt     #4
    sacl    *+
    lar     ar3,#LPV210     ;init LP delay lines
    mar     *,ar3
    rpt     #LPLEN
    sacl    *+
    ldp		#FSKCOUNT
    sacl    FSKCOUNT
    sacl    _FSKREG
	sacl	FSKCHAR
	sacl	FSKC
	lac		#40
	ldp		#DecCOUNT
	sacl	DecCOUNT		; bit count>>1
   	eint
    ret

_ResetFSK
	dint
	zac
	ldp		#FSKCOUNT
	sacl	FSKCOUNT
	sacl	FSKCHAR
	sacl	FSKC
	lac		_FSKREG
	and		#0002h		; clear all bits apart from CD
	sacl	_FSKREG
	eint
	ret


RXV21
    eint
    .newblock
    ldp     #OAFLAG
    lac     OAFLAG
    bnz     $0
; Mode=Calling, reception=upper passband
    ldp     #FromAD
    lac     FromAD,14
    call    V21FIRA

    b       $1
; Mode=Answering, reception=lower passband
$0  ldp     #FromAD
    lac     FromAD,14
    call    V21FIRC
$1
	ldp		#AGCSamp
	sach	AGCSamp,0

	call	AgcFSK

 	ldp		#UartStatus
 	lac		UartStatus
 	and		#RecOn
 	bz		EndV21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       Demodulator Section                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       THIS DESIGN IMPLEMENTS A DELAY OF 5(PI)/2
;_____________________________________________________________________________
;       AGC
;_____________________________________________________________________________
;
;_____________________________________________________________________________
;       FSK Demodulator
;               Memory configuration; (consecutive addresses)
;                  AGCOUT
;                  PDEL0
;                  PDEL1
;                  PDEL2
;                  LPDEL0
;                  LPDEL1
;                  LPDEL2
;_____________________________________________________________________________
     SOVM            ;; set overflow mode
;
;   take product for product demod scheme. ASSUME ANSWER MODE (2 SAMPLES)
;
     ldp	#AGCSamp
	 lac	AGCSamp

		 
     LDP	#AGCOUT
	 SACL	AGCOUT
     LT      AGCOUT  ; load T with agc stage output
     MPY     PDEL2   ; take product with delay line output
;;
;;  ORIGINATE/ANSWER FLAG = 0 WHEN TX ORIGINATES THE CALL
;;                         HENCE RX RECEIVES IN THE HIGH BAND
;;
     LAC     OAFLAG  ; check for high band / low band
	 mar	 *,AR3
     BNZ     ANSWER  ; low band, done.
;     BNZ     ANSWER,*,AR3  ; low band, done.
     MPY     PDEL1   ; high band, use one less sample delay
ANSWER 
     PAC           ;; accumulate the product output
     SACH    PROD,1  ; store in PROD (1,15)


;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Product Demod Delay line                      |--------------> for high band
;               -------------------     ------- |   -------
;    AGCOUT--->| 1 zero fir filter |-->| z**-1 |-->| z**-1 |---> for low band
;               -------------------     -------     -------
;
;    PRODuct = AGCOUT * Output of delay line
;    PRODuct is lowpass filtered and it's sign indicates '0' or '1' data...
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       one zero filter to mop-up phase shift of flat delay line
;       to be pi/2 in product FSK demodulator;
;
;       ; Coefficients for zero;  (b1)
;              Bell 103:                       Gain 103:
;                       1170Hz    0.07175               0.57731
;                       2125Hz    0.31678               1.0
;
;              V.21 :                          Gain V21:
;                       1080Hz    0.32796               0.69753
;                       1750Hz    0.68889               1.0
;
; START UPDATING THE DELAY LINE
;
     DMOV    PDEL1   ; start shifting data in delay line
;;
;; GENERATE THE EXACT DELAY REQUIRED FOR RECEIVER.
;;
     LAC     AGCOUT,15 ; prepare for FIR accumulation
     LT      PDEL0   ; State of one zero FIR filter
     MPY     B1FSK   ; Mult by coefficient
     APAC            ;; output of one zero FIR filter
     BV      RSFLAG  ;; RESET OVERFLOW FLAG
RSFLAG: .equ $       ;;
     SACH    PDEL1,1 ; store at next stage of delay line
     DMOV    AGCOUT  ; shift sample in filter
;;
;; PREPARE TO LOW PASS FILTER THE PRODUCT.
;; Input=PROD
;;

     LAC    PROD
     SACL   LPV210
;     LAC    OAFLAG
;     BNZ    LPLB
;HIGH BAND
    MPYK    0       ;P = 0
    ZAC             ;ACC = 0
    LRLK    AR3,LPV21L 
    RPTK    LPLEN
    MACD    V21LPCoef,*-   ;MULTIPLY, ACCUM. and  DELAY
     APAC            ;; 
;    B       LPEND
; LOW BAND
;LPLB
;    SSXM
;    MPYK    0       ;P = 0
;    ZAC             ;ACC = 0
;    LRLK    AR3,LPV21L 
;    RPTK    LPLEN
;    MACD    V21LPCoef,*-   ;MULTIPLY, ACCUM. and  DELAY
;     APAC            ;; 
LPEND
     SACH    LPFOUT,0 ; 


;
;
;       Decision;  Slicer with dead zone in middle (window comparator)
;
	 LAC	LPFOUT
     ABS             ;
     SUB     DZONE   ;
     BLZ     DONE    ;
;;
;;
;; FOR V.21, NEGATIVE SIGNAL MEANS THAT WE HAVE RECEIVED A 0
;; AND A POSITIVE SIGNAL MEANS THAT WE HAVE A 1.
;;
ITSV21       ;
     LAC     LPFOUT  ;
     BLEZ    LOW     ;
     LACK    1       ; SET BAUD_DATA TO 1
     SACL    V21BIT  ;
     B       STORE    ;
LOW  LACK    0       ; SET BAUD_DATA TO 0
     B       STORE
DONE
     ldp	#_FSKREG
     BIT     _FSKREG,10     ; Test mem bit
     BBZ     B00            ; return this bit value
     LAC     #1            ;
     B       STORE                   ;
B00  ZAC                   ;
STORE
	ldp		#V21BIT
     SACL    V21BIT  ;
;
     BZ      BIT0            ;
     ldp	#_FSKREG
     LAC     _FSKREG        ;
     OR      #MEMON        ;
     B       BIT1            ;
BIT0
     ldp	#_FSKREG
     LAC     _FSKREG        ;
     AND     #~MEMON       ;
BIT1 SACL    _FSKREG        ;



     LAR    AR3,#V21BIT      ;
	 CALL	 FSKDec
EndV21 
;     RET                   ;
	
	B		TXV21


;--------------------------------------
; AGC and carrier detection
; AGCSamp contains signal after passband filtering
;--------------------------------------
AgcFSK
	LDP		#_FSKREG
    LAC     _FSKREG        ;
    AND     #~OLDCARON    ;
    BIT     _FSKREG,14     ; OldCarrier=Carrier
    BBZ     CarOn           ;
    OR      #OLDCARON     ;
CarOn
	SACL    _FSKREG        ;


; Automatic Gain Control

    SOVM
    ssxm
    LAC     #2000H
    SACL    AGCTEMP
    LT      AGCSamp        ;load sample band pass filtered
    MPY     AGCGAIN       ; mult by GAIN
    PAC 
    NORM    *             ;prevents overflow and saturates if required  
    NORM    *             ;
    NORM    *             ;
    NORM    *
    NORM    *             ;
    SACH    AGCSamp        ;
    ADDH    AGCSamp        ;
    SACH    AGCSamp        ;


    ABS                   ;compute new GAIN value   
    SUBH    AGCTEMP
    NEG
    SUB     AGCGAIN,14
    SACH    AGCTEMP
    ZALH    AGCGAIN
    ADDS    AGCGAIN+1
    ADD     AGCTEMP,8
    SACH    AGCGAIN
    SACL    AGCGAIN+1
    ROVM
;       rsxm


; Carrier detection
    LAC     AGCGAIN          ;
    SUB     _AGCTHRESH        ; if(y<=Threshold1)
    BLEZ    C1           ; {
    LAC     _FSKREG
    AND     #~CARRIERON   ;   Carrier=0
    SACL    _FSKREG        ;
                            ; }
    B       C2
C1  LAC     AGCGAIN          ; else if(y>=Threshold2)
    SUB     _AGCTHRESL       ;      {
    BGEZ    C3           ;        Carrier=1
    LAC     _FSKREG        ;
    OR      #CARRIERON    ;
    SACL    _FSKREG        ;      }
    B       C2           ;      else if(OldCarrier==0)
C3  BIT     _FSKREG,13     ;           {
    BBNZ    C4           ;
    LAC     _FSKREG        ;
    AND     #~CARRIERON   ;             Carrier=0
    SACL    _FSKREG        ;
;    B       EndCid        ;           }
    B       C2
C4  LAC     _FSKREG        ;           else {
    OR      #CARRIERON    ;                  Carrier=1
    SACL    _FSKREG        ;                }

C2
	RET
	   

;---------------------------------------
; Decision Unit
; 300 bauds
; at 8 kHz -> 26.66... samples per bit
; sample counter at 80, incremented by 3
; Input: Demodulated bit contained in AR3 
;---------------------------------------
FSKDec
        .newblock
     ssxm
     LDP	#_FSKREG
     BIT     _FSKREG,11     ;  if(stop_char)
     BBZ     $0            ;   {
     LAC     FSKCOUNT         ;     count++;
     ADD     #3            ;
     SACL    FSKCOUNT         ;
     SUB     DecCOUNT,1           ;     if(count>=80)
     BLZ     $1            ;     {
     				       ;       count=0,1,2;
     SACL    FSKCOUNT         ;
     LAC     _FSKREG        ;
     AND     #~STOPON      ;       stop_char=0;
     SACL    _FSKREG        ;     }
     B       $1            ;   }
$0:  MAR     *,AR3         ;   else
     LACC    *             ;   {
     BIT     _FSKREG,12     ;     if(!(out[i] || start_char))
     BBZ     $2           ;
     OR      #1            ;
$2   BNZ     $3            ;     {
     SACL    FSKCHAR          ;       char=0;
     LAC     FSKCOUNT         ;       count++;
     ADD     #3            ;
     SACL    FSKCOUNT         ;
     SUB     DecCOUNT          ;       if(count>=40)
     BLZ     $3            ;       {
     SACL    FSKCOUNT         ;         count=0;
     LAC     _FSKREG        ;         start_char=1;
     OR      #STARTON      ;
     SACL    _FSKREG        ;       }
$3:  BIT     _FSKREG,12     ;     }
     BBZ     $1            ;     if(start_char)
     LAC     FSKCOUNT         ;     {
     ADD     #3            ;       count++;
     SACL    FSKCOUNT         ;
     SUB     DecCOUNT,1           ;       if(count>=80)
     BLZ     $1            ;       {
     LAC     *             ;         acc=out[i];
     AND     #01h          ;         acc=acc&0x01;
     RPT     FSKC             ;         acc=acc<<(c+1);
     SFL                   ;
     SFR                  ;
     NOP                   ;
     OR      FSKCHAR          ;         acc=acc|char;
     SACL    FSKCHAR          ;         char=char|((out[i]&0x01)<<c);
     LAC     FSKC             ;         c++;
     ADD     #1            ;
     SACL    FSKC             ;
     SUB     #8            ;         if(c>=8)
     BLZ     $4            ;         {
     ZAC            ;
     SACL    FSKC             ;           c=0;
     LAC     _FSKREG        ;
     AND     #~STARTON     ;           start_char=0;
     OR      #STOPON       ;           stop_char=1;
     OR      #CHARON       ;           char_available=1
     AND     #00FFh        ;
     SACL    _FSKREG        ;

     LAC     FSKCHAR,8        ;
     OR      _FSKREG        ;
     SACL    _FSKREG        ;         }

     LAC     FSKCHAR,8        ;
	 ldp	 #OUT
	 lar	 ar3,OUT
	 sacl	*
	 call	UpdatPtr

$4:  LAC     #0            ;         count=0;
     ldp	#FSKCOUNT
     SACL    FSKCOUNT         ;       }
$1: 
	 RET




V21LPCoef
*
* FIR Coefficients for high band and low band
*
* Cutoff frequencies:
* Passband: 500 Hz
* Stopband: 1500 Hz
*
	.word    336  ;C014
	.word    971  ;C013
	.word   2072  ;C012
	.word   3592  ;C011
	.word   5338  ;C010
	.word   6986  ;C009
	.word   8170  ;C008
	.word   8602  ;C007
	.word   8170  ;C006
	.word   6986  ;C005
	.word   5338  ;C004
	.word   3592  ;C003
	.word   2072  ;C002
	.word    971  ;C001
	.word    336  ;C000


;	.word    2045  ;C027
;	.word    2102  ;C026
;	.word    3062  ;C025
;	.word    4200  ;C024
;	.word    5490  ;C023
;	.word    6902  ;C022
;	.word    8384  ;C021
;	.word    9881  ;C020
;	.word   11331  ;C019
;	.word   12668  ;C018
;	.word   13829  ;C017
;	.word   14756  ;C016
;	.word   15402  ;C015
;	.word   15734  ;C014
;	.word   15734  ;C013
;	.word   15402  ;C012
;	.word   14756  ;C011
;	.word   13829  ;C010
;	.word   12668  ;C009
;	.word   11331  ;C008
;	.word    9881  ;C007
;	.word    8384  ;C006
;	.word    6902  ;C005
;	.word    5490  ;C004
;	.word    4200  ;C003
;	.word    3062  ;C002
;	.word    2102  ;C001
;	.word    2045  ;C000


