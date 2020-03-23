LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pc_logic IS

    PORT( 
        
        rd          :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        regw        :  IN  STD_LOGIC;
        branch      :  IN STD_LOGIC;
        pcs         :  OUT STD_LOGIC

    );

END;

ARCHITECTURE arch OF pc_logic IS

    BEGIN
        
        pcs <= ((rd(3) AND rd(2) AND rd(1) AND rd(0) AND regw) OR branch);
END ARCHITECTURE;
    