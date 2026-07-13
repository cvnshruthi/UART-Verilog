//------------------------------------------------------------------------------
// UART Transmitter 
//
// Description:
// Transmits one start bit, 8 data bits (LSB first), and one stop bit.
// Baud rate is controlled using BAUD_DIV.
//
//UART Frame: 1 Start | 8 Data (LSB First) | 1 Stop
//
// Author: Shruthi
//------------------------------------------------------------------------------

module uart_baud(
    input clk,
    input reset,
    input start,
    input [7:0] data,

    output reg tx,
    output reg busy   
);


reg [7:0] data_reg;
reg [2:0] bit_index;
reg [1:0] state;
reg [1:0] baud_count;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

parameter BAUD_DIV = 4;


always @(posedge clk or posedge reset) 
begin
    if (reset)
    begin
        state <= IDLE;
        tx <= 1'b1;
        busy <= 1'b0;
        baud_count <= 2'b00;
        data_reg <= 8'b0;
        bit_index <= 3'b0;
    end
    else
    begin
        case(state)

        //wait for transmission request
        IDLE:
        begin
            tx <= 1'b1;
            busy <= 1'b0;

            if(start)
            begin
                $display("START detected at time %0t", $time);
                
                data_reg <= data;
                bit_index <= 3'b000;
                busy <= 1'b1;
                baud_count <= 2'b0;
                tx <= 1'b0;
                state <= START;
            end
        end 
        
        //transmit start bit
        START:
        begin
            tx <= 1'b0;
            if(baud_count == BAUD_DIV - 1)
            begin
                baud_count <= 1'b0;
                state <= DATA;
            end
            else
            begin
                baud_count <= baud_count + 1;
            end
        end
        
        //transmit data bits
        DATA:
        begin
            tx <= data_reg[bit_index];
            if (baud_count == BAUD_DIV - 1)
            begin
                baud_count <= 1'b0;
                if(bit_index == 3'b111)
                begin
                    state <= STOP;
                end
                else
                begin
                    bit_index <= bit_index + 1;
                end
            end

            else
            begin
                baud_count <= baud_count + 1;
            end
        end
        
        //transmit stop bit
        STOP:
        begin
            tx <= 1'b1;
            busy <= 1'b1;
            if(baud_count == BAUD_DIV - 1)
            begin
                baud_count <= 1'b0;
                state <= IDLE;
            end
            else
            begin
                baud_count <= baud_count + 1;
            end
        end
        endcase
    end
end



endmodule