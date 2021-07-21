// Code your testbench here
// or browse Examples
//Test Bench
module t_task4_2();
  wire done;
  wire [95:0] yout;
  reg start,clk,data;
  task4_2 T4_2(yout,done,data,start,clk);
  
  initial begin
    clk=1'b0;
    #6 start=1'b0;
    #1 start=1'b1;
    #10 start=1'b0;
  end
  
  always #5 clk=~clk;
  
  initial #1000 $finish;
  initial begin        //Input taken is 32'h03_01_02_03
    #17 data=0;		   
    #10 data=0;
    #10 data=0;
    #10 data=0;//
    #10 data=0;
    #10 data=0;
    #10 data=1;
    #10 data=1;//8
    #10 data=0;
    #10 data=0;
    #10 data=0;
    #10 data=0;//
    #10 data=0;
    #10 data=0;
    #10 data=0;
    #10 data=1;//8
    #10 data=0;
    #10 data=0;
    #10 data=0;
    #10 data=0;//
    #10 data=0;
    #10 data=0;
    #10 data=1;
    #10 data=0;//8
    #10 data=0;
    #10 data=0;
    #10 data=0;
    #10 data=0;//
    #10 data=0;
    #10 data=0;
    #10 data=1;
    #10 data=1;//8
  end
  
  initial begin
    $monitor($time,"- %h , %b , %h",yout,done,T4_2.fec2);
  end
  
  initial begin
    $dumpfile ("t_task4_2.vcd"); $dumpvars (0, t_task4_2);
  end
endmodule