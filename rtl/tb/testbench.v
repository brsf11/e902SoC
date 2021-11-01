`timescale 1ns/1ns
module testbench();

    reg       clk,rst_n;
    reg[3:0]  col;
    wire[3:0] row;
    wire[5:0] DIG;
    wire      TXD;
    wire      A,B,C,D,E,F,G,DP;
    wire      LED;

    reg[3:0] key;

    e902SoC core(
        .clk(clk),
        .rst_n(rst_n),
        .RXD(1'b1),
        .TXD(TXD),
        .col_in(col),
        .row(row),
        .DIG(DIG),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .DP(DP),
        .LED(LED)
    );

    always @(*) begin
        case(key)
            4'h0: col = {3'b111,~(row == 4'b1110)};
            4'h1: col = {2'b11,~(row == 4'b1110),1'b1};
            4'h2: col = {1'b1,~(row == 4'b1110),2'b11};
            4'h3: col = {~(row == 4'b1110),3'b111};    
            4'h4: col = {3'b111,~(row == 4'b1101)};
            4'h5: col = {2'b11,~(row == 4'b1101),1'b1};
            4'h6: col = {1'b1,~(row == 4'b1101),2'b11};
            4'h7: col = {~(row == 4'b1101),3'b111};    
            4'h8: col = {3'b111,~(row == 4'b1011)};
            4'h9: col = {2'b11,~(row == 4'b1011),1'b1};
            4'ha: col = {1'b1,~(row == 4'b1011),2'b11};
            4'hb: col = {~(row == 4'b1011),3'b111};    
            4'hc: col = {3'b111,~(row == 4'b0111)};
            4'hd: col = {2'b11,~(row == 4'b0111),1'b1};
            4'he: col = {1'b1,~(row == 4'b0111),2'b11};
            4'hf: col = {~(row == 4'b0111),3'b111};    
            default: col = 4'b1111;
        endcase
    end

    always begin
        clk=0;
        #10;
        clk=1;
        #10;
    end

    initial begin
        rst_n=0;
        #100;
        rst_n=1;
    end

initial begin
        key = 0;
        #1000000;
        key = 4;
        #1000000;
        key = 5;
        #1000000;
        key = 6;
    end



endmodule