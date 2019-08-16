#include "common.h"
#include "dtmf.h"
#include "Filters.h"                              

#define DEBUG_FILTER    0
#define DEBUG_DTMF      0
#define DEBUG           0


/* external functions and variables */
int GetNext(int **Pt);

extern int *RPtOut0;

#if DEBUG_FILTER                
void B00(void);
void B01(void);
#endif

void InitRXV23(void);
void InitTXV23(void);
void InitTXV21(void);
void InitTXV23(void);

void ResetFSK(void);

void StartUart(void);

/*----------------------------------*/


int Calling(int WDial, int Digit)
{
    int c0;
    int i0;
    int i1,i2;
    int ton,toff;
    int time;

    int onflag;

    c0=Digit;
    CID=NoMode;
    InitDTMF();
    InitTot();
    InitDial(); /* init CPT-filter */
    InitV23();
    InitV21();
    InitAnswer();
    CptdFilter = 0;
    FConnect();
    Tim0=0;
    CID=CPTMode; /* CPTD: check for dial tone */
    /* wait dial tone */
                
#if DEBUG_FILTER                
    Tim0=0;
    while(1){ /* for debug */
    
        if (CptdFilter & DialMask)    
            B01();
        else
            B00(); 

		if (abort()) return RNoCarrier;
    }
    /* end debug */
#endif

    /* if WDial !=0 wait for dial tone, else dial immediately after function call */
    if (WDial){
        ton=0; /* init tone on length */
        toff=0; /* init tone off length */

        for(i1=0;i1<600;i1++){ /* timout at 6sec */
            for(Tim0=0;Tim0<80;); /* wait 10ms */
            if(CptdFilter & DialMask){
                ton++;
                toff=0;
            }else{
                toff++;
                if(toff>3) ton=0; /* hole of more than 30ms */
            }
            if(ton>=160) break; /* 1.6s of tone -> ok */
            if (abort()) return RAbort;
        }
        if (ton<160) return RNoDial; /* no dial tone detected */
    }
   
   /* init */                
   while(isdigit(c0)){
       Dial(c0);
       c0=GetNext(&RPtOut0);
   }

   Tim0=0;
   InitTot();
   InitBusy();  
   InitAnswer(); /* init filter 2100 Hz */
   InitNotch(); /* 1300 Hz rejection filter */
   Send1300();
   
   
   /* busy tone detector: cadence 375ms +/- 10%, 3s of busy tone min. */
   /* answer tone detector: min. of 300ms of 2100 Hz */ 
   /* calling tone generator: 1.8s of silence, 0.6s of tone burst */
   Tim0=0;
   i0=0;
   i1=0;    /* count for timeout, incremented every 10 ms */
   i2=0;    /* count for calling tone, starts with silence */
   ton=0;   /* busy tone cadence: ontime */
   toff=0;  /* offtime */
   time=0;  /* answer tone counter */
   onflag=0;
   DtmfFlag=0;
   do{
    if (CptdFilter & DialMask){
        while (Tim0 < 80){  /* i1 incremented every 10ms */
            if (i2 > 180){  /* 1.8s silence */
                DtmfFlag=CallTone;
            }
            else {
                DtmfFlag=0;
            }
                    
        }
        Tim0=0;
        i1++;
        i2++;
        ton++;
        
        if (!(onflag)){
            if (ton>3){
                onflag=0x0001;  /* transition off/ on */
                if ((toff >= BusyOffMin) && (toff <= BusyOffMax))
                    i0++;
                else if (toff>3)
                    i0=0;

                toff=0;
            }
            else    toff++;
        }
    }
    else if (! CptdFilter){
        while (Tim0 < 80){  /* i1 incremented every 10ms */
            if (i2 > 180){  /* 1.8s silence */
                DtmfFlag=CallTone;
            }
            else{
                 DtmfFlag=0;
            }
        }
        Tim0=0;
        i1++;
        i2++;
        toff++;

        if ((onflag & 0x0001)){
            if (toff>3){
                onflag=0x0000;  /* transition on/off */
                if ((ton >= BusyOnMin) && (ton <= BusyOnMax))
                    i0++;
                else 
                    i0=0;

                ton=0;
            }
            else    ton++;
        }
    }

    if (i2 > 180 + 60)  i2=0; /* reset counter after 600 ms burst */

    /* detect answer tone during 1.5 + (0.3) s of silence */
    if (i2 < 150){
        time=0;
        DtmfFlag=0;

#if DEBUG
        return RAnswer;
#endif

        while (CptdFilter & AnswerMask){
            if (Tim0 > 80){ /* 10 ms counter */
                Tim0=0;
                time++;
                i2++;
            }
            if (time>30)         /* 300 ms of answer tone received */      
                break;

        }   
        if (time<=30)
            time=0;
        
        while (CptdFilter & V23Mask){
            if (Tim0 > 80){ /* 10 ms counter */
                Tim0=0;
                time++;
                i2++;
            }
            if (time>50){        /* 500 ms of answer tone received */      
                CID=NoMode;
                InitRXV23();
                InitTXV23();
                CID=FSKV23;
                Tim0=0;
                while(Tim0<120);    /* wait for 15ms for AGC and filter convergence */
                StartUart();
                ResetFSK();                                           
                return RV23;
            }
        } 
        if (time<=30)
            time=0;
        
        while (CptdFilter & V21Mask){
            if (Tim0 > 80){ /* 10 ms counter */
                Tim0=0;
                time++;
                i2++;
            }
            if (time>50){        /* 500 ms of answer tone received */      
                CID=NoMode;
                InitRXV21();
                InitTXV21();
                CID=FSKV21;
                Tim0=0;
                while(Tim0<120);    /* wait for 15ms for AGC and filter convergence */
                StartUart();
                ResetFSK();                                           
                return RV21;
            }

        } 
    } 
    else if (CptdFilter & 0x000e){
        CptdFilter=0;
        while (Tim0<80); /* wait 10 ms */
        Tim0=0;
        i2++;
    }

    if (time>30) break;     
                                        
    if (i0 >=6)         /* length of busy tone x 6 in seconds of busy tone received */
        return RBusy;

    if (abort()) return RAbort;
                
                
   }while (i1 <= 6000);  /* timeout 60 s */
   
                                                                                                       
   if (time>30){
    while (CptdFilter & AnswerMask){ /* wait for end of answer tone */
        if (abort()) return RAbort;
    }
    return RAnswer;
    }
   else return RNoCarrier;
}


/* DTMF generator for dialing */
void Dial(int Digit)
{
    int temp;

    if (Digit=='*')
        temp=10;
    else if (Digit=='#')
        temp=11;
    else if (Digit>='a')
        temp=Digit-85;
    else
        temp=Digit & 0x000f; /* mask 4 LSB which contain digit */

    temp<<=2; /* offset for ToneTable, 4 entries for each digit/tone */

    Phi1=0;     /* init phase */
    Phi2=0;

    DeltaPhi1=table_read(ToneTable+temp);       /* init step1 for low freq. */
    DeltaPhi2=table_read(ToneTable+temp+1);     /* init step2 for high freq. */

    Ampl1=table_read(ToneTable+temp+2);     /* DTMF gain low */     
    Ampl2=table_read(ToneTable+temp+3);     /* DTMF gain high */
    DtmfFlag=1;

#if DEBUG_DTMF
    while(1){
        if (abort()) break; /* for debug */
    }
#endif

    Tim0=0;
    while(Tim0 < DTMF_TimeOn);      /* wait for DTMF-time */

    DtmfFlag=0;
    Ampl1=0;        /* stop DTMF */
    Ampl2=0;

    Tim0=0;
    while(Tim0 < DTMF_TimeOff);         /* silence */
}


/* Calling tone generator */
void Send1300 (void)
{
    int temp=16;

    temp<<=2; /* offset for ToneTable, 4 entries for each digit/tone */

    Phi1=0;     /* init phase */
    Phi2=0;

    DeltaPhi1=table_read(ToneTable+temp);       /* init step1 for low freq. */
    DeltaPhi2=table_read(ToneTable+temp+1);     /* init step2 for high freq. */

    Ampl1=table_read(ToneTable+temp+2);         /* single tone */
    Ampl2=0;
}



void InitDTMF(void)
{
    DtmfFlag=0;
    Ampl1=0;        /* be sure that nothing emitted when not dialling */
    Ampl2=0;
}



