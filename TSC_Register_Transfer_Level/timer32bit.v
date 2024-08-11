module Timer(
    input wire clk, // Clock input
    input wire reset, // Reset input
    output reg [31:0] timer // 32-bit timer output
);

// Reset condition
always @ (posedge clk or posedge reset)
begin
    if (reset)
        timer <= 0;
    else
        timer <= timer + 1;
end

endmodule	