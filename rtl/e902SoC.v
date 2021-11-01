module e902SoC(input wire       clk,rst_n,
               input wire       RXD,
               output wire      TXD,
               input wire[3:0]  col_in,
               output wire[3:0] row,
               output wire[5:0] DIG,
               output wire      A,B,C,D,E,F,G,DP,
               output wire      LED);

    //system bus
    wire[31:0]  SYS_HADDR;
    wire[31:0]  SYS_HWDATA;
    wire[2:0]   SYS_HBURST;
    wire[2:0]   SYS_HSIZE;
    wire[1:0]   SYS_HTRANS;
    wire        SYS_HWRITE;
    wire[3:0]   SYS_HPROT;

    wire[31:0]  SYS_HRDATA;
    wire        SYS_HREADY;
    wire[1:0]   SYS_HRESP;

    //instruction bus
    wire[31:0]  INS_HADDR;
    wire[31:0]  INS_HWDATA;
    wire[2:0]   INS_HBURST;
    wire[2:0]   INS_HSIZE;
    wire[1:0]   INS_HTRANS;
    wire        INS_HWRITE;
    wire[3:0]   INS_HPROT;

    wire[31:0]  INS_HRDATA;
    wire        INS_HREADY;
    wire[1:0]   INS_HRESP;

    //Interrupt
    wire        KeyboardINT;
    wire[63:0]  CLIC_INT;

    assign CLIC_INT = {63'b0,KeyboardINT};
    
    //------------------------------
    // Instantiate core
    //------------------------------
    openE902 core(

        //system signals
        //clk
        .pll_core_cpuclk        (clk),
        //reset
        //in
        .pad_cpu_rst_b          (rst_n),
        .pad_cpu_rst_addr       (32'b0),
        .pad_had_jtg_trst_b     (rst_n),
        .pad_had_rst_b          (rst_n),
        //out
        .cpu_pad_soft_rst       (),

        //system bus signals
        //out
        .biu_pad_haddr          (SYS_HADDR),
        .biu_pad_hburst         (SYS_HBURST),
        .biu_pad_hprot          (SYS_HPROT),
        .biu_pad_hsize          (SYS_HSIZE),
        .biu_pad_htrans         (SYS_HTRANS),
        .biu_pad_hwdata         (SYS_HWDATA),
        .biu_pad_hwrite         (SYS_HWRITE),
        //in
        .pad_biu_hrdata         (SYS_HRDATA),
        .pad_biu_hready         (SYS_HREADY),
        .pad_biu_hresp          (SYS_HRESP[0]),


        //instruction bus signals
        //out
        .iahbl_pad_haddr        (INS_HADDR),
        .iahbl_pad_hburst       (INS_HBURST),
        .iahbl_pad_hprot        (INS_HPROT),
        .iahbl_pad_hsize        (INS_HSIZE),
        .iahbl_pad_htrans       (INS_HTRANS),
        .iahbl_pad_hwdata       (INS_HWDATA),
        .iahbl_pad_hwrite       (INS_HWRITE),
        //in
        .pad_iahbl_hrdata       (INS_HRDATA),
        .pad_iahbl_hready       (INS_HREADY),
        .pad_iahbl_hresp        (INS_HRESP[0]),
        //region def
        //in
        .pad_bmu_iahbl_base     (12'b0),
        .pad_bmu_iahbl_mask     (12'b1111_1111_1111),

        //interrupt signals
        //in
        .pad_cpu_nmi            (1'b0),
        .pad_clic_int_vld       (CLIC_INT),
        .pad_cpu_ext_int_b      (1'b1),
        .pad_cpu_sys_cnt        (64'b0),


        //jtag
        //in
        .pad_had_jtg_tclk       (1'b0),
        .pad_had_jtg_tms_i      (1'b0),
        //out
        .had_pad_jtg_tms_o      (),
        .had_pad_jtg_tms_oe     (),


        //dynamic frequency switch signals
        //in
        .pad_cpu_dfs_req        (1'b0),
        //out
        .cpu_pad_dfs_ack        (),


        //power control signals
        //in
        .pad_cpu_wakeup_event   (1'b0),
        //out
        .sysio_pad_lpmd_b       (),
        

        //debug signals
        //in
        .pad_sysio_dbgrq_b      (1'b1),  //pull up when unused
        //out
        .had_pad_jdb_pm         (),


        //DFT signals
        //in
        .pad_yy_gate_clk_en_b   (1'b0),
        .pad_yy_test_mode       (1'b0),
        
        

        //runtime signals
        //out
        .iu_pad_gpr_data        (),
        .iu_pad_gpr_index       (),
        .iu_pad_gpr_we          (),
        .iu_pad_inst_retire     (),
        .iu_pad_inst_split      (),
        .iu_pad_retire_pc       (),
        .cp0_pad_mcause         (),
        .cp0_pad_mintstatus     (),
        .cp0_pad_mstatus        (),
        .cpu_pad_lockup         ()
    );

    //------------------------------
    // System bus addr decode
    //------------------------------

    wire DATA_HSEL;
    wire BRIDGE_HSEL;

    assign DATA_HSEL    = (SYS_HADDR[31:30] == 2'b01);
    assign BRIDGE_HSEL = (SYS_HADDR[31:30] == 2'b10);

    //------------------------------
    // Instantiate AHB Slave mux
    //------------------------------

    //DataRam AHB signals
    wire        DATA_HREADY;
    wire[1:0]   DATA_HRESP;
    wire[31:0]  DATA_HRDATA;

    //AHB2APB Bridge signals
    wire        BRIDGE_HREADY;
    wire[1:0]   BRIDGE_HRESP;
    wire[31:0]  BRIDGE_HRDATA;


    cmsdk_ahb_slave_mux #(
        // Parameters to enable/disable ports
        // By default all ports are enabled
        .PORT0_ENABLE   (1),
        .PORT1_ENABLE   (1),
        .PORT2_ENABLE   (0),
        .PORT3_ENABLE   (0),
        .PORT4_ENABLE   (0),
        .PORT5_ENABLE   (0),
        .PORT6_ENABLE   (0),
        .PORT7_ENABLE   (0),
        .PORT8_ENABLE   (0),
        .PORT9_ENABLE   (0),
        // Data Bus Width
        .DW             (32)
    ) AHBSlaveMux
    (
        .HCLK           (clk),       
        .HRESETn        (rst_n),    
        .HREADY         (SYS_HREADY),     
        .HSEL0          (DATA_HSEL),      
        .HREADYOUT0     (DATA_HREADY), 
        .HRESP0         (DATA_HRESP[0]),     
        .HRDATA0        (DATA_HRDATA),    
        .HSEL1          (BRIDGE_HSEL),      
        .HREADYOUT1     (BRIDGE_HREADY), 
        .HRESP1         (BRIDGE_HRESP[0]),     
        .HRDATA1        (BRIDGE_HRDATA),    
        .HSEL2          (f),      
        .HREADYOUT2     (), 
        .HRESP2         (),     
        .HRDATA2        (),    
        .HSEL3          (),      
        .HREADYOUT3     (), 
        .HRESP3         (),     
        .HRDATA3        (),    
        .HSEL4          (),      
        .HREADYOUT4     (), 
        .HRESP4         (),     
        .HRDATA4        (),    
        .HSEL5          (),      
        .HREADYOUT5     (), 
        .HRESP5         (),     
        .HRDATA5        (),    
        .HSEL6          (),      
        .HREADYOUT6     (), 
        .HRESP6         (),     
        .HRDATA6        (),    
        .HSEL7          (),      
        .HREADYOUT7     (), 
        .HRESP7         (),     
        .HRDATA7        (),    
        .HSEL8          (),      
        .HREADYOUT8     (), 
        .HRESP8         (),     
        .HRDATA8        (),    
        .HSEL9          (),      
        .HREADYOUT9     (), 
        .HRESP9         (),     
        .HRDATA9        (),    
        .HREADYOUT      (SYS_HREADY),  
        .HRESP          (SYS_HRESP[0]),      
        .HRDATA         (SYS_HRDATA)      
    );

    //------------------------------
    // Instantiate APB subsystem
    //------------------------------

    //APB bus signals
    wire[15:0]  APBS_PADDR;
    wire        APBS_PENABLE;
    wire        APBS_PWRITE;
    wire[3:0]   APBS_PSTRB;
    wire[2:0]   APBS_PPROT;
    wire[31:0]  APBS_PWDATA;
    wire        APBS_PSEL;
    wire[31:0]  APBS_PRDATA;
    wire        APBS_PREADY;
    wire        APBS_PSLVERR;

    cmsdk_ahb_to_apb #(
        // Parameter to define address width
        // 16 = 2^16 = 64KB APB address space
        .ADDRWIDTH        (16),
        .REGISTER_RDATA   (1),
        .REGISTER_WDATA   (0)
    ) AHB2APB
    (
        .HCLK           (clk),     
        .HRESETn        (rst_n),  
        .PCLKEN         (1'b1),   
        .HSEL           (BRIDGE_HSEL),     
        .HADDR          (SYS_HADDR[15:0]),    
        .HTRANS         (SYS_HTRANS),   
        .HSIZE          (SYS_HSIZE),    
        .HPROT          (SYS_HPROT),    
        .HWRITE         (SYS_HWRITE),   
        .HREADY         (SYS_HREADY),   
        .HWDATA         (SYS_HWDATA),   
        .HREADYOUT      (BRIDGE_HREADY),
        .HRDATA         (BRIDGE_HRDATA),   
        .HRESP          (BRIDGE_HRESP[0]),    
        
        .PADDR          (APBS_PADDR),    
        .PENABLE        (APBS_PENABLE),  
        .PWRITE         (APBS_PWRITE),   
        .PSTRB          (APBS_PSTRB),    
        .PPROT          (APBS_PPROT),    
        .PWDATA         (APBS_PWDATA),   
        .PSEL           (APBS_PSEL),     
        .APBACTIVE      (),
        
        .PRDATA         (APBS_PRDATA),   
        .PREADY         (APBS_PREADY),   
        .PSLVERR        (APBS_PSLVERR)
    );

    //Uart APB signals
    wire        UART_PSEL;
    wire        UART_PREADY;
    wire[31:0]  UART_PRDATA;
    wire        UART_PSLVERR;

    //APB Keyboard signals
    wire[31:0]  KEY_PRDATA;

    //APB Tube signals
    wire        TUBE_PSEL;
    wire[31:0]  TUBE_PRDATA;

    //APB Led signals
    wire        LED_PSEL;

    cmsdk_apb_slave_mux #(
        .PORT0_ENABLE (1),
        .PORT1_ENABLE (1),
        .PORT2_ENABLE (1),
        .PORT3_ENABLE (1),
        .PORT4_ENABLE (0),
        .PORT5_ENABLE (0),
        .PORT6_ENABLE (0),
        .PORT7_ENABLE (0),
        .PORT8_ENABLE (0),
        .PORT9_ENABLE (0),
        .PORT10_ENABLE(0),
        .PORT11_ENABLE(0),
        .PORT12_ENABLE(0),
        .PORT13_ENABLE(0),
        .PORT14_ENABLE(0),
        .PORT15_ENABLE(0)
    ) APBSlaveMux
    (
        .DECODE4BIT     (APBS_PADDR[15:12]),
        .PSEL           (APBS_PSEL),

        //Uart
        .PSEL0          (UART_PSEL),
        .PREADY0        (UART_PREADY),
        .PRDATA0        (UART_PRDATA),
        .PSLVERR0       (UART_PSLVERR),

        //Keyboard
        .PSEL1          (),
        .PREADY1        (1'b1),
        .PRDATA1        (KEY_PRDATA),
        .PSLVERR1       (1'b0),

        //Tube
        .PSEL2          (TUBE_PSEL),
        .PREADY2        (1'b1),
        .PRDATA2        (TUBE_PRDATA),
        .PSLVERR2       (1'b0),

        //Led
        .PSEL3          (LED_PSEL),
        .PREADY3        (1'b1),
        .PRDATA3        (32'b0),
        .PSLVERR3       (1'b0),

        .PSEL4          (),
        .PREADY4        (1'b0),
        .PRDATA4        (32'b0),
        .PSLVERR4       (1'b0),

        .PSEL5          (),
        .PREADY5        (1'b0),
        .PRDATA5        (32'b0),
        .PSLVERR5       (1'b0),

        .PSEL6          (),
        .PREADY6        (1'b0),
        .PRDATA6        (32'b0),
        .PSLVERR6       (1'b0),

        .PSEL7          (),
        .PREADY7        (1'b0),
        .PRDATA7        (32'b0),
        .PSLVERR7       (1'b0),

        .PSEL8          (),
        .PREADY8        (1'b0),
        .PRDATA8        (32'b0),
        .PSLVERR8       (1'b0),

        .PSEL9          (),
        .PREADY9        (1'b0),
        .PRDATA9        (32'b0),
        .PSLVERR9       (1'b0),

        .PSEL10         (),
        .PREADY10       (1'b0),
        .PRDATA10       (32'b0),
        .PSLVERR10      (1'b0),

        .PSEL11         (),
        .PREADY11       (1'b0),
        .PRDATA11       (32'b0),
        .PSLVERR11      (1'b0),

        .PSEL12         (),
        .PREADY12       (1'b0),
        .PRDATA12       (32'b0),
        .PSLVERR12      (1'b0),

        .PSEL13         (),
        .PREADY13       (1'b0),
        .PRDATA13       (32'b0),
        .PSLVERR13      (1'b0),

        .PSEL14         (),
        .PREADY14       (1'b0),
        .PRDATA14       (32'b0),
        .PSLVERR14      (1'b0),

        .PSEL15         (),
        .PREADY15       (1'b0),
        .PRDATA15       (32'b0),
        .PSLVERR15      (1'b0),

        .PREADY         (APBS_PREADY),
        .PRDATA         (APBS_PRDATA),
        .PSLVERR        (APBS_PSLVERR)
    );


    //------------------------------
    // Instantiate AHBLiteBlockRam
    //------------------------------

    //CodeRam signals
    wire[13:0]  CODE_RDADDR;
    wire[13:0]  CODE_WRADDR;
    wire[31:0]  CODE_RDATA;
    wire[31:0]  CODE_WDATA;
    wire[3:0]   CODE_WRITE;

    //DataRam signals
    wire[13:0]  DATA_RDADDR;
    wire[13:0]  DATA_WRADDR;
    wire[31:0]  DATA_RDATA;
    wire[31:0]  DATA_WDATA;
    wire[3:0]   DATA_WRITE;

    AHBlite_Block_RAM #(
        .ADDR_WIDTH(14)
    ) AHBLiteBlockRamCode
    (
        .HCLK           (clk),    
        .HRESETn        (rst_n), 
        .HSEL           (1'b1),    
        .HADDR          (INS_HADDR),   
        .HTRANS         (INS_HTRANS),  
        .HSIZE          (INS_HSIZE),   
        .HPROT          (INS_HPROT),   
        .HWRITE         (INS_HWRITE),  
        .HWDATA         (INS_HWDATA),   
        .HREADY         (INS_HREADY), 
        .HREADYOUT      (INS_HREADY), 
        .HRDATA         (INS_HRDATA),  
        .HRESP          (INS_HRESP),
        .BRAM_RDADDR    (CODE_RDADDR),
        .BRAM_WRADDR    (CODE_WRADDR),
        .BRAM_RDATA     (CODE_RDATA),
        .BRAM_WDATA     (CODE_WDATA),
        .BRAM_WRITE     (CODE_WRITE)
    );

    AHBlite_Block_RAM #(
        .ADDR_WIDTH(14)
    ) AHBLiteBlockRamData
    (
        .HCLK           (clk),    
        .HRESETn        (rst_n), 
        .HSEL           (DATA_HSEL),    
        .HADDR          (SYS_HADDR),   
        .HTRANS         (SYS_HTRANS),  
        .HSIZE          (SYS_HSIZE),   
        .HPROT          (SYS_HPROT),   
        .HWRITE         (SYS_HWRITE),  
        .HWDATA         (SYS_HWDATA),   
        .HREADY         (SYS_HREADY), 
        .HREADYOUT      (DATA_HREADY), 
        .HRDATA         (DATA_HRDATA),  
        .HRESP          (DATA_HRESP),
        .BRAM_RDADDR    (DATA_RDADDR),
        .BRAM_WRADDR    (DATA_WRADDR),
        .BRAM_RDATA     (DATA_RDATA),
        .BRAM_WDATA     (DATA_WDATA),
        .BRAM_WRITE     (DATA_WRITE)
    );


    //------------------------------
    // Instantiate CodeRam
    //------------------------------

    Block_RAM #(
        .ADDR_WIDTH(14)
    ) CodeRam
    (
        .clka        (clk),
        .addra       (CODE_WRADDR),
        .addrb       (CODE_RDADDR),
        .dina        (CODE_WDATA),
        .wea         (CODE_WRITE),
        .doutb       (CODE_RDATA)
    );

    //------------------------------
    // Instantiate DataRam
    //------------------------------

    Block_RAM #(
        .ADDR_WIDTH(14)
    ) DataRam
    (
        .clka        (clk),
        .addra       (DATA_WRADDR),
        .addrb       (DATA_RDADDR),
        .dina        (DATA_WDATA),
        .wea         (DATA_WRITE),
        .doutb       (DATA_RDATA)
    );

    //------------------------------
    // Instantiate APBUart
    //------------------------------

    cmsdk_apb_uart UART(
        .PCLK           (clk),
        .PCLKG          (clk),
        .PRESETn        (rst_n),
        .PSEL           (UART_PSEL),
        .PADDR          (APBS_PADDR[11:2]),
        .PENABLE        (APBS_PENABLE),
        .PWRITE         (APBS_PWRITE),
        .PWDATA         (APBS_PWDATA),
        .ECOREVNUM      (4'b0),
        .PRDATA         (UART_PRDATA),
        .PREADY         (UART_PREADY),
        .PSLVERR        (UART_PSLVERR),
        .RXD            (RXD),
        .TXD            (TXD),
        .TXEN           (),
        .BAUDTICK       (),
        .TXINT          (),
        .RXINT          (),
        .TXOVRINT       (),
        .RXOVRINT       (),
        .UARTINT        ()
    );

    //------------------------------
    // Instantiate APBKeyboard
    //------------------------------

    APB_Keyboard APB_Keyboard(
        .clk            (clk),
        .rst_n          (rst_n),
        .col_in         (col_in),
        .row            (row),
        .PRDATA         (KEY_PRDATA),
        .KeyboardINT    (KeyboardINT)
    );

    //------------------------------
    // Instantiate APBTube
    //------------------------------

    APBTube APBTube(
        .clk            (clk),
        .rst_n          (rst_n),
        .PADDR          (APBS_PADDR),
        .PWRITE         (APBS_PWRITE),
        .PSEL           (TUBE_PSEL),
        .PENABLE        (APBS_PENABLE),
        .PWDATA         (APBS_PWDATA),
        .PRDATA         (TUBE_PRDATA),
        .DIG            (DIG),
        .A              (A),
        .B              (B),
        .C              (C),
        .D              (D),
        .E              (E),
        .F              (F),
        .G              (G),
        .DP             (DP)
    );

    //------------------------------
    // Instantiate APBLed
    //------------------------------

    APBLed APBLed(
        .clk            (clk),
        .rst_n          (rst_n),
        .PWRITE         (APBS_PWRITE),
        .PSEL           (LED_PSEL),
        .PENABLE        (APBS_PENABLE),
        .PWDATA         (APBS_PWDATA),
        .LED            (LED)
    );

endmodule