LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY pc_handler IS 

    GENERIC(

        C_WIDTH : INTEGER := 32

    );

    PORT(

        clk : IN  STD_LOGIC;
        pcp : IN  STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0);
        pc  : OUT STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0)
    );

END ENTITY;



ARCHITECTURE arch OF pc_handler IS 

    BEGIN 

        update : PROCESS(clk)

            BEGIN

                IF(clk'EVENT AND clk = '1') THEN 

                    pc <= pcp;

                END IF;

            END PROCESS;

END ARCHITECTURE;