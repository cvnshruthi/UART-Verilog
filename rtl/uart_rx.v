//------------------------------------------------------------------------------
// UART Receiver
//
// Description:
// Receives one start bit, 8 data bits (LSB first), and one stop bit.
// Validates the start and stop bits, converts serial data to parallel,
// and asserts data_valid for one clock cycle when a valid byte is received.
// Baud rate is controlled using BAUD_DIV.
//
// UART Frame: 1 Start | 8 Data (LSB First) | 1 Stop
//
// Author: Shruthi
//------------------------------------------------------------------------------

module uart_rx(
    input clk,
    input reset,
    input rx,

    output reg [7:0] data_out,
    output reg data_valid

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
    if(reset)
    begin
        state <= IDLE;
        baud_count <= 2'b00;
        data_reg <= 8'b0;
        bit_index <= 3'b0;
        data_out <= 8'b0;
        data_valid <= 1'b0;
    end
    else
    begin
        case(state)

        // Wait for falling edge on rx
        IDLE:
        begin
            data_valid <= 1'b0;
            bit_index  <= 1'b0;
            baud_count <= 1'b0;

            if(rx == 1'b0)
            begin
                state <= START;
            end
        end
        
        // Verify start bit after half baud
        START:
        begin
            if (baud_count == BAUD_DIV/2 -1)
            begin
                baud_count <= 1'b0;

                if (rx == 1'b0)
                begin
                    state <= DATA;
                end
                else
                begin
                    state <= IDLE;
                end
            end

            else
            begin
                baud_count <= baud_count + 1;
            end
        end
        
        // Sample incoming bits
        DATA:
        begin
            if (baud_count == BAUD_DIV -1)
            begin
                data_reg[bit_index] <= rx;
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
        
        // Verify stop bit and update output
        STOP:
        begin
        if(baud_count == BAUD_DIV - 1)
        begin
            baud_count <= 1'b0;
            if(rx == 1'b1)
            begin
                data_out <= data_reg;
                data_valid <= 1'b1;
                state <= IDLE;
            end
            else
            begin
                state <= IDLE;
            end
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