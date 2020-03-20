LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY alu is

    GENERIC( 

        N : INTEGER := 8

    );

    PORT ( a          : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
           b          : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
           alucontrol : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
           result     : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
           cout       : OUT STD_LOGIC
    );

END ENTITY;


ARCHITECTURE arch OF alu IS 

    SIGNAL sum        : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

    SIGNAL bin_adder : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

    COMPONENT N_bits_full_adder is

        GENERIC( 
    
            SIZE : INTEGER := 8
    
        );
    
        PORT ( a    : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
               b    : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
               cin  : IN STD_LOGIC;
               s    : OUT STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
               cout : OUT STD_LOGIC
        );
    
    END COMPONENT;

    BEGIN 

        bin_adder <= b WHEN alucontrol(0) = '0' ELSE  NOT(b);

        result <= sum       WHEN alucontrol = "00" ELSE
                  sum       WHEN alucontrol = "01" ELSE
                  (a AND b) WHEN alucontrol = "10" ELSE
                  (a OR  b) WHEN alucontrol = "11";
                 

        uut : N_bits_full_adder 

            GENERIC MAP ( SIZE => N)
            PORT MAP(
                a    => a, 
                b    => bin_adder, 
                cin  => alucontrol(0), 
                s    => sum,
                cout => cout 
            );

END ARCHITECTURE;