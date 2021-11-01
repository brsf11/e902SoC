module APBLed(input wire       clk,rst_n,
              input wire       PWRITE,
              input wire       PSEL,
              input wire       PENABLE,
              input wire[31:0] PWDATA,
              output wire      LED);

    reg[31:0] LedReg;
    wire WriteEN;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) LedReg <= 32'b0;
        else if(WriteEN) LedReg <= PWDATA;
    end

    assign WriteEN = PWRITE & PSEL & PENABLE;

    wire[1:0]  LedMode;
    wire[29:0] BlinkCnt;
    reg[29:0]  Cnt;

    reg LedBlink;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            Cnt <= 30'b0;
            LedBlink <= 1'b0;
        end
        else begin
            if((Cnt == BlinkCnt) | WriteEN) begin
                Cnt <= 30'b0;
                LedBlink <= ~LedBlink;
            end
            else begin
                Cnt <= Cnt + 1'b1;
            end
        end
    end

    assign LedMode  = LedReg[31:30];
    assign BlinkCnt = LedReg[29:0];
    assign LED      = LedMode[0] | (LedMode[1] & LedBlink);

endmodule