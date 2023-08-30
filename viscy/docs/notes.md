# Notes

## Tools

### GHDL + GtkWave (Hardware-Entwurf / Sicht:Verhalten)

GHDL ist ein Simulator für VHDL (=Hardwarebeschreibungssprache). GtkWave dient zur Anzeige der Signalverläufte.
Zielt des Hardware-Entwurfs ist eine synthetisierbare Verhaltensbeschreibung (Architekturname: RTL, =Register-Transfer-Level), welche später automatisch in eine Struktur übersetzt werden kann. Zur Entwicklung nutzt man Testbenches um den Entwurf zu validieren.

### Alliance Tools (Frontend, Backend / Sicht:Struktur,Geometrie)

Die Alliance Tools unterstützen bei der Synthese (Frontend) und Platzierung und Verdrahtung (Backend) für den IC-Entwurf (=integrated circuit/integrierter Schaltkreis).

- Wie FlipFlops und Latches erkennen? (Loon, Boog)
`ff` in der ausgabe suchen...

## Komponenten

### Arithmetic Logic Unit (=ALU)

Rechenwerk aus arithemtischen und logischen Operatoren.
Erzeugt das ZERO-Signal für bedingte Sprünge.

### Instruction Register (=IR)

Das Befehlsregister empfängt/lädt die Programmbefehle und speichert sie zwischen während sie gerade ausgeführt werden.

### Programm Counter (=PC)

Dieses Register zeigt auf die aktuelle/nächste Stelle im Speicher, die sich in Bearbeitung befindet. RESET dominiert und kann den Zähler zurücksetzen. Bei uns ist die Adresse 0 der Programmstartpunkt, was in der Software mit `.org 0x0000` beachtet werden muss. (Synthese: 16-D Flipflops)

### Register File (=Regfile)

Speicherelement für 8 (Register, R0-R7) x 16 Bit (Wortbreite). Daraus ergeben sich 128 D-Flipflops in der Synthese. Das Laden eines 16Bit Worts in ein Register muss in der VISCY-Umsetzung durch die Kombination LDIH/LDIL umgesetzt werden. Hierzu gibt es keinen vereinfachten Befehl. Die Ausgänge sind unabhängig.

### Controller

Schaltwerke mit Taktsteuerung bezeichnet man als synchron. Ihr Zeitverhalten wird von Taktsignalen bestimmt, die die Zustandswechsel auslösen. Die Aufgabe ist es, die Abläufe zu steuern und den übrigen Komponenten (=Operationswerk)
mitzuteilen, was sie wann tun sollen. Das Steuerwerk generiert somit Steuersignale und beachtet/reagiert auf Statussignale.

Zielstruktur ist ein Moore-Automat: Die Zustandübergangsfunktion ermittelt anhand der Statussignale den aktuellen Zustand (taktsynchroner Prozess). Die Ausgabefunktion (Schaltnetz-Prozess, Ausgangssignale hängen nur von anliegenden Eingangsignalen ab) wird vom aktuellen Zustand abgeleitet, welche die Steuersignal enthält.

Synthese: Alle Signale, denen im Prozess etwas zugewiesen wird, entsprechen den Schaltnetz-Ausgängen. Diesen muss in jedem möglichen Kontrollpfad ein Wert zugewiesen werden, weil sonst ungewollte Latches entstehen -> Defaultwerte nutzen.

### Central Processing Unit (=CPU)

Hier werden alle Komponenten und ggf. mehrere Steuersignal über Multiplexer zu einer Einheit verbunden. Zusätzlich kommen noch Ein-/Ausgabe und ein Speicher hinzu. (CPU = Ein-/Ausgabe + Rechenwerk + Steuerlogik + Speicherlogik).

## Assembler

- `.res` reserviert worte im speicher. z.B. .org0x100 .res 1 -> 0x100. dadurch wird die adresse 0x100 im weitern verlauf von anderen befehlen nicht mehr verwendent. z.b. im multiply.asm speichern wir so das ergebnis in adresse 0x102.
- `.data` lädt werte in den speicher. die aderesse im speicher ist von .org und der code reihenfolge abhänging.
- `>>, &` (LDIL, LDIH)

```md
1010_1110_1010_0101 (16bit)
0000_0000_1111_1111 (& 255)
-> 0000_0000_1010_0101
```

```md
1010_1110_1010_0101 (16bit)
 (>>8) 8 bits nach rechts schieben
-> 0000_0000_1010_1110
```
