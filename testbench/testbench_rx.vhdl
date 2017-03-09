LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testbench_vhd IS
END testbench_vhd;

ARCHITECTURE behavior OF testbench_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)

    COMPONENT resiver is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           data : out  std_logic_vector(7 downto 0);
           data_ready : out  STD_LOGIC);

    END COMPONENT;

	--Inputs
	SIGNAL clk   : std_logic := '0';
	SIGNAL rst   : std_logic := '1';
	SIGNAL rx : std_logic := '1';
       
	--Outputs
	SIGNAL data_ready :  std_logic;
        SIGNAL data :   std_logic_vector(7 downto 0);
        SIGNAL send_data :   std_logic_vector(7 downto 0):="10101010";
           

BEGIN

  
	-- Instantiate the Unit Under Test (UUT)
	uut: resiver PORT MAP(
		clk => clk,
		rst => rst,
		rx => rx,
		data => data,
		data_ready  => data_ready 
	);

  clk <= not clk after 50 ns;
  rst <= '0' after 150 ns;
  tb : PROCESS
  BEGIN
    -- idle bit
    rx <= '1';
    -- wiat 
    wait for 100 * 430 ns;

    --stat bit
    rx <= '0';
    wait for 100 * 430 ns;
    
    for i in 0 to 7 loop
      rx <= send_data(i);
      wait for 100 * 430 ns;
    end loop;

    -- party bit not implemented
    rx <= '-';
    wait for 100 * 430 ns;

    -- stop bit
    rx <= '1';
    wait for 100 * 5200 ns;

    -- do nothing
    wait for 100 * 430 ns;

    -- test if rw data = to sended data
    assert (data = send_data)
    report " data /= send_data" 
    severity Error;
    
    -- end of simulation
    wait for 1000ns;
    assert (2=1)
    report "end simulation"
    severity note;	
  
    wait; -- will wait forever
  end process;

END;
