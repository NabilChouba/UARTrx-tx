----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:18:40 11/13/2009 
-- Design Name: 
-- Module Name:    transiver - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transiver is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0);
           sendchar : in  STD_LOGIC);
end transiver;



architecture RTL of transiver is

    COMPONENT resiver is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           data : out  std_logic_vector(7 downto 0);
           data_ready : out  STD_LOGIC);

    END COMPONENT;

	COMPONENT  transmiter is
        Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           start : in  STD_LOGIC;
           data : in  std_logic_vector(7 downto 0);
           tx : out  STD_LOGIC);
	END COMPONENT;

signal datasend :   STD_LOGIC_VECTOR (7 downto 0);
signal data_ready :   STD_LOGIC;
begin

u_rx: resiver PORT MAP(
		clk => clk,
		rst => rst,
		rx => rx,
		data => data,
		data_ready  => data_ready 
	);

u_tx: transmiter PORT MAP(
		clk => clk,
		rst => rst,
		start => sendchar,
		data => datasend,
		tx => tx
	);
	
datasend <= "01100001";

end RTL;

