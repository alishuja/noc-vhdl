library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity ic is
	generic(
	location: DIRECTION);
	port(
		    reset: in std_logic;
		    rok: in std_logic;
		    din: in FLIT;
		    x_dout: out FLIT;
		    x_req: out std_logic_vector((NUMBER_OF_PORTS-2)downto 0)

	    );
end entity;

architecture arch of ic is
	signal temp_flit: FLIT;
	signal temp_x_req: std_logic_vector(NUMBER_OF_PORTS-2 downto 0);
begin
	x_dout<=temp_flit;
	x_req <= temp_x_req;
	process(din, reset)
	begin
		if reset='1' then
			temp_flit<=(others=>'0');
			temp_x_req<=(others=>'0');
		else
			temp_flit(FLIT_LENGTH-1 downto 4) <=din(FLIT_LENGTH-1 downto 4);
			temp_flit(2)<= din(2);
			if (din(FLIT_LENGTH-2)='1') then
				--Now to check if Xmod>0
				--	if (unsigned(din((((FLIT_LENGTH-3)-(FLIT_LENGTH-3-RIB_M_LENGTH)-2) downto (((FLIT_LENGTH-3)-(FLIT_LENGTH-3-RIB_M_LENGTH)-2) - ((RIB_M_LENGTH-2)/2)))))>0) then 
				--		x_dout((((FLIT_LENGTH-3)-(FLIT_LENGTH-3-RIB_M_LENGTH)-2) downto (((FLIT_LENGTH-3)-(FLIT_LENGTH-3-RIB_M_LENGTH)-2) - ((RIB_M_LENGTH-2)/2)))) <=std_logic_vector(unsigned(din((((FLIT_LENGTH-3)-(FLIT_LENGTH-3-RIB_M_LENGTH)-2) downto (((FLIT_LENGTH-3)-(FLIT_LENGTH-3-RIB_M_LENGTH)-2) - ((RIB_M_LENGTH-2)/2)))))-1);
				if unsigned(din(4 downto 3))>0 then
					temp_flit(4 downto 3) <=std_logic_vector(unsigned(din(4 downto 3))-1);
					temp_flit(1 downto 0) <=din(1 downto 0);
				elsif unsigned(din(1 downto 0))>0 then
					temp_flit(4 downto 3) <=din(4 downto 3);
					temp_flit(1 downto 0) <=std_logic_vector(unsigned(din(1 downto 0))-1);
				else
					temp_flit(1 downto 0) <=din(1 downto 0);
				end if;
				if (location=LOCAL) then
					if unsigned(din(4 downto 3))>0 then
						if din(5)='0' then
							temp_x_req<="0100";
						else
							temp_x_req<="0010";
						end if;
					elsif unsigned(din(1 downto 0))>0 then
						if din(2)='0' then
							temp_x_req<="1000";
						else
							temp_x_req<="0001";
						end if;
					end if;
				elsif (location=NORTH) then
					if unsigned(din(1 downto 0))>0 then
						temp_x_req<="0001";
					else
						temp_x_req<="1000";
					end if;
				elsif (location = SOUTH) then
					if unsigned(din(1 downto 0))>0 then
						temp_x_req<="0100";
					else
						temp_x_req<="1000";
					end if;
				elsif ((location=EAST) or (location=WEST)) then
					if unsigned(din(4 downto 3))>0 then
						temp_x_req<="0010";
					elsif unsigned(din(1 downto 0))>0 then
						if din(2)='0' then
							temp_x_req<="0100";
						else
							temp_x_req<="0001";
						end if;
					else
						temp_x_req<="1000";
					end if;
				else
					temp_x_req<="1000";
				end if;					
			else
				temp_x_req<="0000";
			end if;
		end if;
	end process;
end arch;
