	.org 0x0000
	.start 
	; 1. Faktor in r1
start:	LDIH  r0, 0x01   ; r0 => 0x100 => 0000 0001 0000 0000
	LDIL  r0, 0x00
	LD    r1, [r0]
	; 2. Faktor in r2
	LDIL  r0, 0x01	; r0 => 0x101 => 0000 0001 0000 0001 
	LD    r2, [r0]   
	; 3. Faktor in r3
	LDIL  r0, 0x02	; r0 => 0x102 => 0000 0001 0000 0010   
	LDIH  r3, 0
	LDIL  r3, 1
	ldil r6, loop & 255		
	ldih r6, loop>>8
	ldil r5, shiftloop & 255		
	ldih r5, shiftloop>>8
loop:	and  r4, r2, r3		
	jz  r4, r5			
	add  r7, r7, r1			
shiftloop:	sal  r1, r1
	sar  r2, r2
	jnz  r2, r6
finish:	st   [r0],r7
	  
	HALT
	.org 0x100
	.data 13,9
	.res 1
         .end
