LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY dff IS 

    GENERIC(

        N : INTEGER := 8

    );

    PORT(

        clk : IN  STD_LOGIC;
        en  : IN  STD_LOGIC;
        d   : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0 );
        q   : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0 )

    );

END ENTITY;

ARCHITECTURE arch OF dff IS 

    BEGIN 

        PROCESS(clk, en)
            
            BEGIN 

                IF(clk'EVENT AND clk = '1') THEN 

                    IF(en = '1') THEN

                        q <= d;

                    END IF;

                END IF ;

            END PROCESS;


END ARCHITECTURE;