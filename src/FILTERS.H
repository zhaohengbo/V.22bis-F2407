/* Dial Filter*/
/* All coefficients Q14 */
/* Coefficients for 1st biquad */
#define			Dial1_B0	1201   /*	1065	 */
#define			Dial1_B1   	-1977  /*	-1881  */
#define			Dial1_B2  	1201   /*	1065*/
#define			Dial1_A1   29988   /*	30750  */
#define			Dial1_A2   -15785  /*	-16099    */
/* Coefficients for 2nd biquad */
#define		    Dial2_B0   	6204	/*	3034*/
#define			Dial2_B1   -12201	/* -5947*/
#define			Dial2_B2   	6204	/*	3034*/
#define			Dial2_A1  	30793	/* 31054*/
#define			Dial2_A2   	-15887	/* -16122*/

#define			DialScale	0x3800/*13			/* input sample >> 1 */

/* threshold for dial tone detection */
#define			DialThres  	0x50	/*	0x31	*/

/* paramerters for busy tone detection, different dynamic range */
#define			BusyScale	0x6000	/*14*/
#define			BusyThres	0x40

#define			DialMinEng	0x150

/* Answer Filter 2100 Hz */
/* Coefficients for 1st biquad */
#define			Answer1_B0	758	  
#define			Answer1_B1  -524
#define			Answer1_B2  756
#define			Answer1_A1  -1450
#define			Answer1_A2  -15792  
/* Coefficients for 2nd biquad */
#define		    Answer2_B0 	2683
#define			Answer2_B1  2555
#define			Answer2_B2  2677
#define			Answer2_A1  -3596
#define			Answer2_A2  -15795	

#define			AnswerScale	20000 /*15				/* input sample >> 2 */

/* threshold for answer tone detection */
#define			AnswerThres  	0x1a	/*	0x2a	*/


/* V23 Filter 1300 Hz */
/* Coefficients for 1st biquad */
#define			V23_1_B0	660		
#define			V23_1_B1 	-252
#define			V23_1_B2 	660
#define			V23_1_A1 	16139
#define			V23_1_A2 	-15913
/* Coefficients for 2nd biquad */
#define		    V23_2_B0	3214
#define			V23_2_B1 	-4803
#define			V23_2_B2 	3214
#define			V23_2_A1 	17611
#define			V23_2_A2 	-15928

#define			V23Scale	14				/* input sample >> 2 */

/* threshold for V23 binary 1 detection */
#define			V23Thres  	0x40	/*	0x38	*/


/* V21 Filter 1650 Hz */
/* Coefficients for 1st biquad */
#define			V21_1_B0	1077
#define			V21_1_B1 	-114
#define			V21_1_B2 	1076
#define			V21_1_A1 	8292
#define			V21_1_A2 	-16087
/* Coefficients for 2nd biquad */
#define		    V21_2_B0	1767
#define			V21_2_B1 	-1643
#define			V21_2_B2 	1765
#define			V21_2_A1 	9335
#define			V21_2_A2 	-16090

#define			V21Scale	15				/* input sample >> 1 */

/* threshold for V21 binary 1 detection */
#define			V21Thres  	0x3a	/*	0x38	*/


#define			MinThres	0x58	/* minimum detection threshold */
											 
														
/* min. and max. timing for cadence check: busy tone */
#define BusyOnMin	30 	/* value * 10ms, BusyMax+20ms to account for filter delay*/
#define BusyOnMax 	60	
#define BusyOffMin	30 	/* value * 10ms, BusyMax+20ms to account for filter delay*/
#define BusyOffMax 	60	


/* initialization routines for the implemented filters */
void InitTot(void);
void InitDial(void);
void InitBusy(void);
void InitAnswer(void);
void InitV23(void);
void InitV21(void);









