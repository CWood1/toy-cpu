library ieee;
use ieee.std_logic_1164.all;

library WORK;
use WORK.components.carry_lookahead_adder;

entity carry_lookahead_adder_tb is
end carry_lookahead_adder_tb;

architecture behav of carry_lookahead_adder_tb is
  signal a, b, o : std_logic_vector(15 downto 0);
  signal ci, co : std_logic;
begin
  carry_lookahead_adder_0 : carry_lookahead_adder
    generic map (bit_width => 16)
    port map (a => a, b => b, ci => ci, o => o, co => co);

  process
    type pattern_type is record
      a, b : std_logic_vector(15 downto 0);
      ci : std_logic;
      o : std_logic_vector(15 downto 0);
      co : std_logic;
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0000000000000000", "0000000000000000", '0', "0000000000000000", '0'),
       ("1111111111111111", "0000000000000001", '0', "0000000000000000", '1'),
       ("0000000000001010", "0000000000001010", '0', "0000000000010100", '0'),
       ("1010000000000000", "1010000000000000", '0', "0100000000000000", '1'),
       ("0000000000000000", "0000000000000000", '1', "0000000000000001", '0'),
       ("1111111111111111", "1111111111111111", '1', "1111111111111111", '1'));
  begin
    for i in patterns'range loop
      a <= patterns(i).a;
      b <= patterns(i).b;
      ci <= patterns(i).ci;

      wait for 1 ns;

      assert o = patterns(i).o
        report "bad sum value" severity error;
      assert co = patterns(i).co
        report "bad carry out value" severity error;
    end loop;
    std.env.finish;
  end process;
end behav;
