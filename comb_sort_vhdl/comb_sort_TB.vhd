library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.sort_types.all;

entity comb_sort_tb is
end comb_sort_tb;

architecture sim of comb_sort_tb is
	impure function count_elements(filename : string) return integer is
    	file f : text open read_mode is filename;
    	variable l : line;
    	variable cnt : integer := 0;
    	variable dummy : integer;
  	begin
    	while not endfile(f) loop
    		readline(f, l);
      		if l'length > 0 then
        		cnt := cnt + 1;
      		end if;
    	end loop;
    	file_close(f);
    	return cnt;
  	end function;

  constant N_actual : integer := count_elements("C:\data.txt");  
  signal clk      : std_logic := '0';
  signal reset    : std_logic := '1';
  signal working  : std_logic;
  signal data_in  : massType(0 to N_actual-1);
  signal data_out : massType(0 to N_actual-1);
  signal done     : std_logic;
  constant clk_period : time := 10 ns;

  component comb_sort
    generic (N : integer);
    port (
      clk      : in  std_logic;
      reset    : in  std_logic;
      working  : out std_logic;
      data_in  : in  massType(0 to N-1);
      data_out : out massType(0 to N-1);
      done     : out std_logic
    );
  end component;

begin

  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
  end process;

  UUT: comb_sort
    generic map (N => N_actual)
    port map (
      clk      => clk,
      reset    => reset,
      working  => working,
      data_in  => data_in,
      data_out => data_out,
      done     => done
    );

  stimulus: process
    file infile : text open read_mode is "C:\data.txt";
    variable line_v : line;
    variable val    : integer;
    variable idx    : integer := 0;
    variable tmp_array : massType(0 to N_actual-1);
  begin
    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    while not endfile(infile) loop
      readline(infile, line_v);
      read(line_v, val);
      if idx < N_actual then
        tmp_array(idx) := std_logic_vector(to_unsigned(val,8));
        idx := idx + 1;
      else
        exit;
      end if;
    end loop;
    
    data_in <= tmp_array;

    wait;
  end process;

end sim;

configuration TESTBENCH_FOR_comb_sort of comb_sort_tb is
  for sim
    for UUT : comb_sort
      use entity work.comb_sort(beh);
    end for;
  end for;
end TESTBENCH_FOR_comb_sort;
