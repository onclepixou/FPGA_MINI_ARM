LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY control_unit IS 

    PORT(

        clk        : IN  STD_LOGIC;
        cond       : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        aluflags   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        op         : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        funct      : IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        rd         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        pcsrc      : OUT STD_LOGIC;
        regwrite   : OUT STD_LOGIC;
        memwrite   : OUT STD_LOGIC;
        memtoreg   : OUT STD_LOGIC;
        alusrc     : OUT STD_LOGIC;
        immsrc     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        regsrc     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        alucontrol : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

    );

END ENTITY;


ARCHITECTURE arch OF control_unit IS 

    SIGNAL flagw : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL pcs   : STD_LOGIC;
    SIGNAL regw  : STD_LOGIC;
    SIGNAL memw  : STD_LOGIC;

    COMPONENT decoder IS

        PORT( 
            op        :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            funct     :  IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
            rd        :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            flagw     :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            pcs       :  OUT STD_LOGIC;
            regw      :  OUT STD_LOGIC;
            memw      :  OUT STD_LOGIC;
            memtoreg  :  OUT STD_LOGIC;
            alusrc    :  OUT STD_LOGIC;
            immsrc    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            regsrc    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            alucontrol:  OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );

    END COMPONENT;

    COMPONENT conditional_logic IS 

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

    END COMPONENT;

    BEGIN 


        decoder_part : decoder

            PORT MAP(
                      op         => op,
                      funct      => funct,
                      rd         => rd,
                      flagw      => flagw,
                      pcs        => pcs,
                      regw       => regw,
                      memw       => memw,
                      memtoreg   => memtoreg,
                      alusrc     => alusrc,
                      immsrc     => immsrc,
                      regsrc     => regsrc,
                      alucontrol => alucontrol
            );


        conditional_logic_part : conditional_logic

            PORT MAP(
                      clk        => clk,
                      cond       => cond,
                      aluflags   => aluflags,
                      flagw      => flagw,
                      pcs        => pcs,
                      regw       => regw,
                      memw       => memw,
                      pcsrc      => pcsrc,
                      regwrite   => regwrite,
                      memwrite   => memwrite
            );            

END ARCHITECTURE;