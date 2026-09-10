module spi_slave (sclk , rst_n , SS_n , tx_valid , rx_valid , tx_data , rx_data , MOSI , MISO);

    input sclk , rst_n , SS_n , tx_valid , MOSI ;
    input [7:0] tx_data ;
    output reg MISO , rx_valid ;
    output reg [9:0] rx_data ;

    localparam IDLE = 2'b00 ;
    localparam CHK_CMD = 2'b01 ;
    localparam WRITE = 2'b10 ;
    localparam READ = 2'b11 ;

    reg [3:0] rx_count ;
    reg [3:0] tx_count ;

    reg [1:0] cs , ns ;

always @(posedge sclk , negedge rst_n) begin
    if (~rst_n) begin
        cs <= IDLE ;
    end
    else begin
        cs <= ns ;
    end
end    

always @(*) begin
    case (cs)
       IDLE : ns = SS_n? IDLE : CHK_CMD ;
       CHK_CMD : ns = SS_n? IDLE : (MOSI? READ : WRITE) ;
       WRITE : ns = SS_n? IDLE : WRITE ;
       READ : ns = SS_n? IDLE : READ ; 
        default: ns = IDLE ;
    endcase
end 

always @(posedge sclk , negedge rst_n) begin
    if (~rst_n) begin
        rx_data <= 0 ;
        rx_count <= 0 ;
        rx_valid <= 0 ; 
    end    

    else if (SS_n) begin
        rx_data <= 0 ;
        rx_count <= 0 ;
        rx_valid <= 0 ;
    end 

    else begin
        if (rx_count == 9) begin
            rx_data <= {rx_data[8:0] , MOSI} ;
            rx_count <= 0 ;
            rx_valid <= 1 ; 
        end

        else begin
        rx_valid <= 0;
        rx_data <= {rx_data[8:0] , MOSI} ;    
        rx_count <= rx_count + 1 ;
        end
    end       
end

always @(*) begin
    if (~SS_n && tx_valid) begin 
        MISO = tx_data [7-tx_count] ; 
    end
    else begin
        MISO = 0 ;
    end
end

always @(negedge sclk , negedge rst_n) begin
    if (~rst_n) begin
        tx_count <= 0 ;
    end

    else if (SS_n) begin
        tx_count <= 0 ;
    end
    
<<<<<<< HEAD
    else if (rx_count > 2) begin
        tx_count <= tx_count + 1 ;
=======
    else if (~tx_valid) begin
    tx_count <= 0;
    end
    else if (tx_count < 7) begin 
    tx_count <= tx_count + 1 ; 
>>>>>>> 57e09f61fb6b879ff58df0dd89492b00391d905d
    end

    else begin
        tx_count <= 0 ;
    end
    end
endmodule