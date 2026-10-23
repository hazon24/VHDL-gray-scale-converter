----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2026 13:44:56
-- Design Name: 
-- Module Name: register_Nbit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_Nbit is
    Generic (
        DIM : integer := 7
    );
    Port (
        reset : in  STD_LOGIC;
        clk : in  STD_LOGIC;
        
        data_in  : in  STD_LOGIC_VECTOR(DIM downto 0);
        data_out : out STD_LOGIC_VECTOR(DIM downto 0)
    );  
end register_Nbit;

architecture Behavioral of register_Nbit is
    component ff_d is
        Port (
            reset : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            d : in  STD_LOGIC;
            q : out STD_LOGIC
        );
    end component; 
begin

    LOOP_GEN : for I in 0 to DIM generate
        ff_d_inst : ff_d
            port map (
                reset => reset,
                clk => clk,
                d => data_in(I),
                q => data_out(I)
            );
    end generate LOOP_GEN;

end Behavioral;
