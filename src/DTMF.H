#define CallTone        1300            /* flag for calling tone */
#define AnswerTone      2100

#define DTMF_TimeOn     520   /* 65ms*8kHz   tone */
#define DTMF_TimeOff    520   /* 65ms*8kHz   pause */

extern int Phi1;
extern int Phi2;
extern int DeltaPhi1;
extern int DeltaPhi2;
extern int Ampl1;
extern int Ampl2;
extern int DtmfFlag;

extern int ToneTable[];                 /* Dtmf table: Frequency constants and levels */

