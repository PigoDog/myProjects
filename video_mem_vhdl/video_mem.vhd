library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity video_mem is 
	port(
		data: in std_logic_vector(7 downto 0);
		clock: in std_logic;
		kks: in std_logic_vector(7 downto 0);
		query: in std_logic;
		init: in std_logic;
		synchro: out std_logic;
		q: out std_logic_vector(7 downto 0);
		get: out std_logic
	);
end video_mem;

architecture behav of video_mem is
	component lpm_dff
		generic(
			LPM_WIDTH : natural := 8			
		);		
		port( 
			data: in std_logic_vector(7 downto 0);
			clock: in std_logic;
			q: out std_logic_vector(7 downto 0)
		);
	end component;
	component busmux
		generic(
			WIDTH : natural := 8			
		);
		port(
			dataa : IN std_logic_vector(WIDTH -1 downto 0);
			datab : IN std_logic_vector(WIDTH -1  downto 0);
			sel : IN std_logic;
			result : OUT std_logic_vector(WIDTH -1  downto 0)
		);
	end component;
	component lpm_compare
		generic(
			LPM_WIDTH : natural := 8;
			LPM_REPRESENTATION : string := "UNSIGNED"
		);
		port(
			dataa : in std_logic_vector(7 downto 0);
			datab : in std_logic_vector(7 downto 0);
			aeb : out std_logic
		);
	end component;
	component rstr1
		port( 
			s : in std_logic;
			r : in std_logic;
			q : out std_logic
		);
	end component;

	component counter
		port(
			CLOCK: IN STD_LOGIC;
			RESET: IN STD_LOGIC;
			OVER: OUT STD_LOGIC
		);
	end component;
	signal dff1: std_logic_vector(7 downto 0);
	signal dff2: std_logic_vector(7 downto 0);
	signal dff3: std_logic_vector(7 downto 0);
	signal dff4: std_logic_vector(7 downto 0);
	signal dff5: std_logic_vector(7 downto 0);
	signal dff6: std_logic_vector(7 downto 0);
	signal dff7: std_logic_vector(7 downto 0);
	signal dff8: std_logic_vector(7 downto 0);
	signal count: std_logic;
	signal trstr1 : std_logic;
	signal trstr2 : std_logic;
	signal sigand : std_logic;
	signal sigsynchro : std_logic; 
	signal sigq : std_logic_vector(7 downto 0);
	signal sigmux : std_logic_vector(7 downto 0);
	signal sigget : std_logic; 
 
BEGIN
	sigget <= trstr2 or init;
	compare : lpm_compare
		port map(kks, sigq, sigsynchro);
	muxchange : busmux
		port map (sigq, data, sigget, sigmux);
	dtrig1 : lpm_dff
		port map (sigmux, clock, dff1);
	dtrig2 : lpm_dff
		port map (dff1, clock, dff2);
	dtrig3 : lpm_dff
		port map (dff2, clock, dff3);
	dtrig4 : lpm_dff
		port map (dff3, clock, dff4);
	dtrig5 : lpm_dff
		port map (dff4, clock, dff5);
	dtrig6 : lpm_dff
		port map (dff5, clock, dff6);
	dtrig7 : lpm_dff
		port map (dff6, clock, dff7);
	dtrig8 : lpm_dff
		port map (dff7, clock, dff8);
	dtrig9 : lpm_dff
		port map (dff8, clock, sigq);
	schet : counter
		port map (clock, sigsynchro, count);
	rs1: rstr1
		port map(query, count, trstr1);
	sigand <= trstr1 and sigsynchro;
	synchro <= sigsynchro;
	q <= sigq;
	get <= sigget;
	rs2: rstr1
		port map(sigand, count, trstr2);

end behav;

			
		
