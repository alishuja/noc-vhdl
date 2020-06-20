library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity output_channel is
	port(
		    clk: in std_logic;
		    reset: in std_logic;

		    x_din: in FLIT_4_PORT;

		    x_rd: out std_logic;

		    x_req: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
		    x_gnt: out std_logic_vector((NUMBER_OF_PORTS-2) downto 0);

		    x_rok: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);

		    out_data: out FLIT;
		    out_val: out std_logic;
		    out_ack: in std_logic);
end entity;

architecture arch of output_channel is
	component ods
		port(
			    clk: in std_logic;
			    x_din: in FLIT_4_PORT;
			    x_gnt: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);

			    out_data: out FLIT);
	end component;

	component oc
		port(
			    clk: in std_logic;
			    reset: in std_logic;

			    x_req: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
			    x_gnt: out std_logic_vector((NUMBER_OF_PORTS-2) downto 0);

			    eop: in std_logic;

			    out_ack: in std_logic);
	end component;

	component ors
		port(
			    x_rok: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
			    x_gnt: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
			    out_val: out std_logic);	
	end component;

	component ofc
		port(
			    out_ack : in std_logic;
			    x_out_ack: out std_logic;

			    x_out_val: in std_logic;
			    out_val: out std_logic);
	end component;

	signal x_gnt_temp: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	signal out_data_temp: FLIT;
	signal eop, out_ack_temp, out_val_temp, out_val_temp2: std_logic;
begin
	out_data<=out_data_temp;
	eop<=out_data_temp(FLIT_LENGTH-1);
	x_gnt<=x_gnt_temp;
	x_rd<=out_ack_temp;
	out_val<=out_val_temp2;

	ods_i: ods port map(
				   clk=>clk,
				   x_din=>x_din,
				   x_gnt=>x_gnt_temp,
				   out_data=>out_data_temp);

	oc_i: oc port map(
				 clk=>clk,
				 reset=>reset,
				 x_req=>x_req,
				 x_gnt=>x_gnt_temp,
				 eop=>eop,
				 out_ack=>out_ack_temp);

	ors_i: ors port map(
				   x_rok=>x_rok,
				   x_gnt=>x_gnt_temp,
				   out_val=>out_val_temp);

	ofc_i: ofc port map(
				   out_val=>out_val_temp2,
				   x_out_ack=>out_ack_temp,
				   x_out_val=>out_val_temp,
				   out_ack=>out_ack);
end arch;
