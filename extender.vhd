LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY extender IS 

    PORT(
        instr  : IN  STD_LOGIC_VECTOR(23 DOWNTO 0);
        immsrc : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
        extimm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ENTITY;


ARCHITECTURE arch OF extender IS 

    BEGIN 

        update : PROCESS(instr, immsrc)

            BEGIN 

                CASE immsrc IS
                
                    WHEN "00"   => extimm <= ( X"000000" & instr( 7 DOWNTO 0) );
                    WHEN "01"   => extimm <= ( X"00000"  & instr(11 DOWNTO 0) );
                    -- handle branch : sign extension and x4
                    WHEN "10"   => extimm <= ( instr(23) & instr(23) &   
                                               instr(23) & instr(23) &
                                               instr(23) & instr(23) &
                                               instr     &      "00" );
                    WHEN OTHERS => extimm <= (OTHERS => '-');

                END CASE;



            END PROCESS;


END ARCHITECTURE;