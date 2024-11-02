-- Copyright (C) 2024  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 23.1std.1 Build 993 05/14/2024 SC Lite Edition"

-- DATE "11/02/2024 12:05:34"

-- 
-- Device: Altera 5CEBA4F23C7 Package FBGA484
-- 

-- 
-- This VHDL file should be used for Questa Intel FPGA (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	mini_tst IS
    PORT (
	ac : IN std_logic_vector(2 DOWNTO 0);
	enable : IN std_logic;
	q : OUT std_logic_vector(2 DOWNTO 0)
	);
END mini_tst;

-- Design Ports Information
-- q[0]	=>  Location: PIN_L22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q[1]	=>  Location: PIN_L18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q[2]	=>  Location: PIN_N19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ac[0]	=>  Location: PIN_K21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- enable	=>  Location: PIN_M18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ac[1]	=>  Location: PIN_M16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ac[2]	=>  Location: PIN_M22,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF mini_tst IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_ac : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_enable : std_logic;
SIGNAL ww_q : std_logic_vector(2 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \ac[0]~input_o\ : std_logic;
SIGNAL \enable~input_o\ : std_logic;
SIGNAL \q[0]$latch~combout\ : std_logic;
SIGNAL \ac[1]~input_o\ : std_logic;
SIGNAL \q[1]$latch~combout\ : std_logic;
SIGNAL \ac[2]~input_o\ : std_logic;
SIGNAL \q[2]$latch~combout\ : std_logic;
SIGNAL \ALT_INV_q[0]$latch~combout\ : std_logic;
SIGNAL \ALT_INV_q[1]$latch~combout\ : std_logic;
SIGNAL \ALT_INV_q[2]$latch~combout\ : std_logic;
SIGNAL \ALT_INV_ac[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_enable~input_o\ : std_logic;
SIGNAL \ALT_INV_ac[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_ac[2]~input_o\ : std_logic;

BEGIN

ww_ac <= ac;
ww_enable <= enable;
q <= ww_q;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_q[0]$latch~combout\ <= NOT \q[0]$latch~combout\;
\ALT_INV_q[1]$latch~combout\ <= NOT \q[1]$latch~combout\;
\ALT_INV_q[2]$latch~combout\ <= NOT \q[2]$latch~combout\;
\ALT_INV_ac[0]~input_o\ <= NOT \ac[0]~input_o\;
\ALT_INV_enable~input_o\ <= NOT \enable~input_o\;
\ALT_INV_ac[1]~input_o\ <= NOT \ac[1]~input_o\;
\ALT_INV_ac[2]~input_o\ <= NOT \ac[2]~input_o\;

-- Location: IOOBUF_X54_Y19_N56
\q[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \q[0]$latch~combout\,
	devoe => ww_devoe,
	o => ww_q(0));

-- Location: IOOBUF_X54_Y21_N22
\q[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \q[1]$latch~combout\,
	devoe => ww_devoe,
	o => ww_q(1));

-- Location: IOOBUF_X54_Y19_N5
\q[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \q[2]$latch~combout\,
	devoe => ww_devoe,
	o => ww_q(2));

-- Location: IOIBUF_X54_Y21_N38
\ac[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ac(0),
	o => \ac[0]~input_o\);

-- Location: IOIBUF_X54_Y19_N21
\enable~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enable,
	o => \enable~input_o\);

-- Location: LABCELL_X53_Y19_N30
\q[0]$latch\ : cyclonev_lcell_comb
-- Equation(s):
-- \q[0]$latch~combout\ = ( \enable~input_o\ & ( \ac[0]~input_o\ ) ) # ( !\enable~input_o\ & ( \q[0]$latch~combout\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000011111111000000001111111100110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_ac[0]~input_o\,
	datad => \ALT_INV_q[0]$latch~combout\,
	dataf => \ALT_INV_enable~input_o\,
	combout => \q[0]$latch~combout\);

-- Location: IOIBUF_X54_Y18_N61
\ac[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ac(1),
	o => \ac[1]~input_o\);

-- Location: LABCELL_X53_Y19_N39
\q[1]$latch\ : cyclonev_lcell_comb
-- Equation(s):
-- \q[1]$latch~combout\ = ( \ac[1]~input_o\ & ( \enable~input_o\ ) ) # ( \ac[1]~input_o\ & ( !\enable~input_o\ & ( \q[1]$latch~combout\ ) ) ) # ( !\ac[1]~input_o\ & ( !\enable~input_o\ & ( \q[1]$latch~combout\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111000011110000111100000000000000001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_q[1]$latch~combout\,
	datae => \ALT_INV_ac[1]~input_o\,
	dataf => \ALT_INV_enable~input_o\,
	combout => \q[1]$latch~combout\);

-- Location: IOIBUF_X54_Y19_N38
\ac[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_ac(2),
	o => \ac[2]~input_o\);

-- Location: LABCELL_X53_Y19_N42
\q[2]$latch\ : cyclonev_lcell_comb
-- Equation(s):
-- \q[2]$latch~combout\ = ( \q[2]$latch~combout\ & ( \enable~input_o\ & ( \ac[2]~input_o\ ) ) ) # ( !\q[2]$latch~combout\ & ( \enable~input_o\ & ( \ac[2]~input_o\ ) ) ) # ( \q[2]$latch~combout\ & ( !\enable~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111100110011001100110011001100110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_ac[2]~input_o\,
	datae => \ALT_INV_q[2]$latch~combout\,
	dataf => \ALT_INV_enable~input_o\,
	combout => \q[2]$latch~combout\);

-- Location: MLABCELL_X42_Y8_N3
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


