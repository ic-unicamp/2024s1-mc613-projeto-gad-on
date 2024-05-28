//Bug do score corrigido, best_score está perfeito
module vgaproj(
  input CLOCK_50,
  input [3:0] KEY,
  input [9:0] SW,
  output reg VGA_CLK,
  output reg [7:0] VGA_R,
  output reg [7:0] VGA_G,
  output reg [7:0] VGA_B,
  output  VGA_HS,
  output  VGA_VS,
  output VGA_BLANK_N,
  output VGA_SYNC_N,
  output reg [6:0] HEX0,
  output reg [6:0] HEX1,
  output reg [6:0] HEX2,
  output reg [6:0] HEX3,
  output reg [6:0] HEX4,
  output reg [6:0] HEX5
);

assign VGA_SYNC_N = 1;
assign VGA_BLANK_N = 1;

always @(posedge CLOCK_50) begin
    VGA_CLK = ~VGA_CLK;
end

reg def1 = 0;
reg [11:0] contador;
reg [11:0] linhas;
reg [25:0] number;

always @(posedge VGA_CLK) begin
	if(SW[0] || ~def1) begin
		contador = 0;
		linhas = 0;
		def1 = 1;
	end
	contador = contador + 1;
	if(contador == 800) begin
		contador = 0;
		linhas = linhas + 1;
		if(linhas == 525) begin
			linhas = 0;
		end
	end
end

assign VGA_HS = (contador <= 96) ? 0 : 1;
assign VGA_VS = (linhas <= 2) ? 0 : 1;
assign ativo = ((contador > 144) && (contador <784)  && (linhas >= 35) && (linhas <= 515))? 1 : 0;
// COORDENADAS X E Y PARA O VGA
wire [11:0] x;
wire [11:0] y;
assign  x = contador - 144;  
assign  y = linhas - 35;








//CLOCK DE QUEDA DO SHAPE
reg def2 = 0;
reg [23:0] count_shape = 0;
reg SHAPE_CLK;

always @(posedge CLOCK_50) begin
	if(SW[0] || ~def2) begin
		count_shape <= 0;
		SHAPE_CLK <= 0;
		def2 = 1;
	end
	if (count_shape ==  24'b0001011111010111100001) begin
		count_shape <= 0;
		SHAPE_CLK <= 0;
	end 
	else begin
		count_shape <= count_shape + 1;
		SHAPE_CLK <= 1;
	end
end






//SETANDO O MAPA MANUALMENTE PARA TESTES
reg [0:2] map [0:2];

always @(posedge CLOCK_50) begin 
	map[1][1] = 1'b1;
end







//CONTROLADOR DE VIDEO DO MAPA
reg[7:0] i;
reg[7:0] j;
wire[11:0] x_map;
wire[11:0]  y_map;
assign x_map = 320 - 18;
assign y_map = 240 - 18;

always @(VGA_CLK) begin
	if(x >= x_map && x < x_map + 36 && y >= y_map && y < y_map + 36) begin
    for(i = 0; i < 3; i = i + 1) begin
		for(j = 0; j < 3; j = j + 1) begin
			if((x >= i*12 +x_map) && (x < i*12 + 12+x_map) && (y >= j*12 + y_map) && (y < j*12 + 12+y_map)) begin 
				VGA_R = ativo ?  (map[i][j] == 1 ? 255: 155) : 0;
				VGA_G = ativo ?  (map[i][j] == 1 ? 255: 34) : 0;
				VGA_B = ativo ?  (map[i][j] == 1 ? 255: 255) : 0;
			end
		end
	end
	end
	else begin 
		VGA_R = ativo ? 34 : 0;
		VGA_G = ativo ? 34 : 0;
		VGA_B = ativo ? 34 : 0;
	end
	 
end

endmodule

