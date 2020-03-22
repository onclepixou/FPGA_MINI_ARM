LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY instr_mem IS

    GENERIC(

        C_LEN : INTEGER := 23

    );
    
    PORT(

        addr : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        rd   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        
    );

END;

ARCHITECTURE arch OF instr_mem IS

        TYPE ramtype IS ARRAY (0  TO C_LEN - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
        
        SIGNAL mem : ramtype := (X"E04F000F",
                                 X"E2802005", 
                                 X"E280300C", 
                                 X"E2437009", 
                                 X"E1874002", 
                                 X"E0035004", 
                                 X"E0855004", 
                                 X"E0558007",
                                 X"0A00000C", 
                                 X"E0538004", 
                                 X"AA000000", 
                                 X"E2805000", 
                                 X"E0578002",
                                 X"B2857001", 
                                 X"E0477002", 
                                 X"E5837054", 
                                 X"E5902060", 
                                 X"E08FF000", 
                                 X"E280200E", 
                                 X"EA000001", 
                                 X"E280200D", 
                                 X"E280200A", 
                                 X"E5802064");

        BEGIN 

            rd <= mem(TO_INTEGER(UNSIGNED(addr(7 DOWNTO 2))));   

END ARCHITECTURE;