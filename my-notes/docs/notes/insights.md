# Insights

- STRUCTURE Architektur: `component` und `for use` statt direkt `WORK.` verwenden. Das hat den Vorteil, dass man eine genaue Architektur auswählen kann. Beide Implemenierungen funktionieren.
- TESTBENCH: Vorteil Implementierung gegen Spezifikation testen, man muss nicht die Ausgangswerte wissen. In der Praxis werden möglichst beide Architekturen von zwei unterschiedliche Personen entwickelt.
- Makefile: Am bessten einfach immer alle Files analysieren, das spart viel Tipparbeit. Ebenfalls wird dokumentiert was ausgeführt werden soll und wie.
- Wieviel Testfälle brauche ich?
  - 2^n + längste pfade zusätlich implementieren (siehe Schaubild)
  - 2^n^2 -> jede mögliche kombination testen
  - x-werte implementieren und mit delays arbeiten

---

## Tooling

- Mit dem Dockerimage war kein fehlerfreies Arbeite möglich. Mit der Virtualbox und der bereitgestellten VM läuft alles.
- show all -> ghdl -d
- make file
- gtw-tool (fn + F4 -> ports zusammenfassen in eine gruppe)

---

Statt BEVAHIOR kann beliebiger Name gegeben werden -> Konvention: Name = RTL
Arithmetisches Schieben an Stelle von logischem Schieben! "a(15) & a(15 downto 1)"
Testen mit eigener Funktion, die alle CASES abdeckt. (auslagern) Funktion kann dann immer mit zwei Zahlen aufgerufen werden
FOR USE in Counter-Beispiel-TB
Höchste Zahl 16Bit: 65535

loon mit -x 1 ausführen (das ist kein L)

synthetisiertes Bild prüfen:
- Hängen Ein- oder Ausgänge einfach irgendwo in der Luft? -> schlecht
- ALU sollte keine FlipFlops haben (ist nur ein Schlatnetz und speichert nichts)
## Alliance Tools

- In Port-Deklarationen nur die Typen std_logic oder std_logic_vector verwenden

---

## Meeting-Notes

Terminal: cmd: `history`

### BLATT 2

CPU
CONTROLLER

---

regilf: max 128 flipflops
boog:
sff1_x4 -> flipflop
sff2_x4 -> flipflop

alu
a,b -> in
sel -> welche operation
y -> out
zero -> nötig für jump zero, jump not zero. (JZ, JNZ)
wenn b = 0, dann jump zero.
bedingter sprung: berechnung/opeeration
operation NOT: b=0 -> zero=1 -> JZ


other -> mit 0 belegen. -> kein undefinierter zustand!

testbench -> operationen testen.
- operationen prüfen
- operationen und zero-flag zusammen prüfen
- spezialfälle (minuszahlen, ...)
- 0 abziehe -> zeroflag = 1
-> extremfälle überlegen und testen. random-numbers, randstellen 0/maximumzahl, ...

Befehlssatz
(Opcode)

00 -> arithmetische operationen
000 -> select = welche operation 

load and store 01
jump/alt -> 10

ddd,sss,ttt (platzhalter)-> register 0 - 7
snnn -> platzhatler für values

---

assembler Seite 408.
ST (store)
SUB speicher, params
JNZ rz, [r6] -> 

r7 != 0 dann spring nach r6 springen bzw. weitermachen

JNZ -> springt wenn nicht 0
JZ -> springt wenn 0

--> hilfreich bei loops: JNZ -> mach weiter; JZ -> fertig, mach noch was tolles mit dem ergebnis.



---

assembler befehlssatz jnzi8086.de

---

signed/unsigned

zeitverhalten

// params = sinsitifitätsliste
todo: process(clk) -> hier noch alle anderen signal eintragen.
