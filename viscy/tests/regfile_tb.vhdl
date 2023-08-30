library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REGFILE_TB is
end REGFILE_TB;

architecture TESTBENCH of REGFILE_TB is

    component REGFILE is
        port(
            clk: in std_logic;
            out0_data: out std_logic_vector (15 downto 0);  -- Datenausgang 0 (16bit)
            out0_sel: in std_logic_vector (2 downto 0);     -- Register-Nr. 0 (=int(0-7))
            out1_data: out std_logic_vector (15 downto 0);  -- Datenausgang 1 (16bit)
            out1_sel: in std_logic_vector (2 downto 0);     -- Register-Nr. 1 (=int(0-7))
            in_data: in std_logic_vector (15 downto 0);     -- Dateneingang   (16bit)
            in_sel: in std_logic_vector (2 downto 0);       -- Register-Wahl  (=int(0-7))
            load_lo, load_hi: in std_logic                  -- Register laden
        );
    end component;

    -- Configuration
    for SPEC: REGFILE use entity WORK.REGFILE(RTL);

    -- Signals
    signal clk, load_lo, load_hi: std_logic;
    signal out0_data, out1_data, in_data: std_logic_vector(15 downto 0);
    signal out0_sel, out1_sel, in_sel: std_logic_vector(2 downto 0);

    -- Constants
    constant delay : time := 20 ns;

begin
    -- Instantiate entity
    SPEC : REGFILE port map(
        clk => clk,
        out0_data => out0_data,
        out0_sel => out0_sel,
        out1_data => out1_data,
        out1_sel => out1_sel,
        in_data => in_data,
        in_sel => in_sel,
        load_lo => load_lo,
        load_hi => load_hi
    );

    -- Main process
    process
        -- Helper functions
        procedure run_cycle is
        begin
            clk <= '0';
            wait for delay;
            clk <= '1';
            wait for delay;
        end procedure;

        procedure reset_signals is
        begin
            load_lo <= '0'; load_hi <= '0';
            out0_sel <= std_logic_vector(to_unsigned(1, out0_sel'length));
            out1_sel <= std_logic_vector(to_unsigned(2, out1_sel'length));
            in_sel <= std_logic_vector(to_unsigned(3, in_sel'length));
        end procedure;
    begin
        -- Init
        reset_signals;

        -- CASE 1: Should load hi and low
        load_hi <= '1'; load_lo <= '1';
        in_data <= "0101010101010101";
        out0_sel <= std_logic_vector(to_unsigned(3, out0_sel'length));
        run_cycle;
        assert out0_data = "0101010101010101"
            report("Case1 failed: Should load hi! (clk=1, load_hi=1, load_lo=1, out0_sel=3)");

        -- CASE 2: Should only load lo
        reset_signals;
        load_lo <= '1';
        in_data <= "0000000011111111";
        out0_sel <= std_logic_vector(to_unsigned(3, out0_sel'length));
        run_cycle;
        assert out0_data = "0101010111111111"
            report ("Case2 failed: Should only load lo! (clk=1, load_lo=1, out0_sel=3)");

        -- CASE 3: Should only load hi
        reset_signals;
        load_hi <= '1';
        in_data <= "1111111100000000";
        out0_sel <= std_logic_vector(to_unsigned(3, out0_sel'length));
        run_cycle;
        assert out0_data = "1111111111111111" 
            report ("Case3 failed: Should only load hi! (clk=1, load_hi=1, out0_sel=3)");

        -- CASE 4: Should keep the value
        reset_signals;
        out0_sel <= std_logic_vector(to_unsigned(3, out0_sel'length));
        run_cycle;
        assert out0_data = "1111111111111111"
            report ("Case4 failed: Should keep value! (clk=1, out0_sel=3)");

        -- CASE 5: Should not load on falling_edge
        reset_signals;
        load_hi <= '1'; load_lo <= '1';
        in_data <= "0000000000000000";
        out0_sel <= std_logic_vector(to_unsigned(3, out0_sel'length));
        clk <= '0';
        wait for delay;
        assert out0_data = "1111111111111111"
            report ("Case5 failed: Should not load on falling_edge! (clk=0, load_hi=1, load_lo=1, out0_sel=3)");

        -- Print a note & finish simulation
        assert false report "REGFILE Simulation finished" severity note;
        wait; -- end simulation

    end process;

end architecture TESTBENCH;