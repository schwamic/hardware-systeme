library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity REGFILE is
    port (
        clk: in std_logic;
        out0_data: out std_logic_vector (15 downto 0);  -- Datenausgang 0 (16bit)
        out0_sel: in std_logic_vector (2 downto 0);     -- Register-Nr. 0 (=int(0-7))
        out1_data: out std_logic_vector (15 downto 0);  -- Datenausgang 1 (16bit)
        out1_sel: in std_logic_vector (2 downto 0);     -- Register-Nr. 1 (=int(0-7))
        in_data: in std_logic_vector (15 downto 0);     -- Dateneingang   (16bit)
        in_sel: in std_logic_vector (2 downto 0);       -- Register-Wahl  (=int(0-7))
        load_lo, load_hi: in std_logic                  -- Register laden
    );
end REGFILE;


architecture RTL of REGFILE is
    type t_regfile is array (0 to 7) of std_logic_vector (15 downto 0); -- Mehrdimensionales Array (8 x 16)
    signal reg: t_regfile;
    signal reg_idx : std_logic_vector (15 downto 0);

begin
    -- Ausgabe
    -- process(out0_set, out1_sel, in_sel)
    -- beginn
    out0_data <= reg(to_integer(unsigned(out0_sel))); -- Ausgang 0
    out1_data <= reg(to_integer(unsigned(out1_sel))); -- Ausgang 1
    reg_idx <= reg(to_integer(unsigned(in_sel))); -- ausgewähltes Register zum Laden
    -- end process

    -- Zustandsübergang
    process(clk, load_hi, load_lo, in_data, in_sel, reg_idx)
    begin
        if rising_edge(clk) then
            if(load_lo = '1' and load_hi = '0') then
                reg(to_integer(unsigned(in_sel))) <= reg_idx(15 downto 8) & in_data(7 downto 0);
            end if;
            if(load_lo = '0' and load_hi = '1') then
                reg(to_integer(unsigned(in_sel))) <= in_data(15 downto 8) & reg_idx(7 downto 0);
            end if;
            if(load_lo = '1' and load_hi = '1') then
                reg(to_integer(unsigned(in_sel))) <= in_data(15 downto 0);
            end if;
        end if;
    end process;    
    
end RTL;
