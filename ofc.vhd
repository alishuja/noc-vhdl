library ieee;
use ieee.std_logic_1164.all;

entity ofc is
	port(
		    out_ack : in std_logic;
		    x_out_ack: out std_logic;

		    x_out_val: in std_logic;
		    out_val: out std_logic);
end entity;

architecture arch of ofc is
begin
	x_out_ack<='1' when out_ack='1' else '0';
	out_val<='1' when x_out_val='1' else '0';
end arch;
