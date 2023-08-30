LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;



entity ALU is
	port (
		a:		in	std_logic_vector (15 downto 0);		-- Eingang A
		b:		in	std_logic_vector (15 downto 0);		-- Eingang B
		sel:	in	std_logic_vector ( 2 downto 0);		-- Operation
		y:		out	std_logic_vector (15 downto 0);		-- Ausgang
		zero:	out	std_logic							-- gesetzt, wenn B = 0
	);
end ALU;


architecture RTL of ALU is
begin
	process(a, b, sel)
	begin
		case(sel) is
			when "000" =>	-- add
				y <= std_logic_vector(signed(a) + signed(b));
			when "001" =>	-- sub
				y <= std_logic_vector(signed(a) - signed(b));
			when "010" =>	-- sal
				y <=  a(14 downto 0) & '0';
			when "011" =>	-- sar
				y <= a(a'high) & a(15 downto 1);
			when "100" =>	-- and
				y <= a and b;
			when "101" =>	-- or
				y <= a or b;
			when "110" =>	-- xor
				y <= a xor b;
			when "111" =>	-- not
				y <= not a;
			when others =>
				y <= X"0000";
		end case;
	end process;

	process(b)
	begin
		if b = X"0000" then
			zero <= '1';
		else
			zero <= '0';
		end if;
	end process;
end;

