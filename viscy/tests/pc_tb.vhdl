library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity PC_TB is
end PC_TB;


architecture TESTBENCH of PC_TB is

    component PC is
        port (
            clk: in std_logic;
            reset, inc, load: in std_logic;
            pc_in: in std_logic_vector (15 downto 0);
            pc_out: out std_logic_vector (15 downto 0)
        );
    end component;

	-- Configuration
	for SPEC: PC use entity WORK.PC(RTL);

	-- Signals
	signal clk, reset, inc, load : std_logic;
	signal pc_in, pc_out : std_logic_vector (15 downto 0);
	
	-- Constants
	constant delay : time := 20 ns;

begin
    -- Instantiate entity
    SPEC : PC port map(clk => clk, reset => reset, inc => inc, load => load, pc_in => pc_in, pc_out => pc_out);
    
    -- Main process
    process
        -- helper function to simulate a cycle
        procedure run_cycle is
        begin
            clk <= '0';
            wait for delay;
            clk <= '1';
            wait for delay;
        end procedure;

        procedure reset_signals is
        begin
            reset <= '0'; inc <= '0'; load <= '0';
        end procedure;

    begin
        -- Init
        reset_signals;

        -- CASE: Should load
        load <= '1';  pc_in <= std_logic_vector(to_unsigned(3, pc_in'length));
        run_cycle;
        assert pc_out = std_logic_vector(to_unsigned(3, pc_out'length))
            report "Failed: Should load! (clk= 1, reset=0, inc=0, load=1, pc_in=3)";

        -- CASE: Should keep value
        reset_signals;
        run_cycle;
        assert pc_out = std_logic_vector(to_unsigned(3, pc_out'length))
            report "Failed: Should keep value! (clk= 0, reset=0, inc=0, load=0, pc_in=3)";

        -- CASE: Should reset
        reset_signals;
        reset <= '1';
        run_cycle;
        assert pc_out = std_logic_vector(to_unsigned(0, pc_out'length))
            report "Failed: Should reset! (clk= 1, reset=1, inc=0, load=0, pc_in=0)";

        -- CASE: Should increment
        reset_signals;
        inc <= '1';
        run_cycle;
        assert pc_out = std_logic_vector(to_unsigned(1, pc_out'length))
            report "Failed: Should increment! (clk= 1, reset=0, inc=1, load=0, pc_in=0)";

        -- Case: Reset should dominate
        reset <= '1'; inc <= '1'; load <= '1';  pc_in <= std_logic_vector(to_unsigned(3, pc_in'length));
        run_cycle;
        assert pc_out = std_logic_vector(to_unsigned(0, pc_out'length))
            report "Failed: Reset should dominate! (clk= 1, reset=1, inc=1, load=1, pc_in=3)";

        -- Case: Should do nothing on falling_edge
        reset_signals;
        load <= '1';  pc_in <= std_logic_vector(to_unsigned(3, pc_in'length));
        clk <= '0';
        wait for delay;
        assert pc_out = std_logic_vector(to_unsigned(0, pc_out'length))
            report "Failed: Should do nothing on falling_edge! (clk= 0, reset=0, inc=0, load=1, pc_in=3)";

        -- Print a note & finish simulation
        assert false report "PC Simulation finished" severity note;
        wait;   -- end simulation

    end process;

end architecture TESTBENCH;
