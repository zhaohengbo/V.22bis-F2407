/* Routine initializes all CPTD Filters for double biquad */
/* Memory Organization:
	NameFilter:		
		D11(N-1)
		D12(N-1)
		D21(N-1)
		D22(N-1)
		B10
		B11
		A11
		A12
		B12
		B20
		B21
		B22
		A21
		A22
		*/

#include "Filters.h"

extern int DialFilter[14];
extern int DialThreshold;
extern int DialIn, DialOut, TotIn, TotOut, DialShift, DialMin;
extern int AnswerFilter[14];
extern int AnswerThreshold;
extern int AnswerIn, AnswerOut, AnswerShift;
extern int V23Filter[14];
extern int V23Threshold;
extern int V23In, V23Out, V23Shift;
extern int V21Filter[14];
extern int V21Threshold;
extern int V21In, V21Out, V21Shift;


extern int MinEng;
int InitFiltFunc(void);


void InitTot(void)
{
	MinEng=MinThres;
	TotIn=0;
	TotOut=0;
	InitFiltFunc();
}


void InitDial(void)
{
	DialFilter[0]=0;
	DialFilter[1]=0;
	DialFilter[2]=0;
	DialFilter[3]=0;
	DialFilter[4]=Dial1_B0;
	DialFilter[5]=Dial1_B1;
	DialFilter[6]=Dial1_A1;
	DialFilter[7]=Dial1_A2;
	DialFilter[8]=Dial1_B2;
	DialFilter[9]=Dial2_B0;
	DialFilter[10]=Dial2_B1;
	DialFilter[11]=Dial2_A1;
	DialFilter[12]=Dial2_A2;
	DialFilter[13]=Dial2_B2;

	DialThreshold=DialThres;	
	DialIn=0;
	DialOut=0;
	DialShift=DialScale;
	DialMin=DialMinEng;
}

void InitBusy(void)
{
	DialFilter[0]=0;
	DialFilter[1]=0;
	DialFilter[2]=0;
	DialFilter[3]=0;
	DialFilter[4]=Dial1_B0;
	DialFilter[5]=Dial1_B1;
	DialFilter[6]=Dial1_A1;
	DialFilter[7]=Dial1_A2;
	DialFilter[8]=Dial1_B2;
	DialFilter[9]=Dial2_B0;
	DialFilter[10]=Dial2_B1;
	DialFilter[11]=Dial2_A1;
	DialFilter[12]=Dial2_A2;
	DialFilter[13]=Dial2_B2;

	DialThreshold=BusyThres;	
	DialIn=0;
	DialOut=0;
	DialShift=BusyScale;
	DialMin=DialMinEng;
}

void InitAnswer (void)
{
	AnswerFilter[0]=0;
	AnswerFilter[1]=0;
	AnswerFilter[2]=0;
	AnswerFilter[3]=0;
	AnswerFilter[4]=Answer1_B0;
	AnswerFilter[5]=Answer1_B1;
	AnswerFilter[6]=Answer1_A1;
	AnswerFilter[7]=Answer1_A2;
	AnswerFilter[8]=Answer1_B2;
	AnswerFilter[9]=Answer2_B0;
	AnswerFilter[10]=Answer2_B1;
	AnswerFilter[11]=Answer2_A1;
	AnswerFilter[12]=Answer2_A2;
	AnswerFilter[13]=Answer2_B2;

	AnswerThreshold=AnswerThres;	
	AnswerIn=0;
	AnswerOut=0;
	AnswerShift=AnswerScale;
}

void InitV23 (void)
{
	V23Filter[0]=0;
	V23Filter[1]=0;
	V23Filter[2]=0;
	V23Filter[3]=0;
	V23Filter[4]=V23_1_B0;
	V23Filter[5]=V23_1_B1;
	V23Filter[6]=V23_1_A1;
	V23Filter[7]=V23_1_A2;
	V23Filter[8]=V23_1_B2;
	V23Filter[9]=V23_2_B0;
	V23Filter[10]=V23_2_B1;
	V23Filter[11]=V23_2_A1;
	V23Filter[12]=V23_2_A2;
	V23Filter[13]=V23_2_B2;

	V23Threshold=V23Thres;	
	V23In=0;
	V23Out=0;
	V23Shift=V23Scale;
}

void InitV21 (void)
{
	V21Filter[0]=0;
	V21Filter[1]=0;
	V21Filter[2]=0;
	V21Filter[3]=0;
	V21Filter[4]=V21_1_B0;
	V21Filter[5]=V21_1_B1;
	V21Filter[6]=V21_1_A1;
	V21Filter[7]=V21_1_A2;
	V21Filter[8]=V21_1_B2;
	V21Filter[9]=V21_2_B0;
	V21Filter[10]=V21_2_B1;
	V21Filter[11]=V21_2_A1;
	V21Filter[12]=V21_2_A2;
	V21Filter[13]=V21_2_B2;

	V21Threshold=V21Thres;	
	V21In=0;
	V21Out=0;
	V21Shift=V21Scale;
}


