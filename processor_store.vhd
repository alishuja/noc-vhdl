library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity processor_store is
	port(
		    clk: in std_logic;
		    reset: in std_logic;
		    in_val: in std_logic;
		    in_ack: out std_logic;
		    in_data: in FLIT
	    );
end entity;
architecture arch of processor_store is
	signal rd: std_logic;
	signal dout: FLIT;

	component ib
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
	end component;
begin
	rd<='0';

	ib_i: ib
	port map(
			clk=>clk,
			reset=>reset,
			din=>in_data,
			dout=>dout,
			rd=>rd,
			wr=>in_val,
			wok=>in_ack
		);
end arch;
