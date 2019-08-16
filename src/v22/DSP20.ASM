;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;               V22 BIS MODEM
;
; ALL RIGHTS RESERVED BY TEXAS INSTRUMENTS  (C)

;
;--------------------------------------------------------
;       CONSTANT DEFINITIONS
;--------------------------------------------------------
;
     .include   "..\msp58c80.i8x"
     .include   "..\global.inc"
     .include   "..\dsp20.i8x"

     .text
;_____________________________________________________________________
;       COMMAND MODE SUBROUTINE LOOK-UP TABLE
;               IN COMMAND MODE, EACH COMMAND BYTE CORRESPONDS TO
;               AN ENTRY HERE WHICH CONTAINS THE NAME OF THE
;               APPROPRIATE SUBROUTINE TO CALL TO EXECUTE THE COMMAND.
;______________________________________________________________________
;
CMDTBL:
     .word   NONE    ; 00  no command
     .word   DMOD2   ; 1X  SEND X IN 2400
     .word   DMOD1   ; 2X  SEND X IN 1200
     .word   RESET   ; 3X  RESET THE DSP
     .word   EQUEN   ; 4X  ENABLE TIMING RECOVERY
     .word   Error1  ; 5X  FSK DATA MODE
     .word   Error1  ; 6X  hang
     .word   RMODE   ; 7X  RECVR. MODE SETUP
                     ;  70: receive idle
                     ;  71: call progress monitor
                     ;  72: receive data
     .word   XMODE   ; 8X  TRANS. MODE SETUP
                     ;  80: transmit iddle   
                     ;  81: transmit answer tone
                     ;  82: transmit enable 
                     ;  83:
     .word   Error1  ; 9X  hang
     .word   Error1  ; AX  hang
     .word   Error1  ; BX  hang
     .word   Error1  ; CX  hang
     .word   Error1  ; DX  hang
     .word   Error1  ; EX  hang
     .word   PROTO   ; FX  PROTOCOL SELECT
                     ;  1111 ABCC
                     ;  A: 0=ORIGINATE  1=ANSWER
                     ;  B:
                     ;  CC:   
                     ;   00: 
                     ;   01: 
                     ;   10: 1200BPS
                     ;   11: 2400BPS
;
Error1				; in case of command error
		dint
		b		$
;
;---------------------------------------------------------------
;
;       PLL     DATA
;
PHNTAB:
     .word   16384
     .word   3277
     .word   1820
;
;       AGC     DATA
;
HYSINC: .word 0F0Fh  ;1/17 of  65536
;
;       SXDET   DATA
;
;LEVEL0: .word 0800h  ; S0 THRESHOLD
;LEVEL1: .word 03Ah   ; S1 THRESHOLD
LEVEL0 .set 0800h  ; S0 THRESHOLD
LEVEL1 .set 058h   ; S1 THRESHOLD 60h
;-------------------------------------------------
;       Interpolation filter coefficients.
;-------------------------------------------------
	.include	"inte.asm"
;-------------------------------------------------
;       ADDITIONAL TABLES
;-------------------------------------------------
;
     .copy   "TXTBL.TBL" ; CONSTELLATION
	.copy "8k_0.tbl"
	.copy "8k_1.tbl"
	.copy "8k_2.tbl"
	
     .copy   "COSTBL.TBL" ; COSINE FUNCTION TABLE
;
;------------------------
;
; data for Fifo
;
;------------------------
FifoOut     .usect  "reloc",14+14 ; FIFO with samples for DA
FifoIn      .usect  "reloc",NB_COEFF+3*14  ; FIFO with samples from AD margin of 8
;FifoIn      .usect  "reloc",NB_COEFF+3*14-7 ; FIFO with samples from AD margin of 1
;---------------------
;
; new it sigma delta with task switch
;
;---------------------
;
;---- data
;
OsStack .usect  "TSave",36  ; OsStack
ModemStat .usect "TSave",1  ; flag for OS
ModemOut .usect "TSave",1   ; output pointeur
ModemIn .usect  "TSave",1   ; input pointer

;---------------------------
;
;----- program
; 
;-----------------------
;
     .copy   "CCIDTM.ASM"
     .copy   "ENCODE.ASM"
     .copy   "SINGEN.ASM"
     .copy   "COSGEN.ASM"
;
     .copy   "RXIIR.ASM"
;
     .copy   "RTASKC.ASM"
     .copy   "TMRCVC.ASM"
     .copy   "DLUPDT.ASM"
;
     .copy   "QUAN24.ASM"
     .copy   "QUAN12.ASM"
     .copy   "DIFDEC.ASM"
;
;       EQUALIZER FILES
;
     .copy   "PLL2.ASM"
     .copy   "UPDATE.ASM"
     .copy   "UPERR.ASM"
     .copy   "IFIR.ASM"
;
     .copy   "AGC.ASM"
     .copy   "INTERP.ASM"
     .copy   "SXDET.ASM"

