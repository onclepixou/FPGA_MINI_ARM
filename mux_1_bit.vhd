LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mux_1_bit IS

    GENERIC(

        N: INTEGER := 32

    );

    PORT(

        sel:      IN   STD_LOGIC;
        e0:       IN   STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        e1:       IN   STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        s:        OUT  STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        
    );

END;

ARCHITECTURE arch OF mux_1_bit IS

    BEGIN

        s <= e0 WHEN sel = '0' ELSE
             e1 WHEN sel = '1' ;

END ARCHITECTURE;
    