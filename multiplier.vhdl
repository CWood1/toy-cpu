library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library WORK;
use WORK.components.carry_lookahead_adder;

entity multiplier is
  port (
    clk : in std_logic;
    a, b : in std_logic_vector(7 downto 0);
    o : out std_logic_vector(15 downto 0) );
end entity;

architecture rtl of multiplier is
  type t_shifted_table is array (0 to 7) of std_logic_vector(15 downto 0);
  signal r_shifted_table : t_shifted_table := (others => (others => '0'));

  type t_first_stage is array (0 to 3) of std_logic_vector(15 downto 0);
  signal r_first_stage : t_first_stage := (others => (others => '0'));
  signal r_first_stage_gated : t_first_stage := (others => (others => '0'));

  type t_second_stage is array (0 to 1) of std_logic_vector(15 downto 0);
  signal r_second_stage : t_second_stage := (others => (others => '0'));
  signal r_second_stage_gated : t_second_stage := (others => (others => '0'));
begin
  gen_shifted_table : for ii in 7 downto 0 generate
    r_shifted_table(ii) <= std_logic_vector(shift_left(resize(unsigned(a), 16), ii)) when b(ii) = '1'
                           else "0000000000000000";
  end generate;

  gen_first_stage : for ii in 3 downto 0 generate
    add_first_stage : carry_lookahead_adder
      generic map (bit_width => 16)
      port map (
        r_shifted_table(ii + ii), r_shifted_table(ii + ii + 1), '0',
        r_first_stage(ii), open);
  end generate;

  gen_second_stage : for ii in 1 downto 0 generate
    add_second_stage : carry_lookahead_adder
      generic map (bit_width => 16)
      port map (
        r_first_stage_gated(ii + ii), r_first_stage_gated(ii + ii + 1), '0',
        r_second_stage(ii), open);
  end generate;

  add_final_stage : carry_lookahead_adder
    generic map (bit_width => 16)
    port map (
      r_second_stage(0), r_second_stage(1), '0',
      o, open);

  process(clk) is
  begin
    if rising_edge(clk) then
      r_first_stage_gated <= r_first_stage;
      r_second_stage_gated <= r_second_stage;
    end if;
  end process;
end architecture;
