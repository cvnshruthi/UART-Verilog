module uart_rx_tb;
    reg clk;
    reg reset;
    reg rx;

    wire [7:0] data_out;
    wire data_valid;

    uart_rx uut(.clk(clk), .reset(reset), .rx(rx), .data_out(data_out), .data_valid(data_valid));

    always #5 clk = ~clk;

    always @(posedge clk)
    begin
        $display("Time=%0t state=%b rx=%b bit_index=%0d baud_count=%0d data_valid=%b data_out=%b", $time, uut.state, rx, uut.bit_index, uut.baud_count, uut.data_valid, uut.data_out);
    end

    initial
    begin
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, uart_rx_tb);

        clk = 0;
        reset = 1;
        rx = 1;      // UART line is idle high
        #20;

        reset = 0;
        #20;

        //start bit//
        rx = 0;
        #40;

        //data bits//
        rx = 0; #40;
        rx = 1; #40;
        rx = 0; #40;
        rx = 1; #40;
        rx = 0; #40;
        rx = 1; #40;
        rx = 0; #40;
        rx = 1; #40;

        //stop bit//
        rx=1;
        #40;

        // giving receiver time to process//
        #10;
        $finish;
    end

endmodule