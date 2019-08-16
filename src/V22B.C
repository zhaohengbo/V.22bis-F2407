/* v22b.c */

/* management of initialization of the connection for V22/V22bis */


#include "common.h"
#include "dtmf.h"

#define DEBUG 0 /* 0 if no debug */

#define WAY16   0
#define S1200   1
#define S2400   2

#define ANSWTONE    17

#define Gain1 1000*GRef /* transmit gain answer no guard 5540*/
#define Gain2 800*GRef /* transmit gain with guard */
int TVGain; /* transmit gain */

extern volatile int mdm_sta;
extern int Guard;
extern int ALPHA; /* gain of AGC */
#if UseTest
int test=0; /* for debug only */
#endif
int V22TR1; /* threshold carrier detect */
int V22TR2; /* threshold carrier detect */

#define RefTR1 16885*TRef  /* threshold carrier lost */
#define RefTR2 16585*TRef  /* threshold carrier dectect */

/* ------ internal functions ------- */

void s1snd(void); /* send s1 */
void sendmarks(unsigned int mode); /* send mark for different case */
int FV22b(void); /* V22bis modulation */
int FV22(void); /* V22 modulation */
int abort(void);
int EndOfV22Ans(void);
int EndV22Call(void);


/* external functions */
void SendCmd(unsigned int command); /* send command to DSP modem */
int SendData(int Data); /* send data to external UART */
int ReadData(void);
int FV21(void);
int FV23(void);
void SendFSK(int temp);
void Print(char *Pt);

/* internal variables */
volatile int speed;



int V22b(void)
/* manage V22b calling */
/* return 0 if OK */
{
    int RetCode,temp;


    /* select transmit gain */
    if((Guard=='2')&&(!(Modul & MCalling))) TVGain=Gain2; /* answer and guard */
    else                                    TVGain=Gain1; /* other */

    /* select carrier threshold */
    if(Modul & MCalling){
        V22TR1=RefTR1;
        V22TR2=RefTR2;
    }else{
        /* answer add 1dB */
        V22TR1=RefTR1*1.12;
        V22TR2=RefTR2*1.12;
    }

    switch(Modul & MModul){
        case MV22b:
            temp=FV22b();
			/* adjust carrier detect threshold */
			V22TR2=V22TR2>>2;
            V22TR1=V22TR1-(V22TR1>>3)-(V22TR1>>4); /* let time to AGC */
            if(!temp)  
            {
                if (speed==2400)
                    RetCode=RV22b;
                else
                    RetCode=RV22;
            }
            else if (temp==1) RetCode=RNoCarrier;
            else RetCode=RAbort;            
            break;
        case MV22:
            temp=FV22();
            if(!temp)  RetCode=RV22;
            else if (temp==1) RetCode=RNoCarrier;
            else RetCode=RAbort;    
            break;
        case MV21:
            RetCode=FV21();
            break;
        case MV23:
            RetCode=FV23();
            break;
    }
    return RetCode; /* ok */
}


int FV22b(void)
/* V22bis protocol */
/* return 0 if OK */
{
    int i0,i1;
    unsigned int stat;
    int S0Count;
    int NewAlpha;
    

    if(Modul & MCalling){
        /* start calling sequence */
        modemini();
        /* start protocol V22b calling */
        stat=detectS0();
        if(stat!=0){          /* look for s0 */            
            return(stat); /* error=1, abort=2 */
        }
        SendCmd(0xf6);    /* ORIGINATE, 1200 bd */
        SendCmd(0x82);    /* trns enable */

        s1snd();               /* send s1 for 100 ms */
        
        S0Count=60;
        for(Tim0=0;Tim0 < 1800;){  /* 1.8s */
            sendmarks(S1200);

            /* test s0 end */
            if ((mdm_sta & 0x10) != 0){ 
                /* s0 detected */
                S0Count=60; /* 100ms */
            }else{
                S0Count--;
                if(S0Count==0) break;
            }

            /* test s1 start */
            if(mdm_sta & 0x20){ /* test s1 */
                break;
            }
            if (abort()) /* test at */
                return 2;
        }
        SendCmd(0x43);    /* enable timing recovery */
        /* if no S1 detected, initiate V22 sequence */
        if ((mdm_sta & 0x20) == 0){ /* no s1 --> V22 */
            return EndV22Call();
        }

        /* S1 detected, continue V22bis */
        SendCmd(0xf6);    /* 1200 */               
        
        for(;Tim0<3000;){                    /* wait for end of s1 */
             sendmarks(S1200);
             if((mdm_sta & 0x20) == 0) break;
             if (abort())
                return 2; /* manual abort during handshake */
        }

        for(i0 = 265;i0>0;i0--){  
            sendmarks(S1200);           /* send at 1200 bps */
        }
    
        /* send scrambled marks with v22b */    
        for(i0 = 85; i0>0;i0--){
            sendmarks(WAY16);   /* send at pseudo 1200 bps (recv 2400bps) */
        }

    }else{
        /* start V22b answering */
        /* 2150ms silence */
        for(Tim0=0;Tim0<2150*8;);
        /* send 2100 3300ms */
        SendFSK(ANSWTONE);
   		CID=NoMode;		/* protect variables in overlay (CID and CPTD) */
		InitTot();
        CID=CPTMode;
        for(Tim0=0;Tim0<3300*8;){          
             if(abort()) return 2; 
        } /* wait 3300ms */
        /* 75ms silence */
        CID=NoMode;
        DtmfFlag=0; /* stop transmit */
        for(Tim0=0;Tim0<75*8;){      /* 75ms */
            if (abort()) return 2;
        }
        modemini();
        /* send s0 and wait s1 */
        SendCmd(0x30); /* reset */
        SendCmd(0xff); /* answer */
		SendCmd(0x72); /* enable receive */
        SendCmd(0x82); /* enable transmit */
        for(Tim0=0;Tim0<400;){ /* 400ms of S0 */
            SendCmd(0x1D); /* send non scramble 1 at 1200  and receive 2400 */
            if(abort()) return 2; 
        }
        /* record ALPHA to avoid starting on noise */
        NewAlpha=(ALPHA>>1)+(ALPHA>>2);   /* wait for 6dB energy step */
        /* check carrier or S1 */
        for(Tim0=0;Tim0<24000;){ /* wait for 24 secondes */
            SendCmd(0x1D); /* send non scramble 1 at 1200  and receive 2400 */
            if(mdm_sta & 0x40){
                if(ALPHA < NewAlpha) break; /* carrier detect */
            }
            if(mdm_sta & 0x20) break; /* S1 detected */
            if(abort())  return 2; 
        }
        if(Tim0>=24000) return 1; /* no carrier no s1 */
        for(Tim0=0;Tim0<100;){  /* 100ms of wait */
            SendCmd(0x1D); /* send non scramble 1 at 1200  and receive 2400 */
            if((mdm_sta & 0x20) != 0) break; /* s1 detected */
            if(abort()) return 2; 
        }
        /* threshold detection lower to secure connection */
        V22TR1=RefTR1;
        V22TR2=RefTR2;
        if((mdm_sta & 0x20)==0){ /* if s1 not detected */
            /* v22 answer */

            SendCmd(0x30); /* reset */
            SendCmd(0xfe); /* V22 answer */
            SendCmd(0x72); /* enable receive */
            SendCmd(0x82); /* enable transmit */
            SendCmd(0x43); /* timing recovery */

            return EndOfV22Ans(); /* finished the protocol */
        }

        /* send s0 and wait s1 stop */
        for(Tim0=0;Tim0<100;){
            SendCmd(0x1D); /* send non scramble 1 at 1200 and receive 2400 */
            if((mdm_sta & 0x20) == 0) break; /* no s1 detected */
            if(abort()) return 2; 
        }

        /* send S1 100ms */
        SendCmd(0x43);    /* enable timing recovery */
        s1snd();

        /* send 450ms 1200 1 scrambled and receive 1200 */
        for(Tim0=0;Tim0<500;){  /* 500ms */           
             sendmarks(S1200); /* scrambled 1 */
             if(abort()) return 2; 
        }
    }

    /* wait of 32 consecutive one */
    speed=2400;
    StartUart();
    i0=0; /* last Tim0 */
    for(Tim0=0;Tim0<2000;){
        /* check carrier */
        if((mdm_sta & 0x40) == 0) return 1; /* no carrier */
		/* check if zero are received */
		/* if a 0 is received it will be consider as a start bit and GetData() will */
		/* return a data with FLAG20 set */
        if((GetData() & FLAG20) != 0){
		    /* received a 0 --> reset time */
            i0=Tim0;
        }else{
		    /* FLAG20 is not set so we received only 1 (no start bit */
            if((Tim0-i0)> 14){ /* 32 bit = 13.333ms */
                if(Tim0>200){
                    return 0;
                }
            }
        }
        if(abort()) return 2; 
    }
    return 1; /* no carrier */
}       


#if DEBUG
/* for debug */
void To12(void)
/* swith to 12 mips */
{
    *(int *)(7)=0xf417;
    *(int *)(3)=639;
}
void To6(void)
/* switch to 6 mips */
{
    *(int *)(7)=0xf437;
    *(int *)(3)=319;
}

#endif

unsigned int detectS0(void)
/* return 0 after 500ms and s0 */
{
/*  SendCmd(0x30); */   /* reset */
    SendCmd(0xf6);      /* ORIGINATE, 1200 bd */
    SendCmd(0x72);      /* recv enable */
    for(Tim0=0;Tim0<200;){ /* wait 200ms for begin of s0 */
        if((mdm_sta & 0x10) !=0) break;
    }
    for(Tim0=0;Tim0<590;){
        if (abort()) return 2;
    }
    return 0;
}



int Carrier(void)
/* return 0 (false) if no carrier */
{
    return (mdm_sta & 0x40);
}


void s1snd(void)
{
    unsigned int look;

    for(look=0;look<30;look++){ /* 30*2 quad bit = 100ms */
        SendCmd(0x21);
        SendCmd(0x2d);
    }
}


void sendmarks(unsigned int mode)
{
    unsigned int    xdibit;

    xdibit = scramble(3);
    xdibit <<= 2;
    switch (mode)
    {
        case S1200:
            xdibit |= 0x21;
            break;
        case WAY16:
            xdibit |= 0x11;
            break;
        case S2400:
            xdibit |= scramble(3);
            xdibit |= 0x10;
            break;
    }
    SendCmd(xdibit);
}



int FV22(void)
/* V22 protocol */
/* return 0 if OK */
{
    int i0,i1,S0Count;
    unsigned int stat;
    int NewAlpha;

    
    if(Modul & MCalling){
        /* calling mode */
        modemini();
        /* start protocol V22 calling */
        stat=detectS0();
        if(stat!=0){          /* look for busy, answer and s0 */            
            return(stat); /* error=1, abort=2 */
        }
        SendCmd(0xf6);    /* ORIGINATE, 1200 bd */
        SendCmd(0x82);    /* trns enable */
        /* wait end s0 */
        S0Count=60;
        for(Tim0=0;Tim0 < 1800;){
            sendmarks(S1200);

            /* test s0 end */
            if ((mdm_sta & 0x10) != 0){
                /* s0 detected */
                S0Count=60; /* 100ms */
            }else{
                S0Count--;
                if(S0Count==0) break;
            }
            if (abort()) /* test at */
                return 2;
        }

        SendCmd(0x43);    /* enable timing recovery */
        return EndV22Call();
    }else{
        /* start V22 answering */                      /* add Guardtone !!!!!!!!!!!*/
        /* 2150ms silence */
        for(Tim0=0;Tim0<2150*8;);
        /* send 2100 3300ms */
        SendFSK(ANSWTONE);
   		CID=NoMode;		/* protect variables in overlay (CID and CPTD) */
		InitTot();
        CID=CPTMode;
        for(Tim0=0;Tim0<3300*8;){          
             if(abort()) return 2; 
        } /* wait 3300ms */
        /* 75ms silence */
        CID=NoMode;
        DtmfFlag=0; /* stop transmit */
        for(Tim0=0;Tim0<75*8;){
            if (abort())  return 2;
        }
        modemini();
        /* send s0 */
        SendCmd(0x30);    /* reset */        
        SendCmd(0xfe); /* 1200 answer */
		SendCmd(0x72); /* enable receive */
        SendCmd(0x82); /* enable transmit */

        /* send marks non scrambled one */
        for(Tim0=0;Tim0<400;){
            SendCmd(0x1D); /* send non scramble 1 at 1200  and receive 1200 */
            if (abort()) return 2;
        }

        /* record ALPHA to avoid starting on noise */
        NewAlpha=(ALPHA>>1)+(ALPHA>>2);   /* wait for 6dB energy step */
        for(Tim0=0;Tim0<24000;){ /* wait for 24 secondes */
            SendCmd(0x1D); /* send non scramble 1 at 1200  and receive 2400 */
            if(mdm_sta & 0x40){
                if(ALPHA < NewAlpha) break; /* carrier detect */
            }
            if(abort())  return 2; 
        }
        if(Tim0>=24000) return 1; /* no carrier */

        SendCmd(0x43); /* timing recovery */
        return EndOfV22Ans(); /* finished the protocol */
     } /* end answering */ 
}       


/*** Routine checks manual interrupt of handshake ***/
int abort(void) 
{
  if(ReadData()>=0)  return 1;
  else               return 0;
}   


int EndV22Call(void)
/* */
{
    int i0;

    /* wait consecutive one */
    speed=1200;
    /* wait for enable timing command used */
    sendmarks(S1200); /* scrambled 1 */
    sendmarks(S1200); /* scrambled 1 */
    StartUart();

    i0=0; /* last Tim0 */
    for(Tim0=0;Tim0<270+765;){
        if((GetData() & FLAG20) != 0){
            if((Tim0-i0) < 14)  i0=Tim0;    /* 16 bit 1200 = 13.3333ms */
        }
        if(abort()) return 2; 
    }
    if (Tim0-i0< 14) return 1;  /* less than 16 consecutive one */
    return 0;   /* return with no error */      
}


int EndOfV22Ans(void)
{
    int stat,i0=0;

    /* receive 270ms 1200 unscrambled 1*/
    SendCmd(0x2d); /* send 1 1200 unscrambled */
    for(Tim0=0;Tim0<270;){             
         if (abort()) return 2;
    }
   
    speed=1200;

    StartUart();
    i0=0; /* last Tim0 */

    for(Tim0=0;Tim0<765;){
        if((GetData() & FLAG20) != 0){
            if((Tim0-i0) < 27)  i0=Tim0; /* 16 symbols */
        }
        if(abort()) return 2; 
    }
    if (Tim0-i0< 27) return 1;  /* error */
    return 0;   /* return with no error */      
}


