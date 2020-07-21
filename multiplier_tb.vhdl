library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library WORK;
use WORK.components.multiplier;

entity multiplier_tb is
end multiplier_tb;

architecture behav of multiplier_tb is
  constant clock_frequency : integer := 100e6; -- 100 MHz
  constant clock_period : time := 1000 ms / clock_frequency;

  signal clk : std_logic := '0';

  signal a : std_logic_vector(7 downto 0);
  signal b : std_logic_vector(7 downto 0);
  signal o : std_logic_vector(15 downto 0);
begin
  multiplier_0: multiplier
    port map (clk, a, b, o);
  clk <= not clk after clock_period / 2;

  process
    type pattern_type is record
      a, b : std_logic_vector(7 downto 0);
      o : std_logic_vector(15 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00000000", "00000000", "0000000000000000"),
       ("00001010", "00000111", "0000000001000110"),
       ("11111111", "11111111", "1111111000000001"));
  begin
    for i in patterns'range loop
      a <= patterns(i).a;
      b <= patterns(i).b;
      wait for clock_period;

      assert o = patterns(i).o
        report "bad multiplication - " &
        integer'image(to_integer(unsigned(patterns(i).o))) & ", not " &
        integer'image(to_integer(unsigned(o))) severity error;
    end loop;
    std.env.finish;
  end process;
end behav;
