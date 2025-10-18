module my_fsm (
    input wire clk,
    input wire reset,

    output reg [4:0] key_0,
    output reg [4:0] key_1,
    output reg [4:0] key_2,
    output reg [4:0] key_3,
    output reg [4:0] key_4,
    output reg [4:0] key_5,
    output reg [4:0] key_6,
    output reg [4:0] key_7
);

    localparam STATE_IDLE = 2'd0;
    localparam STATE_PRESS = 2'd1;
    localparam STATE_RELASE = 2'd2;
    localparam STATE_NEXT = 2'd3;
    localparam STATE_DONE = 2'd4;
    localparam MAX_KEYS = 1024;

    reg [2:0] state;
    reg [31:0] timer;
    reg [7:0] key_index;

    // --------------------------
    // timing ticks
    // --------------------------
    localparam CLK_FREQ = 27000000;  // 27 MHz
    localparam integer IDLE_TICKS  = CLK_FREQ / 1000 * 3000;  // 3 sec
    localparam integer PRESS_TICKS = CLK_FREQ / 1000 * 100;   // 100 ms
    localparam integer RELEASE_TICKS = CLK_FREQ / 1000 * 100; // 400 ms

    // --------------------------
    // sequence memory
    // --------------------------
    reg [15:0] seq_mem [0:MAX_KEYS-1];
    reg [15:0] code;
    integer i;
    integer seq_len;

    // ===== INIT FILE =====
    initial begin
        $readmemh("../asm/zx_type.hex", seq_mem);
        seq_len = 0;
        for (i=0;i<MAX_KEYS;i=i+1) begin
            if (seq_mem[i] !== 16'hXXXX) seq_len = seq_len + 1;
        end

        // outputs init
        key_0 = 5'b11111; key_1 = 5'b11111; key_2 = 5'b11111;
        key_3 = 5'b11111; key_4 = 5'b11111; key_5 = 5'b11111;
        key_6 = 5'b11111; key_7 = 5'b11111;

        state = STATE_IDLE;
        timer = 0;
        key_index = 0;
    end

    // ======== FSM =============
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_IDLE;
            timer <= 0;
            key_index <= 0;
            key_0 <= 5'b11111; key_1 <= 5'b11111; key_2 <= 5'b11111;
            key_3 <= 5'b11111; key_4 <= 5'b11111; key_5 <= 5'b11111;
            key_5 <= 5'b11111; key_7 <= 5'b11111;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (timer < IDLE_TICKS) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= STATE_PRESS;
                    end
                end
                STATE_PRESS: begin
                    if (timer < PRESS_TICKS) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= STATE_RELASE;
                        code <= seq_mem[key_index];
//                        key_0 <= (code[15:8] == 8'd0) ? code[4:0] : 5'b11111;
                        key_0 <= (code[15:8] == 8'd0) ?
                                ( (code[6] == 1'b1) ?
                                    (code[4:0] & 5'b11110) :   // toets + CS
                                    code[4:0]                  // alleen toets
                                )
                            :
                                ( (code[6] == 1'b1) ?
                                    5'b11110 :                 // alleen CS
                                    5'b11111                   // niks
                                );
                        key_1 <= (code[15:8] == 8'd1) ? code[4:0] : 5'b11111;
                        key_2 <= (code[15:8] == 8'd2) ? code[4:0] : 5'b11111;
                        key_3 <= (code[15:8] == 8'd3) ? code[4:0] : 5'b11111;
                        key_4 <= (code[15:8] == 8'd4) ? code[4:0] : 5'b11111;
                        key_5 <= (code[15:8] == 8'd5) ? code[4:0] : 5'b11111;
                        key_6 <= (code[15:8] == 8'd6) ? code[4:0] : 5'b11111;
//                        key_7 <= (code[15:8] == 8'd7) ? code[4:0] : 5'b11111;
                        key_7 <= (code[15:8] == 8'd7) ?
                                ( (code[5] == 1'b1) ?
                                    (code[4:0] & 5'b11101) :   // toets + SS
                                    code[4:0]                  // alleen toets
                                )
                            :
                                ( (code[5] == 1'b1) ?
                                    5'b11101 :                 // alleen SS
                                    5'b11111                   // niks
                                );

                    end
                end
                STATE_RELASE: begin
                    if (timer < RELEASE_TICKS) timer <= timer + 1;
                    else begin
                        timer <= 0;
                        state <= STATE_NEXT;
                        key_0 <= 5'b11111;
                        key_1 <= 5'b11111;
                        key_2 <= 5'b11111;
                        key_3 <= 5'b11111;
                        key_4 <= 5'b11111;
                        key_5 <= 5'b11111;
                        key_6 <= 5'b11111;
                        key_7 <= 5'b11111;
                    end
                end
                STATE_NEXT: begin
                    if (key_index < seq_len -1) begin
                        key_index <= key_index +1;
                        state <= STATE_PRESS;
                    end else begin
                        state <= STATE_DONE;
                    end
                end
                STATE_DONE: begin
                    // niks te doen
                end
            endcase
        end
    end

endmodule