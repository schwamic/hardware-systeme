library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.uniform;
use IEEE.math_real.floor;


entity ALU_TB is
end entity;


architecture TESTBENCH of ALU_TB is

	component ALU is
		port(
			a:		in	std_logic_vector (15 downto 0);
			b:		in	std_logic_vector (15 downto 0);
			sel:	in	std_logic_vector ( 2 downto 0);
			y:		out	std_logic_vector (15 downto 0);
			zero:	out	std_logic
		);
	end component;

	for IMPL: ALU use entity WORK.ALU(RTL);

	signal a:		std_logic_vector (15 downto 0);
	signal b:		std_logic_vector (15 downto 0);
	signal sel:		std_logic_vector ( 2 downto 0);
	signal y:		std_logic_vector (15 downto 0);
	signal zero:	std_logic;

begin
	IMPL: ALU port map (
		a		=> a,
		b		=> b,
		sel		=> sel,
		y		=> y,
		zero	=> zero
	);

    process
		constant FUNC_ADD: std_logic_vector (2 downto 0) := "000";
		constant FUNC_SUB: std_logic_vector (2 downto 0) := "001";
		constant FUNC_SAL: std_logic_vector (2 downto 0) := "010";
		constant FUNC_SAR: std_logic_vector (2 downto 0) := "011";
		constant FUNC_AND: std_logic_vector (2 downto 0) := "100";
		constant FUNC_OR:  std_logic_vector (2 downto 0) := "101";
		constant FUNC_XOR: std_logic_vector (2 downto 0) := "110";
		constant FUNC_NOT: std_logic_vector (2 downto 0) := "111";


		function to_string (int: integer) return string is
		begin
			return integer'image(int);
		end function;


		function to_string (sl: std_logic) return string is
		begin
			return std_logic'image(sl);
		end function;


		function to_string (slv: std_logic_vector) return string is
			variable slv_str: string (slv'length - 1 downto 0) := (others => NUL);
		begin
			for i in slv'length - 1 downto 0 loop
				slv_str(i) := std_logic'image(slv(i))(2);
			end loop;

			return slv_str;
		end function;


		procedure test_function(
			g_sel: in std_logic_vector (2 downto 0);
			g_a, g_b, e_y: in std_logic_vector (15 downto 0);
			e_zero: in std_logic
		) is
			constant reset_delay: time := 1 ns;
			constant input_delay: time := 1 ns;
		begin
			sel <= (others => 'X');
			a <= (others => 'X');
			b <= (others => 'X');
			wait for reset_delay;
			sel <= g_sel;
			a <= g_a;
			b <= g_b;
			wait for input_delay;
			assert y = e_y
				report
					"Did not get the expected value for y:" & LF &
					"g_sel:  " & to_string(g_sel) & LF &
					"g_a:    " & to_string(g_a) & LF &
					"g_b:    " & to_string(g_b) & LF &
					"sel:    " & to_string(sel) & LF &
					"a:      " & to_string(a) & LF &
					"b:      " & to_string(b) & LF &
					"y:      " & to_string(y) & LF &
					"e_y:    " & to_string(e_y) & LF
				severity error;
			assert zero = e_zero
				report
					"Did not get the expected value for zero:" & LF &
					"g_sel:  " & to_string(g_sel) & LF &
					"g_a:    " & to_string(g_a) & LF &
					"g_b:    " & to_string(g_b) & LF &
					"sel:    " & to_string(sel) & LF &
					"a:      " & to_string(a) & LF &
					"b:      " & to_string(b) & LF &
					"zero:   " & to_string(zero) & LF &
					"e_zero: " & to_string(e_zero) & LF
				severity error;
		end procedure;


		variable seed1: positive := 28;
		variable seed2: positive := 350;

		impure function rand_int return integer is
			variable rand_r: real;
			variable rand_i: integer;
		begin
			uniform(seed1, seed2, rand_r);
			rand_i := integer(floor(rand_r * 65535.0));
			return rand_i;
		end function;


		variable t_a: unsigned (15 downto 0);
		variable t_b: unsigned (15 downto 0);
		variable e_y: unsigned (15 downto 0);
		variable e_zero: std_logic;
	begin
		-- this is here to make the report messages less ugly
		wait for 100001 ns;


		report "Running ALU Testbench";

		-- TESTING ADD
        report "add: 0000 + 0000";
		test_function(
			FUNC_ADD,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "add: FFFF + FFFF";
		test_function(
			FUNC_ADD,
			X"FFFF",
			X"FFFF",
			X"FFFE",
			'0'
		);
        report "add: FFFF + 0000";
		test_function(
			FUNC_ADD,
			X"FFFF",
			X"0000",
			X"FFFF",
			'1'
		);
        report "add: 0000 + FFFF";
		test_function(
			FUNC_ADD,
			X"0000",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "add: FFFF + 0001";
		test_function(
			FUNC_ADD,
			X"FFFF",
			X"0001",
			x"0000",
			'0'
		);
        report "add: 0001 + FFFF";
		test_function(
			FUNC_ADD,
			X"0001",
			X"FFFF",
			X"0000",
			'0'
		);
        report "add: AAAA + 5555";
		test_function(
			FUNC_ADD,
			X"AAAA",
			X"5555",
			x"FFFF",
			'0'
		);
        report "add: 5555 + AAAA";
		test_function(
			FUNC_ADD,
			X"5555",
			X"AAAA",
			X"FFFF",
			'0'
		);
        report "add: 0001 + 0001";
		test_function(
			FUNC_ADD,
			X"0001",
			X"0001",
			X"0002",
			'0'
		);
        report "add: 8000 + 8000";
		test_function(
			FUNC_ADD,
			X"8000",
			X"8000",
			X"0000",
			'0'
		);
        report "add: 100000x Random Operands";
		for i in 0 to 100000 loop
			t_a := to_unsigned(rand_int, a'length);
			t_b := to_unsigned(rand_int, b'length);
			e_y := t_a + t_b;
			if t_b = 0 then
				e_zero := '1';
			else
				e_zero := '0';
			end if;
			test_function(
				FUNC_ADD,
				std_logic_vector(t_a),
				std_logic_vector(t_b),
				std_logic_vector(e_y),
				e_zero
			);
			end loop;


		-- TESTING SUB
        report "sub: 0000 - 0000";
		test_function(
			FUNC_SUB,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "sub: FFFF - FFFF";
		test_function(
			FUNC_SUB,
			X"FFFF",
			X"FFFF",
			X"0000",
			'0'
		);
        report "sub: FFFF - 0000";
		test_function(
			FUNC_SUB,
			X"FFFF",
			X"0000",
			X"FFFF",
			'1'
		);
        report "sub: 0000 - FFFF";
		test_function(
			FUNC_SUB,
			X"0000",
			X"FFFF",
			X"0001",
			'0'
		);
        report "sub: 0000 - 0001";
		test_function(
			FUNC_SUB,
			X"0000",
			X"0001",
			X"FFFF",
			'0'
		);
        report "sub: 0001 - FFFF";
		test_function(
			FUNC_SUB,
			X"0001",
			X"FFFF",
			X"0002",
			'0'
		);
        report "sub: AAAA - 5555";
		test_function(
			FUNC_SUB,
			X"AAAA",
			X"5555",
			X"5555",
			'0'
		);
        report "sub: 5555 - AAAA";
		test_function(
			FUNC_SUB,
			X"5555",
			X"AAAA",
			X"AAAB",
			'0'
		);
        report "sub: 0001 - 0001";
		test_function(
			FUNC_SUB,
			X"0001",
			X"0001",
			X"0000",
			'0'
		);
        report "sub: 8000 - 8000";
		test_function(
			FUNC_SUB,
			X"8000",
			X"8000",
			X"0000",
			'0'
		);
        report "sub: 100000x Random Operands";
		for i in 0 to 100000 loop
			t_a := to_unsigned(rand_int, a'length);
			t_b := to_unsigned(rand_int, b'length);
			e_y := t_a - t_b;
			if t_b = 0 then
				e_zero := '1';
			else
				e_zero := '0';
			end if;
			test_function(
				FUNC_SUB,
				std_logic_vector(t_a),
				std_logic_vector(t_b),
				std_logic_vector(e_y),
				e_zero
			);
			end loop;


		-- TESTING SAL
        report "sal: 0000";
		test_function(
			FUNC_SAL,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "sal: FFFF";
		test_function(
			FUNC_SAL,
			X"FFFF",
			X"0000",
			X"FFFE",
			'1'
		);
        report "sal: 0001";
		test_function(
			FUNC_SAL,
			X"0001",
			X"0000",
			X"0002",
			'1'
		);
        report "sal: 8000";
		test_function(
			FUNC_SAL,
			X"8000",
			X"0000",
			X"0000",
			'1'
		);
        report "sal: 8001";
		test_function(
			FUNC_SAL,
			X"8001",
			X"0000",
			X"0002",
			'1'
		);
        report "sal: 7FFE";
		test_function(
			FUNC_SAL,
			X"7FFE",
			X"0000",
			X"FFFC",
			'1'
		);


		-- TESTING SAR
        report "sar: 0000";
		test_function(
			FUNC_SAR,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "sar: FFFF";
		test_function(
			FUNC_SAR,
			X"FFFF",
			X"0000",
			X"FFFF",
			'1'
		);
        report "sar: 0001";
		test_function(
			FUNC_SAR,
			X"0001",
			X"0000",
			X"0000",
			'1'
		);
        report "sar: 8000";
		test_function(
			FUNC_SAR,
			X"8000",
			X"0000",
			X"C000",
			'1'
		);
        report "sar: 8001";
		test_function(
			FUNC_SAR,
			X"8001",
			X"0000",
			X"C000",
			'1'
		);
        report "sar: 7FFE";
		test_function(
			FUNC_SAR,
			X"7FFE",
			X"0000",
			X"3FFF",
			'1'
		);


		-- TESTING AND
        report "and: 0000 & 0000";
		test_function(
			FUNC_AND,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "and: FFFF & 0000";
		test_function(
			FUNC_AND,
			X"FFFF",
			X"0000",
			X"0000",
			'1'
		);
        report "and: 0000 & FFFF";
		test_function(
			FUNC_AND,
			X"0000",
			X"FFFF",
			X"0000",
			'0'
		);
        report "and: FFFF & FFFF";
		test_function(
			FUNC_AND,
			X"FFFF",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "and: 0000 & AAAA";
		test_function(
			FUNC_AND,
			X"0000",
			X"AAAA",
			X"0000",
			'0'
		);
        report "and: 0000 & 5555";
		test_function(
			FUNC_AND,
			X"0000",
			X"5555",
			X"0000",
			'0'
		);
        report "and: AAAA & 0000";
		test_function(
			FUNC_AND,
			X"AAAA",
			X"0000",
			X"0000",
			'1'
		);
        report "and: 5555 & 0000";
		test_function(
			FUNC_AND,
			X"5555",
			X"0000",
			X"0000",
			'1'
		);
        report "and: FFFF & AAAA";
		test_function(
			FUNC_AND,
			X"FFFF",
			X"AAAA",
			X"AAAA",
			'0'
		);
        report "and: FFFF & 5555";
		test_function(
			FUNC_AND,
			X"FFFF",
			X"5555",
			X"5555",
			'0'
		);
        report "and: AAAA & FFFF";
		test_function(
			FUNC_AND,
			X"AAAA",
			X"FFFF",
			X"AAAA",
			'0'
		);
        report "and: 5555 & FFFF";
		test_function(
			FUNC_AND,
			X"5555",
			X"FFFF",
			X"5555",
			'0'
		);
        report "and: AAAA & 5555";
		test_function(
			FUNC_AND,
			X"AAAA",
			X"5555",
			X"0000",
			'0'
		);
        report "and: 5555 & AAAA";
		test_function(
			FUNC_AND,
			X"5555",
			X"AAAA",
			X"0000",
			'0'
		);


		-- TESTING OR
        report "or: 0000 | 0000";
		test_function(
			FUNC_OR,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "or: FFFF | 0000";
		test_function(
			FUNC_OR,
			X"FFFF",
			X"0000",
			X"FFFF",
			'1'
		);
        report "or: 0000 | FFFF";
		test_function(
			FUNC_OR,
			X"0000",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "or: FFFF | FFFF";
		test_function(
			FUNC_OR,
			X"FFFF",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "or: 0000 | AAAA";
		test_function(
			FUNC_OR,
			X"0000",
			X"AAAA",
			X"AAAA",
			'0'
		);
        report "or: 0000 | 5555";
		test_function(
			FUNC_OR,
			X"0000",
			X"5555",
			X"5555",
			'0'
		);
        report "or: AAAA | 0000";
		test_function(
			FUNC_OR,
			X"AAAA",
			X"0000",
			X"AAAA",
			'1'
		);
        report "or: 5555 | 0000";
		test_function(
			FUNC_OR,
			X"5555",
			X"0000",
			X"5555",
			'1'
		);
        report "or: FFFF | AAAA";
		test_function(
			FUNC_OR,
			X"FFFF",
			X"AAAA",
			X"FFFF",
			'0'
		);
        report "or: FFFF | 5555";
		test_function(
			FUNC_OR,
			X"FFFF",
			X"5555",
			X"FFFF",
			'0'
		);
        report "or: AAAA | FFFF";
		test_function(
			FUNC_OR,
			X"AAAA",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "or: 5555 | FFFF";
		test_function(
			FUNC_OR,
			X"5555",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "or: AAAA | 5555";
		test_function(
			FUNC_OR,
			X"AAAA",
			X"5555",
			X"FFFF",
			'0'
		);
        report "or: 5555 | AAAA";
		test_function(
			FUNC_OR,
			X"5555",
			X"AAAA",
			X"FFFF",
			'0'
		);


		-- TESTING XOR
        report "xor: 0000 ^ 0000";
		test_function(
			FUNC_XOR,
			X"0000",
			X"0000",
			X"0000",
			'1'
		);
        report "xor: FFFF ^ 0000";
		test_function(
			FUNC_XOR,
			X"FFFF",
			X"0000",
			X"FFFF",
			'1'
		);
        report "xor: 0000 ^ FFFF";
		test_function(
			FUNC_XOR,
			X"0000",
			X"FFFF",
			X"FFFF",
			'0'
		);
        report "xor: FFFF ^ FFFF";
		test_function(
			FUNC_XOR,
			X"FFFF",
			X"FFFF",
			X"0000",
			'0'
		);
        report "xor: 0000 ^ AAAA";
		test_function(
			FUNC_XOR,
			X"0000",
			X"AAAA",
			X"AAAA",
			'0'
		);
        report "xor: 0000 ^ 5555";
		test_function(
			FUNC_XOR,
			X"0000",
			X"5555",
			X"5555",
			'0'
		);
        report "xor: AAAA ^ 0000";
		test_function(
			FUNC_XOR,
			X"AAAA",
			X"0000",
			X"AAAA",
			'1'
		);
        report "xor: 5555 ^ 0000";
		test_function(
			FUNC_XOR,
			X"5555",
			X"0000",
			X"5555",
			'1'
		);
        report "xor: FFFF ^ AAAA";
		test_function(
			FUNC_XOR,
			X"FFFF",
			X"AAAA",
			X"5555",
			'0'
		);
        report "xor: FFFF ^ 5555";
		test_function(
			FUNC_XOR,
			X"FFFF",
			X"5555",
			X"AAAA",
			'0'
		);
        report "xor: AAAA ^ FFFF";
		test_function(
			FUNC_XOR,
			X"AAAA",
			X"FFFF",
			X"5555",
			'0'
		);
        report "xor: 5555 ^ FFFF";
		test_function(
			FUNC_XOR,
			X"5555",
			X"FFFF",
			X"AAAA",
			'0'
		);
        report "xor: AAAA ^ 5555";
		test_function(
			FUNC_XOR,
			X"AAAA",
			X"5555",
			X"FFFF",
			'0'
		);
        report "xor: 5555 ^ AAAA";
		test_function(
			FUNC_XOR,
			X"5555",
			X"AAAA",
			X"FFFF",
			'0'
		);


		-- TESTING NOT
        report "not: 0000";
		test_function(
			FUNC_NOT,
			X"0000",
			X"0000",
			X"FFFF",
			'1'
		);
        report "not: FFFF";
		test_function(
			FUNC_NOT,
			X"FFFF",
			X"0000",
			X"0000",
			'1'
		);
        report "not: AAAA";
		test_function(
			FUNC_NOT,
			X"AAAA",
			X"0000",
			X"5555",
			'1'
		);
        report "not: 5555";
		test_function(
			FUNC_NOT,
			X"5555",
			X"0000",
			X"AAAA",
			'1'
		);
        report "not: 7FFE";
		test_function(
			FUNC_NOT,
			X"7FFE",
			X"0000",
			X"8001",
			'1'
		);
        report "not: 8001";
		test_function(
			FUNC_NOT,
			X"8001",
			X"0000",
			X"7FFE",
			'1'
		);
        report "not: 0FF0";
		test_function(
			FUNC_NOT,
			X"0FF0",
			X"0000",
			X"F00F",
			'1'
		);
        report "not: F00F";
		test_function(
			FUNC_NOT,
			X"F00F",
			X"0000",
			X"0FF0",
			'1'
		);

		report "ALU Simulation finished";
		wait;
    end process;
end architecture;
