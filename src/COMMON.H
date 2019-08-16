/* common C and ASM */

/* debug variables */

#define UseTest     0   /*  !=0 allow use of test variable */
#define TRACE       0   /* !=0 allow TRACE of variables */
                        /* don't forget to set UseDram to 1 */
#if     TRACE
void Trace(int T); /* put T in DRAM */
void cClearDram();
#endif


#define IsDsk   1	/* if !=0 put software in DSK c2xx mode */
/*    */
#define GRef 5  /* control for all transmit amplitude */
                /* all amplitude are multiply by GRef */
                /* value of 10 is -10dBm on TI board */
                /* variable to be modified in common.inc */
                /* multiply GRef by 2 increase output power by 6dB */
#define TRef   1   /* global reference for carrier detect */
                   /* 1 for detection in -43/-48dBm on TI board */
                   /* multiply TRef by 2 modify detection threshold by -6dB */

#define ModemMode 0
#define NoMode    1
#define CIDMode   2
#define CPTMode   3
#define FSKV23    4
#define FSKV21    5

#define RING    0x2000  /* bit 13 in CID_status */
#define MAX_BUF     8   /* number of buffers in CID */

#define MModul   0x0f  /* mask for modulation type asked */
#define MNoModul    0  /* no modulation */
#define MV22b       1  /* value for V22b modulation */
#define MV22        2  /* V22 modulation */
#define MV21        3  /* V21 modulation */
#define MV23        4  /* V23 modulation */
#define MCalling 0x100  /* bit set = calling mode */

#define AnswerMask  2
#define V21Mask     4
#define V23Mask     8
#define DialMask    1
								   
/* overflow flag */
#define FLAG10 1
/* data present */
#define FLAG20 2


enum EOnOff{ON,OFF};

enum {RNoDial, RV22b, RNoCarrier, RBusy, RAbort, RV22, RV23, RV21, RAnswer};

extern int Modul; /* modulation mode */
extern volatile int CID;
extern int s0; /* s0 register */

extern int *RPtOut, RBuffr, RLast;
extern volatile int Tim0; /* timer incremented at 9.6 or 8k */
                /* do not use a value >32000 */

extern volatile int CptdFilter;

void B00(void); /* set B0 to 0 */
void B01(void); /* set B0 to 1 */

int table_read(int *TableAddress);
void F_ATA(void);
/* connect in answer mode */
