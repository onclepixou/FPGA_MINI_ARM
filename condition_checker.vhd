LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY condition_checker IS 

    PORT(

        cond   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        flags  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        condex : OUT STD_LOGIC
    );

END ENTITY;


ARCHITECTURE arch OF condition_checker IS 

    SIGNAL neg      : STD_LOGIC;
    SIGNAL zero     : STD_LOGIC;
    SIGNAL carry    : STD_LOGIC;
    SIGNAL overflow : STD_LOGIC;
    SIGNAL ge       : STD_LOGIC;

    BEGIN 

        (neg, zero, carry, overflow) <= flags;
        ge <= (neg XNOR overflow);

        update : PROCESS(clk, cond, neg, zero, carry, overflow, ge)

            BEGIN
            
                CASE cond IS 

                    WHEN "0000" => condex <= zero ;
                    WHEN "0001" => condex <= NOT zero ;
                    WHEN "0010" => condex <= carry ;
                    WHEN "0011" => condex <= NOT carry ;
                    WHEN "0100" => condex <= neg ;
                    WHEN "0101" => condex <= NOT neg ;
                    WHEN "0110" => condex <= overflow ;
                    WHEN "0111" => condex <= NOT overflow ;
                    WHEN "1000" => condex <= carry AND (NOT zero) ;
                    WHEN "1001" => condex <= NOT(carry AND (NOT zero)) ;
                    WHEN "1010" => condex <= ge ;
                    WHEN "1011" => condex <= NOT ge ;
                    WHEN "1100" => condex <= (NOT zero) AND ge ;
                    WHEN "1101" => condex <= NOT((NOT ZERO) AND ge) ;
                    WHEN "1110" => condex <= '1' ;
                    WHEN OTHERS => condex <= '-' ;

                END CASE;

            END PROCESS;

END ARCHITECTURE;