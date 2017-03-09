
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:00:22 11/13/2009
-- Design Name:   transiver
-- Module Name:   C:/Xilinx92i/UARTRXTX/testbench_rxtx.vhd
-- Project Name:  UARTRXTX
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: transiver
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testbench_rxtx_vhd IS
END testbench_rxtx_vhd;

ARCHITECTURE behavior OF testbench_rxtx_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT transiver
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		rx : IN std_logic;
		sendchar : IN std_logic;          
		tx : OUT std_logic;
		data : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL clk :  std_logic := '0';
	SIGNAL rst :  std_logic := '1';
	SIGNAL rx :  std_logic ;
	SIGNAL sendchar :  std_logic := '1';

	--Outputs
	SIGNAL tx :  std_logic;
	SIGNAL data :  std_logic_vector(7 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: transiver PORT MAP(
		clk => clk,
		rst => rst,
		rx => rx,
		tx => tx,
		data => data,
		sendchar => sendchar
	);
rx <= tx;
  clk <= not clk after 50 ns;
  rst <= '0' after 150 ns;
  
  

	tb : PROCESS
	BEGIN
    sendchar <= '0' ;
		-- Wait 100 ns for global reset to finish
		wait for 1000000 ns;
 sendchar <= '1' ;
 wait for 1000 ns;
		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
