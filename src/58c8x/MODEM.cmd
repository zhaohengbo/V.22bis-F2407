/* linker command for V22bis */
/* 58c8x board */

-c
-o modem.out
-m modem.map
-stack 0x065 /* stack size used in C */

biquad.obj
call.obj
cid.obj
cid_main.obj
cid_prot.obj
CPE.obj
demod.obj
dsp20.obj
dsp20ini.obj
dtmf.obj
fskfir.obj
initFilt.obj
main.obj
mainc.obj
modul.obj
notch.obj
PrintTab.obj
RXV21F.obj
RXV23F.obj
TXFSKF.obj
uart.obj
v14.obj
v14c.obj
v14t.obj
V21V23.obj
v22b.obj

-l c:\yw\v22b\test\rts25.lib  /* use the modified rts25.lib */
/* -l rts25.lib */	/* this form use the ti_tools rts25.lib	*/



MEMORY
{

/* PROGRAM MEMORY */

    PAGE 0:

    VECTS:		origin = 0		length = 00020h
    PMEM:		origin = 020h	length = 04fe0h

/* DATA MEMORY */

    PAGE 1:

    B2:     origin = 0060h      length = 00020h
	B0L:	origin = 0200h		length = 00F8h
    B0L2:   origin = 02F8h      length = 0008h
    B0H:    origin = 0300h      length = 00100h    
    B1:     origin = 0400h      length = 00300h

/* alternate space */

    PAGE 2:

    ARAM:     origin = 00000h   length = 0FFFFh

}

/********************************************************/
SECTIONS
{

  /* ----- program -----*/

    vectors:    {}      > VECTS     PAGE 0
    .cinit:     {}      > PMEM      PAGE 0
    .text:      {}      > PMEM      PAGE 0
	RomData:    {}      > PMEM      PAGE 0


  /* ------ data --------*/


	UNION
	{
		Modem:
		{
			*(mpage4_1)
			*(mpage4)
			*(reloc)
		}
		CPTD:
		{
			*(X52)
			*(Filter)
			*(Notch)
		}
		FSKV23:
		{
			*(X53)
			*(V23)
			*(CID_Buf)
			*(CID_Var)
			*(CID_Temp)
			*(V23FIR)
		}
		FSKV21:
		{
			*(X54)
			*(V21)
		 	*(V21FIR)
		}
	}					>B0L		PAGE 1


    TStat       {}      >B2         PAGE 1
    SMain       {}      >B0L2       PAGE 1
    mpage5      {}      >B0H        PAGE 1
    TSave       {}      >B0H        PAGE 1
    ModBuf      {}      >B0H        PAGE 1
    Uart0       {}      >B1         PAGE 1
    Uart1       {}      >B1         PAGE 1
    SUart       {}      >B1         PAGE 1
    .bss        {}      >B1         PAGE 1
    .data       {}      >B1         PAGE 1
    .stack      {}      >B1         PAGE 1
	EndRam		{}		>B1 		PAGE 1
/* warning DTMF must stay in a page */
	DTMF		{}		>B0H		PAGE 1
	FSK:		{}		>B1			PAGE 1
	SIN:		{}		>B1			PAGE 1
	CIDb0:		{}		>B1			PAGE 1

	/*----- .const -------*/
	/* information to allow load of .const (Data) at reset */
	/* CONST_COPY must be set to 1 in rts.src */
	/* (cf. page 4-5 in C data book */
    .const:     load= PMEM PAGE 0, run= B1 PAGE 1
			{
				__const_run = .;
				*(.c_mark)
				*(.const)
				__const_length = .-__const_run;
			}

}


