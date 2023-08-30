# VHDL

```bash
// basics
ees-ghdl -a pc_testbench.vhdl   (analyze)
ees-ghdl -e pc_testbench        (elaborate)
ees-ghdl -r pc_testbench        (run tests)

// Create wave
ees-ghdl -r pc_testbench --wave=pc_testbench.ghw

// Display wave
gtkwave -A pc_testbench.ghw -a pc_testbench.gtkw
```

---

Synthese mit Alliance:

```
vasy -VaopL alu_final
boom alu_final.vbe
boog alu_final_o
loon -x 1 pc_o pc_final
xsch -l alu_final.xsc
```


Datei analysieren:

```
ghdl -a and2.vhdl xor2.vhdl half_adder.vhdl half_adder_tb.vhdl full_adder.vhdl
ghdl -d
```

Laufen lassen:

```
ghdl -r half_adder_tb testbench1 --wave=half_adder_tb.ghw
gtkwave half_adder_tb.ghw half_adder_tb.save
ghdl -a and2.vhdl xor2.vhdl half_adder.vhdl half_adder_tb.vhdl or2.vhdl full_adder.vhdl && ghdl -r half_adder_tb testbench2 --wave=half_adder_tb.ghw && gtkwave half_adder_tb.ghw half_adder_tb.save

ghdl -a and2.vhdl xor2.vhdl half_adder.vhdl half_adder_tb.vhdl or2.vhdl full_adder.vhdl full_adder_tb.vhdl && ghdl -r full_adder_tb testbench1 --wave=full_adder_tb.ghw && gtkwave full_adder_tb.ghw full_adder_tb.save


src/openieee/numeric_std-body.v93:398:9:@0ms:(assertion warning): NUMERIC_STD."+": non logical value detected

Passwort: eeslabor

VISCY-Prozessor – Teil 3 (PC):
ghdl -d
ghdl -a pc.vhdl pc_tb.vhdl && ghdl -r pc_tb testbench --wave=pc_tb.ghw &&gtkwave pc_tb.ghw pc_tb.save

vasy -VaopL pc
boom pc.vbe
boog pc_o
loon -x 1 pc_o pc_final
xsch -l pc_final.vst

ocp -ring pc_final pc_final_placed
graal
nero -p pc_final_placed pc_final pc_final
ring pc_final pc_final
druc pc_final

## test_all.asm prüfen
ghdl -d && ghdl -a alu.vhdl ir.vhdl controller.vhdl regfile.vhdl cpu.vhdl cpu_tb.vhdl && ghdl -r cpu_tb VISCY_CPU_TB --wave=cpu_tb.ghw && gtkwave cpu_tb.ghw cpu_tb.save


ghdl -d && ghdl -a alu.vhdl ir.vhdl controller.vhdl regfile.vhdl cpu.vhdl cpu_tb.vhdl && ghdl -r cpu_tb behavior --wave=cpu_tb.ghw && gtkwave cpu_tb.ghw cpu_tb.save
