module SSeg(input wire[4:0] num,
            output wire A,B,C,D,E,F,G,DP);
    
    reg[7:0] out;

    always @(*)begin
        case(num[3:0])
            4'b0000: out = 8'b1111_1100;
            4'b0001: out = 8'b0110_0000;
            4'b0010: out = 8'b1101_1010;
            4'b0011: out = 8'b1111_0010;
            4'b0100: out = 8'b0110_0110;
            4'b0101: out = 8'b1011_0110;
            4'b0110: out = 8'b1011_1110;
            4'b0111: out = 8'b1110_0000;
            4'b1000: out = 8'b1111_1110;
            4'b1001: out = 8'b1110_0110;
            4'b1010: out = 8'b1110_1110;
            4'b1011: out = 8'b0011_1110;
            4'b1100: out = 8'b0001_1010;
            4'b1101: out = 8'b0111_1010;
            4'b1110: out = 8'b1001_1110;
            4'b1111: out = 8'b1000_1110;
            default: out = 8'b0000_0000;
        endcase
    end

    assign {A,B,C,D,E,F,G} = out[7:1];
    assign DP = num[4];
    
endmodule