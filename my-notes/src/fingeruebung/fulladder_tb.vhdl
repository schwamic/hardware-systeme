library IEEE;
use IEEE.std_logic_1164.all;



entity FULL_ADDER_TB is
end FULL_ADDER_TB;



architecture TESTBENCH of FULL_ADDER_TB is

    -- Component declaration 
    component FULL_ADDER is
        port(a, b, c_in: in std_logic; sum, c_out: out std_logic);
    end component;

    -- Configuration / why do we need this?
    for SPEC : FULL_ADDER use entity WORK.FULL_ADDER(BEHAVIOR);
    for IMPL: FULL_ADDER use entity WORK.FULL_ADDER(STRUCTURE);

    -- Internal signals
    signal a, b, c, sum_spec, carry_spec, sum_impl, carry_impl: std_logic;

    -- constants
    constant tim: time := 8 ns;
    constant delay: time := 8 ns;

begin
    -- Instantiate full adder
    SPEC : FULL_ADDER port map(a => a, b => b, c_in => c, sum => sum_spec, c_out => carry_spec);
    IMPL : FULL_ADDER port map(a => a, b => b, c_in => c, sum => sum_impl, c_out => carry_impl);

    -- Main process
    process
    begin

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End
    
    a <= '0';
    b <= '0';
    c <= '0';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=0, b=0, c=0)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '0';
    b <= '1';
    c <= '0';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=0, b=1, c=0)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '1';
    b <= '0';
    c <= '0';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=1, b=0, c=0)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '1';
    b <= '1';
    c <= '0';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=1, b=1, c=0)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '0';
    b <= '0';
    c <= '1';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=0, b=0, c=1)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '0';
    b <= '1';
    c <= '1';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=0, b=1, c=1)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '1';
    b <= '0';
    c <= '1';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=1, b=0, c=1)";

    --- Reset Start
    a <= 'X'; b <= 'X'; c <= 'X';
    wait for delay;
    --- Reset End

    a <= '1';
    b <= '1';
    c <= '1';
    wait for tim; -- wait a bit
    assert sum_spec = sum_impl and carry_spec = carry_impl
    report "Specification and implementation differ! (a=1, b=1, c=1)";

    -- Print a note & finish simulation now
    assert false report "Simulation finished" severity note;
    wait; -- end simulation

    end process;
    
end architecture TESTBENCH;
