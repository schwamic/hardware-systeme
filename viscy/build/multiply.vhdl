-- Memory content (generated by viscy2l) ...
type t_memory is array (0 to 258) of std_logic_vector (15 downto 0);
signal mem_content: t_memory := (
    16#0000# => "0100010100000001",  -- start:          LDIL r5, 0x1                        ; constant = 1
    16#0001# => "0100110100000000",  --                 LDIH r5, 0x0
    16#0002# => "0100000000000000",  --                 LDIL r0, f1 & 255                   ; f1 = 232
    16#0003# => "0100100000000001",  --                 LDIH r0, f1 >> 8
    16#0004# => "0101000000000000",  --                 LD r0, [r0]
    16#0005# => "0100000100000001",  --                 LDIL r1, f2 & 255                   ; f2 = 241
    16#0006# => "0100100100000001",  --                 LDIH r1, f2 >> 8
    16#0007# => "0101000100100000",  --                 LD r1, [r1]
    16#0008# => "0100001000000000",  --                 LDIL r2, 0x0                        ; acc = 0
    16#0009# => "0100101000000000",  --                 LDIH r2, 0x0
    16#000a# => "0100001100000010",  --                 LDIL r3, res & 255                  ; init res (Adresse)
    16#000b# => "0100101100000001",  --                 LDIH r3, res >> 8
    16#000c# => "0100010000001110",  --                 LDIL r4, loop & 255                 ; while-loop (Adresse)
    16#000d# => "0100110000000000",  --                 LDIH r4, loop >> 8
    16#000e# => "0000001001000100",  -- loop:           ADD r2, r2, r1                      ; acc += f2
    16#000f# => "0000100000010100",  --                 SUB r0, r0, r5                      ; f1--
    16#0010# => "1001100010000000",  --                 JNZ r0, r4                          ; while(f1 > 0)
    16#0011# => "0101100001101000",  --                 ST [r3], r2                         ; res = 55912
    16#0012# => "1000100000000000",  --                 HALT
    16#0100# => "0000000010110000",  -- f1:             .data 176
    16#0101# => "0000000010100111",  -- f2:             .data 167
    16#0102# => "0000000000000000",  -- res:            .res 1
    others => "UUUUUUUUUUUUUUUU"
    );