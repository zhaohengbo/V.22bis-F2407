; sine and cosine table for demodulation
; 20+13 samples
; Cosine 2400Hz
DCos24
    .word    32363	   ;0
    .word    -14875
    .word    -23169
    .word    29195
    .word    5125	   
    .word    -32363	   
    .word    14875
    .word    23169
    .word    -29195
    .word    -5125
    .word    32363	   
    .word    -14875
    .word    -23169
    .word    29195
    .word    5125	   
    .word    -32363	   
    .word    14875
    .word    23169
    .word    -29195
    .word    -5125
    .word    32363	   ;20
    .word    -14875
    .word    -23169
    .word    29195
    .word    5125
    .word    -32363
    .word    14875	   
    .word    23169
    .word    -29195
    .word    -5125
    .word    32363	   
    .word    -14875
    .word    -23169	   ;32
;sine
DSin24
    .word    5125		;0
    .word    29195
    .word    -23169
    .word    -14875
    .word    32363		
    .word    -5125
    .word    -29195
    .word    23169
    .word    14875
    .word    -32363
    .word    5125
    .word    29195
    .word    -23169
    .word    -14875
    .word    32363		
    .word    -5125
    .word    -29195
    .word    23169
    .word    14875
    .word    -32363
    .word    5125		;20
    .word    29195
    .word    -23169
    .word    -14875
    .word    32363
    .word    -5125
    .word    -29195
    .word    23169
    .word    14875
    .word    -32363
    .word    5125
    .word    29195
    .word    -23169		;32
DSmC24	.set	DSin24-DCos24-1	
;Cosine/sine 1200Hz
DCos12
    .word    32767		;0
    .word    19259
    .word    -10125
    .word    -31163
    .word    -26509
DSin12
    .word    0			;5
    .word    26509		
    .word    31163
    .word    10125
    .word    -19259
    .word    -32767
    .word    -19259
    .word    10125
    .word    31163
    .word    26509		
    .word    0
    .word    -26509
    .word    -31163
    .word    -10125
    .word    19259
    .word    32767		;20
    .word    19259
    .word    -10125
    .word    -31163
    .word    -26509
    .word    0
    .word    26509
    .word    31163
    .word    10125
    .word    -19259
    .word    -32767
    .word    -19259
    .word    10125
    .word    31163
    .word    26509		
    .word    0
    .word    -26509
    .word    -31163		;37
DSmC12	.set	DSin12-DCos12-1
