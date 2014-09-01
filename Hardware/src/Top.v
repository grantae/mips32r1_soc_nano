`timescale 1ns / 1ps
/*
 * File         : Top.v
 * Project      : University of Utah, XUM Project MIPS32 core
 * Creator(s)   : Grant Ayers (ayers@cs.utah.edu)
 *
 * Modification History:
 *   Rev   Date         Initials  Description of Change
 *   1.0   8-Jul-2011   GEA       Initial design.
 *
 * Standards/Formatting:
 *   Verilog 2001, 4 soft tab, wide column.
 *
 * Description:
 *   The top-level file for the FPGA. Also known as the 'motherboard,' this
 *   file connects all processor, memory, clocks, and I/O devices together.
 *   All inputs and outputs correspond to actual FPGA pins.
 */
module Top(
    input  clock_50MHz,
    input  reset_n,
    // I/O
    input  [3:0] Switch,
    output [7:0] LED,
    input  UART_Rx,
    output UART_Tx
    );
    
    
    // Clock signals
    wire clock, clock2x;
    wire PLL_Locked;
    
    reg reset;
    always @(posedge clock) begin
        reset <= ~reset_n | ~PLL_Locked;
    end
    
    // MIPS Processor Signals
    reg  [31:0] MIPS32_DataMem_In;
    wire [31:0] MIPS32_DataMem_Out, MIPS32_InstMem_In;
    wire [29:0] MIPS32_DataMem_Address, MIPS32_InstMem_Address;
    wire [3:0]  MIPS32_DataMem_WE;
    wire        MIPS32_DataMem_Read, MIPS32_InstMem_Read;
    reg         MIPS32_DataMem_Ack;
    wire [4:0]  MIPS32_Interrupts;
    wire        MIPS32_NMI;
    wire [7:0]  MIPS32_IP;
    wire        MIPS32_IO_WE;
    
    // BRAM Memory Signals
    reg  [3:0] BRAM_WEA;
    reg  BRAM_REA;
    reg  [13:0] BRAM_AddrA;
    reg  [31:0] BRAM_DINA;
    wire BRAM_AckA;
    wire BRAM_REB;
    wire [3:0] BRAM_WEB;
    wire [31:0] BRAM_DOUTB;
    wire BRAM_AckB;
    
    // UART Bootloader Signals
    wire UART_RE;
    wire UART_WE;
    wire [16:0] UART_DOUT;
    wire UART_Ack;
    wire UART_Interrupt;
    wire UART_BootResetCPU;
    wire [17:0] UART_BootAddress;
    wire [31:0] UART_BootData;
    wire UART_BootWriteMem_pre;
    wire [3:0] UART_BootWriteMem = (UART_BootWriteMem_pre) ? 4'hF : 4'h0;
    
    // LED Signals
    wire LED_WE;
    wire LED_RE;
    wire [8:0] LED_DOUT;
    wire LED_Ready;
    wire [7:0] LED_Sw_LEDs;

    // Filtered Switch Input Signals
    wire Switches_RE;
    wire Switches_WE;
    wire Switches_Ready;
    wire [3:0] Switches_DOUT;

    // Clock Generation
    PLL_50MHz_to_50MHz_100MHz Clock_Generator (
        .areset (1'b0),
        .inclk0 (clock_50MHz),
        .c0     (clock),
        .c1     (clock2x),
        .locked (PLL_Locked)
    );
 
     // MIPS-32 Core
    Processor MIPS32 (
        .clock            (clock),
        .reset            ((reset | UART_BootResetCPU)),
        .Interrupts       (MIPS32_Interrupts),
        .NMI              (MIPS32_NMI),
        .DataMem_In       (MIPS32_DataMem_In),
        .DataMem_Ack    (MIPS32_DataMem_Ack),
        .DataMem_Read     (MIPS32_DataMem_Read),
        .DataMem_Write    (MIPS32_DataMem_WE),
        .DataMem_Address  (MIPS32_DataMem_Address),
        .DataMem_Out      (MIPS32_DataMem_Out),
        .InstMem_In       (MIPS32_InstMem_In),
        .InstMem_Address  (MIPS32_InstMem_Address),
        .InstMem_Ack    (BRAM_AckA),
        .InstMem_Read     (MIPS32_InstMem_Read),
        .IP               (MIPS32_IP)
    );

    // On-Chip Block RAM
    BRAM_Wrapper Memory (
        .clock    (clock2x),
        .reset    (reset),
        .rea      (BRAM_REA),
        .wea      (BRAM_WEA),
        .addra    (BRAM_AddrA),
        .dina     (BRAM_DINA),
        .douta    (MIPS32_InstMem_In),
        .dreadya  (BRAM_AckA),
        .reb      (BRAM_REB),
        .web      (BRAM_WEB),
        .addrb    (MIPS32_DataMem_Address[13:0]),
        .dinb     (MIPS32_DataMem_Out),
        .doutb    (BRAM_DOUTB),
        .dreadyb  (BRAM_AckB)
    );


    // UART + Boot Loader (v2)
    uart_bootloader UART (
        .clock         (clock2x),
        .reset         (reset),
        .Read          (UART_RE),
        .Write         (UART_WE),
        .DataIn        (MIPS32_DataMem_Out[8:0]),
        .DataOut       (UART_DOUT),
        .Ack           (UART_Ack),
        .DataReady     (UART_Interrupt),
        .BootResetCPU  (UART_BootResetCPU),
        .BootWriteMem  (UART_BootWriteMem_pre),
        .BootAddr      (UART_BootAddress),
        .BootData      (UART_BootData),
        .RxD           (UART_Rx),
        .TxD           (UART_Tx)
    );

  
    // LEDs
    LED LEDs (
        .clock    (clock2x),
        .reset    (reset),
        .dataIn   (MIPS32_DataMem_Out[8:0]),
        .IP       (MIPS32_IP),
        .Write    (LED_WE),
        .Read     (LED_RE),
        .dataOut  (LED_DOUT),
        .Ack      (LED_Ready),
        .LED      (LED_Sw_LEDs)
    );

    // Filtered Input Switches
    Switches Switches (
        .clock       (clock2x),
        .reset       (reset),
        .Read        (Switches_RE),
        .Write       (Switches_WE),
        .Switch_in   (Switch),
        .Ack         (Switches_Ready),
        .Switch_out  (Switches_DOUT)
    );
    
    
    assign MIPS32_IO_WE = (MIPS32_DataMem_WE == 4'hF) ? 1'b1 : 1'b0;
    assign MIPS32_Interrupts[4:1] = Switches_DOUT[3:0];
    assign MIPS32_Interrupts[0]   = UART_Interrupt;
    assign MIPS32_NMI             = 1'b0;
    assign LED = (UART_BootResetCPU) ? 8'hFF : LED_Sw_LEDs[7:0];

    // Allow writes to Instruction Memory Port when bootloading
    always @(*) begin
        BRAM_REA   <= (UART_BootResetCPU) ? 1'b0 : MIPS32_InstMem_Read;
        BRAM_WEA   <= (UART_BootResetCPU) ? UART_BootWriteMem : 4'h0;
        BRAM_AddrA <= (UART_BootResetCPU) ? UART_BootAddress[13:0] : MIPS32_InstMem_Address[13:0];
        BRAM_DINA  <= (UART_BootResetCPU) ? UART_BootData : 32'h0000_0000;
    end


    always @(*) begin
        case (MIPS32_DataMem_Address[29])
            1'b0 : begin
                       MIPS32_DataMem_In    <= BRAM_DOUTB;
                       MIPS32_DataMem_Ack <= BRAM_AckB;
                   end
            1'b1 : begin
                       // Memory-mapped I/O
                       case (MIPS32_DataMem_Address[28:26])
                           // UART
                           3'b011 :    begin
                                           MIPS32_DataMem_In    <= {15'h0000, UART_DOUT[16:0]};
                                           MIPS32_DataMem_Ack <= UART_Ack;
                                       end
                           // LED
                           3'b100 :    begin
                                           MIPS32_DataMem_In    <= {23'h000000, LED_DOUT[8:0]};
                                           MIPS32_DataMem_Ack <= LED_Ready;
                                       end
                           // Switches
                           3'b101 :    begin
                                           MIPS32_DataMem_In    <= {28'h0000000, Switches_DOUT[3:0]};
                                           MIPS32_DataMem_Ack <= Switches_Ready;
                                       end
                           default:    begin
                                           MIPS32_DataMem_In    <= 32'h0000_0000;
                                           MIPS32_DataMem_Ack <= 0;
                                       end
                       endcase
                   end
        endcase
    end
    
    // Memory
    assign BRAM_REB    = (MIPS32_DataMem_Address[29]) ? 1'b0    : MIPS32_DataMem_Read;
    assign BRAM_WEB    = (MIPS32_DataMem_Address[29]) ? 4'h0 : MIPS32_DataMem_WE;
    // I/O
    assign UART_WE     = (MIPS32_DataMem_Address[29:26] == 4'b1011) ? MIPS32_IO_WE : 1'b0;
    assign UART_RE     = (MIPS32_DataMem_Address[29:26] == 4'b1011) ? MIPS32_DataMem_Read : 1'b0;
    assign LED_WE      = (MIPS32_DataMem_Address[29:26] == 4'b1100) ? MIPS32_IO_WE : 1'b0;
    assign LED_RE      = (MIPS32_DataMem_Address[29:26] == 4'b1100) ? MIPS32_DataMem_Read : 1'b0;
    assign Switches_WE = (MIPS32_DataMem_Address[29:26] == 4'b1101) ? MIPS32_IO_WE : 1'b0;
    assign Switches_RE = (MIPS32_DataMem_Address[29:26] == 4'b1101) ? MIPS32_DataMem_Read : 1'b0;
    
endmodule

