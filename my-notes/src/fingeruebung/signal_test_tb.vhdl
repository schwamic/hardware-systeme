library IEEE;
use IEEE.std_logic_1164.all;


entity TEST_TB is
end TEST_TB;


architecture TESTBENCH1 of TEST_TB is
    -- Component declaration
    component TEST is
        port(clk: in std_logic);
    end component;

  -- Configuration
  for SPEC : TEST use entity WORK.TEST(BEHAVIOR);

  -- Initial signals
  signal clk: std_logic := '0';

  -- Constants
  constant delay: time := 10 ns;
begin
  -- Instantiate
  SPEC : TEST port map(clk => clk);
  
  -- Main process
  process
  begin
    clk <= '0';
    wait for delay;
    
    clk <= '1';
    wait for delay;

    assert false report "Simulation finished" severity note;
    wait;

  end process;

end architecture TESTBENCH1;
