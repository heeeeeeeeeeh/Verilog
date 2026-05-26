`timescale 1ns / 1ps

// =============================================================
//  Testbench for bcd.v  -  N=16 (4 digits), N=24 (6 digits),
//                           N=32 (8 digits) tested in parallel
//
//  AddSub = 0 → addition
//  AddSub = 1 → subtraction (10's complement via compliment.v)
//
//  BCD encoding: least-significant digit in bits [3:0],
//  next digit in [7:4], etc.
//
//  Each DUT runs in its own initial block simultaneously,
//  so total sim time = longest single DUT's test sequence.
// =============================================================

module bcd_tb;

    // ========================================================
    //  4-DIGIT DUT  (N=16)
    // ========================================================
    reg  [15:0] A4, B4;
    reg         AS4;
    wire [15:0] D4;
    wire        Cout4;

    bcd #(.N(16)) dut4 (
        .A(A4), .B(B4), .AddSub(AS4), .D(D4), .Cout(Cout4)
    );

    // ========================================================
    //  6-DIGIT DUT  (N=24)
    // ========================================================
    reg  [23:0] A6, B6;
    reg         AS6;
    wire [23:0] D6;
    wire        Cout6;

    bcd #(.N(24)) dut6 (
        .A(A6), .B(B6), .AddSub(AS6), .D(D6), .Cout(Cout6)
    );

    // ========================================================
    //  8-DIGIT DUT  (N=32)
    // ========================================================
    reg  [31:0] A8, B8;
    reg         AS8;
    wire [31:0] D8;
    wire        Cout8;

    bcd #(.N(32)) dut8 (
        .A(A8), .B(B8), .AddSub(AS8), .D(D8), .Cout(Cout8)
    );

    // ========================================================
    //  4-DIGIT tests
    // ========================================================
    integer pass4, fail4;

    initial begin
        pass4 = 0; fail4 = 0;
        A4 = 0; B4 = 0; AS4 = 0;

        $display("============================================");
        $display("  4-Digit (N=16) Tests");
        $display("============================================");

        // --- Addition ---
        // 0000 + 0000 = 0000
        A4=16'h0000; B4=16'h0000; AS4=0; #10;
        if (D4===16'h0000 && Cout4===1'b0) begin $display("PASS [4] 0000+0000=0000");         pass4=pass4+1; end
        else begin $display("FAIL [4] 0000+0000=0000  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 0001 + 0001 = 0002
        A4=16'h0001; B4=16'h0001; AS4=0; #10;
        if (D4===16'h0002 && Cout4===1'b0) begin $display("PASS [4] 0001+0001=0002");         pass4=pass4+1; end
        else begin $display("FAIL [4] 0001+0001=0002  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 0005 + 0005 = 0010 (intra-digit carry)
        A4=16'h0005; B4=16'h0005; AS4=0; #10;
        if (D4===16'h0010 && Cout4===1'b0) begin $display("PASS [4] 0005+0005=0010");         pass4=pass4+1; end
        else begin $display("FAIL [4] 0005+0005=0010  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 0099 + 0001 = 0100
        A4=16'h0099; B4=16'h0001; AS4=0; #10;
        if (D4===16'h0100 && Cout4===1'b0) begin $display("PASS [4] 0099+0001=0100");         pass4=pass4+1; end
        else begin $display("FAIL [4] 0099+0001=0100  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 1234 + 5678 = 6912
        A4=16'h1234; B4=16'h5678; AS4=0; #10;
        if (D4===16'h6912 && Cout4===1'b0) begin $display("PASS [4] 1234+5678=6912");         pass4=pass4+1; end
        else begin $display("FAIL [4] 1234+5678=6912  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 9999 + 0001 = 0000 Cout=1
        A4=16'h9999; B4=16'h0001; AS4=0; #10;
        if (D4===16'h0000 && Cout4===1'b1) begin $display("PASS [4] 9999+0001=0000 Cout=1");  pass4=pass4+1; end
        else begin $display("FAIL [4] 9999+0001=0000  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 5000 + 5000 = 0000 Cout=1
        A4=16'h5000; B4=16'h5000; AS4=0; #10;
        if (D4===16'h0000 && Cout4===1'b1) begin $display("PASS [4] 5000+5000=0000 Cout=1");  pass4=pass4+1; end
        else begin $display("FAIL [4] 5000+5000=0000  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // --- Subtraction ---
        // 0005 - 0003 = 0002
        A4=16'h0005; B4=16'h0003; AS4=1; #10;
        if (D4===16'h0002 && Cout4===1'b1) begin $display("PASS [4] 0005-0003=0002");         pass4=pass4+1; end
        else begin $display("FAIL [4] 0005-0003=0002  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 0010 - 0001 = 0009
        A4=16'h0010; B4=16'h0001; AS4=1; #10;
        if (D4===16'h0009 && Cout4===1'b1) begin $display("PASS [4] 0010-0001=0009");         pass4=pass4+1; end
        else begin $display("FAIL [4] 0010-0001=0009  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 1000 - 0001 = 0999
        A4=16'h1000; B4=16'h0001; AS4=1; #10;
        if (D4===16'h0999 && Cout4===1'b1) begin $display("PASS [4] 1000-0001=0999");         pass4=pass4+1; end
        else begin $display("FAIL [4] 1000-0001=0999  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        // 0003 - 0005 = 9998 (borrow)
        A4=16'h0003; B4=16'h0005; AS4=1; #10;
        if (D4===16'h9998 && Cout4===1'b0) begin $display("PASS [4] 0003-0005=9998 (borrow)"); pass4=pass4+1; end
        else begin $display("FAIL [4] 0003-0005=9998  got D=%h Cout=%b",D4,Cout4);             fail4=fail4+1; end
        #20;

        // 0000 - 0001 = 9999 (borrow)
        A4=16'h0000; B4=16'h0001; AS4=1; #10;
        if (D4===16'h9999 && Cout4===1'b0) begin $display("PASS [4] 0000-0001=9999 (borrow)"); pass4=pass4+1; end
        else begin $display("FAIL [4] 0000-0001=9999  got D=%h Cout=%b",D4,Cout4);             fail4=fail4+1; end
        #20;

        // 5678 - 1234 = 4444
        A4=16'h5678; B4=16'h1234; AS4=1; #10;
        if (D4===16'h4444 && Cout4===1'b1) begin $display("PASS [4] 5678-1234=4444");         pass4=pass4+1; end
        else begin $display("FAIL [4] 5678-1234=4444  got D=%h Cout=%b",D4,Cout4);            fail4=fail4+1; end
        #20;

        $display("--------------------------------------------");
        $display("  4-Digit results: %0d passed, %0d failed", pass4, fail4);
        $display("--------------------------------------------");
    end

    // ========================================================
    //  6-DIGIT tests
    // ========================================================
    integer pass6, fail6;

    initial begin
        pass6 = 0; fail6 = 0;
        A6 = 0; B6 = 0; AS6 = 0;

        $display("============================================");
        $display("  6-Digit (N=24) Tests");
        $display("============================================");

        // --- Addition ---
        A6=24'h000000; B6=24'h000000; AS6=0; #10;
        if (D6===24'h000000 && Cout6===1'b0) begin $display("PASS [6] 000000+000000=000000");         pass6=pass6+1; end
        else begin $display("FAIL [6] 000000+000000=000000  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h000001; B6=24'h000009; AS6=0; #10;
        if (D6===24'h000010 && Cout6===1'b0) begin $display("PASS [6] 000001+000009=000010");         pass6=pass6+1; end
        else begin $display("FAIL [6] 000001+000009=000010  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h000099; B6=24'h000001; AS6=0; #10;
        if (D6===24'h000100 && Cout6===1'b0) begin $display("PASS [6] 000099+000001=000100");         pass6=pass6+1; end
        else begin $display("FAIL [6] 000099+000001=000100  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h123456; B6=24'h654321; AS6=0; #10;
        if (D6===24'h777777 && Cout6===1'b0) begin $display("PASS [6] 123456+654321=777777");         pass6=pass6+1; end
        else begin $display("FAIL [6] 123456+654321=777777  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h999999; B6=24'h000001; AS6=0; #10;
        if (D6===24'h000000 && Cout6===1'b1) begin $display("PASS [6] 999999+000001=000000 Cout=1");  pass6=pass6+1; end
        else begin $display("FAIL [6] 999999+000001=000000  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h500000; B6=24'h500000; AS6=0; #10;
        if (D6===24'h000000 && Cout6===1'b1) begin $display("PASS [6] 500000+500000=000000 Cout=1");  pass6=pass6+1; end
        else begin $display("FAIL [6] 500000+500000=000000  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        // --- Subtraction ---
        A6=24'h777777; B6=24'h654321; AS6=1; #10;
        if (D6===24'h123456 && Cout6===1'b1) begin $display("PASS [6] 777777-654321=123456");         pass6=pass6+1; end
        else begin $display("FAIL [6] 777777-654321=123456  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h000100; B6=24'h000001; AS6=1; #10;
        if (D6===24'h000099 && Cout6===1'b1) begin $display("PASS [6] 000100-000001=000099");         pass6=pass6+1; end
        else begin $display("FAIL [6] 000100-000001=000099  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        A6=24'h000000; B6=24'h000001; AS6=1; #10;
        if (D6===24'h999999 && Cout6===1'b0) begin $display("PASS [6] 000000-000001=999999 (borrow)"); pass6=pass6+1; end
        else begin $display("FAIL [6] 000000-000001=999999  got D=%h Cout=%b",D6,Cout6);               fail6=fail6+1; end
        #20;

        A6=24'h100000; B6=24'h000001; AS6=1; #10;
        if (D6===24'h099999 && Cout6===1'b1) begin $display("PASS [6] 100000-000001=099999");         pass6=pass6+1; end
        else begin $display("FAIL [6] 100000-000001=099999  got D=%h Cout=%b",D6,Cout6);              fail6=fail6+1; end
        #20;

        $display("--------------------------------------------");
        $display("  6-Digit results: %0d passed, %0d failed", pass6, fail6);
        $display("--------------------------------------------");
    end

    // ========================================================
    //  8-DIGIT tests
    // ========================================================
    integer pass8, fail8;

    initial begin
        pass8 = 0; fail8 = 0;
        A8 = 0; B8 = 0; AS8 = 0;

        $display("============================================");
        $display("  8-Digit (N=32) Tests");
        $display("============================================");

        // --- Addition ---
        A8=32'h00000000; B8=32'h00000000; AS8=0; #10;
        if (D8===32'h00000000 && Cout8===1'b0) begin $display("PASS [8] 00000000+00000000=00000000");         pass8=pass8+1; end
        else begin $display("FAIL [8] 00000000+00000000=00000000  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h00000001; B8=32'h00000009; AS8=0; #10;
        if (D8===32'h00000010 && Cout8===1'b0) begin $display("PASS [8] 00000001+00000009=00000010");         pass8=pass8+1; end
        else begin $display("FAIL [8] 00000001+00000009=00000010  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h00000099; B8=32'h00000001; AS8=0; #10;
        if (D8===32'h00000100 && Cout8===1'b0) begin $display("PASS [8] 00000099+00000001=00000100");         pass8=pass8+1; end
        else begin $display("FAIL [8] 00000099+00000001=00000100  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h12345678; B8=32'h87654321; AS8=0; #10;
        if (D8===32'h99999999 && Cout8===1'b0) begin $display("PASS [8] 12345678+87654321=99999999");         pass8=pass8+1; end
        else begin $display("FAIL [8] 12345678+87654321=99999999  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h99999999; B8=32'h00000001; AS8=0; #10;
        if (D8===32'h00000000 && Cout8===1'b1) begin $display("PASS [8] 99999999+00000001=00000000 Cout=1");  pass8=pass8+1; end
        else begin $display("FAIL [8] 99999999+00000001=00000000  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h50000000; B8=32'h50000000; AS8=0; #10;
        if (D8===32'h00000000 && Cout8===1'b1) begin $display("PASS [8] 50000000+50000000=00000000 Cout=1");  pass8=pass8+1; end
        else begin $display("FAIL [8] 50000000+50000000=00000000  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h11111111; B8=32'h22222222; AS8=0; #10;
        if (D8===32'h33333333 && Cout8===1'b0) begin $display("PASS [8] 11111111+22222222=33333333");         pass8=pass8+1; end
        else begin $display("FAIL [8] 11111111+22222222=33333333  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        // --- Subtraction ---
        A8=32'h99999999; B8=32'h12345678; AS8=1; #10;
        if (D8===32'h87654321 && Cout8===1'b1) begin $display("PASS [8] 99999999-12345678=87654321");         pass8=pass8+1; end
        else begin $display("FAIL [8] 99999999-12345678=87654321  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h33333333; B8=32'h22222222; AS8=1; #10;
        if (D8===32'h11111111 && Cout8===1'b1) begin $display("PASS [8] 33333333-22222222=11111111");         pass8=pass8+1; end
        else begin $display("FAIL [8] 33333333-22222222=11111111  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h00000100; B8=32'h00000001; AS8=1; #10;
        if (D8===32'h00000099 && Cout8===1'b1) begin $display("PASS [8] 00000100-00000001=00000099");         pass8=pass8+1; end
        else begin $display("FAIL [8] 00000100-00000001=00000099  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h10000000; B8=32'h00000001; AS8=1; #10;
        if (D8===32'h09999999 && Cout8===1'b1) begin $display("PASS [8] 10000000-00000001=09999999");         pass8=pass8+1; end
        else begin $display("FAIL [8] 10000000-00000001=09999999  got D=%h Cout=%b",D8,Cout8);                fail8=fail8+1; end
        #20;

        A8=32'h00000000; B8=32'h00000001; AS8=1; #10;
        if (D8===32'h99999999 && Cout8===1'b0) begin $display("PASS [8] 00000000-00000001=99999999 (borrow)"); pass8=pass8+1; end
        else begin $display("FAIL [8] 00000000-00000001=99999999  got D=%h Cout=%b",D8,Cout8);                 fail8=fail8+1; end
        #20;

        A8=32'h00000003; B8=32'h00000005; AS8=1; #10;
        if (D8===32'h99999998 && Cout8===1'b0) begin $display("PASS [8] 00000003-00000005=99999998 (borrow)"); pass8=pass8+1; end
        else begin $display("FAIL [8] 00000003-00000005=99999998  got D=%h Cout=%b",D8,Cout8);                 fail8=fail8+1; end
        #20;

        $display("--------------------------------------------");
        $display("  8-Digit results: %0d passed, %0d failed", pass8, fail8);
        $display("--------------------------------------------");
    end

endmodule