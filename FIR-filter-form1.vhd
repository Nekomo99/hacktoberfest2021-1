library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity FIR_DIRECT is
Port ( Xin : in STD_LOGIC_VECTOR (7 downto 0);
clk : in STD_LOGIC;
Yout : out STD_LOGIC_VECTOR (7 downto 0));
end FIR_DIRECT;
architecture Structural of FIR_DIRECT is
component DFF8BIT is
Port ( D : in STD_LOGIC_VECTOR (7 downto 0);
CLK : in STD_LOGIC;
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
--H = [4 5 2 7].
H0 <= "00000100";
H1 <= "00000101";
H2 <= "00000010";
H3 <= "00000111";
--flipflops(for introducing a delay).
DFF0 : DFF8BIT port map(Xin,clk,Q0);
DFF1 : DFF8BIT port map(Q0,clk,Q1);
DFF2 : DFF8BIT port map(Q1,clk,Q2);
--Multiple constant multiplications.
MUL0 : BIT8MULTI port map(H0,Xin,M0);
MUL1 : BIT8MULTI port map(H1,Q0,M1);
MUL2 : BIT8MULTI port map(H2,Q1,M2);
MUL3 : BIT8MULTI port map(H3,Q2,M3);
--Truncation
Tr_M0 <= M0(7 downto 0);
Tr_M1 <= M1(7 downto 0);
Tr_M2 <= M2(7 downto 0);
Tr_M3 <= M3(7 downto 0);
--adders
X0 : BIT8ADDER port map(Tr_M0,Tr_M1,add0);
X1 : BIT8ADDER port map(add0,Tr_M2,add1);
X2 : BIT8ADDER port map(add1,Tr_M3,add2);
--an output produced at every positive edge of clock cycle.
process(clk)
begin
if(rising_edge(clk)) then
Yout <= add2;
end if;
end process;
end Structural;

/*Testbench:*/
stim_proc: process
begin
-- hold reset state for 100 ns.
wait for 100 ns;
Xin <= "00000111"; wait for clk_period*1;
Xin <= "00000101"; wait for clk_period*1;
Xin <= "00000100"; wait for clk_period*1;
Xin <= "00000010"; wait for clk_period*1;
wait;
wait;
end process;
