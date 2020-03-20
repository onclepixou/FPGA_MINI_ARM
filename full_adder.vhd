LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 
ENTITY full_adder is

    PORT ( a    : IN STD_LOGIC;
           b    : IN STD_LOGIC;
           cin  : IN STD_LOGIC;
           s    : OUT STD_LOGIC;
           cout : OUT STD_LOGIC
    );

END full_adder;
 
ARCHITECTURE arch of full_adder is
 
BEGIN
 
    s    <= a XOR b XOR cin ;
    cout <= (a AND b) OR (cin AND a) OR (cin AND b) ;
 
END ARCHITECTURE;