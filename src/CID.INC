	.global		_AGCTHRESL, _AGCTHRESH

DCDon		.set	6100h		; AGC gain -43dBm
DCDoff		.set	6500h		; AGC gain -48dBm

CID_ON	    .set	100h		; bit 8 in CID status reg.
RING_MASK   .set    0040h		; I/O B6 (input)
RING_MIN    .set    800			; 100ms=>100 ms * 8 kHz
RING_MAX    .set    5800 		; < 1 s (clock at 8 kHz)   
SWITCH_IMP  .set    0800h 		; I/O B11 (output)
DCD_TO	    .set    8000  		; 1 s (clock 8 kHz)
DCD_ON      .set    1000h		; bit 12 in CID status reg.
RING		.set	2000h		; bit 13 in CID_status
AS_ON		.set	4000h		; bit 14 in CID_status
CID_TO		.set	20000		; 2.5s (clock at 8 kHz)
