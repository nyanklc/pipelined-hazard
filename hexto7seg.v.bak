module hexto7seg (
    output reg [6:0] hexn,
    input [3:0] hex
);
always @(num) begin
    case (num)
    0: sevenseg1 = 7'b1000000;
    1: sevenseg1 = 7'b1111001;
    2: sevenseg1 = 7'b0100100;
    3: sevenseg1 = 7'b0110000;
    4: sevenseg1 = 7'b0011001;
    5: sevenseg1 = 7'b0010010;
    6: sevenseg1 = 7'b0000010;
    7: sevenseg1 = 7'b1111000;
    8: sevenseg1 = 7'b0000000;
    9: sevenseg1 = 7'b0010000;
    10: sevenseg1 = 7'b0001000;
    11: sevenseg1 = 7'b0000011;
    12: sevenseg1 = 7'b1000110;
    13: sevenseg1 = 7'b0100001;
    14: sevenseg1 = 7'b0000110;
    15: sevenseg1 = 7'b0001110;
    endcase
end
endmodule