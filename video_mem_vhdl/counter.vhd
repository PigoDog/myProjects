library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is 
port(
	CLOCK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	OVER: OUT STD_LOGIC
	);
END COUNTER;

architecture behav of counter is
	signal count_up: std_logic_vector(2 downto 0);
begin 
process(CLOCK, RESET)
BEGIN
	if(RESET = '1') then
		count_up <= "0"; 
		OVER <= '0';
	elsif(rising_edge(CLOCK)) THEN 
		count_up <= count_up + "1";
		if(count_up = "111") THEN
			OVER <= '1';
		ELSE
			OVER <= '0';
		end if;
	end if;
end process;
	
END behav;
	
