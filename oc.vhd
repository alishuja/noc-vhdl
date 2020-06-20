library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity oc is
	port(
		    clk: in std_logic;
		    reset: in std_logic;

		    x_req: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
		    x_gnt: out std_logic_vector((NUMBER_OF_PORTS-2) downto 0);

		    eop: in std_logic;

		    out_ack: in std_logic);
end entity;

architecture arch of oc is
	type STATES is(NO_PORT, PORT_0, PORT_1, PORT_2, PORT_3);
	signal current_state, next_state: STATES;
	signal packet_start: std_logic;

begin
	process(x_req, reset, current_state)
	begin
		if reset='1' then
			next_state<=NO_PORT;
		else
			case (current_state) is
				when NO_PORT =>
					if x_req(3)='1' then
						next_state<=PORT_0;
					elsif x_req(2)='1' then
						next_state<=PORT_1;
					elsif x_req(1)='1' then
						next_state<=PORT_2;
					elsif x_req(0)='1' then
						next_state<=PORT_3;
					else
						next_state<=NO_PORT;
					end if;
				when PORT_0 =>
					if x_req(2)='1' then
						next_state<=PORT_1;
					elsif x_req(1)='1' then
						next_state<=PORT_2;
					elsif x_req(0)='1' then
						next_state<=PORT_3;
					elsif x_req(3)='1' then
						next_state<=PORT_0;
					else
						next_state<=NO_PORT;
					end if;
				when PORT_1 =>
					if x_req(1)='1' then
						next_state<=PORT_2;
					elsif x_req(0)='1' then
						next_state<=PORT_3;
					elsif x_req(3)='1' then
						next_state<=PORT_0;
					elsif x_req(2)='1' then
						next_state<=PORT_1;
					else
						next_state<=NO_PORT;
					end if;
				when PORT_2 =>
					if x_req(0)='1' then
						next_state<=PORT_3;
					elsif x_req(3)='1' then
						next_state<=PORT_2;
					elsif x_req(2)='1' then
						next_state<=PORT_1;
					elsif x_req(1)='1' then
						next_state<=PORT_0;
					else
						next_state<=NO_PORT;
					end if;
				when PORT_3 =>
					if x_req(3)='1' then
						next_state<=PORT_0;
					elsif x_req(2)='1' then
						next_state<=PORT_1;
					elsif x_req(1)='1' then
						next_state<=PORT_2;
					elsif x_req(0)='1' then
						next_state<=PORT_3;
					else
						next_state<=NO_PORT;
					end if;
				when others=>
					next_state<=NO_PORT;
			end case;
		end if;
	end process;
	with current_state select 
		x_gnt<="0000" when NO_PORT, 
		       "1000" when PORT_0, 
		       "0100" when PORT_1,
		       "0010" when PORT_2, 
		       "0001" when PORT_3, 
		       "0000" when others;

	process(clk, reset)
	begin
		if (reset='1') then
			current_state<=NO_PORT;
			packet_start<='0';
		else
			if clk'event and clk='1' then
				if (current_state=NO_PORT and unsigned(x_req)>0) then
					current_state<=next_state;
				elsif eop='1' then
					current_state<=next_state;
				end if;
			end if;
		end if;
	end process;
end arch;

