library IEEE;
use IEEE.std_logic_1164.all;

entity IR_TB is
end IR_TB;

architecture TESTBENCH of IR_TB is

    component IR is
        port (
            clk: in std_logic;
            load: in std_logic;                         -- Steuersignal
            ir_in: in std_logic_vector (15 downto 0);   -- Dateneingang
            ir_out: out std_logic_vector (15 downto 0)  -- Datenausgang
        );
    end component;

    --for SPEC: IR use entity WORK.ir_final(RTL);

    signal clk, load: std_logic;
    signal ir_in, ir_out: std_logic_vector (15 downto 0);
    
    constant wait_time: time := 10 ns;

begin
    SPEC: IR port map(clk => clk, load => load, ir_in => ir_in, ir_out => ir_out);

    process
		-- helper procedure to simulate clock cycle
		procedure run_cycle is 
		begin
			clk <= '0';
			wait for wait_time / 2;
			clk <= '1';
			wait for wait_time / 2;
		end procedure;
		
    begin
		-- value should change when load and clk are set to 1
		run_cycle;
        clk <= '1'; load <= '1'; ir_in <= "1111111111111111";
        run_cycle;
        assert ir_out = "1111111111111111"
            report "Incorrect ir_out value.";

		-- value should not change when load is set to 0
        clk <= '1'; load <= '1'; ir_in <= "XXXXXXXXXXXXXXXX";
        run_cycle;
        clk <= '1'; load <= '0'; ir_in <= "1111111111111111";
        run_cycle;
        assert ir_out = "XXXXXXXXXXXXXXXX"
            report "Incorrect ir_out value.";
            
        -- value should not change when out of tact
        clk <= '1'; load <= '1'; ir_in <= "XXXXXXXXXXXXXXXX";
        run_cycle;
        clk <= '0'; load <= '1'; ir_in <= "1111111111111111";
        wait for wait_time;
        assert ir_out = "XXXXXXXXXXXXXXXX"
			report "Incorrect ir_out value.";
        
        -- Print a note & finish simulation
        assert false report "IR Simulation finished" severity note;
        wait; -- end simulation
    end process;

end architecture;
