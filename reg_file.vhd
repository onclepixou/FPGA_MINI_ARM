LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;

ENTITY regfile IS
    PORT( clk:            in  STD_LOGIC;
          we3:            in  STD_LOGIC;
          ra1, ra2, wa3:  in  STD_LOGIC_VECTOR(3 downto 0);
          wd3, r15:       in  STD_LOGIC_VECTOR(31 downto 0);
          rd1, rd2:       out STD_LOGIC_VECTOR(31 downto 0));
END;

ARCHITECTURE behave OF regfile IS
    TYPE ramtype is array (15 downto 0) OF STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL mem: ramtype;
BEGIN
    -- Writing process
    PROCESS(clk)
    BEGIN
        IF (clk'event AND clk = '1')
        THEN
            IF we3 = '1'
            THEN
                mem(to_integer(UNSIGNED(wa3))) <= wd3;
            END IF;
        END IF;
    END PROCESS;
    
    -- Reading process
    PROCESS(clk, ra1, ra2, we3, wd3, r15)
    BEGIN
        IF (clk'event AND clk = '1')
        THEN
            -- rd1 affectation
            IF (to_integer(UNSIGNED(ra1)) = 15) THEN rd1 <= r15;
            ELSIF (ra1 = "UUUU") THEN rd1 <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
            ELSE rd1 <= mem(to_integer(UNSIGNED(ra1)));
            END IF;
                
            -- rd2 affectation
            IF (to_integer(UNSIGNED(ra2)) = 15) THEN rd2 <= r15;
            ELSIF (ra2 = "UUUU") THEN rd2 <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
            ELSE rd2 <= mem(to_integer(UNSIGNED(ra2)));
            END IF;
       END IF;
   END PROCESS;
END;
    