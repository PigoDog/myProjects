library ieee;
use ieee.std_logic_1164.all;

entity fifo_code is
  port
  (
    CLK : in std_logic;
    DI : in std_logic_vector(0 to 7);
    RD : in std_logic;
    WR : in std_logic;
    Reset : in std_logic;

    Full : out std_logic;
    Empty : out std_logic;
    DO : out std_logic_vector(0 to 7)
  );
end fifo_code;

architecture behav of fifo_code is

  type array_type is array (0 to 7) of std_logic_vector(0 to 7);

  signal dffArr : array_type := (others => (others => '0'));

  signal RDCOUNTER : integer range 0 to 7 := 0;
  signal WRCOUNTER : integer range 0 to 7 := 0;
  signal count : integer range 0 to 8 := 0;

begin

process(CLK, Reset)
begin

  if (Reset = '1') then

    RDCOUNTER <= 0;
    WRCOUNTER <= 0;
    count <= 0;

	for i in 0 to 7 loop
  		dffArr(i) <= "00000000";
	end loop;
    Full <= '0';
    Empty <= '1';

    DO <= (others => '0');

  elsif rising_edge(CLK) then

    if ((RD = '1') and (count > 0)) then

      DO <= dffArr(RDCOUNTER);

      if RDCOUNTER = 7 then
        RDCOUNTER <= 0;
      else
        RDCOUNTER <= RDCOUNTER + 1;
      end if;

      count <= count - 1;

    elsif ((WR = '1') and (count < 8)) then

      dffArr(WRCOUNTER) <= DI;

      if WRCOUNTER = 7 then
        WRCOUNTER <= 0;
      else
        WRCOUNTER <= WRCOUNTER + 1;
      end if;

      count <= count + 1;

    end if;

    if count = 8 then
      Full <= '1';
      Empty <= '0';

    elsif count = 0 then
      Full <= '0';
      Empty <= '1';

    else
      Full <= '0';
      Empty <= '0';

    end if;

  end if;

end process;

end behav;
