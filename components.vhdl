library ieee;

use ieee.std_logic_1164.all;

package components is
  component adder
    port ( i0, i1 : in std_logic;
           ci : in std_logic;
           s : out std_logic;
           co : out std_logic );
  end component;
  
  component carry_lookahead_adder
    generic (
      bit_width : integer := 16 );
    port (
      a, b : in std_logic_vector(bit_width-1 downto 0);
      ci : in std_logic;
      o : out std_logic_vector(bit_width-1 downto 0);
      co : out std_logic );
  end component;

  component adder_subtractor_unit
    generic (
      bit_width : integer := 16 );
    port (
      operation : in std_logic;
      a, b : in std_logic_vector(bit_width-1 downto 0);
      ci : in std_logic;
      o : out std_logic_vector(bit_width-1 downto 0);
      co : out std_logic );
  end component;

  component multiplier
    port (
      clk : in std_logic;
      a, b : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector((bit_width*2)-1 downto 0) );
  end component;
end components;
