#!/bin/bash
./clean.sh
SRC="../../vhdl"
ees-ghdl -a $SRC/regfile.vhdl $SRC/alu.vhdl $SRC/ir.vhdl $SRC/pc.vhdl $SRC/controller.vhdl $SRC/cpu.vhdl ../cpu_tb.vhdl
ees-ghdl -d
ees-ghdl -r cpu_tb --wave=cpu_tb.ghw