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

entity transmiter is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           start : in  STD_LOGIC;
           data : in  std_logic_vector(7 downto 0);
           tx : out  STD_LOGIC);
end transmiter;

architecture rtl of transmiter is

  -- counter bautrate signal
  signal bautrate    : std_logic ; 
  signal run_brcount : std_logic ; 
  signal soft_rst_brcount : std_logic ; 
  signal counter_bautrate_reg , counter_bautrate_next : std_logic_vector(15 downto 0)   ;  

  -- shift data signal
  signal shiftBit: std_logic ;
  signal load_shift : std_logic ;
  signal run_shift  : std_logic ;
  signal data_shift_reg,data_shift_next : std_logic_vector(7 downto 0);

  -- parity signal generation
  signal parity  : std_logic ; 

  -- tx select (stop,start,data,parity) 
  signal seltx   : std_logic_vector(1 downto 0)   ;  

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
    elsif( clk'event and clk='1' ) then
      state_reg<= state_next ;
      counter_bautrate_reg <= counter_bautrate_next;
      data_shift_reg <= data_shift_next;		
    end if;
 end process ;
 
 bautrate <= '1' when counter_bautrate_reg = 6875  else
              '0';
 
 BR_COUNTER_GEN : process( counter_bautrate_reg,run_brcount,soft_rst_brcount,bautrate )
    begin
     counter_bautrate_next  <= counter_bautrate_reg;

     if  soft_rst_brcount = '1' or bautrate = '1' then
       counter_bautrate_next <= (others=>'0');
     elsif( run_brcount  = '1'  ) then
        counter_bautrate_next <= counter_bautrate_reg + 1 ;    
     end if ;
    
 end process ;
	 
comb_shift:process(load_shift,data_shift_reg,run_shift,data,bautrate)
begin
    data_shift_next<= data_shift_reg;
    if load_shift ='1' then
      data_shift_next <=data;
    elsif run_shift ='1' and bautrate = '1' then
      data_shift_next <= data_shift_reg(0) & data_shift_reg(7 downto 1);
    end if;
end process;

  -- data tx signal generation
shiftBit <= data_shift_reg(0);

  -- parity signal generation
 parity<=data_shift_reg(0)xor data_shift_reg(1)xor data_shift_reg(2)xor data_shift_reg(3)xor data_shift_reg(4)xor data_shift_reg(5)xor data_shift_reg(6)xor data_shift_reg(7);

  -- tx select (stop,start,data,parity) 
tx <= 	shiftBit when seltx ="00" else -- Data  bit
        '0'      when seltx ="01" else -- Start bit
        '1'      when seltx ="10" else -- Stop  bit
        parity ;


  --next state processing
  combinatory_FSM_next : process(state_reg,start,bautrate)
  begin
    state_next<= state_reg;
	  
    case state_reg is
    when idle =>
      if start = '1' then
        state_next <= b_start;  
      end if;

    when b_start =>
      if bautrate = '1' then
        state_next <= b_0;
      end if;

    when b_0 =>
      if bautrate = '1' then
        state_next <= b_1;
      end if;

    when b_1 =>
      if bautrate = '1' then
        state_next <= b_2;
      end if;

    when b_2 =>
      if bautrate = '1' then
        state_next <= b_3;
      end if;

    when b_3 =>
      if bautrate = '1' then
        state_next <= b_4;
      end if;

    when b_4 =>
      if bautrate = '1' then
        state_next <= b_5;
      end if;

    when b_5 =>
      if bautrate = '1' then
        state_next <= b_6;
      end if;

    when b_6 =>
      if bautrate = '1' then
        state_next <= b_7;
      end if;

    when b_7 =>
      if bautrate = '1' then
        state_next <= b_stop;
      end if;

    when b_parity =>
      if bautrate = '1' then
        state_next <= b_stop;
      end if;

    when b_stop =>
      if bautrate = '1' then
        state_next <= idle;
      end if;		
		
    when others =>
    end case;
  end process;

  --controle output processing
  combinatory_output : process(state_reg )
  begin
    run_brcount <= '0';
    seltx <= "10"; --stop bit;
    soft_rst_brcount <= '0';
    Load_shift  <= '0';
    run_shift <= '0';
	  
    case state_reg is
    when idle =>
       seltx <= "10"; --stop bit;
       soft_rst_brcount <= '0';

    when b_start =>
      seltx <= "01";
      run_brcount <= '1';
      Load_shift  <= '1';
		

		
    when b_0 | b_1 | b_2 | b_3 |b_4 | b_5 |b_6 | b_7 =>
      run_brcount <= '1';
      run_shift <= '1';
      seltx <= "00";

    when b_parity =>
      run_brcount <= '1';
      seltx <= "10";

    when b_stop =>
      seltx <="10";
      run_brcount <= '1';
		
    when others =>


    end case;
  end process;

end rtl;

