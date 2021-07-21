// Code your design here
//Design
module task2 #(parameter x=32)			//CRC
  ( output reg [15:0]r,
   output reg [25:0]data_out,
   output reg done,
             input  data,start,clk);
  
  reg [7:0]b;
  always@(posedge clk or posedge start)
    begin
      if(start) begin r<=16'hFFFF;b<=1'b0;done<=1'b0;end
      else if(~done) begin
        r[0]<=data+r[15];
        r[1]<=r[0];
        r[2]<=data+r[1]+r[15];
        r[14:3]<=r[13:2];
        r[15]<=r[14]+r[15]+data;
        b<=b+1;
        if(b>=23)
          begin
            data_out[(x-b+2)*2]<=r[5]^r[4]^r[3]^r[2];
            data_out[(x-b+2)*2+1]<=r[5]^r[4]^r[2];
          end
        if(b==x-1) 
          begin
            done<=1'b1;                       
          end
      end
      else
        begin
          data_out[25]<=r[15]^r[14]^r[12];
          data_out[24]<=r[15]^r[14]^r[13]^r[12];
          data_out[5]<=r[5]^r[4]^r[2];
          data_out[4]<=r[5]^r[4]^r[3]^r[2];
          data_out[3]<=r[4]^r[3]^r[1];
          data_out[2]<=r[4]^r[3]^r[2]^r[1];
          data_out[1]<=r[3]^r[2]^r[0];
          data_out[0]<=r[3]^r[2]^r[1]^r[0];
        end
    end
endmodule

module task3#(parameter x =32, k=4)(output reg [2*x-1:0]fec,
                                    output reg done,
                                    output reg [3:0]r,
                              input data,start,clk);
  reg [7:0] b;
   
  always@(posedge clk or posedge start)
    begin
      if(start) begin r<=0;b<=2*x+2;done<=1'b0;fec<=0;end
      else if(~done)
        begin
          if(b!=2)begin r[0]<=data;
            r[3:1]<=r[2:0];end
          fec[b-2]<=r[3]^r[2]^r[1]^r[0];
          fec[b-1]<=r[3]^r[2]^r[0];
          b<=b-2;
          if(b==2) done<=1'b1;
        end
    end
        
endmodule

module interleaver_4byte (
  input [7:0] byte0,		
  input [7:0] byte1,
  input [7:0] byte2,
  input [7:0] byte3, 
  output [7:0] out0,
  output [7:0] out1,
  output [7:0] out2,
  output [7:0] out3
  );
  assign out3 = {byte3[7:6],byte2[7:6],byte1[7:6],byte0[7:6]};
  assign out2 = {byte3[5:4],byte2[5:4],byte1[5:4],byte0[5:4]};
  assign out1 = {byte3[3:2],byte2[3:2],byte1[3:2],byte0[3:2]};
  assign out0 = {byte3[1:0],byte2[1:0],byte1[1:0],byte0[1:0]};
  
  //always@(*)
  //  begin
  //    for(i=0;i<12;i=i+1)
  //      begin
  //        out[:] =
  //      end
  //  end
  
  
  
endmodule

module interleaver (output [95:0] data_out,
             input [95:0] data_in);
//  assign data_out[95:48]={data_in[3:0],data_in[11:8],data_in[19:16],data_in[27:24],data_in[35:32],data_in[43:40],data_in[51:48],data_in[59:56],data_in[67:64],data_in[75:72],data_in[83:80],data_in[91:88]};
//  assign data_out[47:0]={data_in[7:4],data_in[15:12],data_in[23:20],data_in[31:28],data_in[39:36],data_in[47:44],data_in[55:52],data_in[63:60],data_in[71:68],data_in[79:76],data_in[87:84],data_in[95:92]};
  
  interleaver_4byte IL1 (data_in[31:24],data_in[23:16],data_in[15:8],data_in[7:0],data_out[31:24],data_out[23:16],data_out[15:8],data_out[7:0]);
  interleaver_4byte IL2 (data_in[63:56],data_in[55:48],data_in[47:40],data_in[39:32],data_out[63:56],data_out[55:48],data_out[47:40],data_out[39:32]);
  interleaver_4byte IL3 (data_in[95:88],data_in[87:80],data_in[79:72],data_in[71:64],data_out[95:88],data_out[87:80],data_out[79:72],data_out[71:64]);
  
endmodule



module task4_2(output [95:0] yout, // overall module-fec done in two stages,one while crc is going on, for tthe last 16 bits we can do it parallely through combinational circuit to reduce no. of cycles at cost of more circuitry
               output done,
              input data,start,clk);
  
  wire [15:0]r;
  wire [3:0] last4_data;
  wire [25:0] data_out;
  wire [63:0] fec1;
  wire [95:0] fec2;
  wire done1;
  wire [5:0]b;
  
  task2 T2_2(r,data_out,done1,data,start,clk);
  task3 T3_2(fec1,done,last4_data,data,start,clk);
  interleaver I1(yout,fec2);
  assign b[5]=r[15]^last4_data[2]^last4_data[1];
  assign b[4]=r[15]^last4_data[2]^last4_data[1]^last4_data[0];
  assign b[3]=r[14]^last4_data[1]^last4_data[0];
  assign b[2]=r[15]^r[14]^last4_data[1]^last4_data[0];
  assign b[1]=r[15]^r[13]^last4_data[0];
  assign b[0]=r[15]^r[14]^r[13]^last4_data[0];  
  assign fec2={fec1,b,data_out};
endmodule

  