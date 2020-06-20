library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity ors is
	port(
	x_rok: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	x_gnt: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	out_val: out std_logic);
end entity;

architecture arch of ors is
	signal and_result: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
begin
--	AND_GATES: for i in (NUMBER_OF_PORTS-2) downto 0 generate
--	begin
--		and_result(i)<=x_gnt(i) and x_rok(i);
--	end generate;
--	out_val<='1' when (to_integer(unsigned(and_result))>0) else '0';
	out_val<='1' when unsigned(x_gnt)>0 else '0';
end arch;
