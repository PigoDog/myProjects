-- MAX+plus II VHDL Template
-- Clearable flipflop with enable

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY rstr1 IS

	PORT
	(
		s		: IN	STD_LOGIC;
		r    	: IN	STD_LOGIC;
		q 		: OUT	STD_LOGIC);
	
END rstr1;

ARCHITECTURE behav OF rstr1 IS
	component notor
		port(
			a : IN std_logic;
			b : IN std_logic;
			c : INOUT std_logic
		);
	end component;

	SIGNAL	q1	: STD_LOGIC;
	SIGNAL	q2	: STD_LOGIC;	
BEGIN
	u1 : notor
		port map(s, q2, q1);
	u2 : notor
		port map(q1, r, q2);

q <= q2;
END behav;

