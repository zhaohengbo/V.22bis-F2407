*******************************************************************************
*   File:           dsp20ini.asm
*
*
*   Description:    modem initialization
*
*******************************************************************************
     .include "..\msp58c80.i8x"
     .include "..\global.inc"
     .include "..\common.inc"

     .text
;--------------------------
;
; void modemini(void)
; 
; intialisation of modem variable
; this routine must be run before activating the modem functions
; even the interrupt routine (CID=Modem)
;
;--------------------------

_modemini:

;
; Clear mpage4
;
     dint
;
     ZAC
     LARP    AR3
     LAR     AR3,#begin4    ; start of mpage4
     rpt    #Total4-1
     sacl   *+
;
; Clear mpage5
;
     LAR     AR3,#begin5    ; first variable of mpage5
     lac    #end5
     sub    #begin5+1
     sacl   *
     lar    ar4,*
     ZAC
CLEAR5
     SACL    *+, AR4
     BANZ    CLEAR5,*-,AR3

     lar    ar3,#FifoOut                    
ClearTransmit
     rptk   #15
     sacl   *+
;
; Initialize page 4 data
;
     LACK    TimeDelay      
     LDPK    #begin4
     SACL    IRCNT      ;Timing in range counter
     LACK    2          ;INITIALIZE AT 1200 BPS
     SACL    STATUS     ;TX,RX IDLE. LINE MODE; originate, no guard tone
     LACK    1
     SACL    ONE
;
;Initialize carrier phase
;
    lac     #7fffh
     SACL    JREAL
;
;Initialize equalizer
;
     LAC     ONE,14
     SACL    C5R     ; initialize C5R to 1 in S1.14
;
;Initialize agc gain and lock indicator. (MOD. 5/29)
;
     LALK    #MAXALP
     SACL    _ALPHA   ; set alpha to its max poss. val.
;
;Initialize hysteris counter to >8000
;
     LAC     ONE,15
     SACL    HYST
;
; init buffer pointer
;
    lar     ARIn,#FifoIn
    lar     AROut,#FifoOut+13
;
    zac
    mar     *,AROut
    sacl    *

    lac     #1
    ldpk    #FifoOutCnt
    sacl    FifoOutCnt

    lac     #2
    ldp     #ModulSeq
    sacl    ModulSeq
;
; Init OsStack
    lac     #OsStack
    ldpk    #POsStack
    sacl    POsStack
;
    zac
    ldpk    #ModemStat
    sacl    ModemStat

    zac
    ldpk    #Cmd1
    sacl    Cmd1
    ldpk    #Cmd2
    sacl    Cmd2        
    ldpk    #_mdm_sta
    sacl    _mdm_sta
    lack    #ModemMode
    ldpk    #_CID
    sacl    _CID
;
    call    StartUart0
    call    _InitScram  ; warning eint
;
    eint
    larp    ar1

     RET

