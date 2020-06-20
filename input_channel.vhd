library ieee;
use ieee.std_logic_1164.all;
use work.definitions.all;

entity input_channel is
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
end entity;

architecture arch of input_channel is
	component ib
		port(
			    clk: in std_logic;
			    reset: in std_logic;
			    din: in FLIT;
			    wr: in std_logic;
			    rd: in std_logic;
			    dout: out FLIT;
			    rok: out std_logic;
			    wok: out std_logic
		    );
	end component;

	component ifc
		port(
			    in_val: in std_logic;
			    in_ack: out std_logic;
			    out_val: out std_logic;
			    in_wok: in std_logic
		    );
	end component;

	component ic
		generic(
		location: DIRECTION);
		port(
			    reset: in std_logic;

			    rok: in std_logic;
			    din: in FLIT;
			    x_dout: out FLIT;
			    x_req: out std_logic_vector((NUMBER_OF_PORTS-2)downto 0)

		    ); 
	end component;

	component irs
		port(
			    x_rd: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
			    x_gnt: in std_logic_vector((NUMBER_OF_PORTS-2) downto 0);
			    rd: out std_logic);
	end component;

	signal rd, rok_signal, wok, wr: std_logic;
	signal dout: FLIT;
begin
	ifc_i: ifc port map(
				   in_val=>in_val,
				   in_ack=>in_ack,
				   out_val=>wr,
				   in_wok=>wok);

	ib_i: ib port map(
				 clk=>clk,
				 reset=>reset,
				 din=>in_data,
				 wr=>wr,
				 wok=>wok,
				 dout=>dout,
				 rok=>rok_signal,
				 rd=>rd);

	ic_i: ic generic map(location=>location)
	port map(
			reset=>reset,
			din=>dout,
			rok=>rok_signal,
			x_dout=>x_dout,
			x_req=>x_req);

	irs_i: irs port map(
				   x_gnt=>x_gnt,
				   x_rd=>x_rd,
				   rd=>rd);
	x_rok<=rok_signal;
end arch;
