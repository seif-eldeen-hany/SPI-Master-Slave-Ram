`timescale 1ns/1ns
module spi_master_tb; 

    parameter toggle_count=5;
    parameter clk_period=20;//20ns

    reg clk; // 50Mhz T=20ns
    reg rst_n; //active low
    reg start; //signal comming from cpu or testbench that indicates to start the transmission and recieving
    reg [9:0] tx_data; ///transmitted data + 2 bit opcode
    reg MISO;

    wire [7:0] rx_data;//data sent to cpu or testbench
    wire CS_n; //chip select active low
    wire sclk_out;// 5Mhz
    wire tx_interrupt; //1 when transmiting is finished
    wire rx_interrupt; //1 when it is ready to read the rx_data
    wire MOSI; //master out slave in

    master #(.toggle_count(toggle_count)) dut(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tx_data(tx_data),
        .MISO(MISO),

        .rx_data(rx_data),
        .CS_n(CS_n),
        .sclk_out(sclk_out),
        .tx_interrupt(tx_interrupt),
        .rx_interrupt(rx_interrupt),
        .MOSI(MOSI)
    );

    always #(clk_period/2) clk=~clk;

task reset();
    begin
        rst_n=0;
        #(clk_period*2);
        rst_n=1;
    end
endtask

function [9:0] generate_tx_data(input [1:0] opcode,input [7:0] data);
    begin
        generate_tx_data= {opcode, data};
    end
endfunction

    reg [7:0] slave_output_reg;

    initial begin

        $monitor("Time: %0t |start: %b |CS_n: %b |sclk_out: %b |MOSI: %b |MISO: %b |tx_interrupt: %b |rx_data: %b", 
                 $time,      start,     CS_n,     sclk_out,     MOSI,     MISO,     tx_interrupt,     rx_data);

        start=0;
        clk=0;
        tx_data=0;
        MISO=0;
        slave_output_reg=8'b00110011;

        reset();
        #(clk_period*2);
        tx_data= generate_tx_data(2'b10,8'b10_10_10_10);

        //trigger the start signal
        @(posedge clk);
        start=1;
        @(posedge clk);
        start=0;

        wait(tx_interrupt==1);//wait until the transmission is finish
        #(clk_period*2);
        #500;
        $stop;
    end

    always(negedge CS_n)begin
        MOSI<=slave_output_reg[7];
    end


    always @(negedge sclk_out) begin
        if(CS_n)begin
            MISO<=1'b0;
        end
        else begin
            slave_output_reg<={slave_output_reg[6:0],1'b1};
            MISO<=slave_output_reg[6];
        end
    end
endmodule