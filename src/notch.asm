			.def notch, _InitNotch
			.ref FromAD

coef          .usect "Notch", 3
history       .usect "Notch", 2



*****************************************************************************
* Notch filter 
* Calling setup:
*      FromAD = input sample
*      arp   = ar1
*      acc   = pointer to coefficient array
*      ar0   = pointer to history     => hist[1]
*                                        hist[0]
*
*
* After execution:
*      arp   = ar1
*      ar0  +=2
*****************************************************************************
notch:    
    lacc    #notchcoefs  
    lar    ar0, #history
   	
   	spm    1
   	lar    ar1, #coef                         ; upload coefficients
   	rpt    #2
   	tblr   *+              
                                             
   	larp   ar0   
   	ldp	   #FromAD               ; d_n  = (2l*(long)coef[1]*(long)hist[1]);
   	lac    FromAD,10; 10            ; d_n += (2l*(long)coef[2]*(long)hist[0]);
   	ldp	   #coef	
   	lt     coef+1               ; d_n += (((long)insam)<<10);
   	mpy    *+
   	lta    coef+2
   	mpy    *-

   	lta    coef                 ; ans  = d_n;    
   	ldp	   #FromAD	
   	sach   FromAD,1;1               ; ans += (2l*(long)coef[0]*(long)hist[1]);
   	mpy    *+                   ; ans += (((long)hist[0])<<15);
   	add    *-, 15;15               

   	dmov   *                    ; hist[0] = hist[1];       
   	bldd   #FromAD, *+            ; hist[1] = d_n>>15;
   	mpya   *+	              	; apac      
   	sach   FromAD, 6;6
	ret





_InitNotch
       zac
       ldp	  #history
       sacl   history		; hist[0]=0				
	   sacl	  history+1		; hist[1]=0
       ret       






notchcoefs:

;       temp    = -2.0 * cos ((2.0 * PI * Finterest)/Fsampling)
;       coef[0] = temp * 16384>>1
;       coef[1] = -temp * ALPHA * 16384>>1
;       coef[2] = -ALPHA * ALPHA * 16384>>1

;		Fs=8 kHz       

;                   	   	 Frequency       ALPHA     temp
;               	       	 ----------------------------------
        .word 	-17121;-16381   ; 1300 Hz        0.95     -1.999682
        .word 	16265; 15562   ;  
        .word 	-14786;-7393   ;  
