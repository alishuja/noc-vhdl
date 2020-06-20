library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity ib is
	port(
		--control
		clk: in std_logic;
		reset: in std_logic;

		--inputs
		din: in FLIT;
		wr: in std_logic;
		rd: in std_logic;
		
		--outputs
		dout: out FLIT;
		rok: out std_logic;
		wok: out std_logic
	);
end entity;	

architecture arch of ib is
	component circular_buffer
		generic(
			WIDTH: natural;
			LENGTH: natural);
		port(
			clk, reset: in std_logic;
			rd, wr: in std_logic;
			w_data: in std_logic_vector (WIDTH-1 downto 0);
			empty, full: out std_logic;
			r_data: out std_logic_vector(WIDTH-1 downto 0)
		);
	end component;
	signal empty, full, is_wr_ok, is_rd_ok, temp_wr: std_logic;
	signal dout_signal: FLIT;
begin
	c_buffer: circular_buffer 
	generic map(WIDTH=>FLIT_LENGTH, LENGTH=>PACKET_LENGTH)
	port map(
		clk=> clk,
		reset => reset,
		wr=> temp_wr,
		rd=> rd,
		empty => empty,
		full => full,
		w_data=> din,
		r_data=>dout_signal
	);
	dout<=dout_signal;
	temp_wr<='0' when (wr='1' and (din(FLIT_LENGTH-2)='1') and (din=dout_signal)) else wr;
	wok<=is_wr_ok;
	rok<=is_rd_ok;
	process(clk, reset)
	begin
		if (reset='1') then
			is_wr_ok<='0';
			is_rd_ok<='0';
		elsif clk'event and clk='1' then 
			if temp_wr='1' and full/='1' then
				is_wr_ok<='1';
			elsif temp_wr='0' and wr='1' and full/='1' then
				is_wr_ok<='1';
			else
				is_wr_ok<='0';
			end if;
			if rd='1' and empty/='1' then
				is_rd_ok<='1';
			else
				is_rd_ok<='0';
			end if;
		end if;
	end process;
end arch;
