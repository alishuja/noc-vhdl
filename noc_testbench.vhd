library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.definitions.all;

entity noc_testbench is
	end entity;

architecture tb of noc_testbench is
	signal clk, reset: std_logic;

	constant period: time:= 10 ns;
	signal end_sim: boolean:= false;

	--signals for connecting routers
	signal input_data_port_00, input_data_port_01, input_data_port_02, input_data_port_10, input_data_port_11, input_data_port_12, input_data_port_20, input_data_port_21, input_data_port_22: FLIT_PORT;

	signal output_data_port_00, output_data_port_01, output_data_port_02, output_data_port_10, output_data_port_11, output_data_port_12, output_data_port_20, output_data_port_21, output_data_port_22: FLIT_PORT;

	signal in_val_00, in_val_01, in_val_02, in_val_10, in_val_11, in_val_12, in_val_20, in_val_21, in_val_22: std_logic_vector(4 downto 0);

	signal out_val_00, out_val_01, out_val_02, out_val_10, out_val_11, out_val_12, out_val_20, out_val_21, out_val_22: std_logic_vector(4 downto 0);

	signal in_ack_00, in_ack_01, in_ack_02, in_ack_10, in_ack_11, in_ack_12, in_ack_20, in_ack_21, in_ack_22: std_logic_vector(4 downto 0);

	signal out_ack_00, out_ack_01, out_ack_02, out_ack_10, out_ack_11, out_ack_12, out_ack_20, out_ack_21, out_ack_22: std_logic_vector(4 downto 0);

	--temp signals
	signal temp_flit_22, temp_flit_21, temp_flit_20, temp_flit_10, temp_flit_11: FLIT;
	signal rd_22, rok_22, rd_21, rok_21, rd_20, rok_20, rd_10, rok_10, rd_11, rok_11: std_logic;
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
			   location_y=>0)
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

	router_02: entity router
	generic map(
			   location_X=>0,
			   location_y=>2)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_02,
			in_ack=>in_ack_02,
			out_val=>out_val_02,
			out_ack=>out_ack_02,
			input_data_port=>input_data_port_02,
			output_data_port=>output_data_port_02
		);

	router_10: entity router
	generic map(
			   location_X=>1,
			   location_y=>0)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_10,
			in_ack=>in_ack_10,
			out_val=>out_val_10,
			out_ack=>out_ack_10,
			input_data_port=>input_data_port_10,
			output_data_port=>output_data_port_10
		);

	router_11: entity router
	generic map(
			   location_X=>1,
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

	router_12: entity router
	generic map(
			   location_X=>1,
			   location_y=>2)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_12,
			in_ack=>in_ack_12,
			out_val=>out_val_12,
			out_ack=>out_ack_12,
			input_data_port=>input_data_port_12,
			output_data_port=>output_data_port_12
		);

	router_20: entity router
	generic map(
			   location_X=>2,
			   location_y=>0)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_20,
			in_ack=>in_ack_20,
			out_val=>out_val_20,
			out_ack=>out_ack_20,
			input_data_port=>input_data_port_20,
			output_data_port=>output_data_port_20
		);

	router_21: entity router
	generic map(
			   location_X=>2,
			   location_y=>1)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_21,
			in_ack=>in_ack_21,
			out_val=>out_val_21,
			out_ack=>out_ack_21,
			input_data_port=>input_data_port_21,
			output_data_port=>output_data_port_21
		);

	router_22: entity router
	generic map(
			   location_X=>2,
			   location_y=>2)
	port map(
			clk=>clk,
			reset=>reset,
			in_val=>in_val_22,
			in_ack=>in_ack_22,
			out_val=>out_val_22,
			out_ack=>out_ack_22,
			input_data_port=>input_data_port_22,
			output_data_port=>output_data_port_22
		);
	--inputs for router_00
	in_val_00(3)<=out_val_10(0);
	in_val_00(2)<=out_val_01(1);

	out_ack_00(3)<=in_ack_10(0);
	out_ack_00(2)<=in_ack_01(1);

	input_data_port_00(3)<=output_data_port_10(0);
	input_data_port_00(2)<=output_data_port_01(1);

	--inputs for router_01
	in_val_01(3)<=out_val_11(0);
	in_val_01(2)<=out_val_02(1);
	in_val_01(1)<=out_val_00(2);

	out_ack_01(3)<=in_ack_11(0);
	out_ack_01(2)<=in_ack_02(1);
	out_ack_01(1)<=in_ack_00(2);

	input_data_port_01(3)<=output_data_port_11(0);
	input_data_port_01(2)<=output_data_port_02(1);
	input_data_port_01(1)<=output_data_port_00(2);

	--inputs for router_02
	in_val_02(3)<=out_val_12(0);
	in_val_02(1)<=out_val_01(2);

	out_ack_02(3)<=in_ack_12(0);
	out_ack_02(1)<=in_ack_01(2);

	input_data_port_02(3)<=output_data_port_12(0);
	input_data_port_02(1)<=output_data_port_01(2);

	--inputs for router_10
	in_val_10(3)<=out_val_20(0);
	in_val_10(2)<=out_val_11(1);
	in_val_10(0)<=out_val_00(3);

	out_ack_10(3)<=in_ack_20(0);
	out_ack_10(2)<=in_ack_11(1);
	out_ack_10(0)<=in_ack_00(3);

	input_data_port_10(3)<=output_data_port_20(0);
	input_data_port_10(2)<=output_data_port_11(1);
	input_data_port_10(0)<=output_data_port_00(3);

	--input for router_11
	in_val_11(3)<=out_val_21(0);
	in_val_11(2)<=out_val_12(1);
	in_val_11(1)<=out_val_10(2);
	in_val_11(0)<=out_val_01(3);

	out_ack_11(3)<=in_ack_21(0);
	out_ack_11(2)<=in_ack_12(1);
	out_ack_11(1)<=in_ack_10(2);
	out_ack_11(0)<=in_ack_01(3);

	input_data_port_11(3)<=output_data_port_21(0);
	input_data_port_11(2)<=output_data_port_12(1);
	input_data_port_11(1)<=output_data_port_10(2);
	input_data_port_11(0)<=output_data_port_01(3);

	--input for router_12
	in_val_12(3)<=out_val_22(0);
	in_val_12(1)<=out_val_11(2);
	in_val_12(0)<=out_val_02(3);

	out_ack_12(3)<=in_ack_22(0);
	out_ack_12(1)<=in_ack_11(2);
	out_ack_12(0)<=in_ack_02(3);

	input_data_port_12(3)<=output_data_port_22(0);
	input_data_port_12(1)<=output_data_port_11(2);
	input_data_port_12(0)<=output_data_port_02(3);

	--input for router_20
	in_val_20(2)<=out_val_21(1);
	in_val_20(0)<=out_val_10(3);

	out_ack_20(2)<=in_ack_21(1);
	out_ack_20(0)<=in_ack_10(3);

	input_data_port_20(2)<=output_data_port_21(1);
	input_data_port_20(0)<=output_data_port_10(3);

	--inputs for router_21
	in_val_21(2)<=out_val_22(1);
	in_val_21(1)<=out_val_20(2);
	in_val_21(0)<=out_val_11(3);

	out_ack_21(2)<=in_ack_22(1);
	out_ack_21(1)<=in_ack_20(2);
	out_ack_21(0)<=in_ack_11(3);

	input_data_port_21(2)<=output_data_port_22(1);
	input_data_port_21(1)<=output_data_port_20(2);
	input_data_port_21(0)<=output_data_port_11(3);

	--inputs for router_22
	in_val_22(1)<=out_val_21(2);
	in_val_22(0)<=out_val_12(3);

	out_ack_22(1)<=in_ack_21(2);
	out_ack_22(0)<=in_ack_12(3);

	input_data_port_22(1)<=output_data_port_21(2);
	input_data_port_22(0)<=output_data_port_12(3);


	--processor_store at router_22
	processor_store_00: entity processor_store port map(
								   clk=>clk,
								   reset=>reset,
								   in_val=>out_val_00(4),
								   in_ack=>out_ack_00(4),
								   in_data=>output_data_port_00(4)
							   );

	processor_store_01: entity processor_store port map(
								   clk=>clk,
								   reset=>reset,
								   in_val=>out_val_01(4),
								   in_ack=>out_ack_01(4),
								   in_data=>output_data_port_01(4)
							   );

	processor_store_02: entity processor_store port map(
								   clk=>clk,
								   reset=>reset,
								   in_val=>out_val_02(4),
								   in_ack=>out_ack_02(4),
								   in_data=>output_data_port_02(4)
							   );

	processor_store_12: entity processor_store port map(
								   clk=>clk,
								   reset=>reset,
								   in_val=>out_val_12(4),
								   in_ack=>out_ack_12(4),
								   in_data=>output_data_port_12(4)
							   );
	memory_store_22: entity ib port map(
						   clk=>clk,
						   reset=>reset,
						   din=>output_data_port_22(4),
						   wr=>out_val_22(4),
						   rd=>rd_22,
						   wok=>out_ack_22(4),
						   rok=>rok_22,
						   dout=>temp_flit_22
					   );
	memory_store_21: entity ib port map(
						   clk=>clk,
						   reset=>reset,
						   din=>output_data_port_21(4),
						   wr=>out_val_21(4),
						   rd=>rd_21,
						   wok=>out_ack_21(4),
						   rok=>rok_21,
						   dout=>temp_flit_21
					   );
	memory_store_20: entity ib port map(
						   clk=>clk,
						   reset=>reset,
						   din=>output_data_port_20(4),
						   wr=>out_val_20(4),
						   rd=>rd_20,
						   wok=>out_ack_20(4),
						   rok=>rok_20,
						   dout=>temp_flit_20
					   );

	memory_store_10: entity ib port map(
						   clk=>clk,
						   reset=>reset,
						   din=>output_data_port_10(4),
						   wr=>out_val_10(4),
						   rd=>rd_10,
						   wok=>out_ack_10(4),
						   rok=>rok_10,
						   dout=>temp_flit_10
					   );

	memory_store_11: entity ib port map(
						   clk=>clk,
						   reset=>reset,
						   din=>output_data_port_11(4),
						   wr=>out_val_11(4),
						   rd=>rd_11,
						   wok=>out_ack_11(4),
						   rok=>rok_11,
						   dout=>temp_flit_11
					   );

	init: process
	begin
		wait until clk'event and clk='1';
		reset<='1';
		wait until clk'event and clk='1';
		reset<='0';
		wait;
	end process;


	processor_00: process
	begin
		--three clock cycles for  reset
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		input_data_port_00(4)<="0100000000000000000000000110000010";
		in_val_00(4)<='1';
		wait until clk'event and clk='1' and in_ack_00(4)='1';
		input_data_port_00(4)<="0000101100001100001100110000001010";	
		wait until clk'event and clk='1' and in_ack_00(4)='1';
		input_data_port_00(4)<="0001100001001011011100000000001111";
		wait until clk'event and clk='1' and in_ack_00(4)='1';
		input_data_port_00(4)<="1000000000000000000000000000001010";
		wait until clk'event and clk='1' and in_ack_00(4)='1';
		in_val_00(4)<='0';
		wait;
	end process;

	memory_22: process
	begin
		rd_22<='0';
		wait until clk'event and clk='1' and out_val_22(4)='1'; --wait for incoming packet to start
		wait until clk'event and clk='1' and out_val_22(4)='0'; --wait for incoming packet to stop
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		input_data_port_22(4)(33 downto 12)<=temp_flit_22(33 downto 12);
		input_data_port_22(4)(11 downto 6)<=(others=>'0');
		input_data_port_22(4)(5 downto 0)<=temp_flit_22(11 downto 6);
		in_val_22(4)<='1';
		rd_22<='1';
		wait until clk'event and clk='1' and in_ack_22(4)='1';
		while (rok_22/='0') loop
			input_data_port_22(4)<=temp_flit_22;
			wait until clk'event and clk='1' and in_ack_22(4)='1';
		end loop;
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		in_val_22(4)<='0';
		rd_22<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
	end process;

	memory_21: process
	begin
		rd_21<='0';
		wait until clk'event and clk='1' and out_val_21(4)='1'; --wait for incoming packet to start
		wait until clk'event and clk='1' and out_val_21(4)='0'; --wait for incoming packet to stop
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		input_data_port_21(4)(33 downto 12)<=temp_flit_21(33 downto 12);
		input_data_port_21(4)(11 downto 6)<=(others=>'0');
		input_data_port_21(4)(5 downto 0)<=temp_flit_21(11 downto 6);
		in_val_21(4)<='1';
		rd_21<='1';
		wait until clk'event and clk='1' and in_ack_21(4)='1';
		while (rok_21/='0') loop
			input_data_port_21(4)<=temp_flit_21;
			wait until clk'event and clk='1' and in_ack_21(4)='1';
		end loop;
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		in_val_21(4)<='0';
		rd_21<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
	end process;
	
	memory_20: process
	begin
		rd_20<='0';
		wait until clk'event and clk='1' and out_val_20(4)='1'; --wait for incoming packet to start
		wait until clk'event and clk='1' and out_val_20(4)='0'; --wait for incoming packet to stop
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		input_data_port_20(4)(33 downto 12)<=temp_flit_20(33 downto 12);
		input_data_port_20(4)(11 downto 6)<=(others=>'0');
		input_data_port_20(4)(5 downto 0)<=temp_flit_20(11 downto 6);
		in_val_20(4)<='1';
		rd_20<='1';
		wait until clk'event and clk='1' and in_ack_20(4)='1';
		while (rok_20/='0') loop
			input_data_port_20(4)<=temp_flit_20;
			wait until clk'event and clk='1' and in_ack_20(4)='1';
		end loop;
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		in_val_20(4)<='0';
		rd_20<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
	end process;

	memory_10: process
	begin
		rd_10<='0';
		wait until clk'event and clk='1' and out_val_10(4)='1'; --wait for incoming packet to start
		wait until clk'event and clk='1' and out_val_10(4)='0'; --wait for incoming packet to stop
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
		input_data_port_10(4)(33 downto 12)<=temp_flit_10(33 downto 12);
		input_data_port_10(4)(11 downto 6)<=(others=>'0');
		input_data_port_10(4)(5 downto 0)<=temp_flit_10(11 downto 6);
		in_val_10(4)<='1';
		rd_10<='1';
		wait until clk'event and clk='1' and in_ack_10(4)='1';
		while (rok_10/='0') loop
			input_data_port_10(4)<=temp_flit_10;
			wait until clk'event and clk='1' and in_ack_10(4)='1';
		end loop;
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		--wait until clk'event and clk='1' and in_ack_22(4)='1';
		in_val_10(4)<='0';
		rd_10<='0';
		wait until clk'event and clk='1';
		wait until clk'event and clk='1';
	end process;
end tb;

