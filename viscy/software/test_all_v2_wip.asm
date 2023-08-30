.org 0x0000
.start

; Jeder Befehl wird ausgeführt, die mathematischen Befehle zudem noch getestet

; r0: Testregister für LDIL und LDIH
; r1: Parameter 1
; r2: Paramter 2 falls nötig
; r3: Erwartetes Ergebnis
; r4: Tatsächliche Ergebnis
; r5: Zielwort, initialisiert mit 0

; TODO: GtkWave mit korrekter CPU
;		Ggf. Überdenken der Strategie falls JZ nicht erlaubt ist

start:  LDIH r5, 0
		LDIL r5, 0; Zielwort r6 => 0000 0000 0000 0000
				
		
ld_t:	LDIH r0, 104
		LDIL r0, 185 ; Zielwort r0 => 0110 1000 1011 1001
				
				
add_t:  LDIH r1, 77
		LDIL r1, 134 ; Summand r1 => 0100 1101 1000 0110
		
		LDIH r2, 123
		LDIL r2, 61 ; Summand r2 => 0111 1011 0011 1101
		
		; 0100 1101 1000 0110 ADD
		; 0111 1011 0011 1101
		; -------------------
		; 1100 1000 1100 0011
		
		LDIH r3, 200
		LDIL r3, 195 ; r3 => 1100 1000 1100 0011
		
		ADD r4, r1, r2 ; r4 => r1+r2 = 1+2
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
				
sub_t: 	LDIH r1, 123
		LDIL r1, 61 ; r1 => 0111 1011 0011 1101
					
		LDIH r2, 77
		LDIL r2, 134 ; r2 => 0100 1101 1000 0110
		
		; 0111 1011 0011 1101 SUB
		; 0100 1101 1000 0110 
		; -------------------
		; 0010 1101 1011 0111
				
		LDIH r3, 45
		LDIL r3, 183 ; r3 => 0010 1101 1011 0111
				
		SUB r4, r1, r2 ; r4 => r1-r2 = 8-3
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
sal_t:  LDIH r1, 130
		LDIL r1, 246 ; r1 => 1000 0010 1111 0110
				
		LDIH r3, 5
		LDIL r3, 236 ; r3 => 0000 0101 1110 1100
				
		SAL r4, r1 ; r4 => r1 * 2 = 6*2
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
		
sar_t: 	LDIH r1, 104
		LDIL r1, 185 ; r1 => 0110 1000 1011 1001
				
		LDIH r3, 52
		LDIL r3, 92 ; r3 =>  0011 0100 0101 1100
				
		SAR r4, r1 ; r4 => r1 / 2 = 18/2
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
		
and_t:	LDIH r1, 104
		LDIL r1, 185 ; r1 => 0110 1000 1011 1001
				
		LDIH r2, 130
		LDIL r2, 246 ; r2 => 1000 0010 1111 0110
				
		; 0110 1000 1011 1001 AND
		; 1000 0010 1111 0110
		; -------------------
		; 0000 0000 1011 0000
				
		LDIH r3, 0
		LDIL r3, 176 ; r3 => 0000 0000 1011 0000
		
		AND r4, r1, r2 ; r4 => r1 & r2
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
or_t:	LDIH r1, 104
		LDIL r1, 185 ; r1 => 0110 1000 1011 1001
				
		LDIH r2, 130
		LDIL r2, 246 ; r2 => 1000 0010 1111 0110
				
		; 0110 1000 1011 1001 OR
		; 1000 0010 1111 0110
		; -------------------
		; 1110 1010 1111 1111
				
		LDIH r3, 234
		LDIL r3, 255 ; r3 => 1110 1010 1111 1111
				
		OR r4, r1, r2 ; r4 => r1 | r2
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
xor_t:	LDIH r1, 104
		LDIL r1, 185 ; r1 => 0110 1000 1011 1001
					
		LDIH r2, 130
		LDIL r2, 246 ; r2 => 1000 0010 1111 0110
				
		; 0110 1000 1011 1001 XOR
		; 1000 0010 1111 0110
		; -------------------
		; 1110 1010 0100 1111
				
		LDIH r3, 234
		LDIL r3, 79 ; r3 => 1110 1010 0100 1111
				
		XOR r4, r1, r2 ; r4 => r1 XOR r2
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein
		
		
not_t:	LDIH r1, 104
		LDIL r1, 185 ; r1 => 0110 1000 1011 1001
		
		; 0110 1000 1011 1001 NOT
		; -------------------
		; 1001 0111 0100 0110
				
		LDIH r3, 151
		LDIL r3, 70 ; r3 => 1001 0111 0100 0110
				
		NOT r4, r1 ; r4 => NOT r1
		XOR r3, r3, r4 ; XOR Erwartung und Ergebnis
		OR r5, r5, r3 ; r3 sollte jetzt 0 sein


ld:     LDIL r1, 0x00
        LDIH r1, 0x01
        LDIL r3, 0x00
        LDIH r3, 0x01
        LD  r4, [r1]	 ; => 0x0100
        XOR r3, r3, r4
        OR r5, r5, r3    ; => r5 sollte null bleiben


st:    LDIH  r1, 0xFF
       LDIL  r1, 0xFF   ; => 1111111111111111
       LDIH  r3, 0xFF   ; => 00000000
       LDIL  r3, 0xFF   ; => 0000000000000000
       LDIH  r4, 0x00   ; => 00000000
       LDIL  r4, 0x00
       LDIL  r4, result & 255
       LDIH  r4, result >> 8
       ST    [r4], r1
       XOR   r3, r3, [r4]
       OR    r5, r5, r3


jmp:      LDIL r3, 0x00
          LDIH r3, 0x00
          LDIL r1, loopjmp
          LDIH r1, loopjmp>>8
          JMP r1
          LDIL r3, 0xFF
loopjmp:  OR r5, r5, r3



jnz:        XOR   r1, r1, r1
            LDIL r3, 0x00
            LDIH r3, 0x00
            LDIL r2, 0x01
            LDIH r2, 0x00
            LDIL r1, loopjnz
            LDIH r1, loopjnz>>8
            JNZ r2, r1
            LDIH r3, 0xFF
            LDIL r3, 0xFF
            loopjnz: OR r5, r5, r3



jz:         LDIL r3, 0x00
            LDIH r3, 0x00
            LDIL r2, 0x00
            LDIH r2, 0x00
            LDIL r1, loopjz
            LDIH r1, loopjz>>8
            JZ r2, r1
            LDIL r3, 0xFF
            loopjz: OR r5, r5, r3

		
end_t:	HALT


result: .res 8
	    .data 42

; Auswertung:	r5 => 0000 0000 0000 0000
;				r0 => 0110 1000 1011 1001
.end	
