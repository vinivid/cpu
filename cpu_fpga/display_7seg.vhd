library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_7seg is
    port (
        input_disp : in STD_LOGIC_VECTOR (3 downto 0);
        out_disp : out STD_LOGIC_VECTOR (6 downto 0)
    );
end entity display_7seg;

architecture Behaviour of display_7seg is

begin
    process (input_disp)
    begin
        case input_disp is
            when "0000" => out_disp <= "0000001";     
            when "0001" => out_disp <= "1001111";  
            when "0010" => out_disp <= "0010010";  
            when "0011" => out_disp <= "0000110";  
            when "0100" => out_disp <= "1001100";  
            when "0101" => out_disp <= "0100100"; 
            when "0110" => out_disp <= "0100000"; 
            when "0111" => out_disp <= "0001111";  
            when "1000" => out_disp <= "0000000";      
            when "1001" => out_disp <= "0000100"; 
            when "1010" => out_disp <= "0000010"; 
            when "1011" => out_disp <= "1100000"; 
            when "1100" => out_disp <= "0110001"; 
            when "1101" => out_disp <= "1000010"; 
            when "1110" => out_disp <= "0110000"; 
            when "1111" => out_disp <= "0111000";
            when others => out_disp <= "0000000";
            end case;
    end process;
end architecture;