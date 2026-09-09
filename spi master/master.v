module master#( 
    parameter toggle_count = 5 // input/(2*output) for clk divider
)(
    input clk, // 50Mhz T=20ns
    input rst_n, //active low
    input start, //signal comming from cpu or testbench that indicates to start the transmission and recieving
    input [9:0] tx_data, ///transmitted 8 bit data + 2 bit opcode
    input MISO, //master in slave out

    output reg [7:0] rx_data,//data sent to cpu or testbench
    output reg CS_n, //chip select active low
    output reg sclk_out,// 5Mhz
    output reg tx_interrupt, //1 when transmiting is finished
    output reg rx_interrupt, //1 when it is ready to read the rx_data
    output reg MOSI //master out slave in
);
    //state assignment
    localparam idle= 2'b00; //no start yet
    localparam load= 2'b01; //start is 1 ,now load data from the tx_data
    localparam transfer= 2'b10; // shifting and counting
    localparam finish= 2'b11; // finsihed the whole process and all data are ready

    reg [1:0] cs,ns;



    //CLK divider resulting sclk_out
    reg [$clog2(toggle_count)-1:0] divider_counter; // toggle_count =input/(2*output)
    wire clk_divider_enable = (~CS_n) & (cs == transfer);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            divider_counter<=0;
            sclk_out<=1'b0;
        end
        else if (clk_divider_enable) begin
            if (divider_counter== toggle_count - 1) begin
                divider_counter<= 0;
                sclk_out<= ~sclk_out;
            end
            else begin
                divider_counter<=divider_counter + 1;
            end
        end
        else begin
            divider_counter<=0;
            sclk_out<=1'b0; 
        end
    end

    //state register
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            cs<=idle;
        end
        else begin
            cs<=ns;
        end
    end

    //wire and regs needed for ns logic
    reg [3:0] bits_transfered;
    wire finish_transfer =(bits_transfered == 4'b1010); // works as a flag

    //next state logic
    always @(*) begin
        case (cs)
            idle: ns= start? load:idle;
            load: ns= transfer;
            transfer: ns= finish_transfer ? finish : transfer;
            finish: ns= idle;
            default: ns= idle;
        endcase
    end

    //edge detection for sclk_out
    reg sclk_last;
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            sclk_last<=1'b0;
        end
        else begin
            sclk_last<=sclk_out;
        end
    end

    wire sclk_is_rising;
    wire sclk_is_falling;

    assign sclk_is_rising= (clk_divider_enable && (divider_counter== toggle_count- 1) && ~sclk_out);
    assign sclk_is_falling= (clk_divider_enable && (divider_counter== toggle_count- 1) && sclk_out);

    // regs needed for output logic
    reg [9:0] tx_shift_reg;
    reg [7:0] rx_shift_reg;


    //output logic
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n)begin
            CS_n<=1'b1;
            tx_interrupt<=1'b0;
            rx_interrupt<=1'b0;
            MOSI<=1'b0;
            rx_data<=8'b0;
            bits_transfered<=4'b0000;
            rx_shift_reg<=8'b0;
            tx_shift_reg<=10'b0;
        end
        else begin
            //tx_interrupt<=1'b0;
            //rx_interrupt<=1'b0;

            if (cs==idle)begin
                CS_n<=1'b1;
            end
            else if (cs==load)begin
                CS_n<=1'b0;
                bits_transfered<=4'b0000;
                rx_shift_reg<=8'b0;
                tx_shift_reg<=tx_data;
                MOSI<=tx_data[9];
            end
            else if(cs==transfer)begin
                CS_n<=1'b0;

                //recieving data and incrementing the counter
                if(sclk_is_rising)begin
                    rx_shift_reg<={rx_shift_reg[6:0],MISO}; 
                    bits_transfered<=bits_transfered+1;
                end


                //transmitting data and shifting
                if(sclk_is_falling)begin
                    tx_shift_reg<={tx_shift_reg[8:0],1'b0};
                    MOSI<=tx_shift_reg[8];
                end
            
            end
            else if(cs==finish)begin
                CS_n<=1'b1;
                rx_data<=rx_shift_reg;
                tx_interrupt<=1'b1;
                rx_interrupt<=1'b1;
            end
        end
    end
endmodule