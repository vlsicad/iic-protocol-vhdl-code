-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : rdwr1 iic protocol logic
-- Author      : manish
-- Company     : 
--

-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity rdwr1 is 
	port (
		ACKSDA: in STD_LOGIC;
		burstmode: in STD_LOGIC;
		clk: in STD_LOGIC;
		inSDA: in STD_LOGIC;
		loaddata: in STD_LOGIC;
		rst: in STD_LOGIC;
		start_read: in STD_LOGIC;
		startc: in STD_LOGIC;
		stopc: in STD_LOGIC;
		wdata: in STD_LOGIC_VECTOR (7 downto 0);
		ASDA: out STD_LOGIC;
		EXDATACLK: out STD_LOGIC;
		pend: out STD_LOGIC;
		rdata: out STD_LOGIC_VECTOR (7 downto 0);
		SCL: out STD_LOGIC;
		SDA: out STD_LOGIC);
end rdwr1;

architecture rdwr1_arch of rdwr1 is

-- SYMBOLIC ENCODED state machine: Sreg0
type Sreg0_type is (
    S25, S7, S9, S10, S5, S6, S8, S15, S16, S12, S13, S17, S18, S14, S1, S20, S19, S21, S22, S23, S24
);
-- attribute enum_encoding of Sreg0_type: type is ... -- enum_encoding attribute is not supported for symbolic encoding

signal Sreg0: Sreg0_type;

begin

-- concurrent signals assignments

-- Diagram ACTION

----------------------------------------------------------------------
-- Machine: Sreg0
----------------------------------------------------------------------
Sreg0_machine: process (clk)
-- machine variables declarations
variable counter: INTEGER range 8 downto 0;

begin
	if clk'event and clk = '1' then
		if rst='1' then	
			Sreg0 <= S25;
			-- Set default values for outputs, signals and variables
			-- ...
			SDA <= '1';
			SCL <= '1';
			counter := 0;
			rdata <= "00000000";
			EXDATACLK <= '0';
		else
			-- Set default values for outputs, signals and variables
			-- ...
			case Sreg0 is
				when S25 =>
					SDA <= '1';
					SCL <= '1';
					counter := 0;
					rdata <= "00000000";
					EXDATACLK <= '0';
					Sreg0 <= S1;
				when S7 =>
					SCL <= '1';
					counter := counter + 1;
					if counter < 8 then	
						Sreg0 <= S5;
					else
						Sreg0 <= S8;
					end if;
				when S9 =>
					SCL <= '1';
					ASDA <= ACKSDA;
					Sreg0 <= S10;
				when S10 =>
					SCL <= '0';
					Sreg0 <= S1;
				when S5 =>
					SDA <= wdata(counter);
					SCL <= '1';
					Sreg0 <= S6;
				when S6 =>
					SCL <= '0';
					Sreg0 <= S7;
				when S8 =>
					SDA <= '1';
					SCL <= '0';
					Sreg0 <= S9;
				when S15 =>
					SCL <= '0';
					counter := counter + 1;
					if counter < 8 then	
						Sreg0 <= S13;
					else
						Sreg0 <= S16;
					end if;
				when S16 =>
					SCL <= '1';
					Sreg0 <= S17;
				when S12 =>
					SCL <= '0';
					Sreg0 <= S13;
				when S13 =>
					SCL <= '1';
					Sreg0 <= S14;
				when S17 =>
					SDA <= '1';
					Sreg0 <= S18;
				when S18 =>
					SCL <= '0';
					if burstmode='1' then	
						Sreg0 <= S19;
					else
						Sreg0 <= S1;
					end if;
				when S14 =>
					rdata(counter) <= inSDA;
					Sreg0 <= S15;
				when S1 =>
					SDA <= '1';
					SCL <= '1';
					counter := 0;
					rdata <= "00000000";
					EXDATACLK <= '0';
					if loaddata ='1' then	
						Sreg0 <= S5;
					elsif startc='1' then	
						Sreg0 <= S21;
					elsif stopc='1' then	
						Sreg0 <= S23;
					elsif start_read ='1' then	
						Sreg0 <= S12;
					elsif startc ='0' and  stopc = '0' and  start_read ='0' and  loaddata = '0' then	
						Sreg0 <= S1;
					end if;
				when S20 =>
					EXDATACLK <= '0';
					Sreg0 <= S12;
				when S19 =>
					EXDATACLK <= '1';
					Sreg0 <= S20;
				when S21 =>
					SDA <= '1';
					SCL <= '1';
					Sreg0 <= S22;
				when S22 =>
					SDA <= '0';
					SCL <= '1';
					Sreg0 <= S1;
				when S23 =>
					SDA <= '0';
					SCL <= '1';
					Sreg0 <= S24;
				when S24 =>
					SDA <= '1';
					SCL <= '1';
					Sreg0 <= S1;
--vhdl_cover_off
				when others =>
					null;
--vhdl_cover_on
			end case;
		end if;
	end if;
end process;

-- signal assignment statements for combinatorial outputs
pend_assignment:
pend <= '0' when (Sreg0 = S25) else
        '1' when (Sreg0 = S7) else
        '1' when (Sreg0 = S9) else
        '1' when (Sreg0 = S10) else
        '1' when (Sreg0 = S5) else
        '1' when (Sreg0 = S6) else
        '1' when (Sreg0 = S8) else
        '1' when (Sreg0 = S15) else
        '1' when (Sreg0 = S16) else
        '1' when (Sreg0 = S12) else
        '1' when (Sreg0 = S13) else
        '1' when (Sreg0 = S17) else
        '1' when (Sreg0 = S18) else
        '1' when (Sreg0 = S14) else
        '0' when (Sreg0 = S1) else
        '1' when (Sreg0 = S20) else
        '1' when (Sreg0 = S19) else
        '1' when (Sreg0 = S21) else
        '1' when (Sreg0 = S22) else
        '1' when (Sreg0 = S23) else
        '1' when (Sreg0 = S24) else
        '0';

end rdwr1_arch;
