library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UPDOWN is
    Port ( RST,UP,DN,CLK : in  STD_LOGIC;
           OP : out  STD_LOGIC_VECTOR (3 downto 0));
end UPDOWN;

architecture Behavioral of UPDOWN is

component TFF is
    Port ( RST,CLK,T : in  STD_LOGIC;
           Q,Qbar : out  STD_LOGIC);
end component;

signal X,Y,Z : STD_LOGIC_VECTOR(3 downto 0);

begin

TFF0: TFF port map (RST,CLK,Y(0),X(0),Z(0));
TFF1: TFF port map (RST,CLK,Y(1),X(1),Z(1));
TFF2: TFF port map (RST,CLK,Y(2),X(2),Z(2));
TFF3: TFF port map (RST,CLK,Y(3),X(3),Z(3));

Y(0)<= ((DN and (not UP)) or UP);
Y(1)<= ((DN and (not UP) and Z(0)) or (UP and X(0)));
Y(2)<= (((DN and (not UP) and Z(0)) and Z(1)) or ((UP and X(0)) and X(1))); 
Y(3)<= ((((DN and (not UP) and Z(0)) and Z(1)) and Z(2)) or (((UP and X(0)) and X(1)) and X(2)));
 
OP<=X;
end Behavioral;

