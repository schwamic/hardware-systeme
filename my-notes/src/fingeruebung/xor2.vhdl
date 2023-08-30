library IEEE;
use IEEE.std_logic_1164.all;



entity XOR2 is
    port (x, y: in std_logic; z: out std_logic);
end XOR2;



architecture DATAFLOW of XOR2 is
begin
    z <= x xor y after 2 ns;
end architecture DATAFLOW;
