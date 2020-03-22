LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;

ENTITY data_memory IS

    GENERIC(
          N: INTEGER := 32);
          
    PORT( clk, we, rst: IN    STD_LOGIC;
          a, wd:        IN    STD_LOGIC_VECTOR(N - 1 downto 0);
          rd:           OUT   STD_LOGIC_VECTOR(N - 1 downto 0));
END;

ARCHITECTURE behave OF data_memory IS

CONSTANT wrong_address: STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => 'U');
TYPE ramtype IS ARRAY (2**N - 1 DOWNTO 0) OF STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
SIGNAL mem: ramtype;

BEGIN

   
    PROCESS(clk, we, a, wd)

        BEGIN
        
            -- initialisation memory set to 0
            FOR i IN 0 TO N - 1 LOOP
            
                mem(i) <= (OTHERS => '0');
                
            END LOOP;
            
            -- read and write loop
            LOOP
                -- asynchronous rest
                IF (rst = '1') THEN
                
                        FOR i IN 0 TO N - 1 LOOP
            
                            mem(i) <= (OTHERS => '0');
                
                        END LOOP;
                   
                -- rising edge
                ELSIF (clk'EVENT AND clk = '1') THEN
                    
                    -- valid address test
                    IF a = wrong_address THEN
                    
                        rd <= (OTHERS => 'U');
                    
                    ELSE
                    
                        -- write affectation
                        IF (we = '1') THEN
                    
                            mem(TO_INTEGER(UNSIGNED(a(N - 1 DOWNTO 2)))) <= wd;
                        
                        END IF;
                    
                        -- read affectation
                        rd <= mem(TO_INTEGER(UNSIGNED(a(N - 1 DOWNTO 2))));

                    END IF;
                    
                END IF;
                
            END LOOP;
            
        END PROCESS;

END ARCHITECTURE;
        
    