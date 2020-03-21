LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;

ENTITY mux_1_bit IS
    GENERIC(
        N: INTEGER := 32);
    PORT( sel:      in   STD_LOGIC;
          e1:       in   STD_LOGIC_VECTOR(N - 1 downto 0);
          e2:       in   STD_LOGIC_VECTOR(N - 1 downto 0);
          s:        out  STD_LOGIC_VECTOR(N - 1 downto 0));
END;

ARCHITECTURE behave OF mux_1_bit IS

BEGIN
    s <= e1 WHEN sel = '0' ELSE
         e2 WHEN sel = '1';
END;
    