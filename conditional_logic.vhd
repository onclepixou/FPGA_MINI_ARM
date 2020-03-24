LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY conditional_logic IS 

    PORT(

        clk        : IN  STD_LOGIC;
        cond       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        aluflags   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        flagw      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        pcs        : IN  STD_LOGIC;
        regw       : IN  STD_LOGIC;
        memw       : IN  STD_LOGIC;
        pcsrc      : OUT STD_LOGIC;
        regwrite   : OUT STD_LOGIC;
        memwrite   : OUT STD_LOGIC
    );

END ENTITY;


ARCHITECTURE arch OF conditional_logic IS 


    COMPONENT dff IS 

        GENERIC(
            N : INTEGER := 8
        );

        PORT(
            clk : IN  STD_LOGIC;
            en  : IN  STD_LOGIC;
            d   : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0 );
            q   : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0 )

        );

    END COMPONENT;

    COMPONENT condition_checker IS 

        PORT(
            cond   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            flags  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            condex : OUT STD_LOGIC
        );

    END COMPONENT;

    SIGNAL condex : STD_LOGIC;
    SIGNAL enable_vector : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL condition_input_flag : STD_LOGIC_VECTOR(3 DOWNTO 0);


    BEGIN 

        pcsrc    <= pcs AND condex;
        regwrite <= regw AND condex;
        memwrite <= memw AND condex;

        enable_vector <= flagw AND (condex, condex);


        zer_neg : dff

            GENERIC MAP( N => 2)
            PORT MAP(
                clk => clk,
                en  => enable_vector(1),
                d   => aluflags(3 DOWNTO 2),
                q   => condition_input_flag(3 DOWNTO 2)
            );

        car_over : dff

            GENERIC MAP( N => 2)
            PORT MAP(

                clk => clk,
                en  => enable_vector(0),
                d   => aluflags(1 DOWNTO 0),
                q   => condition_input_flag(1 DOWNTO 0)
            );


        checker : condition_checker 

            PORT MAP(

                cond   => cond,
                flags  => condition_input_flag,
                condex => condex
            );

END ARCHITECTURE;