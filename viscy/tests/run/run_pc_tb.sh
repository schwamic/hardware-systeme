#!/bin/bash
./clean.sh
SRC="../../vhdl"
ees-ghdl -a $SRC/pc.vhdl ../pc_tb.vhdl
ees-ghdl -d
ees-ghdl -r pc_tb