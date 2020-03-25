LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg_file IS

    PORT( 
        
        clk  :  IN  STD_LOGIC;
        we3  :  IN  STD_LOGIC;
        a1  :  IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
        a2  :  IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
        a3  :  IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
        wd3  :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        r15  :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        rd1  :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rd2  :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    );

END ENTITY;

ARCHITECTURE arch OF reg_file IS

    TYPE ramtype IS ARRAY (15 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem: ramtype;

    BEGIN
        -- Writing process
        PROCESS(clk, we3, a3)

            BEGIN

                IF (clk'EVENT AND clk = '1') THEN

                    IF (we3 = '1') THEN

                        mem(TO_INTEGER(UNSIGNED(a3))) <= wd3;

                    END IF;

                END IF;

            END PROCESS;

        -- Reading process
        PROCESS(clk, a1, a2, r15)

            BEGIN

                IF (clk'EVENT AND clk = '1') THEN

                    -- rd1 affectation
                    IF (TO_INTEGER(UNSIGNED(a1)) = 15) THEN 

                        rd1 <= r15;

                    ELSIF (a1 = "UUUU") THEN 
                    
                        rd1 <= (OTHERS => 'U');

                    ELSE 

                        rd1 <= mem(TO_INTEGER(UNSIGNED(a1)));

                    END IF;

                    -- rd2 affectation
                    IF (TO_INTEGER(UNSIGNED(a2)) = 15) THEN 
                    
                        rd2 <= r15;

                    ELSIF (a2 = "UUUU") THEN 
                    
                        rd2 <= (OTHERS => 'U');

                    ELSE 
                    
                        rd2 <= mem(TO_INTEGER(UNSIGNED(a2)));

                    END IF;

               END IF;

            END PROCESS;

END ARCHITECTURE;
    