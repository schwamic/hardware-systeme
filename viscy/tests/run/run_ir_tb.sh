#!/bin/bash
./clean.sh
SRC="../../vhdl"
ees-ghdl -a $SRC/ir.vhdl ../ir_tb.vhdl
ees-ghdl -d
ees-ghdl -r ir_tb