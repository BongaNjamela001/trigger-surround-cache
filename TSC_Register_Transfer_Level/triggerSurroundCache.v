module triggersurroundcache(
    reset,       // reset when high
    start,       // start pulse
    clk,         // clock for TSC
    adc_data,  // data from ADC
    req,         // request line to ADC
    trd,         // trigger detected
    cd,          // completed data transfer
    trigtm,  // when trigger
    sd          // serial data out
);

input reset;       // reset when high
input start;       // start pulse
input clk;         // clock for TSC
input adc_data;  // data from ADC
input req;         // request line to ADC
output trd;         // trigger detected
output cd;          // completed data transfer
output trigtm;  // when trigger
output sd;        
    
wire reset;       // reset when high
wire start;       // start pulse
wire clk;         // clock for TSC
wire [7:0] adc_data;  // data from ADC
wire req;         // request line to ADC
reg trd;         // trigger detected
reg cd;          // completed data transfer
reg [31:0] trigtm;  // when trigger
wire sd;

// Internal state signals
typedef enum logic [1:0] {
    IDLE,
    RUNNING,
    TRIGGERED,
    BUFFER_SEND
} State;

// Register to hold current state
reg [1:0] current_state, next_state;

// Internal signals
reg [31:0] timer;
reg [31:0] ring_buffer [0:31];
reg [4:0] ring_head, ring_tail;
reg [7:0] trigger_threshold;
reg [31:0] buffer_data;

// Parameter
localparam TRIGGER_LEVEL = 8'hD5; // example threshold value

// State register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        trd <= 0;
        cd <= 0;
        timer <= 0;
        ring_head <= 0;
        ring_tail <= 0;
        trigger_threshold <= TRIGGER_LEVEL;
    end else begin
        current_state <= next_state;
    end
end

// Output assignments
always @* begin
    trd = (current_state == TRIGGERED);
    trigtm = (current_state == TRIGGERED) ? timer : 32'd0;
    sd = (current_state == BUFFER_SEND);
end

// State transition and logic
always @* begin
    case (current_state)
        IDLE: begin
            if (start) begin
                next_state = RUNNING;
            end else if (req && (adc_data >= trigger_threshold)) begin
                next_state = TRIGGERED;
            end else begin
                next_state = IDLE;
            end
        end
        RUNNING: begin
            if (req && (adc_data >= trigger_threshold)) begin
                next_state = TRIGGERED;
            end else begin
                next_state = RUNNING;
            end
        end
        TRIGGERED: begin
            if (ring_tail < 31) begin
                ring_buffer[ring_tail] <= adc_data;
                ring_tail <= ring_tail + 1;
            end
            if (ring_tail == 31) begin
                next_state = BUFFER_SEND;
            end else begin
                next_state = TRIGGERED;
            end
        end
        BUFFER_SEND: begin
            if (ring_head < 31) begin
                buffer_data <= ring_buffer[ring_head];
                ring_head <= ring_head + 1;
            end
            if (ring_head == 31) begin
                cd <= 1;
            end
            if (cd) begin
                next_state = IDLE;
            end else begin
                next_state = BUFFER_SEND;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule
