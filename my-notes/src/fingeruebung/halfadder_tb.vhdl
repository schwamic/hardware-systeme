library IEEE;
use IEEE.std_logic_1164.all;


entity HALF_ADDER_TB is
end HALF_ADDER_TB;


architecture TESTBENCH2 of HALF_ADDER_TB is

  -- Component declaration...
  component HALF_ADDER is
    port (a, b: in std_logic; sum, carry: out std_logic);
  end component;

  -- Configuration...
  for SPEC: HALF_ADDER use entity WORK.HALF_ADDER(DATAFLOW);
  for IMPL: HALF_ADDER use entity WORK.HALF_ADDER(STRUCTURE);

  -- Internal signals...
  signal a, b, sum_spec, carry_spec, sum_impl, carry_impl: std_logic;

begin

  -- Instantiate half adder...
  SPEC: HALF_ADDER port map (a => a, b => b, sum => sum_spec, carry => carry_spec);
  IMPL: HALF_ADDER port map (a => a, b => b, sum => sum_impl, carry => carry_impl);

  -- Main process...
  process
  begin
    a <= '0'; b <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=0)";

    a <= '0'; b <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=0, b=1)";

    a <= '1'; b <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=0)";

    a <= '1'; b <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
        report "Specification and implementation differ! (a=1, b=1)";

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation

  end process;

end architecture;


architecture TESTBENCH1 of HALF_ADDER_TB is

  -- Component declaration
  component HALF_ADDER is
    port (a, b: in std_logic; sum, carry: out std_logic);
  end component;

  -- Configuration...
  for IMPL: HALF_ADDER use entity WORK.HALF_ADDER(BEHAVIOR);

  -- Internal signals...
  signal a, b, sum, carry: std_logic;

begin

  -- Instantiate half adder
  IMPL: HALF_ADDER port map (a => a, b => b, sum => sum, carry => carry);

  -- Main process...
  process
  begin
    a <= '0'; b <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum = '0' and carry = '0' report "0 + 0 is not 0/0!";

    a <= '0'; b <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum = '1' and carry = '0' report "0 + 1 is not 1/0!";

    a <= '1'; b <= '0';
    wait for 1 ns;      -- wait a bit
    assert sum = '1' and carry = '0' report "1 + 0 is not 1/0!";

    a <= '1'; b <= '1';
    wait for 1 ns;      -- wait a bit
    assert sum = '0' and carry = '1' report "1 + 1 is not 0/1!";

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait;               -- end simulation

  end process;

end architecture;