LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decoder IS

    PORT( 
        
        op        :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
        funct     :  IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
        rd        :  IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        flagw      :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        pcs, regw, memw :  OUT STD_LOGIC;
        memtoreg  :  OUT STD_LOGIC;
        alusrc    :  OUT STD_LOGIC;
        immsrc    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        regsrc    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        alucontrol:  OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

    );

END;

ARCHITECTURE arch OF decoder IS
    COMPONENT alu_decoder IS
        PORT( 
        
        funct         :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
        aluop         :  IN  STD_LOGIC;
        alucontrol    :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        flagw         :  OUT STD_LOGIC_VECTOR(1 DOWNTO 0)

    );
    END COMPONENT;
    
    COMPONENT main_decoder IS
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
    END COMPONENT;
    
    COMPONENT pc_logic IS

    PORT( 
        
        rd          :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        regw        :  IN  STD_LOGIC;
        branch      :  IN STD_LOGIC;
        pcs         :  OUT STD_LOGIC

    );

    END COMPONENT;
    
    
    -- Internal signals
    SIGNAL branch: STD_LOGIC;
    SIGNAL regw_int: STD_LOGIC;
    SIGNAL aluop: STD_LOGIC;
    SIGNAL funct50: STD_LOGIC_VECTOR(1 DOWNTO 0) := (funct(4) & funct(0));
    
    BEGIN
        main_decoder1: main_decoder 
        PORT MAP
        (op => op,
         funct => funct50,
         branch => branch,
         regw => regw_int,
         memw => memw,
         memtoreg => memtoreg,
         alusrc => alusrc,
         immsrc => immsrc,
         regsrc => regsrc      
        );
        
        alu_decoder1: alu_decoder
        PORT MAP
        (funct => funct( 4 DOWNTO 0),
         aluop => aluop,
         alucontrol => alucontrol,
         flagw => flagw);
         
         
        pc_logic1: pc_logic
        PORT MAP
        (rd => rd,
         regw => regw_int,
         branch => branch,
         pcs => pcs);
        
        regw <= regw_int;
END ARCHITECTURE;
    