#include "common.h"

#define RING    0x2000  /* bit 13 in CID_status */
#define MAX_BUF     8   /* number of buffers in CID */

/* external functions */
int CallerID(int as);
int Print(char *Ptr);
void Init_Ptrs(void);
int ReadTable(int *table);

/* external variables */
extern int CID_status;
extern int CID_ret;
extern int *CID_Ptr[MAX_BUF];
extern int AS; /* DT alerting signal on/off AS=1/0 */
extern char transfer_buf[32];

extern int CLI0[], CLI1[], CLI2[], CLI3[], CLI4[], CLI5[], CLI6[], CLI7[];  


void Manage_CID(void)
{
    int status,i,temp;

    temp=AS;
   
    if (CID==CIDMode)
    {
        status=CallerID(temp);

        if (!status){
            if (CID_status & RING){
                CID_status &= ~RING; /* reset ring bit */
                Print("RING");
                if(s0!=0) F_ATA(); /* connect in answer mode */
            }
        }else{
            for (i=0;i<MAX_BUF;i++){
                if (status & (0x0001 << i))
                    transfer_data(i);
            }
        }
    }
}


void transfer_data(int number)
{
    int *tmp_ptr;
    int BufferLen,i, toggle=0,count=1;
    
    
    switch (number)
    {
        case 0x0000 :   count=ReadTable(CLI0);
                        BufferLen=4;
                        break;
        case 0x0001 :   count=ReadTable(CLI1);
                        BufferLen=10;
                        break;
        case 0x0002 :   count=ReadTable(CLI2);
                        BufferLen=10;
                        break;
        case 0x0003 :   count=ReadTable(CLI3);
                        BufferLen=1;
                        break;
        case 0x0004 :   count=ReadTable(CLI4);
                        BufferLen=10;
                        break;
        case 0x0005 :   count=ReadTable(CLI5);
                        BufferLen=1;
                        break;
        case 0x0006 :   count=ReadTable(CLI6);
                        BufferLen=1;
                        break;
        case 0x0007 :   count=ReadTable(CLI7);
                        BufferLen=1;
                        break;
        default:        break;
    }

   /*   count--;    /* transfer_buf[count] is next free element in buffer */

    tmp_ptr=CID_Ptr[number]; /* points to current CID buffer */
    
    if (BufferLen > 1)
    {
        for (i=0;i<BufferLen<<1;i++)     
        {
            if(!toggle)
                transfer_buf[count+i]=(char) (*(tmp_ptr) >> 8);
            else
            {
                transfer_buf[count+i]=(char) (*(tmp_ptr) & 0x00ff);
                tmp_ptr++;
            }

            toggle^=1;
        }
        transfer_buf[count+i]=(char) 0x0000;
    }
    else
    {
        transfer_buf[count]=(char) *tmp_ptr;
        transfer_buf[count+1]=(char) 0x0000;
    }

    
    Print(transfer_buf);    

}