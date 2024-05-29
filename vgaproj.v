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








// CLOCK DE QUEDA DO SHAPE
// a ideia e usa-lo como uma flag na logica principal
// se for 0, o bloco cai um pixel, se nao, continua como estava
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






//CONTROLADOR DO MAPA (logica principal do jogo)
// aqui, temos 20 linhas e 10 segmentos de 5 bits para cada cor
// esse sera o bloco de always mais extenso
reg [0:49] map [0:19];

always @(posedge CLOCK_50) begin 
	//linha, coluna, respectivamente
	//aqui, coloquei um pixel como sendo 1
	map[0][5:9] = 1;
	map[1][5:9] = 2;
	map[2][5:9] = 3;
	map[3][5:9] = 4;
	map[4][5:9] = 5;
	map[5][5:9] = 6;
	map[6][5:9] = 7;
	map[7][5:9] = 8;
	map[8][5:9] = 9;
end





//CONTROLADOR DE VIDEO DO MAPA
//permite a impressao de ate 31 cores
//aqui, so foi testado o branco (1) e o vazio (0)
//para criar o carrossel e a bag, basta criar 2 matrizes adicionais e adicionar os condicionais no bloco de always
reg[9:0] i;
reg[9:0] j;
wire[11:0] x_map;
wire[11:0] y_map;
assign x_map = 320-9-76;
assign y_map = 10;

always @(VGA_CLK) begin


	if(x >= x_map && x < x_map +190 && y >= y_map && y < y_map + 460) begin
	
    for(i = 0; i < 20; i = i + 1) begin
		for(j = 0; j < 10; j = j + 1) begin
			if((x >= j*19 +x_map) && (x < j*19 + 19+x_map) && (y >= i*23 + y_map) && (y < i*23 + 23+y_map)) begin 
			
				if(map[i][j*5 +: 5] == 0) begin  //fundo cod 0
					VGA_R = ativo ?  (90) : 0;
					VGA_G = ativo ?  (90) : 0;
					VGA_B = ativo ?  (90) : 0;
				end
				else if(map[i][j*5 +: 5] == 1 || map[i][j*5 +: 5] == 11) begin //branco cod 1 ou 11
					VGA_R = ativo ?  (255) : 0;
					VGA_G = ativo ?  (255) : 0;
					VGA_B = ativo ?  (255) : 0;
				end
				else if(map[i][j*5 +: 5] == 2 || map[i][j*5 +: 5] == 12) begin //ciano cod 2 ou 12
					VGA_R = ativo ?  (0) : 0;
					VGA_G = ativo ?  (255) : 0;
					VGA_B = ativo ?  (255) : 0;
				end
				else if(map[i][j*5 +: 5] == 3 || map[i][j*5 +: 5] == 13) begin //amarelo cod 3 ou 13
					VGA_R = ativo ?  (255) : 0;
					VGA_G = ativo ?  (255) : 0;
					VGA_B = ativo ?  (0) : 0;
				end
				else if(map[i][j*5 +: 5] == 4 || map[i][j*5 +: 5] == 14) begin //roxo cod 4 ou 14
					VGA_R = ativo ?  (128) : 0;
					VGA_G = ativo ?  (0) : 0;
					VGA_B = ativo ?  (128) : 0;
				end
				else if(map[i][j*5 +: 5] == 5 || map[i][j*5 +: 5] == 15) begin //verde cod 5 ou 15
					VGA_R = ativo ?  (0) : 0;
					VGA_G = ativo ?  (255) : 0;
					VGA_B = ativo ?  (0) : 0;
				end
				else if(map[i][j*5 +: 5] == 6 || map[i][j*5 +: 5] == 16) begin //vermelho cod 6 ou 16
					VGA_R = ativo ?  (255) : 0;
					VGA_G = ativo ?  (0) : 0;
					VGA_B = ativo ?  (0) : 0;
				end
				else if(map[i][j*5 +: 5] == 7 || map[i][j*5 +: 5] == 17) begin //azul cod 7 ou 17
					VGA_R = ativo ?  (0) : 0;
					VGA_G = ativo ?  (0) : 0;
					VGA_B = ativo ?  (255) : 0;
				end
				else if(map[i][j*5 +: 5] == 8 || map[i][j*5 +: 5] == 18) begin //laranja cod 8 ou 18
					VGA_R = ativo ?  (255) : 0;
					VGA_G = ativo ?  (127) : 0;
					VGA_B = ativo ?  (0) : 0;
				end
				else if(map[i][j*5 +: 5] == 9 || map[i][j*5 +: 5] == 19) begin //cinza cod 9 ou 19
					VGA_R = ativo ?  (127) : 0;
					VGA_G = ativo ?  (127) : 0;
					VGA_B = ativo ?  (127) : 0;
				end
				
				
			end
		end
	end
	end
	//else if x, y dentro da regiao da bag ou do carrosel (sera implementado futuramente)
	else begin 
		VGA_R = ativo ? 34 : 0;
		VGA_G = ativo ? 34 : 0;
		VGA_B = ativo ? 34 : 0;
	end
	
	 
end

endmodule
