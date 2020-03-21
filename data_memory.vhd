LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;

ENTITY data_memory IS

    GENERIC(
          N: INTEGER := 32);
          
    PORT( clk, we:      IN    STD_LOGIC;
          a, wd:        IN    STD_LOGIC_VECTOR(N - 1 downto 0);
          rd:           OUT   STD_LOGIC_VECTOR(N - 1 downto 0));
END;

ARCHITECTURE behave OF data_memory IS

TYPE ramtype IS ARRAY (2**N - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
SIGNAL mem: ramtype;

BEGIN

   
    PROCESS(clk, we, a, wd)

        BEGIN
        
            -- memory initialisation to 0
            FOR i IN 0 TO N - 1 LOOP
            
                mem(i) <= (OTHERS => '0');
                
            END LOOP;
            
            -- read and write
            LOOP
            
                IF (clk'EVENT AND clk = '1') THEN
                
                    -- write affectation
                    IF (we = '1') THEN
                    
                        mem(TO_INTEGER(UNSIGNED(a))) <= wd;
                        
                    END IF;
                    
                    -- read affectation
                    rd <= mem(TO_INTEGER(UNSIGNED(a)));
                    
                END IF;
                
            END LOOP;
            
        END PROCESS;

END ARCHITECTURE;
        
    