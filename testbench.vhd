library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.definitions.all;

entity tb is

	end tb;


architecture tb_circular_buffer of tb is
	signal clk, reset, wr, rd, empty, full: std_logic;
	constant WIDTH: natural:=4;
	constant LENGTH: natural:=5;
	signal w_data, r_data: std_logic_vector(WIDTH-1 downto 0);
	signal end_sim: boolean:=false;
	constant period : time := 10 ns;
	signal count: integer:=0;

begin
	uut: entity circular_buffer(arch)
	generic map(WIDTH=>WIDTH, LENGTH=>LENGTH)
	port map(
			rd=>rd,
			wr=>wr,
			clk=>clk,
			reset=>reset,
			w_data=>w_data,
			r_data=>r_data,
			empty=>empty,
			full=>full
		);

	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	process
	begin
		reset<='0';
		rd<='0';
		wr<='0';
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		wait until clk'event and clk='1';
		--for i in 0 to LENGTH+1 loop
		while full/='1' loop
			w_data<=std_logic_vector(to_unsigned(count,WIDTH));
			wr<='1';
			count<=count +1;
			wait until clk'event and clk='1';
		end loop;
		wr<='0';
		wait until clk'event and clk='1';
		rd<='1';
		while empty/='1' loop
			wait until clk'event and clk='1';
		end loop;
		end_sim<=true;
	end process;
end tb_circular_buffer;

architecture tb_ib of tb is
	signal clk, reset, wr, rd, rok, wok: std_logic;
	signal din, dout: FLIT;
	signal end_sim: boolean:= false;
	signal period: time :=10 ns;
begin
	uut: entity ib 
	port map(
			clk=>clk,
			reset=>reset,
			din=>din,
			wr=>wr,
			rd=>rd,
			dout=>dout,
			rok=>rok,
			wok=>wok);
	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	process
	begin
		rd<='0';
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset <='0';
		wait until clk'event and clk='1';
		for i in 1 to (PACKET_LENGTH+2)loop
			din<=std_logic_vector(to_unsigned(i,FLIT_LENGTH));
			wr<='1';
			wait until clk'event and clk='1';
		end loop;
		wr<='0';
		wait until clk'event and clk='1';
		rd<='1';
		for i in 0 to 6 loop
			wait until clk'event and clk='1';
		end loop;

		end_sim<=true;

	end process;
end tb_ib;

architecture tb_irs of tb is
	signal x_rd: std_logic_vector(3 downto 0);
	signal x_gnt: std_logic_vector(3 downto 0);
	signal rd: std_logic;
begin
	uut: entity irs 
	port map(
			x_rd=>x_rd,
			x_gnt=>x_gnt,
			rd=>rd);

	process
	begin
		x_rd<="0001";
		x_gnt<="0010";
		wait for 10 ns;
		x_rd<="0010";
		wait for 5 ns;
		x_rd<="1000";
		x_gnt<="1000";
		wait for 10 ns;
		x_gnt<="0100";
		wait for 10 ns;
		x_gnt<="0000";
		x_rd<="0000";
		wait;

	end process;
end tb_irs;

architecture tb_ic of tb is
	signal clk, reset, rok: std_logic;
	signal din,x_dout: FLIT;
	signal x_req :std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	constant period: time :=10 ns;
	signal end_sim: boolean:=false;

begin
	uutLocal: entity ic
	generic map(location=>LOCAL)
	port map(
			reset=>reset,
			rok=>rok,
			din=> din,
			x_dout=>open,
			x_req=>open);

	uutNorth: entity ic
	generic map(location=>NORTH)
	port map(
			reset=>reset,
			rok=>rok,
			din=> din,
			x_dout=>open,
			x_req=>open);

	uutSouth: entity ic
	generic map(location=>SOUTH)
	port map(
			reset=>reset,
			rok=>rok,
			din=> din,
			x_dout=>open,
			x_req=>open);

	uutEast: entity ic
	generic map(location=>EAST)
	port map(
			reset=>reset,
			rok=>rok,
			din=> din,
			x_dout=>open,
			x_req=>open);

	uutWest: entity ic
	generic map(location=>WEST)
	port map(
			reset=>reset,
			rok=>rok,
			din=> din,
			x_dout=>open,
			x_req=>open);


	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	process
	begin
		rok<='1';
		din<="0100000000000000000000000000010000";
		wait until clk'event and clk='1';
		din<="0100000000000000000000000000110000";
		wait until clk'event and clk='1';
		din<="0100000000000000000000000000100010";
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb_ic;

architecture tb_input_channel of tb is
	signal clk, reset, in_val, in_ack, x_rok: std_logic;
	signal in_data, x_dout: FLIT;
	signal x_gnt, x_rd: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	constant period: time:= 10 ns;
	signal end_sim: boolean:= false;
	signal x_req: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
begin
	uutLocal: entity input_channel generic map(location=>LOCAL)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>in_data,
			in_val=>in_val,
			in_ack=>in_ack,
			x_dout=>x_dout,
			x_req=>x_req,
			x_rok=>x_rok,
			x_gnt=>x_gnt,
			x_rd=>x_rd);


	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	process
	begin
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		wait until clk'event and clk='1';
		in_data<="0100000000000000000000000000010000";	
		in_val<='1';
		wait until clk'event and clk='1';
		in_val<='0';
		x_rd<="0100";
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb_input_channel;


architecture tb_oc of tb is
	signal clk, reset, eop, out_ack: std_logic;
	signal x_req, x_gnt: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	constant period : time :=10 ns;
	signal end_sim: boolean:= false;
begin
	uut: entity oc 
	port map(
			clk=>clk,
			reset=>reset,
			x_req=>x_req,
			x_gnt=>x_gnt,
			eop=>eop,
			out_ack=>out_ack);
	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;
	process
	begin
		x_req<="0000";
		eop<='0';
		out_ack<='0';
		wait until clk'event and clk='1';
		reset<='0';
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';

		reset<='0';
		x_req<="1000";
		out_ack<='1';
		wait until clk'event and clk='1';
		x_req<="0000";
		wait until clk'event and clk='1';
		eop<='1';
		wait until clk'event and clk='1';
		eop<='0';
		wait until clk'event and clk='1';
		eop<='1';
		wait until clk'event and clk='1';
		eop<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb_oc;

architecture tb_output_channel of tb is
	signal x_din: FLIT_4_PORT;
	signal x_rd, out_val, out_ack, clk, reset: std_logic;
	signal x_gnt, x_req, x_rok: std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
	signal out_data: FLIT;
	constant period : time :=10 ns;
	signal end_sim: boolean := false;

begin
	uut: entity output_channel port map(
						   clk=>clk,
						   reset=>reset,
						   x_din=>x_din,
						   x_rd=>x_rd,
						   x_req=>x_req,
						   x_gnt=>x_gnt,
						   x_rok=>x_rok,
						   out_data=>out_data,
						   out_val=>out_val,
						   out_ack=>out_ack);

	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	process
	begin
		x_din(0)<="0101010101010101010111000000000000";
		x_din(1)<="0110101010101011000000000000000000";
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		x_din(3)<="0100000000000000000000000000000000";
		x_req<="1101";
		x_rok<="1001";
		out_ack<='0';
		wait until clk'event and clk='1';
		out_ack<='1';
		wait until clk'event and clk='1';
		x_din(3)<="0000011110000011111100000000000000";
		wait until clk'event and clk='1';
		x_din(3)<="1000111110000101010111110000000000";
		wait until clk'event and clk='1';
		x_din(2)<="0100001011101010111101011100000000";
		wait until clk'event and clk='1';
		x_din(2)<="0001101011101010111101011100000000";
		wait until clk'event and clk='1';
		x_din(2)<="1000001110101110110000000000000000";
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		x_din(0)<="1000000010101011010101010000000000";
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb_output_channel;

architecture tb_router of tb is
	signal clk, reset: std_logic;
	signal input_data_port, output_data_port: FLIT_PORT;
	signal in_val, in_ack, out_val, out_ack: std_logic_vector(NUMBER_OF_PORTS-1 downto 0);
	constant period: time :=10 ns;
	signal end_sim: boolean:= false;
begin
	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	uut: entity router generic map(
					      LOCATION_X=>0,
					      LOCATION_Y=>0)
	port map(
			clk=>clk,
			reset=>reset,
			input_data_port=>input_data_port,
			in_val=>in_val,
			in_ack=>in_ack,
			output_data_port=>output_data_port,
			out_val=>out_val,
			out_ack=>out_ack
		);
	process
	begin
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		input_data_port(4)<="0100110000111000000111000000000001";
		in_val(4)<='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb_router;

architecture tb_in_out of tb is
	signal clk, reset, in_val, in_ack, out_val, out_ack: std_logic;
	signal in_data, out_data: FLIT;
	signal x_dout: FLIT_4_PORT;
	signal x_req, x_gnt, x_rd, x_rok: std_logic_vector(3 downto 0);
	constant period: time:=10 ns;
	signal end_sim: boolean:=false;
begin
	clock_gen: process
	begin
		clk<='0';
		loop
			wait for period/2;
			clk <= not clk;
			exit when end_sim=true;
		end loop;
		wait;
	end process clock_gen;

	input_channel_local: entity input_channel
	generic map(location=>LOCAL)
	port map(
			clk=>clk,
			reset=>reset,
			in_data=>in_data,
			in_val=>in_val,
			in_ack=>in_ack,
			x_dout=>x_dout(3),
			x_req=>x_req,
			x_gnt=>x_gnt,
			x_rd=>x_rd,
			x_rok=>x_rok(3)
		);
	output_channel_north: entity output_channel
	port map(
			clk=>clk,
			reset=>reset,
			x_din=>x_dout,
			x_rd=>x_rd(3),
			x_req=>x_req,
			x_gnt=>x_gnt,
			x_rok=>x_rok,
			out_data=>out_data,
			out_val=>out_val,
			out_ack=>out_ack
		);
	process
	begin
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		in_data<="0100000000000000000000000000000001";
		in_val<='1';
		wait until clk'event and clk='1';
		in_val<='0';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb_in_out;
