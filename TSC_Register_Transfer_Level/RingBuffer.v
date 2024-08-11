module RingBuffer(
    input wire clk, // Clock input
    input wire rst, // Reset input
    input wire adc_req, // ADC request signal
    output reg adc_rdy, // ADC ready signal
    output reg [7:0] adc_dat // ADC data output
);

// Define ring buffer depth
parameter BUFFER_DEPTH = 32;

// Define ring buffer array
reg [7:0] buffer [0:BUFFER_DEPTH-1];

// Define read and write pointers
reg [4:0] read_ptr = 5'b0;
reg [4:0] write_ptr = 5'b0;

// Reset condition
always @ (posedge clk or posedge rst)
begin
    if (rst)
    begin
        adc_rdy <= 0;
        adc_dat <= 8'b0;
        read_ptr <= 5'b0;
        write_ptr <= 5'b0;
    end
    else
    begin
        // Check if ADC request is asserted
        if (adc_req)
        begin
            // Read data from buffer and increment read pointer
            adc_dat <= buffer[read_ptr];
            read_ptr <= read_ptr + 1;
            adc_rdy <= 1;
        end
        else
        begin
            adc_rdy <= 0;
        end
    end
end

// Write data to buffer
always @ (posedge clk)
begin
    if (adc_req && ~rst)
    begin
        buffer[write_ptr] <= adc_dat;
        write_ptr <= write_ptr + 1;
    end
end

endmodule
