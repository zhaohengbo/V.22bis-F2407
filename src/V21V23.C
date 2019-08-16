#include "common.h"
#include "dtmf.h"
#include "Filters.h"
#include "Param.h"		   

#define CHARAV		0x0001
#define CARRIERON	0x0002

#define	ANSWTONE	17
#define	V21ANSW		19
#define	V23ANSW		21

void PrintFSK(char *Pt);
/* void EightKHz(void); */
void InitRXV23(void);
void InitTXV23(void);
void InitTXV21(void);
void InitTXV23(void);

void ResetFSK(void);

void StartUart(void);

extern char transfer_buf[32];
extern int FSKREG;

extern int Command;


/* V21 protocol */
int FV21(void)
{

	Tim0=0;


    if(Modul & MCalling){	/* V21 calling */
 
		return(V21Cont());
	}
	else{	/* V21 answering */
        /* 2150ms silence */
        DtmfFlag=0;
        Tim0=0;
        while(Tim0<215*80);
        /* send 2100 3300ms */
        SendFSK(ANSWTONE);
   		CID=NoMode;
		InitTot();
        CID=CPTMode;
        Tim0=0;
        while(Tim0<300*80){          
             if(abort())
                return 2; 
        } /* wait 3000ms */
        Tim0=0;
        while(Tim0<30*80){
             
            if(abort())
                return 2; 
        } /* wait 300ms */
        /* 75ms silence */
        DtmfFlag=0; /* stop transmit */
        Tim0=0;
        while(Tim0<75*8)
        {
            if (abort())
                return 2;	 
        }
		return(V21Cont());
	}
}


int V21Cont(void)
{
	int time=0,i1=0;

	Tim0=0;    
    
    CID=NoMode;
	InitRXV21();	/* init V21 reception */
	InitTXV21();	/* init V21 transmission */
	Init_V21();		/* init parameter values */
    CID=FSKV21;

	do{
   		while (FSKREG & CARRIERON){
   			if (Tim0 > 80){	/* 10 ms counter */
   				Tim0=0;
   				time++;
   				i1++;
   			}
   			if (time>30)		 /* 300 ms of answer tone received */  
   			{
				Tim0=0;
				while(Tim0<160);	/* wait for 20ms for AGC and filter convergence */
				ResetFSK();  					   				      
				StartUart();
   				return RV21;
			}
   		}
   		time=0;

		while (Tim0 <=80);
		Tim0=0;
		i1++;

		if (abort()) return RAbort; 
	}while(i1 < 1500);	/* Timeout: 15s (*100) */
	
	return RNoCarrier;
}



/* V23 protocol */
int FV23(void)
{

	Tim0=0;    
    
    if(Modul & MCalling){	/* V23 Calling */
    	
		return (V23Cont());
	}
	else{	/* V23 Answering */
        /* 2150ms silence */
        Tim0=0;
        while(Tim0<215*80);
        /* send 2100 3300ms */
        SendFSK(ANSWTONE);
   		CID=NoMode;
		InitTot();
        CID=CPTMode;
        Tim0=0;
        while(Tim0<300*80){          
             if(abort())
                return 2; 
        } /* wait 3000ms */
        Tim0=0;
        while(Tim0<30*80){
             
            if(abort())
                return 2; 
        } /* wait 300ms */
        /* 75ms silence */
        DtmfFlag=0; /* stop transmit */
        Tim0=0;
        while(Tim0<75*8) 
        {
            if (abort())
                return 2;	 
        }
		
		return (V23Cont());
	}
}


int V23Cont(void)
{
	int time=0,i1=0;

	Tim0=0;    
    
    
    CID=NoMode;
	InitRXV23();	/* init V23 reception */
	InitTXV23();	/* init V23 transmission */
   	Init_V23();		/* init parameter values */
    CID=FSKV23;

	do{
   		while (FSKREG & CARRIERON){
   			if (Tim0 > 80){	/* 10 ms counter */
   				Tim0=0;
   				time++;
   				i1++;
   			}
   			if (time>30)		 /* 300 ms of answer tone received */  
   			{
				Tim0=0;
				while(Tim0<160);	/* wait for 20ms for AGC and filter convergence */
				ResetFSK();  					   				      
				StartUart();
   				return RV23;
			}
   		}
   		time=0;

		while (Tim0 <=80);
		Tim0=0;
		i1++;

		if (abort()) return RAbort; 
	}while(i1 < 1500);	/* Timeout: 15s (*100) */
	
	return RNoCarrier;
}

/* V21, V23 tone generator at 8 kHz*/
void SendFSK(int temp)
{
	temp<<=2; /* offset for ToneTable, 4 entries for each digit/tone */

	Phi1=0;		/* init phase */
	Phi2=0;

	DeltaPhi1=table_read(ToneTable+temp);		/* init step1 for low freq. */
	DeltaPhi2=table_read(ToneTable+temp+1);	    /* init step2 for high freq. */

	Ampl1=table_read(ToneTable+temp+2);			/* single tone */
	Ampl2=0;

	DtmfFlag=1;
}


/* RX Management in FSK mode */
int ModemFSK()
{
	if (FSKREG & CARRIERON){
		/*if (Command==OFF){
		   	if (FSKREG & CHARAV){
				FSKREG &= ~CHARAV; 		/* reset bit character available */
		/*		transfer_buf[0]=FSKREG>>8;
				transfer_buf[1]=0;
				PrintFSK(transfer_buf);
			}
		} */
		return 0;
	}
	else{
		 return 1; /* no carrier */
	}	
}


void Init_V21(void)
{
	if (Modul & MCalling){
	   
	   AGCTHRESL=V21THRES1C;
	   AGCTHRESH=V21THRES2C;
	   TXGain=TXGainV21C;
	}
	else{
		
		AGCTHRESL=V21THRES1A;
		AGCTHRESH=V21THRES2A;
		TXGain=TXGainV21A;
	}
}



void Init_V23(void)
{
	if (Modul & MCalling){

		AGCTHRESL=V23THRES1C;
		AGCTHRESH=V23THRES2C;
		TXGain=TXGainV23C;
		
	}
	else{
		
		AGCTHRESL=V23THRES1A;
		AGCTHRESH=V23THRES2A;
		TXGain=TXGainV23A;
		
	}
}

