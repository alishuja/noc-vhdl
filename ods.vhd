library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity ods is
	port(
		    clk: in std_logic;
		    x_din: in FLIT_4_PORT;
		    x_gnt: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);

		    out_data: out FLIT);
end entity;

architecture arch of ods is
	signal out_data_reg: FLIT;
begin
	out_data<=out_data_reg;

	process(x_gnt, x_din)
	begin
		case(x_gnt) is
			when "1000" => out_data_reg<=x_din(3);
			when "0100" => out_data_reg<=x_din(2);
			when "0010" => out_data_reg<=x_din(1);
			when "0001" => out_data_reg<=x_din(0);
			when others=> out_data_reg<=(others=>'0');
		end case;
	end process;
--	process(clk)
--	begin
--		if clk'event and clk='1' then
--			case(x_gnt) is
--				when "1000" => out_data_reg<=x_din(3);
--				when "0100" => out_data_reg<=x_din(2);
--				when "0010" => out_data_reg<=x_din(1);
--				when "0001" => out_data_reg<=x_din(0);
--				when others=> out_data_reg<=(others=>'0');
--			end case;
--		end if;
--	end process;
end arch;
