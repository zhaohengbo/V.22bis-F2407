*********************************************************************
*   File:           global.inc
*
*   Description:    This is the include file for the dsp20 modem.
*
*
*********************************************************************



;--------------------
;
; Debug variables
;
;--------------------

UseTest .set    0           ; if != 0 use the _test variable (defined in C)
        .if     UseTest
        .global _test
        .endif

UseDram .set    0           ; if != 0  the DRAM is initialized
TRACE   .EQU    0           ; 0 NO DRAM TRACE   1:TRACE in DRAM
                            ; warning UseDram flag must be set
        .global IB00, IB01  ; debug function
UseTim19 .set   0           ; if !=0 Tim19 is created (Timer 19.2kHz)

UartTest .equ   0
TRxOverflow .equ 0      ; !=0 block system on receive buffer overflow (main.asm)
TModOverrun .equ 0      ; !=0 block system if Modulation interrupted by Modulation
TMips   .equ    0       ; !=0 load CPU for Mips mesurement

CBacc	.set	0		; if !=0 check BACC address  

    .if UseTim19
    .global Tim19
    .endif

;--------------------
;
;
;
;--------------------
; The following values are the calculated values with no
; window implementation around the theoretical energy
; band of QAM signals. However, due to ISI effects, windows
; are required. For proper operation, these values must be
; adjusted for approximately 3 dB difference in signal energy
; levels to compensate for the windows.
;
MAXALP .set 038A1h ;-52.0 dbm receive level
PSM: .set   01EA6h  ;baud energy error level 10628
;NSM: .set   0113h   ;baud energy error level 1
NSM: .set   1000h   ;baud energy error level 1

;
; B0 definition
;

; position of TX, RX, CTS, DSR
TX      .set    0002h   ; TX (B1)
TXPos   .set    1    
RX      .set    0020h   ; RX (B5)
CTS     .set    0080h   ; RST (B7)
DSR     .set    0100h   ; DSR (B8)
CD      .set    0200h   ; CD (B9)
RI      .set    0400h   ; RI (B10)
CON     .set    4000h   ; 0=connect 

        .global ForDA   ; next sample to send on DA
        .global FromAD  ; last sample from AD




;
; PLL EQUATES
;
G1:     .equ     203    ; offset compensation
G2:     .equ     20     ; frequency compensation
INVPI:  .equ     1304   ; Pi inverted IN (4,12) FORMAT
;
G3:     .equ     0300h
BJ1:    .equ     3329
BJ2:    .equ     -2032
AJ1:    .equ     -1640
;
; AGC EQUATES
;
AGCREF: .equ     05b6h
;
; SXDET EQUATES
;
GAINS0: .equ     233
COFS0:  .equ     -3700
B0LP:   .equ     56
B1LP:   .equ     -84
B2LP:   .equ     56
A1LP:   .equ     3805
A2LP:   .equ     -1786
BETAS0: .equ     0800h
BETAS1: .equ     0600h
;
;       HIGH PASS FILTER CONSTANT
;
TAU:    .equ     14      ;16 - 14


TimeDelay .equ  20      ; number of symbole for clock recovery


;       DATA MEMORY (RAM) ASSIGNMENTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; page 4 (ldpk 4) ldpk gegin4
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        .global begin4
        .global STATUS
; 

ANMSK:  .equ     3     ; bit in STATUS 1=ANALOG loop
; set bits 5 & 4 in STATUS = 10 DIGITAL LOOPBACK
RMMSK:  .equ    0C0h    ; receive mode mask
NTXMSK: .equ    0CFh    ; neg of trans mode mask (8bit)
NRCMSK: .equ    03Fh    ; neg of receive mode mask (8bit)
NSPMSK: .equ    0FCh    ; neg of speed mask (8bit)
TXSH:   .equ    04h     ; first transmit mode bit (shift)
RCSH:   .equ    06h     ; first receive mode bit (shift)
SBit1   .equ    1       ; bit 1 for status
SBit2   .equ    2       ; bit 2 for status
SBit4   .equ    4       ; bit 4 for status
SBit5   .equ    5       ; bit 5 for status
SBit10  .equ    10      ; bit 10 for status (guard tone bits)


		.global XShape0, XShape1, XShape2
        .global CosBuf, SinBuf
        .global Shape, NbSamp, ModulSeq
        .global XDATA, ONE
        .global S1CNT
        .global STWRD
BitEne  .set    6   ; position of energy detect

        .global XBITS, XOUT
        .global RIN, RXFRQ, RXPHS
        .global PtSin,PtCos,ShiftI,ShiftR
        .global LASTQ
        .global RPQUAD, TMP4, TMP5
;
;       RAM LOCATION DEFINITIONS FOR THE REAL
;       RECEIVER LOWPASS FILTER
;
        .global URDEL1, TMP2, WRDEL1, WRDEL2, TMP0
        .global XRM1, XRM2
;
;       RAM LOCATION DEFINITIONS FOR THE IMAGINARY
;       RECEIVER LOWPASS FILTER
;
        .global UIDEL1, TMP3, WIDEL1, WIDEL2, TMP1
        .global XIM1, XIM2
;
;       TIMING RECOVERY VARIABLES
;
        .global STAT2, AVECNT, TMFUNC, IRCNT, TIMIND


;
;       INTERPOLATOR DELAY LINES
;
        .global IR0, IR1, IR2, IR3, II0
        .global II1, II2, II3
;
;       EQUALIZER DELAY LINES
;
        .global XTMPR, X0R, X5R, X8R, X9R
        .global XTMPI, X0I, X5I, X8I, X9I
;
;       EQUALIZER COEFFICIENTS
;
        .global C0R, C4R, C5R, C9R
        .global C0I, C4I, C5I, C9I
;
;       EQUALIZER       OUTPUT
;
        .global BETA, WREAL, WIMAG
;
;       UPDATE ERROR
;
        .global EREAL, EIMAG
;
;
;
;
;       PLL RAM
;
        .global YREAL, YIMAG, PREAL, PIMAG, JREAL, JIMAG
        .global PHERR, FROFF, PHFREQ, XXJ1, XXJ2
;
;       AGC     RAM
;
        .global _ALPHA, AVESQR, HYST
;
;       BAUD COUNTER
;
        .global BDCNTR
;
;       SXDET   RAMS
;
        .global Y0DEL2, Y0DEL1, SIGS0, YRLP1, YRLP2
        .global YILP1, YILP2, SIGS1
;
;       DEBUGGING PHASE RAMS
;
        .global CNVFL
;;
; temporary variable for transmit
        .global TxTmp0, TxTmp1, TxTmp2
        
        .global Total4


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       PAGE 5 RAM ASSIGNEMENTS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        .global begin5, end5


; added by YW 03/97 for test : comparison to C version
T_NO    .set    0   ; no transfer in YW 
T_TMP2  .set    1   ; YW <- signal after AGC before demodulation
T_COS   .set    2   ; YW <- output of cosgen
T_SIN   .set    3   ; YW <- output of singen

T_TEST  .set    T_NO


; BUFFER FOR LOW PASS FILTER AFTER DEMODULATION
;
NB_COEFF .SET   50      ; NUMBER OF COEFFICIENT
        .global YW

; timer context
        .global TSst1,TSst,TAccuh,TAccul,TAr0
        .global ItTmp1,ItSst1,ItSst


; BO port
LINE    .set    04000h  ; b14=0 connect to line

; transmit : sinus 4000h peak = -7.1dBm
; receive : 0dBm = sinus 4000h peak

AROut       .set    AR7
ARIn        .set    AR6
; bit position of ModemStat
BitDemod    .set    0   ; demodulation routine still running in background
BStat1      .set    1   ; 0-> next = demodulate state 15 to 8
                        ; 1-> next = demodulate state 7  to 0
BStat4      .set    4   ; used in debug (modulation on)

            .global FifoOut, FifoIn, FifoOutCnt, _Tim0, _CID
            .global P0Tmp1, ModemStat, ItPage0, ETmp1, POsStack
            .global OsStack
            .global ModemOut
            .global LocalBuff

;
; function
;
        .global RTSK0, S1DET, AGC, SXDET, RTSK4, IUPDT1
        .global RUPDT2, RUPDT1, RTSK8, RTSK9, RTSK10
        .global RTSK12, RTSK13, RTSK15
        .global SINGEN, CMULT1, COSGEN, DLUPDT, IFIR, RXIIR
        .global Demod, Demod0, Demod1, Demod2
        .global Modul0,Modul1
        .global CCI,ENCODE
        .global RSTSKN, TMRCV
		.global DemodSymb
		.global NONE

;
; ------ main.asm
;
        .global     Cmd1, Cmd2, _mdm_sta

; miscea
        .global _speed, _modemini
        .global ModemIn
        .global DemTab00, DemTab11
		.global DCos12,DCos24,DSin12,DSin24	; sine table for demodulation
		.global DSmC12,DSmC24
		.global ModulSeq


;***************************
;
; ------ v14.asm
;
;***************************

; variables
        .global UartStatus
; variables receive
        .global CPT64, MASK, D1803, D0201
; variables transmit

        .global BIT_COUNT,IN, OUT, Bit4, Bit4_V22
        .global Descram0, Descram1, FIRST_OUT, LAST_OUT, STATE
        .global ScShift0, ScShift1, ScCount64, Scram0
        .global SEND_IN, SEND_OUT, TransCount, BufferTrans, BufferTransLast
        .global V14TCpt8, _V14NbStop
		.global TPtOut,TBuffr,TLast,TPtIn
		.global	_RBuffr,RPtIn,_RPtOut,_RLast
; function
        .global RecUartWait
        .global Rec4, Get2, Get4, _InitScram
        .global _StartUart, _GetData, _V14Send, _descramble, _scramble
        .global StartUart0


;
        .global _Connect
        .global One
        .global COSOFF
        .global UartTransmit
        .global UpdatPtr


; bit in UartStatus
FLAG1   .set   1      ; overflow flag
RecOn   .set   2      ; ASM receiver is on
FLAG10  .set  1       ; overflow
FLAG20  .set  2       ; valid data

NbStop  .set    1     ; number of stop bit send to modulation



