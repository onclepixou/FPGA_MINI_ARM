LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY datapath  IS

    GENERIC(

        DATABUS_SIZE : INTEGER := 32
    );

    PORT(

        clk        : IN   STD_LOGIC;
        pcsrc      : IN   STD_LOGIC;
        memtoreg   : IN   STD_LOGIC;
        memwrite   : IN   STD_LOGIC;
        alucontrol : IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
        alusrc     : IN   STD_LOGIC;
        immsrc     : IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
        regwrite   : IN   STD_LOGIC;
        regsrc     : IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
        cond       : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
        op         : OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
        funct      : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
        rd         : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
        aluflags   : OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
    );

END ENTITY;



ARCHITECTURE arch OF datapath IS 

    -- PC HANDLER COMPONENT
    COMPONENT pc_handler IS 
        GENERIC(
            C_WIDTH : INTEGER := 32
        );
        PORT(

            clk : IN  STD_LOGIC;
            pcp : IN  STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0);
            pc  : OUT STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- INSTRUCTION MEMORY COMPONENT
    COMPONENT instr_mem IS
        GENERIC(
            C_LEN : INTEGER := 23
        );
        PORT(
            addr : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    
    -- ADDER COMPONENT
    COMPONENT adder IS 
        GENERIC(
            C_WIDTH : INTEGER := 32
        );
        PORT(
            a  : IN  STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0);
            b  : IN  STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0);
            y  : OUT STD_LOGIC_VECTOR(C_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- MUX 1 BIT COMPONENT
    COMPONENT mux_1_bit IS
        GENERIC(
            N: INTEGER := 32
        );
        PORT(
            sel:      IN   STD_LOGIC;
            e0:       IN   STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            e1:       IN   STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            s:        OUT  STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- REGISTER FILE COMPONENT
    COMPONENT reg_file IS
        PORT( 
            clk  :  IN  STD_LOGIC;
            we3  :  IN  STD_LOGIC;
            a1  :  IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
            a2  :  IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
            a3  :  IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
            wd3  :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            r15  :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd1  :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            rd2  :  OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    -- EXTENDER COMPONENT
    COMPONENT extender IS 
        PORT(
            instr  : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
            immsrc : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
            extimm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    -- ALU COMPONENT
    COMPONENT alu is
        GENERIC( 
            N : INTEGER := 8
        );
        PORT ( 
             a          : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
             b          : IN  STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
             alucontrol : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
             result     : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
             aluflags   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    -- DATA MEMORY COMPONENT
    COMPONENT data_memory IS
        GENERIC(
              N: INTEGER := 32
        );
        PORT( 
              clk         : IN    STD_LOGIC;
              we          : IN    STD_LOGIC;
              rst         : IN    STD_LOGIC;
              a           : IN    STD_LOGIC_VECTOR(N - 1 downto 0);
              wd          : IN    STD_LOGIC_VECTOR(N - 1 downto 0);
              rd          : OUT   STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    END COMPONENT;


    SIGNAL pcp        : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL pc         : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL instr      : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL constant4  : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0) := X"00000004";
    SIGNAL constant15 : STD_LOGIC_VECTOR(3 DOWNTO 0)                := "1111";
    SIGNAL pcplus4    : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL pcplus8    : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL ra1        : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL ra2        : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL result     : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL srca       : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL srcb       : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL rd2        : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL extimm     : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL aluresult  : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL readdata   : STD_LOGIC_VECTOR(DATABUS_SIZE - 1 DOWNTO 0);
    SIGNAL reset      : STD_LOGIC := '0';

    BEGIN 

        mux_pc : mux_1_bit
            GENERIC MAP( N => 32 )
            PORT MAP(
                sel => pcsrc,
                e0  => pcplus4,        
                e1  => result,     
                s   => pcp  
            );

        pc_component : pc_handler
            GENERIC MAP(C_WIDTH => DATABUS_SIZE)
            PORT MAP(

                clk => clk,
                pcp => pcp,
                pc => pc
            );

        instr_memory : instr_mem
            GENERIC MAP(C_LEN => 23)
            PORT MAP(
                addr => pc,
                rd   => instr
            );

        adder1 : adder
            GENERIC MAP(C_WIDTH => DATABUS_SIZE)
            PORT MAP(
                a => pc,
                b => constant4,
                y => pcplus4
            );

        adder2 : adder
            GENERIC MAP(C_WIDTH => DATABUS_SIZE)
            PORT MAP(
                a => constant4,
                b => pcplus4,
                y => pcplus8
            );


        mux_ra1 : mux_1_bit
            GENERIC MAP( N => 4 )
            PORT MAP(
                sel => regsrc(0),
                e0  => instr(19 DOWNTO 16),        
                e1  => constant15,     
                s   => ra1  
            );

        mux_ra2 : mux_1_bit
            GENERIC MAP ( N => 4 )
            PORT MAP(
                sel => regsrc(1),
                e0  => instr( 3 DOWNTO  0),        
                e1  => instr(15 DOWNTO 12),     
                s   => ra2  
            );

        register_file_component : reg_file
            PORT MAP( 
                clk => clk,
                we3 => regwrite,
                a1  => ra1,
                a2  => ra2,
                a3  => instr(15 DOWNTO 12),
                wd3 => result,
                r15 => pcplus8,
                rd1 => srca,
                rd2 => rd2
            );

        immediate_component : extender
            PORT MAP (
                instr  => instr(23 DOWNTO 0),
                immsrc => immsrc,
                extimm => extimm
            );

        mux_srcb : mux_1_bit
            GENERIC MAP( N => 32 )
            PORT MAP(
                sel => alusrc,
                e0  => rd2,       
                e1  => extimm,     
                s   => srcb 
            );

        alu_component : alu 
            GENERIC MAP(N => DATABUS_SIZE)
            PORT MAP(
                a          => srca, 
                b          => srcb,  
                alucontrol => alucontrol,
                result     => aluresult,
                aluflags   => aluflags                 
            );

        data_memory_component : data_memory
            GENERIC MAP(N => DATABUS_SIZE)
            PORT MAP(
                    clk => clk,
                    we  => memwrite,
                    rst => reset,
                    a   => aluresult,
                    wd  => rd2,
                    rd  => readdata
            );

        mux_result : mux_1_bit
            GENERIC MAP( N => 32 )
            PORT MAP(
                sel => memtoreg,
                e0  => aluresult,       
                e1  => readdata,     
                s   => result
            );

END ARCHITECTURE;