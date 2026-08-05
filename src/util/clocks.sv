module clocks (
    input  logic clk,
    input  logic rst,
    output logic clkVga,
    output logic locked
);

// PLL to generate slower VGA clock
wire clkout, clkfbout, clkfbuf;
PLLE2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .COMPENSATION("ZHOLD"),
    .STARTUP_WAIT("FALSE"),

    // Master division value (1-56)
    .DIVCLK_DIVIDE(3),        

    // Feedback clock parans
    .CLKFBOUT_MULT(37),
    .CLKFBOUT_PHASE(0.0),

    // Input clock params
    .CLKIN1_PERIOD(10.0),

    // Output clock params
    .CLKOUT0_DIVIDE(49),
    .CLKOUT0_PHASE(0.0),
    .CLKOUT0_DUTY_CYCLE(0.5)

) pll (
    // Output clocks
    .CLKOUT0(clkout),
    .CLKOUT1(),
    .CLKOUT2(),
    .CLKOUT3(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKFBOUT(clkfbout),

    // Input clocks
    .CLKIN1(clk),
    .CLKIN2(1'b0),
    .CLKFBIN(clkfbuf),

    // Control Ports
    .CLKINSEL(1'b1),
    .LOCKED(locked),
    .PWRDWN(1'b0),
    .RST(rst),

    // DRP Ports
    .DADDR(7'h0),
    .DCLK(1'b0),
    .DEN(1'b0),
    .DI(16'h0),
    .DO(),
    .DRDY(),
    .DWE(1'b0)
);

// Output buffers
BUFG fbuf (.I(clkfbout), .O(clkfbuf));
BUFG obuf (.I(clkout), .O(clkVga));

endmodule