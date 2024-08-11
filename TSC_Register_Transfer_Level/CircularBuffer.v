module CircularBuffer (
    input wire clk,          // Clock input
    input wire rst,          // Reset input
    input wire adc_req,      // ADC request signal
    input wire [7:0] adc_dat, // ADC data input
    output reg adc_rdy,      // ADC ready signal
    output reg [7:0] adc_out // ADC data output
);

// Define buffer depth
parameter BUFFER_DEPTH = 32;

// Define buffer array
reg [7:0] buffer [0:BUFFER_DEPTH-1];

// Define read and write pointers
reg [4:0] head_ptr = 5'b0;
reg [4:0] tail_ptr = 5'b0;

// Define trigger value
parameter TRIGVL = 8'hD5; // Example trigger value

// Reset condition
always @ (posedge clk or posedge rst)
begin
    if (rst)
    begin
        adc_rdy <= 0;
        adc_out <= 8'b0;
        head_ptr <= 5'b0;
        tail_ptr <= 5'b0;
    end
    else
    begin
        // Check if ADC request is asserted
        if (adc_req)
        begin
            // Write data to buffer and increment tail pointer
            buffer[tail_ptr] <= adc_dat;
            tail_ptr <= tail_ptr + 1;

            // Check for trigger condition
            if (adc_dat > TRIGVL)
                adc_rdy <= 1;
            else
                adc_rdy <= 0;
        end
        else
        begin
            adc_rdy <= 0;
        end
    end
end

// Output data from buffer
always @ (posedge clk)
begin
    if (~rst)
    begin
        // Output data from head_ptr - 31 (circular wrap-around)
        adc_out <= buffer[(head_ptr + BUFFER_DEPTH - 31) % BUFFER_DEPTH];
    end
end

endmodule
