module wrapper_slave_ram_tb;
    parameter DATA_WIDTH = 8;
    parameter MEM_DEPTH = 256;
    parameter ADDR_WIDTH = 8;

    reg sclk;
    reg rst_n;
    reg SS_n;
    reg MOSI;

    wire MISO;

    always #5 sclk=~sclk;
initial begin
    sclk=0;
    rst_n=0;
    SS_n=1;
    @(negedge sclk);

    rst_n=1;
    SS_n=0;

    //changing on the opcode bits
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    //data sent
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);

    SS_n=1;
    repeat(5) @(negedge sclk);
    SS_n=0;

    //changing on the opcode bits
    MOSI=0;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    //data sent
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);


    SS_n=1;
    repeat(5) @(negedge sclk);
    SS_n=0;

    //changing on the opcode bits
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    //data sent
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);



    SS_n=1;
    repeat(5) @(negedge sclk);
    SS_n=0;

    //changing on the opcode bits
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    //data sent
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=1;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);
    MOSI=0;
    @(negedge sclk);

    SS_n=1;
    repeat(5) @(negedge sclk);
    $stop;
end
endmodule