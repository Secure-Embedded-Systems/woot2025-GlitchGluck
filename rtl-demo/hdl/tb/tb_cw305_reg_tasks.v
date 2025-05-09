task write_byte;
   input [1:0] block;
   input [pADDR_WIDTH-pBYTECNT_SIZE-1:0] address;
   input [pBYTECNT_SIZE-1:0] subbyte;
   input [7:0] data;
   begin
   @(posedge usb_clk);
   usb_addr = {block, address[5:0], subbyte};
   usb_wdata = data;
   usb_wrn = 0;
   @(posedge usb_clk);
   usb_cen = 0;
   @(posedge usb_clk);
   usb_cen = 1;
   @(posedge usb_clk);
   usb_wrn = 1;
   @(posedge usb_clk);
   end
endtask


task read_byte;
   input [1:0] block;
   input [pADDR_WIDTH-pBYTECNT_SIZE-1:0] address;
   input [pBYTECNT_SIZE-1:0] subbyte;
   output [7:0] data;
   begin
   @(posedge usb_clk);
   usb_addr = {block, address[5:0], subbyte};
   @(posedge usb_clk);
   usb_rdn = 0;
   usb_cen = 0;
   @(posedge usb_clk);
   @(posedge usb_clk);
   #1 data = usb_data;
   @(posedge usb_clk);
   usb_rdn = 1;
   usb_cen = 1;
   repeat(2) @(posedge usb_clk);
   end
endtask


task write_bytes;
   input [1:0] block;
   input [7:0] bytes;
   input [pADDR_WIDTH-pBYTECNT_SIZE-1:0] address;
   input [255:0] data;
   integer subbyte;
   begin
   for (subbyte = 0; subbyte < bytes; subbyte = subbyte + 1)
      write_byte(block, address, subbyte, data[subbyte*8 +: 8]);
   end
endtask


task read_bytes;
   input [1:0] block;
   input [7:0] bytes;
   input [pADDR_WIDTH-pBYTECNT_SIZE-1:0] address;
   output [255:0] data;
   integer subbyte;
   begin
   for (subbyte = 0; subbyte < bytes; subbyte = subbyte + 1)
      read_byte(block, address, subbyte, data[subbyte*8 +: 8]);
   end
endtask


