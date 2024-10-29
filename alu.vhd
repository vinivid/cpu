library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        a : in STD_LOGIC_VECTOR (7 downto 0);
        b : in STD_LOGIC_VECTOR (7 downto 0);
        op : in STD_LOGIC_VECTOR (2 downto 0);
        r : out STD_LOGIC_VECTOR (7 downto 0);
        flags : out STD_LOGIC_VECTOR (3 downto 0)
    );
end entity alu;

architecture Behaviour of alu is
    signal operation : STD_LOGIC_VECTOR (8 downto 0);
begin
    process (all)
    begin
        case op is
            when "000" =>
                operation <= STD_LOGIC_VECTOR(signed(a) + signed(b));
                r <= operation(7 downto 0);
                --Checa se o numero é igual a 0;
                if (r = "00000000") then
                    flags(0) <= '1';
                else
                    flags(0) <= '0';
                end if;
        
                flags(1) <= r(7);
                flags(2) <= operation(8);

                if (a(7) = b(7)) then
                    flags(3) <= a(7) xor r(7);
                else 
                    flags(3) <= '0';
                end if; 
            when "001" =>
                operation <= STD_LOGIC_VECTOR(signed(a) - signed(b));
                r <= operation(7 downto 0);

                if (r = "00000000") then
                    flags(0) <= '1';
                else
                    flags(0) <= '0';
                end if;

                flags(1) <= r(7);
                flags(2) <= '0';
                
                if (a(7) = b(7)) then
                    flags(3) <= a(7) xor r(7);
                else 
                    flags(3) <= '0';
                end if; 
            when "010" =>
                r <= a and b;

                if (r = "00000000") then
                    flags(0) <= '1';
                else
                    flags(0) <= '0';
                end if;

                flags(1) <= r(7);
                flags(2) <= '0';
                flags(3) <= '0';
            when "011" =>
                r <= a or b;

                if (r = "00000000") then
                    flags(0) <= '1';
                else
                    flags(0) <= '0';
                end if;
                
                flags(1) <= r(7);
                flags(2) <= '0';
                flags(3) <= '0';
            when "100" => 
                r <= not a;

                if (r = "00000000") then
                    flags(0) <= '1';
                else
                    flags(0) <= '0';
                end if;
                
                flags(1) <= r(7);
                flags(2) <= '0';
                flags(3) <= '0';
            when others =>     
                r <= "00000000";                
                flags(1) <= '0';
                flags(2) <= '0';
                flags(3) <= '0';
        end case;
    end process;    

end architecture Behaviour;