-- ---------------------------------------------
-- UART system to test the simple uart unit and tha VGA Char generator
-- BAUD RATE 115200
-- ---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity serial2vga_system is
port (
      clk :	in std_logic;
      rst :	in std_logic;
--      Divisor :	in std_logic_vector (11 downto 0); descomentar para otras velocidades
      rx :	in std_logic;
      tx :	out std_logic;
      hsync : out std_logic;
      vsync : out std_logic;
		red_out : out std_logic;
      grn_out : out std_logic;
      blu_out : out std_logic
);
end serial2vga_system;

architecture arch of serial2vga_system is
      component uart
      	generic (
		F: natural;
		min_baud: natural;
		num_data_bits: natural
	);
	port (
         	Rx	: in std_logic;
	 	Tx	: out std_logic;
	 	Din	: in std_logic_vector(7 downto 0);
	 	StartTx	: in std_logic;
		TxBusy	: out std_logic;
		Dout	: out std_logic_vector(7 downto 0);
		RxRdy	: out std_logic;
		RxErr	: out std_logic;
		Divisor	: in std_logic_vector; 
		clk	: in std_logic;
		rst	: in std_logic
	);
      end component;

      component aplicVGA
      	port (
      	      clk: in std_logic;
             char_in: in std_logic_vector(7 downto 0);
             RxRdy: in std_logic;
             hsync : out std_logic;
             vsync : out std_logic;
             red_out : out std_logic;
             grn_out : out std_logic;
             blu_out : out std_logic
             );
      end component;

      constant Divisor : std_logic_vector := "000000011011"; -- Divisor=27 para 115200 baudios
      signal sig_Din	: std_logic_vector(7 downto 0);
      signal sig_Dout	: std_logic_vector(7 downto 0);
      signal sig_RxErr	: std_logic;
      signal sig_RxRdy	: std_logic;
      signal sig_TxBusy	: std_logic;
      signal sig_StartTx: std_logic;

   begin
   -- UART Instanciation :
	UUT : uart
	generic map (
		F 	=> 50000,
		min_baud => 1200,
		num_data_bits => 8
	)
	port map (
         	Rx	=> rx,
	 	Tx	=> tx,
	 	Din	=> sig_Din,
	 	StartTx	=> sig_StartTx,
		TxBusy	=> sig_TxBusy,
		Dout	=> sig_Dout,
		RxRdy	=> sig_RxRdy,
		RxErr	=> sig_RxErr,
		Divisor	=> Divisor,
		clk	=> clk,
		rst	=> rst
	);
   
   -- BACKEND APPLICATION Instanciation :
	APPLICATION: aplicVGA
	port map (
		CLK	=> clk,
		char_in	=> sig_Dout,
		RxRdy	=> sig_RxRdy,
		hsync => hsync,
      vsync => vsync,
      red_out => red_out,
      grn_out => grn_out,
      blu_out => blu_out
	);
end arch;
