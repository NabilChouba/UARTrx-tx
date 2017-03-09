----------------------------------------------------------------------------------
-- Company:  
-- Engineer: Nabil Chouba
-- 
-- Create Date:    10:51:24 04/16/2009 
-- Design Name:  transmiter RS-232
-- Module Name:    transmiter - rtl 
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

entity resiver is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           data : out  std_logic_vector(7 downto 0);
           data_ready : out  STD_LOGIC);
end resiver;

architecture rtl of resiver is

  -- counter bautrate signal
  signal bautrate8,bautrate16 : std_logic ; 
  signal run_brcount : std_logic ; 
  signal soft_rst_brcount : std_logic ; 
  signal counter_bautrate_reg , counter_bautrate_next : std_logic_vector(15 downto 0)   ; 


  -- shift data signal
  signal save_data : std_logic ;
  signal run_shift  : std_logic ;
  signal data_shift_reg,data_shift_next : std_logic_vector(7 downto 0);
  signal data_save_reg, data_save_next : std_logic_vector(7 downto 0);

  -- start detect
  signal rx_reg , rx_next  : std_logic ; 
  signal detect_start : std_logic ; 

  -- FSM States
   type state_type is (idle,b_start,b_0,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_parity,b_stop);
  -- FSM registers
  signal state_reg : state_type;
  signal state_next: state_type;

begin

 cloked_process : process( clk, rst )
  begin
    if( rst='1' ) then
      state_reg <=  idle ;
      counter_bautrate_reg  <= (others =>'0') ;
      data_shift_reg <= (others =>'0') ;
      data_save_reg <= (others =>'0') ;
      rx_reg <= '0';
    elsif( clk'event and clk='1' ) then
      state_reg<= state_next ;
      counter_bautrate_reg <= counter_bautrate_next;
      data_shift_reg <= data_shift_next;		
      data_save_reg <= data_save_next ;
      rx_reg <= rx_next;
    end if;
 end process ;
 
 bautrate16 <= '1' when counter_bautrate_reg = 6875  else
              '0';
 
 bautrate8 <= '1' when counter_bautrate_reg = 3437  else
              '0';

 BR_COUNTER_GEN : process( counter_bautrate_reg,run_brcount,soft_rst_brcount,bautrate16 )
    begin
     counter_bautrate_next  <= counter_bautrate_reg;

     if  soft_rst_brcount = '1' or bautrate16 = '1' then
       counter_bautrate_next <= (others=>'0');
     elsif( run_brcount  = '1'  ) then
        counter_bautrate_next <= counter_bautrate_reg + 1 ;    
     end if ;
    
 end process ;
	 
comb_shift:process(data_shift_reg,run_shift,rx)
begin
    data_shift_next<= data_shift_reg;
    if run_shift ='1'  then
      data_shift_next <= rx & data_shift_reg(7 downto 1);
    end if;
end process;

rx_next <= rx;
detect_start <= '1' when  rx_next = '0' and rx_reg = '1' else
                '0';
data_save_next <= data_shift_reg when save_data = '1' else
                  data_save_reg;

data <= data_save_reg;

  -- parity signal generation
-- parity<=data_shift_reg(0)xor data_shift_reg(1)xor data_shift_reg(2)xor data_shift_reg(3)xor data_shift_reg(4)xor data_shift_reg(5)xor data_shift_reg(6)xor data_shift_reg(7);


  --next state processing
  combinatory_FSM_next : process(state_reg,detect_start,bautrate8,bautrate16)
  begin
    state_next<= state_reg;
    run_brcount <='0';
    data_ready <= '0';
    save_data <= '0';
    soft_rst_brcount<='0';
    run_shift <='0';
	  
    case state_reg is
    when idle =>
      if detect_start = '1' then
        state_next <= b_start;  
        run_brcount <='1';
      end if;

    when b_start =>
      run_brcount <='1';
      if bautrate8 = '1' then
        state_next <= b_0;
      end if;

    when b_0 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_1;
        run_shift <='1';
      end if;

    when b_1 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_2;
        run_shift <='1';
      end if;

    when b_2 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_3;
        run_shift <='1';
      end if;

    when b_3 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_4;
        run_shift <='1';
      end if;

    when b_4 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_5;
        run_shift <='1';
      end if;

    when b_5 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_6;
        run_shift <='1';
      end if;

    when b_6 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_7;
        run_shift <='1';
      end if;

    when b_7 =>
      run_brcount <='1';
      if bautrate8  = '1' then
        state_next <= b_stop;
        run_shift <='1';
      end if;

    when b_parity =>
      run_brcount <='1';
      if bautrate8 = '1' then
        state_next <= b_stop;
      end if;

    when b_stop =>
      run_brcount <='1';
      if bautrate8 = '1' then
        state_next <= idle;
        data_ready <= '1';
        save_data <= '1';
        soft_rst_brcount<='1';
      end if;		
		
    when others =>
    end case;
  end process;

 
end rtl;

