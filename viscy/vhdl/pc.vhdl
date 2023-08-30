library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity PC is
    port (
        clk: in std_logic;
        reset, inc, load: in std_logic;             -- Steuersignale
        pc_in: in std_logic_vector (15 downto 0);   -- Dateneingang
        pc_out: out std_logic_vector (15 downto 0)  -- Ausgabe Zaehlerstand
    );
end PC;


architecture RTL of PC is

    signal counter_register: std_logic_vector (15 downto 0);

begin

    -- process (counter_register)
    -- begin
        pc_out <= std_logic_vector(counter_register);
    -- end process;

    process (clk, reset, inc, load, pc_in)
    begin
        if rising_edge(clk) then 
            if (reset = '1') then 
                counter_register <= "0000000000000000";
            else
                if (inc = '1') then 
                    counter_register <= std_logic_vector(unsigned(counter_register) + 1);
                end if;
                if (load = '1') then
                    counter_register <= std_logic_vector(unsigned(pc_in));
                end if;
            end if;
        end if;
    end process;

end RTL;
