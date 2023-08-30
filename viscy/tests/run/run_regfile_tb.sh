#!/bin/bash
./clean.sh
SRC="../../vhdl"
ees-ghdl -a $SRC/regfile.vhdl ../regfile_tb.vhdl
ees-ghdl -d
ees-ghdl -r regfile_tb