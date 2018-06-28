
//###############################################################
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//###############################################################



`include "svunit_defines.svh"
`include "svunit_uvm_mock_pkg.sv"
import uvm_pkg::*;
`include "riscv_vip_uvc_pkg.sv"
import riscv_vip_pkg::*;
import riscv_vip_uvc_pkg::*;
import svunit_uvm_mock_pkg::*;

class uvc_env_uvm_wrapper extends riscv_vip_uvc_pkg::uvc_env;

  `uvm_component_utils(uvc_env_uvm_wrapper)
  function new(string name = "uvc_env_uvm_wrapper", uvm_component parent);
    super.new(name, parent);
  endfunction

  //===================================
  // Build
  //===================================
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    /* Place Build Code Here */
  endfunction

  //==================================
  // Connect
  //=================================
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    /* Place Connection Code Here */
  endfunction
endclass

module uvc_env_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "uvc_env_ut";
  svunit_testcase svunit_ut;


  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  uvc_env_uvm_wrapper my_uvc_env;

  logic clk;
  logic rstn; 
  riscv_vip_if my_if(.*);
   

   
  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);

    my_uvc_env = uvc_env_uvm_wrapper::type_id::create("", null);

    uvm_config_db#(virtual riscv_vip_if)::set(uvm_root::get(), "", "m_vi",my_if);
    uvm_config_db#(int)::set(uvm_root::get(), "", "m_core_id",199);     
    
    svunit_deactivate_uvm_component(my_uvc_env);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */
    clk = 0;
    rstn = 1;
    #1
    rstn = 0;


    
    svunit_activate_uvm_component(my_uvc_env);

    //-----------------------------
    // start the testing phase
    //-----------------------------
    svunit_uvm_test_start();



  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    //-----------------------------
    // terminate the testing phase 
    //-----------------------------
    svunit_uvm_test_finish();

    /* Place Teardown Code Here */

    svunit_deactivate_uvm_component(my_uvc_env);
  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  `SVTEST(some_insts)    

    const logic [31:0] pc_insts [][2] = '{
	 {0,		  i_inst_t'{imm:99    ,rs1:2,   funct3:3,   rd:1, op:LOAD}},
         {4,  	          i_inst_t'{imm:'hFF  ,rs1:1,   funct3:2,   rd:5, op:SYSTEM}},		
         {8,         	  r_inst_t'{funct7:1, rs2:1, rs1:1, funct3:2, rd:2, op:OP}}
                                          };
   

    // Toggle interface pins
   foreach(pc_insts[i,]) begin
     my_if.curr_pc = pc_insts[i][0];
     my_if.curr_inst = pc_insts[i][1];
     toggle_clock();

   end

    // Stop monitor
    disable run;

  `SVTEST_END

  `SVUNIT_TESTS_END


  task toggle_clock();
    repeat (2) #5 clk = ~clk;
  endtask



endmodule