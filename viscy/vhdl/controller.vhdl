library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity CONTROLLER is
  port (
    clk, reset : in std_logic;

    -- Statussignale
    ir : in std_logic_vector(15 downto 0);      -- Befehlswort
    ready, zero : in std_logic;                 -- weitere Statussignale

    -- Steuersignale
    c_reg_ldmem, c_reg_ldi,                     -- Auswahl beim Register-Laden
    c_regfile_load_lo, c_regfile_load_hi,       -- Steuersignale Reg.-File
    c_pc_load, c_pc_inc,                        -- Steuereingänge PC
    c_ir_load,                                  -- Steuereingang IR
    c_mem_rd, c_mem_wr,                         -- Signale zum Speicher
    c_adr_pc_not_reg : out std_logic            -- Auswahl Adress-Quelle
  );
end CONTROLLER;


architecture RTL of CONTROLLER is
  -- Anmerkung: s_ld(ready=0) / s_ld2(ready=1)
  -- Laden des Werts aus dem Speicher, wenn der Speicher bereit ist (ready=0).
  -- Erst in das Register-File schreiben, wenn Ladevorgang fertig ist (ready=1).
  -- Problem: Würde das Register-File zu früh geupdatet werden, könnte mit veralteten/falschen Werten gerechnet werden...
  type t_state is (s_reset, s_if1, s_if2, s_id, s_alu, s_ldih, s_ldil, s_ld, s_ld2, s_st, s_jmp, s_halt, s_jz, s_jnz, s_wait);
  signal state : t_state;
begin

  -- Prozess für die Übergangsfunktion / Zustandsregister (taktsynchroner Prozess)
  state_trans : process (clk)
  begin
    if rising_edge (clk) then
      if reset = '1' then
        state <= s_reset;                                               -- Reset hat Vorrang!
      else
        case state is
          when s_reset => state <= s_if1;                               -- Reset state: geht direkt zu instruction fetch 1 (if1)
          when s_if1 => if ready = '0' then state <= s_if2; end if;     -- Instruction fetch 1
          when s_if2 => if ready = '1' then state <= s_id; end if;      -- Instruction fetch 2
          when s_id =>                                                  -- Instruction decode
            if ir(15 downto 14) = "00" then state <= s_alu;
            elsif ir(15 downto 14) = "01" then
              if ir(12 downto 11) = "00" then state <= s_ldil;
              elsif ir(12 downto 11) = "01" then state <= s_ldih;
              elsif ir(12 downto 11) = "10" then                        -- load from memory
                if ready = '0' then
                  state <= s_ld;
                else
                  state <= s_wait;
                end if;
              elsif ir(12 downto 11) = "11" then                        --store to memory
                if ready = '0' then
                  state <= s_st;
                else
                  state <= s_wait;
                end if;
              else NULL;
              end if;
            elsif ir(15 downto 14) = "10" then
                if ir(12 downto 11) = "00" then state <= s_jmp;
                elsif ir(12 downto 11) = "01" then state <= s_halt;
                elsif ir(12 downto 11) = "10" then
                  if zero = '1' then
                    state <= s_jz;
                  else
                    state <= s_if1;                                     -- if no jump, fetch next
                  end if;
                elsif ir(12 downto 11) = "11" then
                  if zero = '0' then
                    state <= s_jnz;
                  else
                    state <= s_if1;                                     -- if no jump, fetch next
                  end if;
                else NULL;
              end if;
            else
              NULL;
            end if;
          when s_alu => state <= s_if1;                                 -- ALU
          when s_ldil => state <= s_if1;                                -- LDIL
          when s_ldih => state <= s_if1;                                -- LDIH
          when s_wait =>
            if ready = '0' then                                         -- warten auf "memory ready"
              if ir(12 downto 11) = "10" then                           -- load
                state <= s_ld;
              elsif ir(12 downto 11) = "11" then                        -- store
                state <= s_st;
              end if;
            end if;
          when s_ld => if ready = '1' then state <= s_ld2; end if;
          when s_st => if ready = '1' then state <= s_if1; end if;      -- Store to memory
          when s_ld2 => state <= s_if1;
          when s_jmp => state <= s_if1;                                 -- jump
          when s_jz => state <= s_if1;                                  -- jump on zero
          when s_jnz => state <= s_if1;                                 -- jump on one
          when others => NULL;                                          -- Halt
            -- im Halt Zustand wird nichts gemacht, bis ein RESET kommt
        end case;
      end if;
    end if;
  end process;

  -- Prozess für die Ausgabefunktion (Schaltnetz)
  -- Zielstruktur: Moore-Automat, demnach hier keine Bedingungen mehr verwenden. Ausgang muss komplett vom Zustand abhängen.
  output : process (state)
  begin
    -- Default-Werte für alle Ausgangssignale
    c_reg_ldmem <= '0';
    c_reg_ldi <= '0';                                                   -- Auswahl beim Register-Laden
    c_regfile_load_lo <= '0';
    c_regfile_load_hi <= '0';                                           -- Steuersignale Reg.-File
    c_pc_load <= '0';
    c_pc_inc <= '0';                                                    -- Steuereingänge PC
    c_ir_load <= '0';                                                   -- Steuereingang IR
    c_mem_rd <= '0';
    c_mem_wr <= '0';                                                    -- Signale zum Speicher
    c_adr_pc_not_reg <= '0';

    -- Hier müssen nur Abweichungen von der Default-Belegung behandelt werden
    case state is
      when s_if2 =>
        c_adr_pc_not_reg <= '1'; 
        c_mem_rd <= '1';
        c_ir_load <= '1';
      when s_id =>
        c_pc_inc <= '1';
      when s_alu =>
        c_regfile_load_lo <= '1';
        c_regfile_load_hi <= '1';
      when s_ldil =>
        c_regfile_load_lo <= '1';
        c_reg_ldi <= '1';
      when s_ldih =>
        c_regfile_load_hi <= '1';
        c_reg_ldi <= '1';
      when s_st =>
        c_mem_wr <= '1';
      when s_ld =>
        c_mem_rd <= '1';
        c_reg_ldmem <= '1';
      when s_ld2 =>
        c_mem_rd <= '1';
        c_reg_ldmem <= '1';
        c_regfile_load_hi <= '1';
        c_regfile_load_lo <= '1';
      when s_jmp =>
        c_pc_load <= '1';
      when s_jz =>
        c_pc_load <= '1';
      when s_jnz =>
        c_pc_load <= '1';
      when others => NULL;
    end case;
  end process;

end RTL;
