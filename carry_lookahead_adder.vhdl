library ieee;
use ieee.std_logic_1164.all;

library WORK;
use WORK.components.adder;

entity carry_lookahead_adder is
  generic (
    bit_width : integer := 16 );
  port (
    a, b : in std_logic_vector(bit_width-1 downto 0);
    ci : in std_logic;
    o : out std_logic_vector(bit_width-1 downto 0);
    co : out std_logic );
end carry_lookahead_adder;

architecture rtl of carry_lookahead_adder is
  signal w_carry_internal : std_logic_vector(bit_width downto 0);
  signal w_generate : std_logic_vector(bit_width-1 downto 0);
  signal w_propagate : std_logic_vector(bit_width-1 downto 0);
begin
  w_generate <= a and b;
  w_propagate <= a or b;

  w_carry_internal(0) <= ci;
  co <= w_carry_internal(bit_width);

  gen_carries : for ii in 0 to bit_width-1 generate
    w_carry_internal(ii + 1) <= w_generate(ii) or (w_propagate(ii) and w_carry_internal(ii));
  end generate;

  gen_adders : for ii in 0 to bit_width-1 generate
    adder_x : adder port map(a(ii), b(ii), w_carry_internal(ii),
                             o(ii), open);
  end generate;
end rtl;
