module io_device_in (
    input  wire        clk,
    input  wire        reset,
    input  wire        ce,      // IORQ laag + adres match
    input  wire        rd,      // RD laag
    input  wire        wr,      // WR laag
    input  wire [15:0]  ad,     // fuul address
    inout  wire [7:0]  data_bus,
    input wire  [4:0]  row_0,
    input wire  [4:0]  row_1,
    input wire  [4:0]  row_2,
    input wire  [4:0]  row_3,
    input wire  [4:0]  row_4,
    input wire  [4:0]  row_5,
    input wire  [4:0]  row_6,
    input wire  [4:0]  row_7
);

wire [7:0] io_data =((ad[15:8]==8'hFE)) ? {3'b111, row_0} :                 //V, C, X, Z, CS
                    ((ad[15:8]==8'hFD)) ? {3'b111, row_1} :                 //G, F, D, S, A
                    ((ad[15:8]==8'hFB)) ? {3'b111, row_2} :                 //T, R, E, W, Q
                    ((ad[15:8]==8'hF7)) ? {3'b111, row_3} :                 //5, 4, 3, 2, 1
                    ((ad[15:8]==8'hEF)) ? {3'b111, row_4} :                 //6, 7, 8, 9, 0
                    ((ad[15:8]==8'hDF)) ? {3'b111, row_5} :                 //Y, U, I, O, P
                    ((ad[15:8]==8'hBF)) ? {3'b111, row_6} :                 //H, J, K, L, ENTR
                    ((ad[15:8]==8'h7F)) ? {3'b111, row_7} : 8'b11111111;    //B, N, M, SS, SP

// ===== TRI-STATE =====
assign data_bus = (ce && rd) ? io_data : 8'bz;

endmodule