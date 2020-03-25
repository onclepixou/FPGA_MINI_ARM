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
           aluflags   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );

END ENTITY;


ARCHITECTURE arch OF alu IS 

    SIGNAL sum           : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL bmod          : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL result_tmp    : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL cout      : STD_LOGIC;
    SIGNAL temp          : STD_LOGIC;

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

    CONSTANT ZERO_VECTOR : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');

    BEGIN 

        bmod <= b WHEN alucontrol(0) = '0' ELSE  NOT(b);

        result_tmp <= sum       WHEN alucontrol = "00" ELSE
                      sum       WHEN alucontrol = "01" ELSE
                      (a AND b) WHEN alucontrol = "10" ELSE
                      (a OR  b) WHEN alucontrol = "11";

        result <= result_tmp;
    
        -- negative
        aluflags(3) <= result_tmp(N - 1);
        -- zero
        aluflags(2) <= '1' WHEN result_tmp = ZERO_VECTOR ELSE '0';
        -- carry
        aluflags(1) <= (NOT(alucontrol(1))) AND cout ;
        -- overflow
        aluflags(0) <= (NOT(alucontrol(1))) AND (a(N - 1) XOR sum(N - 1)) AND (alucontrol(0) XNOR a(N - 1) XNOR b(N - 1));


        uut : N_bits_full_adder 

            GENERIC MAP ( SIZE => N)
            PORT MAP(
                a    => a, 
                b    => bmod, 
                cin  => alucontrol(0), 
                s    => sum,
                cout => cout 
            );

END ARCHITECTURE;