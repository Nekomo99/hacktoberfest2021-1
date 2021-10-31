library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity LSHIFT is
Port (IP,CLK,SL : in STD_LOGIC;
D : in STD_LOGIC_VECTOR (3 downto 0);
OP : out STD_LOGIC_VECTOR (3 downto 0));
end LSHIFT;
architecture Behavioral of LSHIFT is
component DFF is
Port ( RST,CLK,D : in STD_LOGIC;
Q,Qbar : out STD_LOGIC);
end component;
component MUX2X1 is
Port ( A0,A1,S : in STD_LOGIC;
F : out STD_LOGIC);
end component;
signal Y3,Y2,Y1,Y0: STD_LOGIC;
signal X3,X2,X1,X0: STD_LOGIC;
begin
MUX0: MUX2X1 port map (A0=>IP,A1=>D(0),S=>SL,F=>X0);
MUX1: MUX2X1 port map (A0=>Y0,A1=>D(1),S=>SL,F=>X1);
MUX2: MUX2X1 port map (A0=>Y1,A1=>D(2),S=>SL,F=>X2);
MUX3: MUX2X1 port map (A0=>Y2,A1=>D(3),S=>SL,F=>X3);
DFF0: DFF port map (RST=>'0',CLK=>CLK,D=>X0,Q=>Y0);
DFF1: DFF port map (RST=>'0',CLK=>CLK,D=>X1,Q=>Y1);
DFF2: DFF port map (RST=>'0',CLK=>CLK,D=>X2,Q=>Y2);
DFF3: DFF port map (RST=>'0',CLK=>CLK,D=>X3,Q=>Y3);
OP(0)<= Y0;
OP(1)<= Y1;
OP(2)<= Y2;
OP(3)<= Y3;
end Behavioral;
