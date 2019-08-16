; /* common C and ASM */
NoMode      .set    1
ModemMode   .set    0
CIDMode     .set    2
CPTMode     .set    3
FSKV23      .set    4
FSKV21      .set    5

MModul      .set    000fh
MV22b       .set    1  
MV22        .set    2  
MV21        .set    3  
MV23        .set    4  
MCalling    .set    0100h 

ON          .set    0
OFF         .set    1

DialMask    .set    1
AnswerMask  .set    2
V21Mask     .set    4
V23Mask     .set    8

GRef        .set    5   ; control for all transmit amplitude */
                        ; all amplitude are multiply by GRef */
                        ; value of 10 is -10dBm on TI board */

