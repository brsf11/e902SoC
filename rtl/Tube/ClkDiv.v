module ClkDiv(input wire clk,rst_n,
              output reg div_clk);

    parameter DIVCLK_CNTMAX = 249;
    reg[31:0] cnt = 0;

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt <= 0;
            div_clk <=0;
        end
        else begin
            if(cnt >= DIVCLK_CNTMAX)begin
                cnt <= 0;
                div_clk <= ~div_clk;
            end
            else begin
                cnt <= cnt+1;
            end
        end
    end
endmodule