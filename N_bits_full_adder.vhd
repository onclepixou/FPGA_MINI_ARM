LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 
ENTITY N_bits_full_adder is

    GENERIC( 

        SIZE : INTEGER := 8

    );

    PORT ( a    : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
           b    : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
           cin  : IN STD_LOGIC;
           s    : OUT STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
           cout : OUT STD_LOGIC
    );

END ENTITY;
 

ARCHITECTURE arch of N_bits_full_adder is
 
    COMPONENT full_adder is

        PORT ( a    : IN STD_LOGIC;
               b    : IN STD_LOGIC;
               cin  : IN STD_LOGIC;
               s    : OUT STD_LOGIC;
               cout : OUT STD_LOGIC
        );
    
    END COMPONENT;

    SIGNAL c_vector : STD_LOGIC_VECTOR(SIZE DOWNTO 0);
    
    BEGIN

        c_vector(0) <= cin;
        cout <= c_vector(SIZE);

        gen : FOR i IN 0 TO SIZE - 1 GENERATE

            full_add : full_adder 

                PORT MAP(
                    a    => a(i),
                    b    => b(i),
                    cin  => c_vector(i),
                    s    => s(i),
                    cout => c_vector(i+1)
                );

        END GENERATE;


      
END ARCHITECTURE;
