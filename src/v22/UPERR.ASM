;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                       uperr.asm
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       Computes the rotated diff. error between the
; quantizer input and output.
;
;       e(n)    =  conj( (y(n) - p(n))*(cos(a)-jsin(a))
;
; where a is the carrier phase angle derived by the
; PLL (actually should be a(n)).
; Since y(n) = w(n) * (cos(a) + j sin(a) )
; we have that
;               Re[e(n)] = wr - pr*cosa - pi*sina
;               Im[e(n)] = -wi +pi*cosa - pr*sina
;
; where wr = Re[w(n)]  and wi = Im[w(n)] etc. ...
;
; w(n) is of format S4.11 and p(n) is S3.12.
; cosa and sina are S.15.
; e(n) is also stored as S3.12
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UPERR
     ZALH    WREAL
     LT      JIMAG   ; sina
     MPY     PIMAG
     SPAC
     LT      JREAL   ; cosa
     MPY     PREAL
     SPAC
     SACH    EREAL,1 ; Re[e(n)] as S3.12

;JREAL (cos(a)) still in T reg.
     MPY     PIMAG
     PAC
     LT      JIMAG
     MPY     PREAL
     SPAC
     SUBH    WIMAG
     SACH    EIMAG,1 ; Im[e(n)] as S3.12
     RET
