

/* V21 Carrier Detection Thresholds */
#define	V21THRES1C  0x6500*TRef	/* Calling */
#define	V21THRES2C  0x6C00*TRef		  

#define	V21THRES1A  0x5000*TRef	/* Answering */
#define	V21THRES2A  0x5800*TRef

/* V23 Carrier Detection Thresholds */
#define	V23THRES1C  0x6a00*TRef	/* Calling */ /*-44 dBm*/
#define	V23THRES2C  0x7000*TRef	/* -47 dBm */	  

#define	V23THRES1A  0x5800*TRef	/* Answering */
#define	V23THRES2A  0x5c00*TRef

/* V21,V23 Transmission Gains ~ -10 dBm*/
#define TXGainV21A	110*GRef
#define TXGainV21C	110*GRef
#define TXGainV23A	128*GRef	/* Mode Answer, Transmit upper band */
#define TXGainV23C	154*GRef	/* Mode Calling, Transmit lower band */

extern int AGCTHRESL, AGCTHRESH;		/* Carrier detection, upper and lower thres */
extern int TXGain;
