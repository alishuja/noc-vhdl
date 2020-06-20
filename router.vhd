library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity router is
	generic(
	LOCATION_X: integer;
	LOCATION_Y: integer);
	port(
		    --for input data
		    input_data_port: in FLIT_PORT;
		    in_val: in std_logic_vector(NUMBER_OF_PORTS-1 downto 0);	
		    in_ack: out std_logic_vector(NUMBER_OF_PORTS-1 downto 0);

		    --for output data
		    output_data_port: out FLIT_PORT;
		    out_val: out std_logic_vector(NUMBER_OF_PORTS-1 downto 0);
		    out_ack: in std_logic_vector(NUMBER_OF_PORTS-1 downto 0);

		    --control signals
		    clk: in std_logic;
		    reset: in std_logic
	    );
end entity;

architecture arch of router is
	type ARRAY_4_BIT is array ((NUMBER_OF_PORTS-1) downto 0) of std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	type ARRAY_FLIT_4_PORT is array ((NUMBER_OF_PORTS-1) downto 0) of FLIT_4_PORT;
	signal x_din: array_flit_4_port;
	signal in_ack_signal, x_rok, x_rd: std_logic_vector((NUMBER_OF_PORTS-1) downto 0);
	signal x_dout, out_data: FLIT_PORT;
	signal x_req, x_gnt: ARRAY_4_BIT;
	component input_channel
		generic(location:DIRECTION);
		port(
			    clk: in std_logic;
			    reset: in std_logic;

			    in_data:in FLIT;
			    in_val: in std_logic;
			    in_ack: out std_logic;

			    x_dout: out FLIT;
			    x_req: out std_logic_vector(NUMBER_OF_PORTS-2 downto 0);

			    x_rok: out std_logic;

			    x_gnt: in std_logic_vector(NUMBER_OF_PORTS-2 downto 0);
			    x_rd: in std_logic_vector(NUMBER_OF_PORTS-2 downto 0)
		    );
	end component;

	component output_channel
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
	end component;
begin
	in_ack<=in_ack_signal;
	input_channel_local: input_channel
	generic map(location=>LOCAL)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>input_data_port(4),
			in_val=>in_val(4),
			in_ack=>in_ack_signal(4),
			x_dout=>x_dout(4),
			x_req=>x_req(4),
			x_rok=>x_rok(4),

			x_gnt(3)=>x_gnt(3)(3),
			x_gnt(2)=>x_gnt(2)(3),
			x_gnt(1)=>x_gnt(1)(3),
			x_gnt(0)=>x_gnt(0)(3),

			x_rd(3)=>x_rd(3),
			x_rd(2)=>x_rd(2),
			x_rd(1)=>x_rd(1),
			x_rd(0)=>x_rd(0)
		);

	input_channel_north: input_channel
	generic map(location=>NORTH)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>input_data_port(3),
			in_val=>in_val(3),
			in_ack=>in_ack_signal(3),
			x_dout=>x_dout(3),
			x_req=>x_req(3),
			x_rok=>x_rok(3),

			x_gnt(3)=>x_gnt(4)(3),
			x_gnt(2)=>x_gnt(2)(2),
			x_gnt(1)=>x_gnt(1)(2),
			x_gnt(0)=>x_gnt(0)(2),

			x_rd(3)=>x_rd(4),
			x_rd(2)=>x_rd(2),
			x_rd(1)=>x_rd(1),
			x_rd(0)=>x_rd(0)
		);

	input_channel_east: input_channel
	generic map(location=>EAST)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>input_data_port(2),
			in_val=>in_val(2),
			in_ack=>in_ack_signal(2),
			x_dout=>x_dout(2),
			x_req=>x_req(2),
			x_rok=>x_rok(2),

			x_gnt(3)=>x_gnt(4)(2),
			x_gnt(2)=>x_gnt(3)(2),
			x_gnt(1)=>x_gnt(1)(1),
			x_gnt(0)=>x_gnt(0)(1),

			x_rd(3)=>x_rd(4),
			x_rd(2)=>x_rd(3),
			x_rd(1)=>x_rd(1),
			x_rd(0)=>x_rd(0)
		);

	input_channel_west: input_channel
	generic map(location=>WEST)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>input_data_port(1),
			in_val=>in_val(1),
			in_ack=>in_ack_signal(1),
			x_dout=>x_dout(1),
			x_req=>x_req(1),
			x_rok=>x_rok(1),

			x_gnt(3)=>x_gnt(4)(1),
			x_gnt(2)=>x_gnt(3)(1),
			x_gnt(1)=>x_gnt(2)(1),
			x_gnt(0)=>x_gnt(0)(0),

			x_rd(3)=>x_rd(4),
			x_rd(2)=>x_rd(3),
			x_rd(1)=>x_rd(2),
			x_rd(0)=>x_rd(0)
		);

	input_channel_south: input_channel
	generic map(location=>SOUTH)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>input_data_port(0),
			in_val=>in_val(0),
			in_ack=>in_ack_signal(0),
			x_dout=>x_dout(0),
			x_req=>x_req(0),
			x_rok=>x_rok(0),

			x_gnt(3)=>x_gnt(4)(0),
			x_gnt(2)=>x_gnt(3)(0),
			x_gnt(1)=>x_gnt(2)(0),
			x_gnt(0)=>x_gnt(1)(0),

			x_rd(3)=>x_rd(4),
			x_rd(2)=>x_rd(3),
			x_rd(1)=>x_rd(2),
			x_rd(0)=>x_rd(1)
		);
	--output channels

	output_data_port<=out_data;
	x_din(4)(3)<=x_dout(3);
	x_din(4)(2)<=x_dout(2);
	x_din(4)(1)<=x_dout(1);
	x_din(4)(0)<=x_dout(0);

	output_channel_local: output_channel
	port map(
			clk=>clk,
			reset=>reset,
			x_din=>x_din(4),
			x_rd=>x_rd(4),

			x_req(3)=>x_req(3)(3),
			x_req(2)=>x_req(2)(3),
			x_req(1)=>x_req(1)(3),
			x_req(0)=>x_req(0)(3),

			x_gnt=>x_gnt(4),

			x_rok(3)=>x_rok(3),
			x_rok(2)=>x_rok(2),
			x_rok(1)=>x_rok(1),
			x_rok(0)=>x_rok(0),

			out_data=>out_data(4),
			out_val=>out_val(4),
			out_ack=>out_ack(4)
		);

	x_din(3)(3)<=x_dout(4);
	x_din(3)(2)<=x_dout(2);
	x_din(3)(1)<=x_dout(1);
	x_din(3)(0)<=x_dout(0);

	output_channel_north: output_channel
	port map(
			clk=>clk,
			reset=>reset,
			x_din=>x_din(3),
			x_rd=>x_rd(3),

			x_req(3)=>x_req(4)(3),
			x_req(2)=>x_req(2)(2),
			x_req(1)=>x_req(1)(2),
			x_req(0)=>x_req(0)(2),

			x_gnt=>x_gnt(3),

			x_rok(3)=>x_rok(4),
			x_rok(2)=>x_rok(2),
			x_rok(1)=>x_rok(1),
			x_rok(0)=>x_rok(0),

			out_data=>out_data(3),
			out_val=>out_val(3),
			out_ack=>out_ack(3)
		);

	x_din(2)(3)<=x_dout(4);
	x_din(2)(2)<=x_dout(3);
	x_din(2)(1)<=x_dout(1);
	x_din(2)(0)<=x_dout(0);

	output_channel_east: output_channel
	port map(
			clk=>clk,
			reset=>reset,
			x_din=>x_din(2),
			x_rd=>x_rd(2),

			x_req(3)=>x_req(4)(2),
			x_req(2)=>x_req(3)(2),
			x_req(1)=>x_req(1)(1),
			x_req(0)=>x_req(0)(1),

			x_gnt=>x_gnt(2),

			x_rok(3)=>x_rok(4),
			x_rok(2)=>x_rok(3),
			x_rok(1)=>x_rok(1),
			x_rok(0)=>x_rok(0),

			out_data=>out_data(2),
			out_val=>out_val(2),
			out_ack=>out_ack(2)
		);

	x_din(1)(3)<=x_dout(4);
	x_din(1)(2)<=x_dout(3);
	x_din(1)(1)<=x_dout(2);
	x_din(1)(0)<=x_dout(0);

	output_channel_west: output_channel
	port map(
			clk=>clk,
			reset=>reset,
			x_din=>x_din(1),
			x_rd=>x_rd(1),

			x_req(3)=>x_req(4)(1),
			x_req(2)=>x_req(3)(1),
			x_req(1)=>x_req(2)(1),
			x_req(0)=>x_req(0)(0),

			x_gnt=>x_gnt(1),

			x_rok(3)=>x_rok(4),
			x_rok(2)=>x_rok(3),
			x_rok(1)=>x_rok(2),
			x_rok(0)=>x_rok(0),

			out_data=>out_data(1),
			out_val=>out_val(1),
			out_ack=>out_ack(1)
		);

	x_din(0)(3)<=x_dout(4);
	x_din(0)(2)<=x_dout(3);
	x_din(0)(1)<=x_dout(2);
	x_din(0)(0)<=x_dout(1);

	output_channel_south: output_channel
	port map(
			clk=>clk,
			reset=>reset,
			x_din=>x_din(0),
			x_rd=>x_rd(0),

			x_req(3)=>x_req(4)(0),
			x_req(2)=>x_req(3)(0),
			x_req(1)=>x_req(2)(0),
			x_req(0)=>x_req(1)(0),

			x_gnt=>x_gnt(0),

			x_rok(3)=>x_rok(4),
			x_rok(2)=>x_rok(3),
			x_rok(1)=>x_rok(2),
			x_rok(0)=>x_rok(1),

			out_data=>out_data(0),
			out_val=>out_val(0),
			out_ack=>out_ack(0)
		);
end arch;	
