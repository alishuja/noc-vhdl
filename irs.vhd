library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity irs is
	port(
	x_rd: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	x_gnt: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	rd: out std_logic);
end entity;

architecture arch of irs is
	signal and_result: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
begin
--	rd<='1' when (unsigned(x_rd)>0 or unsigned(x_gnt)>0) else '0';
	AND_GATES: for i in (NUMBER_OF_PORTS-2) downto 0 generate
	begin
		and_result(i)<=x_gnt(i) and x_rd(i);
	end generate;
	rd<='1' when (to_integer(unsigned(and_result))>0) else '0';
end arch;
