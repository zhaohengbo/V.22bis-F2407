
/* AT command set */

#include "common.h"
#include "dtmf.h"
#include "Filters.h"


/* #include <ctype.h> */ /* take too much .bss */

/* for debug */
int s98,s99; /* registers s98 s99 */
int s0=0; /* register s0 */
int V14NbStop=8; /* number of characteres before overspeed */
int scan(char *Buf);
/* return the value read in Buf */


int Modul=MV22b + MCalling; /* modulation mode */

int AS; /* 1: detection of alerting signal for CID */
        /* 0: no detection of alerting signal */
int Mode;
int Loop; /* ON digital local loop */

int Connect=OFF; /* ON: data mode; OFF: command mode */
int Command=ON;
int *RPtOut0=&RBuffr; /* pointer on start of line in RBuff */
int Guard=0x32; /* guard tone : 0=no 31h=550(not implemented) 32h=1800 */
int TGGain=4000; /* gain for guard tone */

char transfer_buf[32];



/* --------- external function --------- */
int GetData(void);
/* get data from receive uart */
/* return:
;   DDDD DDDD SSSS SSSS
;   D: DATA
;   S: STATUS WITH OVERFLOW (FLAG10) AND DATA PRESENT (FLAG20)
;   CLEAR OVERFLOW FLAG AND RESET POINTER IF OVERFLOW
*/

 
int Carrier(void); /* return 0 (false) if no carrier */
int SendData(int Data); /* send data to external UART */
int ReadData(void); /* get data from external UART */
void FConnect(void); /* connect to line */
void FDisConnect(void); /* disconnect from line */
void modemini(void);
void StartUart(void); /* initialize V14 */ 
void InitScram(void); /* " */
int V22b(void);
void Manage_CID(void);
void reset_imp(void);
int abort(void);
void InitNotch(void);
int Calling(int WDial, int Digit);
int ModemFSK(void);
int V14Send(int Data); /* return:  0 if OK, 1 if buffer full  */
int V14Stat(void); /* return:  0 if OK, 1 if buffer full  */


/* --------- internal function ---------- */

void AnalyseOn(void);
/* analyse buffer in connect mode */
void AnalyseOff(void);
/* analyse buffer in disconnect mode */
int GetNext(int **Pt);
/* return tolower(*((*Pt)++)) from RBuffr */          
int GetPrevious(int **Pt);
/* return tolower(*(--(*Pt))) from RBuffr */
int isdigit(int Data);
/* return -1 if digit 0 if not */
void ManageUart(void);
/* manage external UART link */
void Print(char *Pt);
/* send to UART */
void PrintOk(void);
/* send message OK */
void PrintError(void);
/* send message Error */
int tolower(int Data);
/* return lower case of data */

void Dial(int Digit); /* send a DTMF code with silence */
int ReadTable(int *table); /* reads character table into buffer */

/* external variables */
extern int OK[], NoCarrier[], Error[], Connect1200[], Connect2400[];
extern int CidRing[], CidDT[];
extern int NoDial[], Busy[], V22BIS[], V22[], V21[], V23[], CONNECT[];
extern int CON1275[], CON7512[]; 

main()
{
    Print("Hello world."); /* for test */
    Loop=OFF;
    for(;;){
        ManageUart();
    }
}


void ManageUart(void)
/* manage external UART link */
/* interpretation of AT command set */
{
    int LastC; /* last received char */
    
    /* CID management */
    if (CID==CIDMode)
            Manage_CID(); 


    /* -------- RX management ---------- */
    if((Command==OFF) && (Connect==ON)){
         LastC=GetData(); /* data from demodulation ? */
         if((LastC & FLAG20)!= 0){
            LastC=0xff & (LastC>>8);
            if(Loop==ON){
                /* digital loop */
                while(V14Send(LastC)==1); /* send characters to modulation */
            }else{
                while(SendData(LastC)<0); /* send to UART */
            }
         }
    }
    
    if(Connect==ON){
         if ((CID==FSKV23) || (CID==FSKV21)){
            if (ModemFSK()){
                FDisConnect();  /* no carrier -> return to command mode */
                Connect=OFF;
                PrintTab(NoCarrier);
                Command=ON;
            }
        }else{

    /* -------- carrier detect --------- */
            if(!Carrier()){
                FDisConnect();
                Connect=OFF;
                PrintTab(NoCarrier);
                Command=ON;
            }
        }
    }

    /* ------ TX management -------- */
    if(Command==OFF){
        if(!V14Stat()){
            /* V14 is free */
            LastC=ReadData(); /* get a character */
            if(LastC>=0){ /* is there a character */
                /* character available */
                switch(LastC){
                    case '\r':
                        AnalyseOn();
                        break;
                }
                while(V14Send(LastC)==1); /* send characters to modulation */
                RPtOut0=RPtOut; /* resynchronization */
            }
        }
    }else{
        LastC=ReadData(); /* get a character */
        if(LastC>=0){ /* is there a character */
            SendData(LastC); /* echo data */
            if(RPtOut0==RPtOut){
                /* buffer full */
                GetNext(&RPtOut0);
                /* PrintError(); */
            }
            switch(LastC){
                case '\r':
                    AnalyseOff();
                    break;
            }
        }
    }
}


void AnalyseOn(void)
/* analyse buffer in connect mode */
{
    int *Pt1;
    int C0;
    /* look for +++at */

    Pt1=RPtOut; /* point on last character */
    if(GetPrevious(&Pt1)!='\r') return;
    if(GetPrevious(&Pt1)!='t') return;
    if(GetPrevious(&Pt1)!='a') return;
    if(GetPrevious(&Pt1)!='+') return;
    if(GetPrevious(&Pt1)!='+') return;
    if(GetPrevious(&Pt1)!='+') return;

    /* -------- +++at received -------- */


    Command=ON;
    RPtOut0=RPtOut;
    PrintOk();
}



void AnalyseOff(void)
/* analyse buffer in disconnect mode */
{
    int c0;
    int i0;
    int i1,i2;
    char cBuff0[8];


    /* check AT */
    for(;;){
        /* look for a */
        c0=GetNext(&RPtOut0);
        for(;;){
            if(c0=='a'){
                c0=GetNext(&RPtOut0);
                if(c0=='t') break;
            }else if(c0=='\r') break;
            else  c0=GetNext(&RPtOut0);
        }
        if(c0=='\r') {
            break;
        }
        switch(GetNext(&RPtOut0)){
            case '&':
                switch(GetNext(&RPtOut0)){
                    case 'g': /* guard tone */
                        Guard=GetNext(&RPtOut0);
                        PrintOk();
                        break;
                }
                break;
            case 'a': /* connect */
                F_ATA(); /* connect in answer mode */
                break;
            case 'c': /* caller ID mode */
                switch(GetNext(&RPtOut0)){
                    case '0':
                        AS=0; /* ring alerting signal */
                        reset_imp();
                        PrintTab(CidRing);
                        PrintOk();
                        break;
                    case '1':
                        AS=1; /* dual tone alerting signal */
                        reset_imp();
                        PrintTab(CidDT);
                        PrintOk();
                        break;
                    default:
                        PrintError();
                        break;
                }
                break;
            case 'd': /* v22b calling */
                /* calling mode */
                Modul=Modul | MCalling;

                /* dial */
                c0=GetNext(&RPtOut0);
                if(c0=='t') c0=GetNext(&RPtOut0);
                /* blind dialling */
                if(c0==','){
                    c0=GetNext(&RPtOut0);
                    Tim0=0;
                    i1=0;
                    do{
                        if (Tim0 > 9600){
                            Tim0=0;
                            i1++;
                        }
                        if (abort())
                            break;
                    }while(i1<=5);      /* wait for 5s before dialling*/

                    i0=Calling(0, c0);
                }
                else if (isdigit(c0))
                    i0=Calling(1, c0);
                else if (c0=='\r')
                    i0=Calling(0, c0); /* manual connection without dialing */ 
                else{
                    PrintError();
                    break;
                }

                if (i0==RAnswer){
                    i0=V22b(); /* start modem protocol */
                }

                switch(i0){
                    case RV22b:
                        PrintTab(Connect2400);
                        Connect=ON;
                        Command=OFF;
                        break;
                    case RV22:
                        PrintTab(Connect1200);
                        Connect=ON;
                        Command=OFF;
                        break;
                    case RV21:
                        PrintTab(CONNECT);
                        Connect=ON;
                        Command=OFF;
                        break;
                    case RV23:
                        PrintTab(CON7512);
                        Connect=ON;
                        Command=OFF;
                        break;
                    case RNoDial:
                        PrintTab(NoDial);
                        FDisConnect();                          
                        break;
                    case RBusy:
                        PrintTab(Busy);
                        FDisConnect();
                        break;                      
                    case RNoCarrier:
                        PrintTab(NoCarrier);
                        FDisConnect();
                        break;
                    case RAbort:                         
                        PrintTab(NoCarrier);
                        FDisConnect();
                        break;
                    default:
                        FDisConnect();
                        Print("Unknown code");
                        break;
                }/* end switch */
                break;

            case 'h': 
                if (GetNext(&RPtOut0)=='1')     /* connect to line */
                    FConnect();
                else{/* disconnect */
                    FDisConnect();
                    Connect=OFF;
                }
                PrintOk();
                break;
            case 'i': /* send release number */
				Print("Ver V67b");
#if IsDsk
#else
                if( (*(int *)3)==(640-1)) Print("12mips");
                if( (*(int *)3)==(427-1)) Print("8mips"); 
                if( (*(int *)3)==(373-1)) Print("7mips"); 
                if( (*(int *)3)==(320-1)) Print("6mips"); 
#endif
                PrintOk();
                break;
            case 'l': /* digital local loop */
                if(Loop==OFF) Loop=ON;
                else          Loop=OFF;
                PrintOk();
                break;
            case 'n': /* speed */
                i0=GetNext(&RPtOut0);
                if(i0=='?'){
                    switch(Modul & MModul){
                        case MV22b:
                            PrintTab(V22BIS);
                            PrintOk();
                            break;
                        case MV22:          
                            PrintTab(V22);
                            PrintOk();
                            break;
                        case MV21:          
                            PrintTab(V21);
                            PrintOk();
                            break;
                        case MV23:          
                            PrintTab(V23);
                            PrintOk();
                            break;
                        default:
                            Print("Unimplemented modulation");
                            PrintOk();
                            break;
                    }
                }else{
                    switch(i0-'0'){
                        case 0:
                            Modul=(Modul & (~MModul))  | MV22b;
                            PrintOk();
                            break;
                        case 1:
                            Modul=(Modul & (~MModul))  | MV22;
                            PrintOk();
                            break;
                        case 2:
                            Modul=(Modul & (~MModul))  | MV21;
                            PrintOk();
                            break;
                        case 3:
                            Modul=(Modul & (~MModul))  | MV23;
                            PrintOk();
                            break;
                        default:
                            PrintError();
                            break;
                    }
                }
                break;
            case 'o': /* no command */
                if(Connect==ON){
                    PrintTab(CONNECT);
                    Command=OFF;
                }else{
                    PrintError();
                }
                break;
            case 's': /* register */
                /* get number */
                for(i1=0;i1<3;i1++){
                    i0=GetNext(&RPtOut0);
                    if(!isdigit(i0)) break;
                    cBuff0[i1]=i0;
                }
                cBuff0[i1]=0;
                i2=scan(cBuff0);
                switch(i0){
                    case '?':
                        switch(i2){
                            case 0:
                                if(s0==0) Print("0");
                                else      Print("1");
                                break;
                            case 98:
                                break;
                            case 99:
                                break;
                        }
                        break;
                    case '=':
                        /* get value */
                        for(i1=0;i1<7;i1++){
                            i0=GetNext(&RPtOut0);
                            if(!isdigit(i0)) break;
                            cBuff0[i1]=i0;
                        }
                        cBuff0[i1]=0;
                        i1=scan(cBuff0);
                        switch(i2){
                            case 0:
                                s0=i1;
                                break;
                            case 98:
                                s98=i1;
                                break;
                            case 99:
                                s99=i1;
                                break;
                        }
                        PrintOk();
                        break;
                    case '\r':
                    default:
                        PrintError();
                        break;
                }
                break; 
            case '\r': /* at */
                PrintOk();
                break;
            default:
                PrintError();
                break;
        }
        break;
    }
    RPtOut0=RPtOut;
}

void F_ATA(void)
/* connect in answer mode */
{
    FConnect();
    /* answering mode */
    Modul=Modul & (~MCalling);
    switch(V22b()){ /* start modem protocol */
        case RV22b:
            PrintTab(Connect2400);
            Connect=ON;
            Command=OFF;
            break;

         case RV22:
            PrintTab(Connect1200);
            Connect=ON;
            Command=OFF;
            break;

        case RV21:
            PrintTab(CONNECT);
            Connect=ON;
            Command=OFF;
            break;

        case RV23:
            PrintTab(CON1275);
            Connect=ON;
            Command=OFF;
            break;

        case RNoCarrier:
            PrintTab(NoCarrier);
            FDisConnect();
            break;

        case RAbort:
            PrintTab(NoCarrier);
            FDisConnect();
            break;

    }
}


int scan(char *Buf)
/* return the value read in Buf */
{
    int i0,Ret;

    Ret=0;
    i0=0;
    while(Buf[i0]!=0){
        Ret=Ret*10+Buf[i0]-'0';
        i0++;
    }
    return Ret;
}

void Print(char *Pt)
/* send to UART */
/* send CR LF before and after */
/* stop on first 0 */
{
    while(SendData('\r')<0);
    while(SendData('\n')<0);    
    while(*Pt!=0){
        while(SendData(*Pt)<0);
        Pt++;
    }
    while(SendData('\r')<0);
    while(SendData('\n')<0);    
}


int GetNext(int **Pt)
/* return tolower(*((*Pt)++)) from RBuffr */
{
    int c0;
    
    c0=*((*Pt)++);
    if(*Pt>&RLast) *Pt=&RBuffr;
    return tolower(c0);    
}


int GetPrevious(int **Pt)
/* return tolower(*(--(*Pt))) from RBuffr */
{
    int C0;

    (*Pt)--;
    if((*Pt)<&RBuffr) *Pt=&RLast;
    return tolower((**Pt));
}


void PrintOk(void)
/* send message OK */
{
    PrintTab(OK);
}

void PrintError(void)
/* send message Error */
{
    PrintTab(Error);
}


int tolower(int Data)
/* return lower case of data */
{
    if((Data>='A') && (Data<='Z')) Data=Data+('a'-'A');
    return Data;
}

int isdigit(int Data)
/* return 1 if digit 0 if not */
{
    if((Data>='0') && (Data<='9')) return 1;
    else if((Data >='a') && (Data <='d')) return 1;
    else if((Data=='*')  || (Data == '#')) return 1;
    else    return 0;
}


int ReadTable(int *table)
{
    int i=0;
    char temp;

    do{
        temp=table_read(table+(i>>1));
        if (temp == 0)
            break;
        transfer_buf[i]=temp>>8;
        i++;
        if ((temp & 0x00ff) == 0)
            break;
        transfer_buf[i]=temp & 0x00ff;
        i++;

    }while(i < 32);

    transfer_buf[i]=0;      /* if no character is added afterwards, i indicates last element */
                                    
    return i;
}



void PrintTab(int *table)
{
    ReadTable(table);
    Print(transfer_buf);
}


void PrintFSK(char *Pt)
/* send to UART */
/* stop on first 0 */
{
    while(*Pt!=0){
        while(SendData(*Pt)<0);
        Pt++;
    }
}
