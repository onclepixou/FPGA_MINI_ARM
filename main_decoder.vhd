LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY main_decoder IS

    PORT( 
        
        op        :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        funct     :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        branch    :  OUT STD_LOGIC;
        regw      :  OUT STD_LOGIC;
        memw      :  OUT STD_LOGIC;
        memtoreg  :  OUT STD_LOGIC;
        alusrc    :  OUT STD_LOGIC;
        immsrc    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        regsrc    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        aluop     :  OUT STD_LOGIC

    );

END;

ARCHITECTURE arch OF main_decoder IS


    BEGIN
        
        branch <= '1' WHEN ( op = "10" ) ELSE
                  '0';
                  
        memtoreg <= '1' WHEN ( op = "01" AND funct(0) = '0') ELSE
                    'X' WHEN ( op = "01" AND funct(0) = '1') ELSE
                    '0';
                    
        memw <= '1' WHEN ( op = "01" AND funct(0) = '0') ELSE
                '0';
               
        alusrc <= '0' WHEN ( op = "00" AND funct(1) = '0') ELSE
                  '1';
                
        immsrc <= "UU" WHEN ( op = "00" AND funct(1) = '0') ELSE
                  "00" WHEN ( op = "00" AND funct(1) = '1') ELSE
                  "01" WHEN ( op = "01") ELSE
                  "10" WHEN ( op = "10");
               
        regw <= '0' WHEN ( op = "01" AND funct(0) = '0' ) ELSE
                '0' WHEN ( op = "10") ELSE
                '1';
                
        regsrc <= "00" WHEN ( op = "00" AND funct(1) = '0' ) ELSE 
                  "X0" WHEN ( op = "00" AND funct(1) = '1' ) ELSE 
                  "10" WHEN ( op = "01" AND funct(0) = '0' ) ELSE
                  "X0" WHEN ( op = "01" AND funct(0) = '1' ) ELSE
                  "X1" WHEN ( op = "10");
                  
        aluop <= '1' WHEN ( op = "00") ELSE
                 '0' WHEN ( op = "01" OR op = "10");
                

END ARCHITECTURE;
    