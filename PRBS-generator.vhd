library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PRBS is
    Port ( CLK,RST,E : in  STD_LOGIC;
           OP : out  STD_LOGIC_VECTOR(7 downto 0));
end PRBS;

architecture Behavioral of PRBS is

component DFFSET is
    Port ( RST,CLK,D,SET : in  STD_LOGIC;
           Q,Qbar : out  STD_LOGIC);
end component;

signal X : STD_LOGIC_VECTOR(7 downto 0);
signal Y : STD_LOGIC_VECTOR(7 downto 0);
signal M : STD_LOGIC_VECTOR(2 downto 0);

begin
M(0)<= X(3) XOR X(7);
M(1)<= X(2) XOR M(0);
M(2)<= X(1) XOR M(1);
DFF0: DFFSET port map(RST,CLK,M(2),E,X(0),Y(0));		
DFF1: DFFSET port map(RST,CLK,X(0),'0',X(1),Y(1));		
DFF2: DFFSET port map(RST,CLK,X(1),E,X(2),Y(2));	
DFF3: DFFSET port map(RST,CLK,X(2),'0',X(3),Y(3));	
DFF4: DFFSET port map(RST,CLK,X(3),'0',X(4),Y(4));
DFF5: DFFSET port map(RST,CLK,X(4),E,X(5),Y(5));
DFF6: DFFSET port map(RST,CLK,X(5),'0',X(6),Y(6));
DFF7: DFFSET port map(RST,CLK,X(6),E,X(7),Y(7));


OP<=X;
end Behavioral;
