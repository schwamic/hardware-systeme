# Befehle

## Multiply

```bash
viscy-as muliply.asm
viscy-obj2vhdl multiply.o
# mem_content in cp_tb anpassen
./run_cpu_tb.sh
gtkwave cpu_tb.ghw
```

## Frontend

```bash
vasy -a -p pc pc_vasy
boom pc_vasy pc_boom
boog pc_boom pc_boog
loon -x 0 pc_boog pc_final
# xsch &
```

## Backend

```bash
ocp -ring pc_final pc_placed
nero -p pc_placed pc_final pc_final
ring pc_chip pc_chip
# graal
```
