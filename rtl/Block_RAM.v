module Block_RAM #(
    parameter ADDR_WIDTH = 14
)   (
    input clka,
    input [ADDR_WIDTH-1:0] addra,
    input [ADDR_WIDTH-1:0] addrb,
    input [31:0] dina,
    input [3:0] wea,
    output reg [31:0] doutb
);

(* ram_style="block" *)reg [7:0] mem [(2**(ADDR_WIDTH+2)-1):0];

initial begin
    $readmemh("C:/code/e902SoC/build/code.hex",mem);
end

wire[ADDR_WIDTH+1:0] adda,addb;

assign adda = {addra,2'b00};
assign addb = {addrb,2'b00};

always@(posedge clka) begin
    if(wea[0]) mem[adda] <= dina[7:0];
end
always@(posedge clka) begin
    if(wea[1]) mem[adda + 1] <= dina[15:8];
end
always@(posedge clka) begin
    if(wea[2]) mem[adda + 2] <= dina[23:16];
end
always@(posedge clka) begin
    if(wea[3]) mem[adda + 3] <= dina[31:24];
end

always@(posedge clka) begin
    doutb <= {mem[addb + 3],mem[addb + 2],mem[addb + 1],mem[addb]};
end

endmodule