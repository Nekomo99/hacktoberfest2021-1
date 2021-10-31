library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity FIR_BRDCST is
Port ( Xin : in STD_LOGIC_VECTOR (7 downto 0);
clk : in STD_LOGIC;
Yout : out STD_LOGIC_VECTOR (7 downto 0));
end FIR_BRDCST;
architecture Behavioral of FIR_BRDCST is
component DFF8BIT is
Port ( D : in STD_LOGIC_VECTOR (7 downto 0);
clk : in STD_LOGIC;
Q : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component BIT8ADDER is
Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
B : in STD_LOGIC_VECTOR (7 downto 0);
S : out STD_LOGIC_VECTOR (7 downto 0);
C_out : out STD_LOGIC);
end component;
component BIT8MULTI is
Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
B : in STD_LOGIC_VECTOR (7 downto 0);
P : out STD_LOGIC_VECTOR (15 downto 0));
end component;
signal H0,H1,H2,H3 : std_logic_vector(7 downto 0) := (others => '0');
signal M0,M1,M2,M3 : std_logic_vector(15 downto 0) := (others => '0');
signal Q0,Q1,Q2 : std_logic_vector(7 downto 0) := (others => '0');
signal Tr_M0,Tr_M1,Tr_M2,Tr_M3,add0,add1,add2 : std_logic_vector(7 downto 0) := (others =>
'0');
begin
--filter coefficient initializations.
--H = [2 3 0 8].
H0 <= "00000010";
H1 <= "00000011";
H2 <= "00000000";
H3 <= "00001000";
--Multiple constant multiplications.
mul0 : BIT8MULTI port map(H3,Xin,M0);
mul1 : BIT8MULTI port map(H2,Xin,M1);
mul2 : BIT8MULTI port map(H1,Xin,M2);
mul3 : BIT8MULTI port map(H0,Xin,M3);
--Truncation
Tr_M0 <= M0(7 downto 0);
Tr_M1 <= M1(7 downto 0);
Tr_M2 <= M2(7 downto 0);
Tr_M3 <= M3(7 downto 0);
--flipflops(for introducing a delay).
dff0 : DFF8BIT port map(Tr_M0,clk,Q0);
dff1 : DFF8BIT port map(add0,clk,Q1);
dff2 : DFF8BIT port map(add1,clk,Q2);
--adders
a0 : BIT8ADDER port map(Q0,Tr_M1,add0);
a1 : BIT8ADDER port map(Q1,Tr_M2,add1);
a2 : BIT8ADDER port map(Q2,Tr_M3,add2);
--an output produced at every positive edge of clock cycle.
process(clk)
begin
if(rising_edge(clk)) then
Yout <= add2;
end if;
end process;
end behavioral;

  
  
/*Testbench:*/
stim_proc: process
begin
Xin <= "00000111"; wait for clk_period*1;
Xin <= "00000101"; wait for clk_period*1;
Xin <= "00000100"; wait for clk_period*1;
Xin <= "00000010"; wait for clk_period*1;
end process;
