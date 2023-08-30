library IEEE;
use IEEE.std_logic_1164.all;



entity AND2 is
    port (x, y: in std_logic; z: out std_logic);
end AND2;



architecture DATAFLOW of AND2 is
begin
    z <= x and y after 3 ns;
end architecture;
