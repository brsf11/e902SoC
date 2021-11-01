module APBTube(input wire        clk,rst_n,
               inout wire[15:0]  PADDR,
               input wire        PWRITE,
               input wire        PSEL,
               input wire        PENABLE,
               input wire[31:0]  PWDATA,
               output wire[31:0] PRDATA,
               output wire[5:0]  DIG,
               output wire       A,B,C,D,E,F,G,DP);

    reg[31:0] TubeReg,TubeEnbReg;
    wire RegWriteEN,EnbRegWriteEN;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            TubeReg <= 32'b0;
            TubeEnbReg <= 32'b0;
        end
        else begin
            if(RegWriteEN) TubeReg <= PWDATA;
            if(EnbRegWriteEN) TubeEnbReg <= PWDATA;
        end
    end

    assign RegWriteEN = PWRITE & PSEL & PENABLE & (!PADDR[2]);
    assign EnbRegWriteEN = PWRITE & PSEL & PENABLE & PADDR[2];

    wire div_clk;
    wire[4:0] num,num0,num1,num2,num3,num4,num5;
    wire[5:0] enb;

    ClkDiv ClkDiv(
        .clk      (clk),
        .rst_n    (rst_n),
        .div_clk  (div_clk)
    );

    DigSel DigSel(
        .clk      (div_clk),
        .rst_n    (rst_n),
        .num5     (num5),
        .num4     (num4),
        .num3     (num3),
        .num2     (num2),
        .num1     (num1),
        .num0     (num0),
        .enb      (enb),
        .DIG      (DIG),
        .num      (num)
    );

    SSeg SSeg(
        .num      (num),
        .A        (A),
        .B        (B),
        .C        (C),
        .D        (D),
        .E        (E),
        .F        (F),
        .G        (G),
        .DP       (DP)
    );

    assign {num5,num4,num3,num2,num1,num0} = TubeReg[29:0];
    assign enb = TubeEnbReg[5:0];

    assign PRDATA = PADDR[2]?TubeEnbReg:TubeReg;

endmodule