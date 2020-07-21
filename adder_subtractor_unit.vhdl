library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library WORK;
use WORK.components.carry_lookahead_adder;

entity adder_subtractor_unit is
  generic (
    bit_width : integer := 16 );
  port (
    operation : in std_logic;
    a, b : in std_logic_vector(bit_width-1 downto 0);
    ci : in std_logic;
    o : out std_logic_vector(bit_width-1 downto 0);
    co : out std_logic );
end entity;

architecture rtl of adder_subtractor_unit is
  signal w_adjusted_b : std_logic_vector(bit_width-1 downto 0);
  signal w_carry_or_borrow : std_logic;
begin
  w_adjusted_b <= not b when operation = '1' else b; -- 0 = add, 1 = subtract
  w_carry_or_borrow <= not ci when operation = '1' else ci;

  cla : carry_lookahead_adder
    generic map (bit_width => 16)
    port map (
      a, w_adjusted_b, w_carry_or_borrow,
      o, co);
end architecture;
