library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity FULL_ADDER is
    port(a, b, c_in: in std_logic; sum, c_out: out std_logic);
end entity FULL_ADDER;



architecture BEHAVIOR of FULL_ADDER is
begin

  process (a, b, c_in)
    variable a2, b2, c2, result: unsigned (1 downto 0);
  begin
    a2 := '0' & a;           -- extend 'a' to 2 bit
    b2 := '0' & b;           -- extend 'b' to 2 bit
    c2 := '0' & c_in;        -- extend 'c_in' to 2 bit
    result := a2 + b2 + c2;  -- add them
    sum <= result(0);        -- output 'sum' = lower bit
    c_out <= result(1);      -- output 'c_out' = upper bit
  end process;

end BEHAVIOR;



architecture STRUCTURE of FULL_ADDER is
    component HALF_ADDER
        port (a, b: in std_logic; sum, carry: out std_logic);
    end component;
    
    component OR2
        port (x, y: in std_logic; z: out std_logic);
    end component;
    
    signal ha0_sum, ha0_carry, ha1_carry: std_logic;
    
    for I_HA0 : HALF_ADDER use entity WORK.HALF_ADDER(STRUCTURE);
    for I_HA1 : HALF_ADDER use entity WORK.HALF_ADDER(STRUCTURE);
    for I_OR : OR2 use entity WORK.OR2(DATAFLOW);

begin
    I_HA0: HALF_ADDER port map(a => a, b => b, sum => ha0_sum, carry => ha0_carry);
    I_HA1: HALF_ADDER port map(a => ha0_sum, b => c_in ,sum => sum, carry => ha1_carry);
    I_OR: OR2 port map(x => ha0_carry, y => ha1_carry, z => c_out);
end STRUCTURE;
