
class test extends uvm_test;
 
 `uvm_component_utils(test)

 env env_h;
 alu_config m_cfg;

 function new(string name="test",uvm_component parent);
   super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  m_cfg=alu_config::type_id::create("m_cfg");
  //virtual_get
  if(!uvm_config_db#(virtual alu_if)::get(this,"","alu_if",m_cfg.vif))	
    `uvm_fatal(get_type_name(),"Can't get the interface")

  m_cfg.input_agent_is_active=UVM_ACTIVE;
  m_cfg.output_agent_is_active=UVM_PASSIVE;

  uvm_config_db#(alu_config)::set(this,"*","alu_config",m_cfg);

  env_h=env::type_id::create("env_h",this);

 endfunction

 function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
   uvm_top.print_topology();
 endfunction

endclass


class test1 extends test;
 `uvm_component_utils(test1)

   err_seq e1;
   logical_seq ls1;
   arithmetic_seq as1;
   corner_case_seq ccs1;
   direct_test_case_arth dsa1;
   direct_test_case_logic dsl1;
   reset_seq rs1;
   wait_16clk_seq w1;
 function new(string name="test1",uvm_component parent);
   super.new(name,parent);
 endfunction


// function void build_phase(uvm_phase phase);
//   super.build_phase(phase);
// endfunction


 task run_phase(uvm_phase phase);

	phase.raise_objection(this);
	e1=err_seq::type_id::create("e1");
        ls1=logical_seq::type_id::create("ls1");
        as1=arithmetic_seq::type_id::create("as1");
        ccs1=corner_case_seq::type_id::create("ccs1");
	dsa1=direct_test_case_arth::type_id::create("dsa1");
        dsl1=direct_test_case_logic::type_id::create("dsl1");
        rs1=reset_seq::type_id::create("rs1");
        w1=wait_16clk_seq::type_id::create("w1");

	as1.start(env_h.inp_agt_h.seqr_h);
	ls1.start(env_h.inp_agt_h.seqr_h);
	ccs1.start(env_h.inp_agt_h.seqr_h);
	e1.start(env_h.inp_agt_h.seqr_h);
        dsa1.start(env_h.inp_agt_h.seqr_h);
	dsl1.start(env_h.inp_agt_h.seqr_h);
	rs1.start(env_h.inp_agt_h.seqr_h);
        w1.start(env_h.inp_agt_h.seqr_h);
	#50;
	phase.drop_objection(this);


 endtask

endclass
 

