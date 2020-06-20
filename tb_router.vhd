library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.definitions.all;

entity tb_router is

	end tb_router;


architecture tb of tb_router is
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
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		input_data_port(4)<="0100110000111000000111000000000001";
		in_val(4)<='1';
		wait until in_ack(4)'event and in_ack(4)='1';
		input_data_port(4)<="0001110110111010000111000111000001";
		wait until clk'event and clk='1';
		input_data_port(4)<="0000100110110010000101000111000001";
		wait until clk'event and clk='1';
		input_data_port(4)<="1000100110110010000101000111000001";
		wait until clk'event and clk='1';
		in_val(4)<='0';
		out_ack(3)<='1';
		wait until clk'event and clk='1';
		input_data_port(2)<="0110110000111000000111000000000111";
		in_val(2)<='1';
		wait until clk'event and clk='1';
		input_data_port(2)<="0011010101010100010110110011110010";
		wait until clk'event and clk='1';
		input_data_port(2)<="1000100110110010000101000111000001";
		wait until clk'event and clk='1';
		in_val(2)<='0';
		wait until clk'event and clk='1';
		out_ack(0)<='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end tb;

architecture two_router of tb_router is
	signal clk, reset: std_logic;
	signal input_data_port_00, input_data_port_01, output_data_port_00, output_data_port_01: FLIT_PORT;
	signal in_val_00, in_val_01, in_ack_00, in_ack_01, out_val_00, out_val_01, out_ack_00, out_ack_01: std_logic_vector(4 downto 0);
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

	router_00: entity router
	generic map(
			   location_X=>0,
			   location_Y=>0)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_00,
			in_ack=>in_ack_00,
			out_val=>out_val_00,
			out_ack=>out_ack_00,
			input_data_port=>input_data_port_00,
			output_data_port=>output_data_port_00
		);
	in_val_01(1)<=out_val_00(2);
	out_ack_00(2)<=in_ack_01(1);
	input_data_port_01(1)<=output_data_port_00(2);

	router_01: entity router
	generic map(
			   location_X=>0,
			   location_y=>1)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_01,
			in_ack=>in_ack_01,
			out_val=>out_val_01,
			out_ack=>out_ack_01,
			input_data_port=>input_data_port_01,
			output_data_port=>output_data_port_01
		);
	process
	begin
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		wait until clk'event and clk='1';
		input_data_port_00(4)<="0100000101101000101100000000001000";
		in_val_00(4)<='1';
		wait until clk'event and clk='1';
		input_data_port_00(4)<="0000000001101100101000011000000000";
		wait until clk'event and clk='1';
		input_data_port_00(4)<="1000010111001000100100110000000000";
		wait until clk'event and clk='1';
		in_val_00(4)<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		out_ack_01(4)<='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';	
		end_sim<=true;
	end process;
end two_router;

architecture three_router of tb_router is
	signal clk, reset: std_logic;
	signal input_data_port_00, input_data_port_01, input_data_port_11, output_data_port_00, output_data_port_01, output_data_port_11: FLIT_PORT;
	signal in_val_00, in_val_01, in_val_11, in_ack_00, in_ack_01, in_ack_11, out_val_00, out_val_01, out_val_11, out_ack_00, out_ack_01, out_ack_11: std_logic_vector(4 downto 0);
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

	router_00: entity router
	generic map(
			   location_X=>0,
			   location_Y=>0)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_00,
			in_ack=>in_ack_00,
			out_val=>out_val_00,
			out_ack=>out_ack_00,
			input_data_port=>input_data_port_00,
			output_data_port=>output_data_port_00
		);
	in_val_01(1)<=out_val_00(2);
	out_ack_00(2)<=in_ack_01(1);
	input_data_port_01(1)<=output_data_port_00(2);

	router_01: entity router
	generic map(
			   location_X=>0,
			   location_y=>1)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_01,
			in_ack=>in_ack_01,
			out_val=>out_val_01,
			out_ack=>out_ack_01,
			input_data_port=>input_data_port_01,
			output_data_port=>output_data_port_01
		);

	in_val_11(0)<=out_val_01(3);
	out_ack_01(3)<=in_ack_11(0);
	input_data_port_11(0)<=output_data_port_01(3);

	router_11: entity router
	generic map(
			   location_x=>1,
			   location_y=>1)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_11,
			in_ack=>in_ack_11,
			out_val=>out_val_11,
			out_ack=>out_ack_11,
			input_data_port=>input_data_port_11,
			output_data_port=>output_data_port_11
		);
process
	begin
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		wait until clk'event and clk='1';
		input_data_port_00(4)<="0100000101101000101100000000001001";
		in_val_00(4)<='1';
		wait until clk'event and clk='1';
		input_data_port_00(4)<="0000000001101100101000011000000000";
		wait until clk'event and clk='1';
		input_data_port_00(4)<="1000010111001000100100110000000000";
		wait until clk'event and clk='1';
		in_val_00(4)<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';	
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		end_sim<=true;
	end process;
end three_router;
