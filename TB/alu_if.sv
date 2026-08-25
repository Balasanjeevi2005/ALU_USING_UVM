interface alu_if (input bit clk);

logic[`DW-1:0]OA;
logic[`DW-1:0]OB;
logic[1:0]inp_valid;
logic[`CW-1:0]cmd;
logic[`DW*2-1:0]res;
logic rst,mode,ce,cin,err,oflow,cout,G,E,L;

clocking inp_dr_cb@(posedge clk);
	default input #1 output #1;
	output OA;
	output OB;
	output inp_valid;
	output cmd;
	output mode,cin,ce,rst;
endclocking

clocking inp_mon_cb@(posedge clk);
	default input #1 output #1;
	input OA;
	input OB;
	input inp_valid;
	input cmd;
	input mode,cin,ce,rst;
endclocking


clocking out_mon_cb@(posedge clk);
	default input #1 output #1;
	input OA;
	input OB;
	input inp_valid;
	input cmd;
	input mode,cin,ce,rst;
	input err,res,oflow,cout,G,E,L;

endclocking 

modport INP_DRV(clocking inp_dr_cb);
modport INP_MON(clocking inp_mon_cb);
modport OUT_MON(clocking out_mon_cb);

endinterface

