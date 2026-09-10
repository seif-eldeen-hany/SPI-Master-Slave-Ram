module wrapper_slave_ram (sclk , rst_n , SS_n , MISO , MOSI);

    parameter DATA_WIDTH = 8 ;
    parameter MEM_DEPTH = 256 ;
    parameter ADDR_WIDTH = 8 ;

    input sclk , rst_n , SS_n , MOSI ;
    output MISO ;

    wire [9:0] rx_data ;
    wire [7:0] tx_data ;
    wire rx_valid ; 
    wire tx_valid ;

    spi_slave spi_slave1 (
        .sclk(sclk) , .rst_n(rst_n) , .SS_n(SS_n) , .MOSI(MOSI) , .MISO (MISO) , .rx_data(rx_data) , .tx_data(tx_data) , .rx_valid(rx_valid) , .tx_valid(tx_valid)
    );
    
    spi_ram spi_ram1 (
        .sclk(sclk) , .rst_n(rst_n) , .rx_data(rx_data) , .tx_data(tx_data) , .rx_valid(rx_valid) , .tx_valid(tx_valid)
    );

endmodule