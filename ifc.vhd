library ieee;
use ieee.std_logic_1164.all;

entity ifc is
	port(
		in_val: in std_logic;
		in_ack: out std_logic;
		
		out_val: out std_logic;
		in_wok: in std_logic
	);
end entity;

architecture dataflow of ifc is
begin
	out_val<=in_val;
	in_ack<=in_val and in_wok;
end dataflow;

