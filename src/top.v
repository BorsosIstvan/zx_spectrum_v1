module top (
    input wire clk,
    input wire reset_n,
    input wire btn,

    output wire tmds_clk_n,
    output wire tmds_clk_p,
    output wire [2:0] tmds_data_n,
    output wire [2:0] tmds_data_p
);

// =============== hdmi =================

hdmi my_hdmi (
    .clk(clk),
    .reset_n(reset_n),
    .tmds_clk_n(tmds_clk_n),
    .tmds_clk_p(tmds_clk_p),
    .tmds_data_n(tmds_data_n),
    .tmds_data_p(tmds_data_p),
    .rgb_clk(clk_video),
    .video_addr(video_addr),
    .video_dout(video_dout)
);

// =============== video ram ============
wire [12:0] video_addr;
wire [7:0] video_dout;
wire clk_video;


// ==============gowin dram ===========
    Gowin_DPB gw_dram(
        .douta(douta), //output [7:0] douta
        .doutb(video_dout), //output [7:0] doutb
        .clka(clk_spectrum), //input clka
        .ocea(~rd_n), //input ocea
        .cea(ram_cs[2]), //input cea
        .reseta(!reset_n), //input reseta
        .wrea(~wr_n), //input wrea
        .clkb(clk_video), //input clkb
        .oceb(1'b1), //input oceb
        .ceb(1'b1), //input ceb
        .resetb(!reset_n), //input resetb
        .wreb(1'b0), //input wreb
        .ada(address_bus[12:0]), //input [12:0] ada
        .dina(data_bus), //input [7:0] dina
        .adb(video_addr), //input [12:0] adb
        .dinb(8'b0) //input [7:0] dinb
    );
// ============= tristate bus ===============
wire [7:0] douta;
assign data_bus = (!rd_n && ram_cs[2] && !wr_n) ? 8'bz :
                  (!rd_n && ram_cs[2]) ? douta : 8'bz;

// ===============ram =================

rom0_reg rom0 (
    .clk(clk_spectrum),
    .reset(!reset_n),
    .ce(ram_cs[0]),
    .oce(~rd_n),
    .wre(1'b0),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)
);

rom1_reg rom1 (
    .clk(clk_spectrum),
    .reset(!reset_n),
    .ce(ram_cs[1]),
    .oce(~rd_n),
    .wre(1'b0),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)
);

ram8k_reg ram3 (
    .clk(clk_spectrum),
    .reset(!reset_n),
    .ce(ram_cs[3]),
    .oce(~rd_n),
    .wre(~wr_n),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)
);

ram8k_reg ram4 (
    .clk(clk_spectrum),
    .reset(!reset_n),
    .ce(ram_cs[4]),
    .oce(~rd_n),
    .wre(~wr_n),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)
);

ram8k_reg ram5 (
    .clk(clk_spectrum),
    .reset(!reset_n),
    .ce(ram_cs[5]),
    .oce(~rd_n),
    .wre(~wr_n),
    .ad(address_bus[12:0]),
    .data_bus(data_bus)
);

// ============= decoder =========
wire [7:0] ram_cs, io_cs;
decoder ula (
    .mreq_n(mreq_n),
    .iorq_n(iorq_n),
    .ad(address_bus),
    .ram_cs(ram_cs),
    .io_cs(io_cs)
);

// ============= cpu Z80a =========
wire [15:0] address_bus;
wire [7:0] data_bus;
wire int_n, iorq_n, mreq_n, rd_n, wr_n;
cpu_z80a Z80A (
    .clk(clk_spectrum),
    .reset_n(reset_n),
    .address_bus(address_bus),
    .data_bus(data_bus),
    .halt_n(1'b1),
    .int_n(int_n),
    .iorq_n(iorq_n),
    .mreq_n(mreq_n),
    .rd_n(rd_n),
    .wr_n(wr_n)
);

// CLK SPECTRUM : CPU RAM ROM
wire clk_spectrum;
Gowin_OSC osc(
    .oscout(clk_spectrum)   // ~7 MHz
);

// simple 50Hz int generator (example)
reg [18:0] cnt = 0;
always @(posedge clk_spectrum) begin
    if (cnt == 19'd139999)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end
assign int_n = (cnt < 5)? 1'b0 : 1'b1;

// ============= io =================
    io_device_in io_in (
        .clk(clk_spectrum),
        .reset(~resetn),
        .ce(io_cs[1]),
        .rd(~cpu_rd_n),
        .wr(~cpu_wr_n),
        .ad(address_bus),
        .data_bus(data_bus),
        .row_0(key_0),
        .row_1(key_1),
        .row_2(key_2),
        .row_3(key_3),
        .row_4(key_4),
        .row_5(key_5),
        .row_6(key_6),
        .row_7(key_7)
    );
// ================= Typist =================
    wire [4:0] key_0;
    wire [4:0] key_1;
    wire [4:0] key_2;
    wire [4:0] key_3;
    wire [4:0] key_4;
    wire [4:0] key_5;
    wire [4:0] key_6;
    wire [4:0] key_7;

// ========== typist ===============

    my_fsm (
        .clk(clk),
        .reset(!reset_n),
        .key_0(key_0),
        .key_1(key_1),
        .key_2(key_2),
        .key_3(key_3),
        .key_4(key_4),
        .key_5(key_5),
        .key_6(key_6),
        .key_7(key_7)
    );



endmodule