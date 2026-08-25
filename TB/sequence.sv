class err_seq extends uvm_sequence #(trans);
 `uvm_object_utils(err_seq) 

 function new(string name="err_seq");
   super.new(name);
 endfunction

 task body();
  repeat (5)
  begin

   // ROTATE LEFT
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode==0;
      cmd==4'b1100;
      inp_valid==2'b11;
      ce==1;
      OB[7:4]!=4'b0000;   // error case
    });
    finish_item(req);

   // ROTATE RIGHT
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode==0;
      cmd==4'b1101;
      inp_valid==2'b11;
      ce==1;
      OB[7:4]!=4'b0000;   // error case
    });
    finish_item(req);

  end
 endtask

endclass

//=============================================================================================================
//ARITHMETIC OPERATIONS
//=============================================================================================================
class arithmetic_seq extends uvm_sequence #(trans);
  `uvm_object_utils(arithmetic_seq)

  function new(string name="arithmetic_seq");
    super.new(name);
  endfunction

  task body();
    repeat(50)
    begin
     for (int i = 0; i <= 10; i++) begin
      req = trans::type_id::create($sformatf("req_%0d", i));
      start_item(req);
      assert(req.randomize() with {
        mode == 1;
        ce   == 1;
        cmd  == i;
      });
      finish_item(req);
     end
    end
  endtask

endclass


//=============================================================================================================
//LOGICAL OPERATION
//=============================================================================================================
class logical_seq extends uvm_sequence #(trans);
  `uvm_object_utils(logical_seq)

  function new(string name="logical_seq");
    super.new(name);
  endfunction

  task body();
    repeat(50)
    begin
     for (int i = 0; i <= 13; i++) begin
      req = trans::type_id::create($sformatf("req_%0d", i));
      start_item(req);
      assert(req.randomize() with {
        mode == 0;
        ce   == 1;
        cmd  == i;
      });
      finish_item(req);
     end
    end
  endtask

endclass

//=============================================================================================================
//DIRECT ARITHMETIC
//=============================================================================================================
class direct_test_case_arth extends uvm_sequence #(trans);
  `uvm_object_utils(direct_test_case_arth)
   
  function new(string name="direct_test_case_arth");
    super.new(name);
  endfunction

  task body();
   for (int k = 0; k <= 3; k++) begin 
    for (int j = 0; j <= 1; j++) begin
     for (int i = 0; i <= 10; i++) begin

      // 0,0
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b0}};
        OB=={`DW{1'b0}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

      // 0,255
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b0}};
        OB=={`DW{1'b1}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

      // 255,0
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b1}};
        OB=={`DW{1'b0}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

      // 255,255
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b1}};
        OB=={`DW{1'b1}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

     end
    end
   end
  endtask

endclass

//=============================================================================================================
//DIRECT LOGICAL
//=============================================================================================================
class direct_test_case_logic extends uvm_sequence #(trans);
  `uvm_object_utils(direct_test_case_logic)
   
  function new(string name="direct_test_case_logic");
    super.new(name);
  endfunction

  task body();
  for (int k = 0; k <= 3; k++) begin
   for (int j = 0; j <= 1; j++) begin
    for (int i = 0; i <= 10; i++) begin
      // 0,0
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b0}};
        OB=={`DW{1'b0}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

      // 0,255
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b0}};
        OB=={`DW{1'b1}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

      // 255,0
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b1}};
        OB=={`DW{1'b0}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

      // 255,255
      req = trans::type_id::create($sformatf("req_i%0d_j%0d_k%0d ", i,j,k));
      start_item(req);
      assert(req.randomize() with {
        mode==1;
        cmd==i;
        OA=={`DW{1'b1}};
        OB=={`DW{1'b1}};
        ce==1;
        inp_valid==k;
        cin==j;
      });
      finish_item(req);

     end
    end
   end
  endtask

endclass



//=============================================================================================================
//CORNER CASES
//=============================================================================================================
class corner_case_seq extends uvm_sequence #(trans);
  `uvm_object_utils(corner_case_seq)

  function new(string name="corner_case_seq");
    super.new(name);
  endfunction

  task body();

    //====================================================
    // CE = 0
    //====================================================
    repeat(50)
    begin
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      ce == 0;
    });
    finish_item(req);
    end
    
    for (int l = 0; l <= 7; l++) begin
    //====================================================
    // Rotate Left Error
    //====================================================
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1100;
      OA        == 8'b1000_0001;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);
    
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1100;
      OA        == 8'b1000_0000;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);

    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1100;
      OA        == 8'b0000_0001;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);
    
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1100;
      OA        == 8'b0111_1110;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);

    //====================================================
    // Rotate Right Error
    //====================================================
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1101;
      OA        == 8'b1000_0001;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);
   
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1101;
      OA        == 8'b1000_0000;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);
   
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1101;
      OA        == 8'b0000_0001;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);
   
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      mode      == 0;
      cmd       == 4'b1101;
      OA        == 8'b0111_1110;
      OB        == l;
      inp_valid == 2'b11;
      ce        == 1;
    });
    finish_item(req);
   end
  endtask

endclass

//=============================================================================================================
//RESET CASES
//=============================================================================================================
class reset_seq extends uvm_sequence #(trans);
  `uvm_object_utils(reset_seq)

  function new(string name="reset_seq");
    super.new(name);
  endfunction

  task body();
   
    repeat (5)begin

    req = trans::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      ce == 1;
    });

    req.rst = 1'b1;

    finish_item(req);
    
    end
    // Hold reset for a few clock cycles if required
    
    req = trans::type_id::create("req");

    start_item(req);

    assert(req.randomize() with {
      ce == 1;
    });

    req.rst = 1'b0;

    finish_item(req);
    

  endtask
endclass

class wait_16clk_seq extends uvm_sequence #(trans);
  `uvm_object_utils(wait_16clk_seq)

  function new(string name="wait_16clk_seq");
    super.new(name);
  endfunction

  task body();

    // Cycle 1 : OPA arrives
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      ce        == 1;
      mode      == 1;
      inp_valid == 2'b01;
      OA        == 8'd20;
    });
    finish_item(req);


    // Cycle 2 : nothing
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      ce        == 1;
      inp_valid == 2'b00;
    });
    finish_item(req);


    // Cycle 3 : nothing
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      ce        == 1;
      inp_valid == 2'b00;
    });
    finish_item(req);


    // Cycle 4 : OPB arrives
    req = trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {
      ce        == 1;
      mode      == 1;
      inp_valid == 2'b10;
      OB        == 8'd10;
    });
    finish_item(req);

  endtask
endclass






