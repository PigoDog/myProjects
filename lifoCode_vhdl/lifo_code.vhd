library ieee;
use ieee.std_logic_1164.all;

entity lifo_code is
  port(
    CLK:in std_logic;
    DI:in std_logic_vector(0 to 7);
    RD:in std_logic;
    WR:in std_logic;
    Reset:in std_logic;
    Full:out std_logic;
    Empty:out std_logic;
    DO:out std_logic_vector(0 to 7)
  );
end lifo_code;

architecture behav of lifo_code is
  type array_type is array(0 to 7) of std_logic_vector(0 to 7);
  signal dffArr:array_type:=(others=>"00000000");
  signal count:integer:=0;
begin
  process(CLK,Reset)
    variable idx:integer range 0 to 7;
  begin
    if Reset='1' then
      count<=0;
      for i in 0 to 7 loop
        dffArr(i)<="00000000";
      end loop;
      Full<='0';
      Empty<='1';
      DO<="00000000";
    elsif rising_edge(CLK) then
      if WR='1' and RD='1' and count>0 and count<8 then
        idx:=count-1;
        DO<=dffArr(idx);
        dffArr(idx)<=DI;
      elsif WR='1' and count<8 then
        idx:=count;
        dffArr(idx)<=DI;
        count<=count+1;
      elsif (RD='1') and (count>0) then
        idx:=count-1;
        DO<=dffArr(idx);
        count<=count-1;
      end if;
      if count=8 then
        Full<='1';
        Empty<='0';
      elsif count=0 then
        Full<='0';
        Empty<='1';
      else
        Full<='0';
        Empty<='0';
      end if;
    end if;
  end process;
end behav;
