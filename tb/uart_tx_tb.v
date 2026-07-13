module uart_baud_tb;
    reg clk;
    reg reset;
    reg start;
    reg [7:0] data;

    wire tx;
    wire busy;

    uart_baud uut(.clk(clk), .reset(reset), .start(start), .data(data), .tx(tx), .busy(busy));

    always #5 clk = ~clk;

    always @(posedge clk)
    begin
        $display("Time=%0t  state=%b  tx=%b  bit_index=%0d  baud_count=%0d", $time, uut.state, uut.tx, uut.bit_index, uut.baud_count);
    end

    initial
    begin
        $dumpfile("uart_baud.vcd");
        $dumpvars(0, uart_baud_tb);

        clk = 0;
        reset = 1;
        start = 0;
        data = 8'b0;

        //keeping reset active for 2 clk cycles (20 time units)
        #20;
        reset = 0;

        //wait for 10 more time units before asserting start and sending data//
        #10;
        data = 8'b10101010;
        start = 1;

        //deassert start after 10//
        #10; 
        start = 0;

        #500;
        $finish;
    

    
    end

endmodule