library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package definitions is
	constant FLIT_LENGTH: integer := 34;
	constant NUMBER_OF_PORTS: integer := 5;
	constant PACKET_LENGTH: integer := 8;
	constant BUFFER_LENGTH: integer := PACKET_LENGTH;
	constant RIB_M_LENGTH: integer := 6; --length of m in RIB in header

	subtype FLIT is std_logic_vector(FLIT_LENGTH-1 downto 0);--order of ports is Local[0], North[1], East[2], West[3], South[4] for NUMBER_OF_PORTS=5
	type FLIT_PORT is array (NUMBER_OF_PORTS-1 downto 0) of FLIT;
	type FLIT_4_PORT is array(3 downto 0) of FLIT;
	type DIRECTION is (LOCAL, NORTH, EAST, WEST, SOUTH);
end package definitions;

