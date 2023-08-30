library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    port (
        clk, reset: in std_logic;							
        adr: out std_logic_vector (15 downto 0);	-- Adressbus (CPU -> Speicher)
        rdata: in std_logic_vector (15 downto 0);	-- Datenbus (lesen)
        wdata: out std_logic_vector (15 downto 0);	-- Datenbus (scrheiben)
        rd: out std_logic;							-- Lesen: 0: Anforderung / 1: Übernommen
        wr: out std_logic;							-- Schreiben: 0: Anforderung / 1: Übernommen
        ready: in std_logic							-- 0: Speicher bereit / 1: Speicher fertig
    );
end CPU;

architecture RTL of CPU is

    -- Component declarations...
    component ALU is
		port (
			a, b: in std_logic_vector (15 downto 0);
			sel	: in std_logic_vector (2 downto 0);
			y : out std_logic_vector (15 downto 0);
			zero : out std_logic
		);
	end component;
	
	component IR is
		port (
			clk: in std_logic;
			load: in std_logic;
			ir_in: in std_logic_vector (15 downto 0);
			ir_out: out std_logic_vector (15 downto 0)
       );
	end component;
	
	component PC is
		port (
			clk : in std_logic;
			reset, inc, load : in std_logic;
			pc_in : in std_logic_vector (15 downto 0);
			pc_out : out std_logic_vector (15 downto 0)
		);
	end component;

	component REGFILE is
		port (
			clk: in std_logic;
			in_data: in std_logic_vector (15 downto 0);
			in_sel: in std_logic_vector (2 downto 0); 
			out0_data: out std_logic_vector (15 downto 0);
			out0_sel: in std_logic_vector (2 downto 0); 
			out1_data: out std_logic_vector (15 downto 0);
			out1_sel: in std_logic_vector (2 downto 0);
			load_lo, load_hi: in std_logic
		);
	end component;

	component CONTROLLER is
		port (
			clk, reset: in std_logic;
			ir: in std_logic_vector (15 downto 0);
			ready, zero: in std_logic;
			c_reg_ldmem, c_reg_ldi,
			c_regfile_load_lo,
			c_regfile_load_hi,
			c_pc_load, c_pc_inc,
			c_ir_load,
			c_mem_rd, c_mem_wr,
			c_adr_pc_not_reg: out std_logic
		);
	end component;

    -- Configuration...
    for all: ALU use entity WORK.ALU(RTL);
    for all: PC use entity WORK.PC(RTL);
    for all: IR use entity WORK.IR(RTL);
    for all: REGFILE use entity WORK.REGFILE(RTL);
    for all: CONTROLLER use entity WORK.CONTROLLER(RTL);

    -- Internal signals
    
    -- ALU
    signal alu_y: std_logic_vector (15 downto 0);
    signal alu_zero: std_logic;
    
    -- IR
    signal ir_out: std_logic_vector (15 downto 0);
    
    -- REGFILE
    signal regfile_out0_data, regfile_out1_data, regfile_in_data: std_logic_vector (15 downto 0);
    
    -- PC
    signal pc_out: std_logic_vector (15 downto 0);
    
    -- CONTROLLER
	signal c_pc_load, c_pc_inc: std_logic;
	signal c_ir_load: std_logic;
	signal c_regfile_load_lo, c_regfile_load_hi: std_logic;
	signal c_reg_ldmem ,c_reg_ldi: std_logic;
	signal c_adr_pc_not_reg: std_logic;
	signal c_mem_rd, c_mem_wr: std_logic;

begin
    -- Component instatiations...
    U_ALU: ALU port map (
        a => regfile_out0_data,
        b => regfile_out1_data,
        y => alu_y,
        sel => ir_out(13 downto 11),
        zero => alu_zero
    );
    
    U_PC: PC port map (
		clk => clk,
		reset => reset,
		inc => c_pc_inc,
		load => c_pc_load,
		pc_in => regfile_out0_data,
		pc_out => pc_out
	);
	
	U_IR: IR port map (
		clk => clk,
		load => c_ir_load,
		ir_in => rdata,
		ir_out => ir_out
	);
	
	U_REGFILE: REGFILE port map (
		clk => clk,
		in_data => regfile_in_data,
		in_sel => ir_out(10 downto 8),
		out0_data => regfile_out0_data,
		out0_sel => ir_out(7 downto 5), 
		out1_data => regfile_out1_data,
		out1_sel => ir_out(4 downto 2),
		load_lo => c_regfile_load_lo,
		load_hi => c_regfile_load_hi
	);
    
    U_CONTROLLER: CONTROLLER port map (
		clk => clk,
		reset => reset,
		
		ir => ir_out(15 downto 0),
		ready => ready,
		zero => alu_zero,
	
		-- Auswahl beim Register-Laden
		c_reg_ldmem => c_reg_ldmem,
		c_reg_ldi => c_reg_ldi,
		
		-- Steuersignale Registerfile
		c_regfile_load_lo => c_regfile_load_lo,
		c_regfile_load_hi => c_regfile_load_hi,
		
		-- Steuereingänge PC
		c_pc_load => c_pc_load, 
		c_pc_inc => c_pc_inc,
		
		-- Steuereingang IR
		c_ir_load => c_ir_load,
		
		-- Signale zum Speicher
		c_mem_rd => c_mem_rd, 
		c_mem_wr => c_mem_wr,
		
		-- Auswahl Adress-Quelle
		c_adr_pc_not_reg => c_adr_pc_not_reg	
	);
    
    -- Multiplexer Adressbus...
    process (pc_out, regfile_out0_data, c_adr_pc_not_reg)
    begin
        if c_adr_pc_not_reg = '1' then adr <= pc_out;
		else adr <= regfile_out0_data;
        end if;
	end process;
	
	-- Multiplexer Regfile
	process (c_reg_ldi, c_reg_ldmem, ir_out, alu_y, rdata)
	begin
		if c_reg_ldi = '1' then regfile_in_data <= ir_out (7 downto 0) & ir_out (7 downto 0);
		elsif c_reg_ldmem = '1' then regfile_in_data <= rdata;
		elsif not (c_reg_ldi and c_reg_ldmem) = '1' then regfile_in_data <= alu_y;
		end if;
	end process;
		
	-- Speicher
	rd <= c_mem_rd;
	wr <= c_mem_wr;
	wdata <= regfile_out1_data;

end RTL;
