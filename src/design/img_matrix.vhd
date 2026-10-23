library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity img_matrix is
    Generic (
        IMG_DIM_POW2 : integer := 2; 
        DIM : integer := 7  
    );
    Port (
        clk : in  std_logic;
        reset : in  std_logic;
        
        in_red : in  std_logic_vector(7 DOWNTO 0);
        in_green : in  std_logic_vector(7 DOWNTO 0);
        in_blue : in  std_logic_vector(7 DOWNTO 0);
        
        in_x_addr : in  std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0);
        in_y_addr : in  std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0);
        
        out_gray : out std_logic_vector(7 DOWNTO 0);
        
        out_x_addr : in  std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0);
        out_y_addr : in  std_logic_vector(IMG_DIM_POW2-1 DOWNTO 0)
    );    
end img_matrix;

architecture Behavioral of img_matrix is

    component register_Nbit is
        Port (
            reset : in  STD_LOGIC;
            clk : in  STD_LOGIC;
            data_in : in  STD_LOGIC_VECTOR(7 downto 0);
            data_out : out STD_LOGIC_VECTOR(7 downto 0)
        ); 
    end component;
    
    constant NUM_WORDS : integer := 2**(2*IMG_DIM_POW2);
    
    signal RGB_media : std_logic_vector(7 DOWNTO 0);
    signal temp1 : std_logic_vector(7 DOWNTO 0);
    signal temp2 : std_logic_vector(7 DOWNTO 0);
    
    type img_array is array (0 to NUM_WORDS - 1) of std_logic_vector(7 downto 0);
    signal reg_in : img_array;
    signal reg_out : img_array;
    
    signal wr_index : integer range 0 to NUM_WORDS - 1;
    signal rd_index : integer range 0 to NUM_WORDS - 1;

begin

   
    temp1 <= std_logic_vector(unsigned(in_red) + unsigned(in_green));
    temp2 <= std_logic_vector(unsigned(temp1) + unsigned(in_blue));
    RGB_media <= std_logic_vector(unsigned(temp2) / 3);

  
    wr_index <= to_integer(unsigned(in_x_addr) & unsigned(in_y_addr));
    rd_index <= to_integer(unsigned(out_x_addr) & unsigned(out_y_addr));

 
    MEMORIA : for I in 0 to NUM_WORDS - 1 generate
        
        register_inst : register_Nbit 
            port map (
                reset => reset,
                clk => clk,
                data_in => reg_in(I),
                data_out => reg_out(I)
            );
            
    reg_in(I) <= RGB_media when (wr_index = I) else reg_out(I);

    end generate MEMORIA;
    
    out_gray <= reg_out(rd_index);

end Behavioral;