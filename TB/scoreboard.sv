
class scoreboard extends uvm_scoreboard;
 `uvm_component_utils(scoreboard)
  uvm_tlm_analysis_fifo #(trans)inp_mon_fifo;
  uvm_tlm_analysis_fifo #(trans)out_mon_fifo;

  trans inp_mon_xn;
  trans out_mon_xn;
  
  // Reference model state variables
  bit [`DW-1:0] oprd1, oprd2;
  bit [`CW-1:0] CMD_tmp;
  bit [`DW-1:0] AU_out_tmp1, AU_out_tmp2;
  bit [`DW-1:0] OPA_1, OPB_1;
  bit [4:0] cnt;

  bit waiting_op1;
  bit waiting_op2;

  // Better to add these also
  //bit oprd1_valid;
  //bit oprd2_valid;
 function new(string name="scoreboard",uvm_component parent);
   super.new(name,parent);
   inp_mon_fifo=new("inp_mon_fifo",this);
   out_mon_fifo=new("out_mon_fifo",this);
 endfunction

 task run_phase(uvm_phase phase);
   forever
   begin
        
	inp_mon_fifo.get(inp_mon_xn);
	out_mon_fifo.get(out_mon_xn);
	   			
	ref_model(inp_mon_xn);
	`uvm_info("REFERENCE_MODEL",$sformatf("REFERENCE_MODEL\n%s",inp_mon_xn.sprint()),UVM_NONE)
	
        validate_output();

	check_Data(out_mon_xn);
	`uvm_info("CHECKING OUTPUT ",$sformatf("CHECKING OUTPUT\n%s",out_mon_xn.sprint()),UVM_NONE)
		 
   end
 endtask


 virtual task validate_output();

  if(inp_mon_xn.compare(out_mon_xn))
  begin
       `uvm_info(get_type_name,$sformatf("DATA MATCH SUCCESSFUL"),UVM_NONE)
  end
  
  else 
  begin
       `uvm_info(get_type_name,$sformatf("DATA DISMATCH SUCCESSFUL"),UVM_NONE)
	   
       `uvm_info(get_type_name,$sformatf("Expected Packet\n%s",inp_mon_xn.sprint()),UVM_NONE)
       `uvm_info(get_type_name,$sformatf("DUT Packet\n%s",out_mon_xn.sprint()),UVM_NONE)
  end

 endtask

 task check_Data(trans ch);
	begin
	   if(inp_mon_xn.res == ch.res)
		$display("\n RES IS  MATCHING");
	   else
		$display("\n RES IS NOT MATCHING");

           if(inp_mon_xn.err == ch.err)
		$display("\n ERR IS MATCHING");
	   else
		$display("\n ERR IS NOT MATCHING");

 	   if(inp_mon_xn.cout == ch.cout)
		$display("\n COUT IS MATCHING");
	   else
		$display("\n COUT IS NOT MATCHING");

	    if(inp_mon_xn.oflow == ch.oflow)
		$display("\n OFLOW IS MATCHING");
	   else
		$display("\n OFLOW IS NOT MATCHING");

           if(inp_mon_xn.G == ch.G)
		$display("\n Greater IS MATCHING");
	   else
		$display("\n Greater IS NOT MATCHING");

	   if(inp_mon_xn.L == ch.L)
		$display("\n Lesser IS MATCHING");
	   else
		$display("\n Lesser IS NOT MATCHING");

           if(inp_mon_xn.E == ch.E)
		$display("\n Equal IS MATCHING");
	   else
		$display("\n Equal IS NOT MATCHING");
        end
 endtask
	

 virtual task ref_model(trans t);
/*
mode=1
cmd=0,1,2,3,8,9,10

mode=0
cmd=0,1,2,3,4,5,12,13
*/
      if(t.rst) begin
        oprd1=0;
        oprd2=0;
        CMD_tmp=0;
        cnt=0;
        waiting_op1 = 0;
        waiting_op2 = 0;
      end
      else begin

        if( (t.mode && t.cmd inside {[4'd0:4'd3], [4'd8:4'd10]})||
           (!t.mode && t.cmd inside {[4'd0:4'd5], [4'd12:4'd13]})  )begin
         
           // Both operands arrive together
           if (t.inp_valid == 2'b11) begin
        oprd1 = t.OA;
        oprd2 = t.OB;
        CMD_tmp = t.cmd;

        cnt = 0;
        waiting_op1 = 0;
        waiting_op2 = 0;
    end

    // OPA arrives first
    else if (t.inp_valid == 2'b01) begin
        oprd1 = t.OA;
        CMD_tmp = t.cmd;

        if (waiting_op1) begin
            // OPB had already arrived
            waiting_op1 = 0;
            cnt = 0;
        end
        else begin
            // Start waiting for OPB
            waiting_op2 = 1;
            cnt = 0;
        end
    end
        
    // OPB arrives first
    else if (t.inp_valid == 2'b10) begin
        oprd2 = t.OB;
        CMD_tmp = t.cmd;

        if (waiting_op2) begin
            // OPA had already arrived
            waiting_op2 = 0;
            cnt = 0;
        end
        else begin
            // Start waiting for OPA
            waiting_op1 = 1;
            cnt = 0;
        end
    end

    // No operand arrived
    else begin
        if (waiting_op1 || waiting_op2) begin
            cnt = cnt + 1;

            if (cnt >= 16) begin
                t.err = 1'b1;

                oprd1 = 0;
                oprd2 = 0;
                CMD_tmp = 0;

                cnt = 0;
                waiting_op1 = 0;
                waiting_op2 = 0;
            end
        end
    end

      end
        if(t.ce)                   
        begin
         if(t.rst)                
          begin
            t.res={`DW*2{1'b0}};
            t.cout=1'b0;
            t.oflow=1'b0;
            t.G=1'b0;
            t.E=1'b0;
            t.L=1'b0;
            t.err=1'b0;
	    AU_out_tmp1=0;
            AU_out_tmp2=0;
            cnt=0;
	  end
 
         else if(t.mode)          
         begin
            t.res={`DW*2{1'b0}};
            t.cout=1'b0;
            t.oflow=1'b0;
            t.G=1'b0;
            t.E=1'b0;
            t.L=1'b0;
            t.err=1'b0;
            cnt=0;
	case(CMD_tmp)             
    4'b0000: begin            
              t.res=oprd1+oprd2;
	      t.cout=t.res[`DW]?1:0;
            end
     4'b0001 :begin
             t.oflow=(oprd1<oprd2)?1:0;
             t.res=oprd1-oprd2;
            end
     4'b0010:            
            begin
             t.res=oprd1+oprd2+t.cin;
             t.cout=t.res[`DW]?1:0;
            end
     4'b0011:             
           begin
            t.oflow=(oprd1<oprd2)?1:0;
            t.res=oprd1-oprd2-t.cin;
           end
     4'b0100:t.res=oprd1+1;     
     4'b0101:t.res=oprd1-1;    
     4'b0110:t.res=oprd2+1;     
     4'b0111:t.res=oprd2-1; 
     4'b1000:              
           begin
            t.res={`DW*2{1'b0}};
            if(oprd1==oprd2)
             begin
               t.E=1'b1;
               t.G=1'b0;
               t.L=1'b0;
             end
            else if(oprd1>oprd2)
             begin
               t.E=1'b0;
               t.G=1'b1;
               t.L=1'b0;
             end
            else 
             begin
               t.E=1'b0;
               t.G=1'b0;
               t.L=1'b1;
             end
           end

	4'b1001: begin   
                    AU_out_tmp1 = oprd1 + 1;
                    AU_out_tmp2 = oprd2 + 1;
                    t.res =AU_out_tmp1 * AU_out_tmp2;
                  end
	4'b1010: begin   
                    AU_out_tmp1 = oprd1 << 1;
                    AU_out_tmp2 = oprd2;
                    t.res =AU_out_tmp1 * AU_out_tmp2; 
                  end

	default:   
            begin
            t.res={`DW*2{1'b0}};;
            t.cout=1'b0;
            t.oflow=1'b0;
            t.G=1'b0;
            t.E=1'b0;
            t.L=1'b0;
            t.err=1'b0;
            cnt=0;
           end
          endcase
         end

	else          
        begin 
            t.res={`DW*2{1'b0}};;
            t.cout=1'b0;
            t.oflow=1'b0;
            t.G=1'b0;
            t.E=1'b0;
            t.L=1'b0;
            t.err=1'b0;
            cnt=0;
	case(CMD_tmp)    
             4'b0000:t.res={{`DW{1'b0}},oprd1&oprd2};     
             4'b0001:t.res={{`DW{1'b0}},~(oprd1&oprd2)};
	     4'b0010:t.res={{`DW{1'b0}},oprd1|oprd2};  
 	     4'b0011:t.res={{`DW{1'b0}},~(oprd1|oprd2)};
	     4'b0100:t.res={{`DW{1'b0}},oprd1^oprd2};     
             4'b0101:t.res={{`DW{1'b0}},~(oprd1^oprd2)};  
 	     4'b0110:t.res={{`DW{1'b0}},~oprd1};       
             4'b0111:t.res={{`DW{1'b0}},~oprd2};        
	     4'b1000:t.res={{`DW{1'b0}},oprd1>>1};       
             4'b1001:t.res={{`DW{1'b0}},oprd1<<1};
	     4'b1010:t.res={{`DW{1'b0}},oprd2>>1};      
             4'b1011:t.res={{`DW{1'b0}},oprd2<<1};      
	     4'b1100:                        
             begin 
               if(oprd2[0])
                 OPA_1 = {oprd1[6:0], oprd1[7]};
               else
                 OPA_1 = oprd1;
 
               if(oprd2[1])
                 OPB_1 =  {OPA_1[5:0], OPA_1[7:6]}; 
               else
                 OPB_1= OPA_1;
 
               if(oprd2[2])
                 t.res =  {OPB_1[3:0], OPB_1[7:4]} ;
               else
                 t.res = OPB_1;
 
               if(oprd2[4] | oprd2[5] | oprd2[6] | oprd2[7])
                 t.err=1'b1;
             end

	4'b1101:                       
             begin
               if(oprd2[0])
                 OPA_1 = {oprd1[0], oprd1[7:1]};
               else
                 OPA_1 = oprd1;
               if(oprd2[1])
                 OPB_1 =  {OPA_1[1:0], OPA_1[7:2]}; 
               else
                 OPB_1= OPA_1;
               if(oprd2[2])
                 t.res =  {OPB_1[3:0], OPB_1[7:4]} ;
               else
                 t.res = OPB_1;
               if(oprd2[4] | oprd2[5] | oprd2[6] | oprd2[7])
                 t.err=1'b1;
             end
             default:    
               begin
               t.res={`DW*2{1'b0}};;
               t.cout=1'b0;
               t.oflow=1'b0;
               t.G=1'b0;
               t.E=1'b0;
               t.L=1'b0;
               t.err=1'b0;
               cnt=0;
               end
          endcase
     end
    end
   end
endtask 


endclass
