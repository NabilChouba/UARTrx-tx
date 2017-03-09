LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testbenchs_vhd IS
END testbenchs_vhd;

ARCHITECTURE behavior OF testbenchs_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT  transmiter is
        Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           start : in  STD_LOGIC;
           data : in  std_logic_vector(7 downto 0);
           tx : out  STD_LOGIC);
	END COMPONENT;

	--Inputs
	SIGNAL clk   : std_logic := '0';
	SIGNAL rst   : std_logic := '1';
	SIGNAL start : std_logic := '1';
   SIGNAL data  : std_logic_vector(7 downto 0):=x"61";

	--Outputs
	SIGNAL tx :  std_logic;

BEGIN

  
	-- Instantiate the Unit Under Test (UUT)
	uut: transmiter PORT MAP(
		clk => clk,
		rst => rst,
		start => start,
		data => data,
		tx => tx
	);

  clk <= not clk after 50 ns;
  rst <= '0' after 150 ns;
  start <= '0' after 500 ns;
  


END;
