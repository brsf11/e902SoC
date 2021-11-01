module DigSel(input wire clk,rst_n,
              input wire[4:0] num5,num4,num3,num2,num1,num0,
              input wire[5:0] enb,
              output reg[5:0] DIG,
              output reg[4:0] num);

    parameter DIG1 = 3'b000;
    parameter DIG2 = 3'b001;
    parameter DIG3 = 3'b010;
    parameter DIG4 = 3'b011;
    parameter DIG5 = 3'b100;
    parameter DIG6 = 3'b101;
    reg[2:0] curr_state,next_state;

    always @(*)begin
        case(curr_state)
            DIG1:begin
                    num = num5;
                    DIG = {~enb[5],5'b11111};
            end
            DIG2:begin
                    num = num4;
                    DIG = {1'b1,~enb[4],4'b1111};
            end
            DIG3:begin
                    num = num3;
                    DIG = {2'b11,~enb[3],3'b111};
            end
            DIG4:begin
                    num = num2;
                    DIG = {3'b111,~enb[2],2'b11};
            end
            DIG5:begin
                    num = num1;
                    DIG = {4'b1111,~enb[1],1'b1};
            end
            DIG6:begin
                    num = num0;
                    DIG = {5'b11111,~enb[0]};
            end
            default:begin
                     num = 5'b00000;
                     DIG = 6'b111111;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) curr_state <= DIG1;
        else curr_state <= next_state;
    end

    always @(*) begin
        case(curr_state)
        DIG1: next_state = DIG2;
        DIG2: next_state = DIG3;
        DIG3: next_state = DIG4;
        DIG4: next_state = DIG5;
        DIG5: next_state = DIG6;
        DIG6: next_state = DIG1;
        default: next_state = DIG1;
        endcase
    end

endmodule