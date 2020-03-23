LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu_decoder IS

    PORT( 
        
        funct         :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        aluop         :  IN  STD_LOGIC;
        alucontrol    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        flagw         :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

    );

END;

ARCHITECTURE arch OF alu_decoder IS
    signal funct41: STD_LOGIC_VECTOR := funct(4 DOWNTO 1);

    BEGIN
        
        alucontrol <= "00" WHEN ( aluop = '0' ) ELSE
                      "00" WHEN ( aluop = '1' AND funct41 = "0100") ELSE
                      "01" WHEN ( aluop = '1' AND funct41 = "0010") ELSE
                      "10" WHEN ( aluop = '1' AND funct41 = "0000") ELSE
                      "11" WHEN ( aluop = '1' AND funct41 = "1100");
                  
        flagw <= "00" WHEN ( aluop = '0' ) ELSE
                 "00" WHEN ( aluop = '1' AND funct(0) = '0') ELSE
                 "11" WHEN ( aluop = '1' AND funct41 = "0100" AND funct(0) = '1') ELSE
                 "11" WHEN ( aluop = '1' AND funct41 = "0010" AND funct(0) = '1') ELSE
                 "10" WHEN ( aluop = '1' AND funct41 = "0000" AND funct(0) = '1') ELSE
                 "10" WHEN ( aluop = '1' AND funct41 = "1100" AND funct(0) = '1');


END ARCHITECTURE;
    