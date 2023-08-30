#!/bin/bash
./clean.sh
SRC="../../vhdl"
ees-ghdl -a $SRC/alu.vhdl ../alu_tb.vhdl
ees-ghdl -d
ees-ghdl -r alu_tb