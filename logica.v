//Bug do score corrigido, best_score está perfeito
//Caro grupo, venho por meio deste, comunicar-lhes que não pude certificar-me da corretude deste código,
//devido a insuficiência de tempo que tive para dedicar-me ao projeto. Sei que isso é imperdoável, mas 
//rogo-vos que usem de misericórdia para comigo. Apesar de tamanha incapacidade de minha parte, este 
//código contém a lógica principal da geração e movimento das peças, além de checar se as peças estão
//no bottom ou não e gerar uma nova (provavelmente nada funciona!)
module logica(
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

reg def5 = 0;
reg [28:0] count_shape = 0;
reg [3:0] num_shape = 0;
reg SHAPE_CLK;

always @(posedge CLOCK_50) begin
	if(SW[0] || ~def5) begin
		count_shape <= 0;
		num_shape <= 0;
		SHAPE_CLK <= 0;
		def5 = 1;
	end
	if (count_shape ==  29'b001011111010111100000000000) begin //default 29'b010111110101111000000000000
		count_shape <= 0;
		SHAPE_CLK <= 0;
	end 
	else begin
		count_shape <= count_shape + 1;
		SHAPE_CLK <= 1;
	end
	if(num_shape == 7) begin
		num_shape <= 0;
	end
	else begin
		num_shape <= num_shape + 1;
	end
end




reg [2:0][2:0] shape [4:0];
reg [4:0] altura;
reg [3:0] shape_oficial;

//indices dos shapes oficiais
shape_oficial[0] = 0; //quadrado
shape_oficial[1] = 1; //barra
shape_oficial[2] = 3; //S
shape_oficial[3] = 5; //Z
shape_oficial[4] = 7; //T
shape_oficial[5] = 11; //L
shape_oficial[6] = 15; //J

//quadrado
//oficial
shape[0][1][2] = 1;
shape[0][1][3] = 1;
shape[0][2][2] = 1;
shape[0][2][3] = 1;
altura[0] = 1;
//barra
//oficial
shape[1][0][2] = 1;
shape[1][1][2] = 1;
shape[1][2][2] = 1;
shape[1][3][2] = 1;
altura[1] = 0;
//barra rotacionada
shape[2][2][1] = 1;
shape[2][2][2] = 1;
shape[2][2][3] = 1;	
shape[2][2][4] = 1;
altura[2] = 2;
//shape de  S💪
//oficial
shape[3][1][2] = 1;
shape[3][1][3] = 1;
shape[3][2][1] = 1;
shape[3][2][2] = 1;
altura[3] = 1;
//shape de S rotacionado
shape[4][1][2] = 1;
shape[4][2][2] = 1;
shape[4][2][3] = 1;
shape[4][3][3] = 1;
altura[4] = 1;
//shape de  Z💪
//oficial
shape[5][1][1] = 1;
shape[5][1][2] = 1;
shape[5][2][2] = 1;
shape[5][2][3] = 1;
altura[5] = 1;
//shape de Z rotacionado
shape[6][1][3] = 1;
shape[6][2][2] = 1;
shape[6][2][3] = 1;
shape[6][3][2] = 1;
altura[6] = 1;
//shape de  T💪
//oficial
shape[7][1][2] = 1;
shape[7][2][1] = 1;
shape[7][2][2] = 1;
shape[7][2][3] = 1;
altura[7] = 1;
//shape de T rotacionado 1 vez
shape[8][1][2] = 1;
shape[8][2][2] = 1;
shape[8][2][3] = 1;
shape[8][3][2] = 1;
altura[8] = 1;
//shape de T rotacionado 2 vezes
shape[9][2][1] = 1;
shape[9][2][2] = 1;
shape[9][2][3] = 1;
shape[9][3][2] = 1;
altura[9] = 2;
//shape de T rotacionado 3 vezes
shape[10][1][2] = 1;
shape[10][2][1] = 1;
shape[10][2][2] = 1;
shape[10][3][2] = 1;
altura[10] = 1;
//shape de  L💪
//oficial
shape[11][1][2] = 1;
shape[11][2][2] = 1;
shape[11][3][2] = 1;
shape[11][3][3] = 1;
altura[11] = 1;
//shape de L rotacionado 1 vez
shape[12][2][1] = 1;
shape[12][2][2] = 1;
shape[12][2][3] = 1;
shape[12][3][1] = 1;
altura[12] = 2;
//shape de L rotacionado 2 vezes
shape[13][1][1] = 1;
shape[13][1][2] = 1;
shape[13][2][2] = 1;
shape[13][3][2] = 1;
altura[13] = 1;
//shape de L rotacionado 3 vezes
shape[14][1][3] = 1;
shape[14][2][1] = 1;
shape[14][2][2] = 1;
shape[14][2][3] = 1;
altura[14] = 1;
//shape de J 💪
//oficial
shape[15][1][2] = 1;
shape[15][2][2] = 1;
shape[15][3][1] = 1;
shape[15][3][2] = 1;
altura[15] = 1;
//shape de J rotacionado 1 vez
shape[16][1][1] = 1;
shape[16][2][1] = 1;
shape[16][2][2] = 1;
shape[16][2][3] = 1;
altura[16] = 1;
//shape de J rotacionado 2 vezes
shape[17][1][2] = 1;
shape[17][1][3] = 1;
shape[17][2][2] = 1;
shape[17][3][2] = 1;
altura[17] = 1;
//shape de J rotacionado 3 vezes
shape[18][2][1] = 1;
shape[18][2][2] = 1;
shape[18][2][3] = 1;
shape[18][3][3] = 1;
altura[18] = 2;





reg def3 = 0;
reg pode_mover = 1;
reg pode_mover2 = 1;
reg [4:0] idx_shape;
reg [9:0] i1;
reg [9:0] j1;
reg[11:0] x_ofical;
reg[11:0] y_oficial;
reg[11:0] x_shape = 20; //x_shape esta relativo ao 5x5 shape[][] -> x = 2 (meio)
reg[11:0] y_shape = 0; //y_shape esta relativo ao 5x5 shape[][] -> y = altura[shape_oficial[num_shape]]
reg[11:0] temp;
reg bottom;
reg faz_alguma_coisa;
reg[3:0] op_passada;
//CONTROLADOR DO MAPA (logica principal do jogo)
// aqui, temos 20 linhas e 10 segmentos de 5 bits para cada cor
// esse sera o bloco de always mais extenso
reg [0:49] map [0:19];

always @(posedge CLOCK_50) begin 
	//linha, coluna, respectivamente map[linha][coluna*5+:4]
	//aqui, coloquei um pixel como sendo 1
	if(~def3) begin
		y_shape <= 0;
		x_shape <= 20; //comeca no meio!
		idx_shape = 0;
		x_oficial = x_shape-2;
		y_oficial = y_shape-altura[idx_shape];
		
		for(i1 = 0; i1 < 5; i1 = i1+1) begin
			for(j1 = 0; j1 < 5; j1 = j1+1) begin
				if(shape[idx_shape][i1][j1]) begin
					map[y_oficial][x_oficial+:5] = 11;
				end
				x_oficial = x_oficial+5;
			end
			x_oficial = x_shape-2;
			y_oficial = y_oficial+1;
		end
		
		op_passada <= 0;
		faz_alguma_coisa <= 0;
		bottom <= 0;
		def3 <= 1;
	end
	
	if(op_passada != KEY) begin
		faz_alguma_coisa <= 1;
	end
	else begin
		faz_alguma_coisa <= 0;
	end
	
	idx_shape = shape_oficial[num_shape];
	
	if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
		if(~KEY[1]) begin
			pode_mover = 1;
			x_oficial = x_shape-2;
			y_oficial = y_shape-altura[idx_shape];
			
			for(i1 = 0; i1 < 5; i1 = i1+1) begin
				for(j1 = 0; j1 < 5; j1 = j1+1) begin 
					if(shape[idx_shape][i1][j1]) begin 
						if(x_oficial <= 0 || (map[y_oficial][(x_oficial-5)+:5] > 0 && map[y_oficial][(x_oficial-5)+:5] < 10)) begin
							pode_mover = 0;
						end
					end
					x_oficial = x_oficial+5;
				end
				x_oficial = x_shape-2;
				y_oficial = y_oficial+1;
			end
			
			if(pode_mover) begin
				x_oficial = x_shape-2;
				y_oficial = y_shape-altura[idx_shape];
				
				for(i1 = 0; i1 < 5; i1 = i1+1) begin
					for(j1 = 0; j1 < 5; j1 = j1+1) begin 
						if(shape[idx_shape][i1][j1]) begin 
							map[y_oficial][x_oficial+:5] <= 0; //pinta o rastro de cinza
						end
						x_oficial = x_oficial+5;
					end
					x_oficial = x_shape-2;
					y_oficial = y_oficial+1;
				end
				
				x_oficial = x_shape-2;
				y_oficial = y_shape-altura[idx_shape];
				
				for(i1 = 0; i1 < 5; i1 = i1+1) begin
					for(j1 = 0; j1 < 5; j1 = j1+1) begin 
						if(shape[idx_shape][i1][j1]) begin 
							map[y_oficial][(x_oficial-5)+:5] <= 11; //pinta nova posicao de branco
						end
						x_oficial = x_oficial+5;
					end
					x_oficial = x_shape-2;
					y_oficial = y_oficial+1;
				end
				
				x_shape <= x_shape - 5;
			end
		end
		else if(~KEY[0]) begin
			pode_mover2 = 1;
			x_oficial = x_shape-2;
			y_oficial = y_shape-altura[idx_shape];
			
			for(i1 = 0; i1 < 5; i1 = i1+1) begin
				for(j1 = 0; j1 < 5; j1 = j1+1) begin 
					if(shape[idx_shape][i1][j1]) begin 
						if(x_ofiical >= 45 || (map[y_oficial][(x_oficial+5)+:5] > 0 && map[y_oficial][(x_oficial+5)+:5] < 10)) begin
							pode_mover2 = 0;
						end
					end
					x_oficial = x_oficial+5;
				end
				x_oficial = x_shape-2;
				y_oficial = y_oficial+1;
			end
			
			if(pode_mover2) begin
				x_oficial = x_shape-2;
				y_oficial = y_shape-altura[idx_shape];
				
				for(i1 = 0; i1 < 5; i1 = i1+1) begin
					for(j1 = 0; j1 < 5; j1 = j1+1) begin 
						if(shape[idx_shape][i1][j1]) begin 
							map[y_oficial][x_oficial+:5] <= 0; //pinta o rastro de cinza
						end
						x_oficial = x_oficial+5;
					end
					x_oficial = x_shape-2;
					y_oficial = y_oficial+1;
				end
				
				x_oficial = x_shape-2;
				y_oficial = y_shape-altura[idx_shape];
				
				for(i1 = 0; i1 < 5; i1 = i1+1) begin
					for(j1 = 0; j1 < 5; j1 = j1+1) begin 
						if(shape[idx_shape][i1][j1]) begin 
							map[y_oficial][(x_oficial+5)+:5] <= 11; //pinta nova posicao de branco
						end
						x_oficial = x_oficial+5;
					end
					x_oficial = x_shape-2;
					y_oficial = y_oficial+1;
				end
				
				x_shape <= x_shape + 5;
			end
		end
	end
	
	op_passada <= KEY;
	
	bottom <= 0;
	pode_mover = 1;
	x_oficial = x_shape-2;
	y_oficial = y_shape-altura[idx_shape];
			
	for(i1 = 0; i1 < 5; i1 = i1+1) begin
		for(j1 = 0; j1 < 5; j1 = j1+1) begin 
			if(shape[idx_shape][i1][j1]) begin 
				if(y_oficial == 19 || (map[y_oficial+1][x_oficial+:5] > 0 && map[y_oficial+1][x_oficial+:5] < 10)) begin
					bottom = 1;
				end
			end
			x_oficial = x_oficial+5;
		end
		x_oficial = x_shape-2;
		y_oficial = y_oficial+1;
	end
	if(bottom) begin

		x_oficial = x_shape-2;
		y_oficial = y_shape-altura[idx_shape];
			
		for(i1 = 0; i1 < 5; i1 = i1+1) begin
			for(j1 = 0; j1 < 5; j1 = j1+1) begin 
				if(shape[idx_shape][i1][j1]) begin 
					map[y_oficial][x_oficial+:5] <= map[y_oficial][x_oficial+:5]-10;
				end
				x_oficial = x_oficial+5;
			end
			x_oficial = x_shape-2;
			y_oficial = y_oficial+1;
		end
		
		y_shape <= 0;
		x_shape <= 20;
		
		x_oficial = x_shape-2;
		y_oficial = y_shape-altura[idx_shape];
			
		for(i1 = 0; i1 < 5; i1 = i1+1) begin
			for(j1 = 0; j1 < 5; j1 = j1+1) begin 
				if(shape[idx_shape][i1][j1]) begin 
					map[y_oficial][x_oficial+:5] <= 11;
				end
				x_oficial = x_oficial+5;
			end
			x_oficial = x_shape-2;
			y_oficial = y_oficial+1;
		end
	end
	else if(~SHAPE_CLK ) begin //movimento pra baixo
		x_oficial = x_shape-2;
		y_oficial = y_shape-altura[idx_shape];
			
		for(i1 = 0; i1 < 5; i1 = i1+1) begin
			for(j1 = 0; j1 < 5; j1 = j1+1) begin 
				if(shape[idx_shape][i1][j1]) begin 
					map[y_oficial][x_oficial+:5] <= 0;
				end
				x_oficial = x_oficial+5;
			end
			x_oficial = x_shape-2;
			y_oficial = y_oficial+1;
		end
		
		x_oficial = x_shape-2;
		y_oficial = y_shape-altura[idx_shape];
			
		for(i1 = 0; i1 < 5; i1 = i1+1) begin
			for(j1 = 0; j1 < 5; j1 = j1+1) begin 
				if(shape[idx_shape][i1][j1]) begin 
					map[y_oficial+1][x_oficial+:5] <= 11;
				end
				x_oficial = x_oficial+5;
			end
			x_oficial = x_shape-2;
			y_oficial = y_oficial+1;
		end
		
		y_shape <= y_shape + 1;
		
	end
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

always @(posedge VGA_CLK) begin


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
