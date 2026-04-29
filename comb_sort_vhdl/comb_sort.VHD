library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sort_types.all;

entity comb_sort is
  generic (
    N : integer := 8
  );
  port (
    clk      : in  std_logic;
    reset    : in  std_logic;
    working  : out std_logic;
    data_in  : in  massType(0 to N-1);
    data_out : out massType(0 to N-1);
    done     : out std_logic
  );
end comb_sort;

architecture beh of comb_sort is

  type state_type is (IDLE, LOAD, COMPLETE, SORT, UPDATE_GAP);
  signal state : state_type := IDLE;

  signal arr     : massType(0 to N-1);
  signal gap     : integer range 0 to N := N;
  signal i       : integer range 0 to N-1 := 0;
  signal swapped : boolean := false;

begin

  process(clk, reset)
    variable temp     : std_logic_vector(7 downto 0);
    variable new_gap  : integer;
  begin
    if reset = '1' then
      state    <= IDLE;
      working  <= '0';
      done     <= '0';
      arr      <= (others => (others => '0'));
      data_out <= (others => (others => '0'));
      gap      <= N * 1000 / 1300;
      swapped  <= false;
      i        <= 0;

    elsif rising_edge(clk) then
      case state is

        when IDLE =>
          working <= '0';
          state <= LOAD;

        when LOAD =>
          arr <= data_in;
          gap <= N * 1000 / 1300;
          swapped <= false;
          i <= 0;
          working <= '1';
          state <= SORT;

        when SORT =>
          if i + gap < N then
            if unsigned(arr(i)) > unsigned(arr(i + gap)) then
              temp := arr(i);
              arr(i) <= arr(i + gap);
              arr(i + gap) <= temp;
              swapped <= true;
            else
              swapped <= false;
            end if;
            i <= i + 1;
            
          else
            data_out <= arr;
            state <= UPDATE_GAP;

          end if;

        when UPDATE_GAP =>
          new_gap := (gap * 1000) / 1300;
          if new_gap < 1 then
            gap <= 1;
          else
            gap <= new_gap;
          end if;

          if swapped or new_gap > 1 then
            swapped <= false;
            i <= 0;
            state <= SORT;
          else
            state <= COMPLETE;
          end if;

        when COMPLETE =>
          done <= '1';
          working <= '0';

      end case;
    end if;
  end process;

end beh;
