;****************************************************************
; # MULTIPLY TWO 15 BIT POSITIVE NUMBERS (VISCY PROCESSOR)
; ## ALGORITHM
;
; int f1 = 3;
; int f2 = 2;
; int acc = 0;
; while (f1 > 0) {
;   acc += f2;
;   f1--;
; }
; int res = acc;
;
;****************************************************************


                .org 0x0100
f1:             .data 176
f2:             .data 167
res:            .res 1


                .org 0x0000
                .start                              ; required start cmd
start:          LDIL r5, 0x1                        ; constant = 1
                LDIH r5, 0x0                      
                
                LDIL r0, f1 & 255                   ; f1 = 232
                LDIH r0, f1 >> 8
                LD r0, [r0]

                LDIL r1, f2 & 255                   ; f2 = 241
                LDIH r1, f2 >> 8
                LD r1, [r1]
                
                LDIL r2, 0x0                        ; acc = 0
                LDIH r2, 0x0
                
                LDIL r3, res & 255                  ; init res (Adresse)
                LDIH r3, res >> 8

                LDIL r4, loop & 255                 ; while-loop (Adresse)
                LDIH r4, loop >> 8


loop:           ADD r2, r2, r1                      ; acc += f2 
                SUB r0, r0, r5                      ; f1--
                JNZ r0, r4                          ; while(f1 > 0)

                ST [r3], r2                         ; res = 55912
                HALT


                .end                                ; required end cmd
