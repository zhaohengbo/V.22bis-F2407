;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                       DLUPDT.ASM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       Routine updates the equalizer delay lines
;       xr(n) = xr(n-1)
;       xi(n) = xi(n-1)
;       for n=9,...,1
;       and then XTMPR -> xr(0) and XTMPI -> xi(0)
;   where the number of equalizer coefficients is 10
;       c(0),...,c(9)
;
;
DLUPDT
     LRLK    AR0,X8R ;Address real part of x(n-8)
     MAR     *,AR0
     RPTK    9
     DMOV    *-
     LRLK    AR0,X8I ;
     RPTK    9
     DMOV    *-
;
     RET             ;
