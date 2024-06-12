//Bug do score corrigido, best_score está perfeito
//Infelizmente o rastro das peças fica com uma cor diferente de amarelo ou cinza
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

reg def5 = 0;
reg [28:0] count_shape = 0;
reg SHAPE_CLK;
reg [3:0] num_shape = 0;

always @(posedge CLOCK_50) begin
	if(SW[0] || ~def5) begin
		count_shape <= 0;
		SHAPE_CLK <= 0;
		num_shape <= 0;
		def5 = 1;
	end
	if (count_shape ==  29'b000101111101011110000000000) begin //Acelerar 2 vezes -> tirar 1 zeros a direita
		count_shape <= 0;
		SHAPE_CLK <= 0;
	end 
	else begin
		count_shape <= count_shape + 1;
		SHAPE_CLK <= 1;
	end
	
	if(num_shape == 2) begin
		num_shape <= 0;
	end
	else begin
		num_shape <= num_shape + 1;
	end
end






reg def3 = 0;
reg def4 = 0;
reg rodoufo = 0;
reg paint = 0;
reg[11:0] x_shape = 20;
reg[11:0] y_shape = 1;
reg[11:0] temp;
reg bottom;
reg faz_alguma_coisa;
reg[3:0] op_passada;
//CONTROLADOR DO MAPA (logica principal do jogo)
// aqui, temos 20 linhas e 10 segmentos de 5 bits para cada cor
// esse sera o bloco de always mais extenso
reg [0:49] map [0:19];
reg [0:49] new = 0;
reg [9:0] i1 = 0, j1 = 0;
reg [9:0] shape_id = 0;
reg [9:0] rot_id = 0;


always @(posedge VGA_CLK) begin 
	//linha, coluna, respectivamente map[linha][coluna*5+:4]
	//aqui, coloquei um pixel como sendo 1
	if(~def3 || SW[9]) begin
		y_shape <= 1;
		x_shape <= 20;
		bottom <= 0;
		shape_id <= 0;
		rot_id <= 0;
		op_passada <= 0;
		faz_alguma_coisa <= 0;
		def3 <= 1;
	end
	
	if(op_passada != KEY) begin
		faz_alguma_coisa <= 1;
	end
	else begin
		faz_alguma_coisa <= 0;
	end
	
	case(shape_id)
	
		0: begin // cor = 13
					
			if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
				if(~KEY[1] && x_shape > 0 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape+1][(x_shape-5)+:5] == 0) begin
					x_shape <= x_shape - 5;
				end
				else if(~KEY[0] && x_shape < 40 && map[y_shape][(x_shape+10)+:5] == 0 && map[y_shape+1][(x_shape+10)+:5] == 0) begin
					x_shape <= x_shape + 5;
				end
			end

			op_passada <= KEY;
			
			if(map[y_shape+2][x_shape+:5] != 0 || map[y_shape+2][(x_shape+5)+:5] != 0 || y_shape == 18) begin 
				map[y_shape][x_shape+:5] <= 3;
				map[y_shape][(x_shape+5)+:5] <= 3;
				map[y_shape+1][x_shape+:5] <= 3;
				map[y_shape+1][(x_shape+5)+:5] <= 3;
				
				y_shape <= 1;
				x_shape <= 20;
				bottom <= 1;
				
				shape_id <= 1;
			end
			for(i1 = 19; i1 > 0; i1  = i1-1) begin
				if(map[i1][0:4] && map[i1][5:9] && map[i1][10:14] && map[i1][15:19] && map[i1][20:24] && map[i1][25:29] && map[i1][30:34] && map[i1][35:39] && map[i1][40:44] && map[i1][45:49] && bottom) begin
					for(j1 = i1; j1 > 0; j1 = j1-1) begin
						map[j1] <= map[j1-1];
					end
					map[0] <= new;
				end
			end
			
			if (~SHAPE_CLK ) begin 
				y_shape <= y_shape + 1;
				bottom <= 0;
			end
		end
		
	  1: begin
	  

				if(rot_id == 0) begin
					
					if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
						if(~KEY[1] && x_shape > 0 && map[y_shape-1][(x_shape-5)+:5] == 0 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape+1][(x_shape-5)+:5] == 0 && map[y_shape+2][(x_shape-5)+:5] == 0) begin
							x_shape <= x_shape - 5;
						end
						else if(~KEY[0] && x_shape < 45 && map[y_shape-1][(x_shape+5)+:5] == 0 && map[y_shape][(x_shape+5)+:5] == 0 && map[y_shape+1][(x_shape+5)+:5] == 0 && map[y_shape+2][(x_shape+5)+:5] == 0) begin
							x_shape <= x_shape + 5;
						end
						else if(~KEY[2] && x_shape > 0 && x_shape < 40 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape][(x_shape+5)+:5] == 0 && map[y_shape][(x_shape+10)+:5] == 0) begin
							rot_id <= 1;				
						end
					end

					op_passada <= KEY;
					
					if(map[y_shape+3][x_shape+:5] != 0 || y_shape == 17) begin 
						map[y_shape-1][x_shape+:5] <= 5;
						map[y_shape][x_shape+:5] <= 5;
						map[y_shape+1][x_shape+:5] <= 5;
						map[y_shape+2][(x_shape)+:5] <= 5;
						
						y_shape <= 1;
						x_shape <= 20;
						bottom <= 1;
						
						shape_id <= 2;
					end
					for(i1 = 19; i1 > 0; i1  = i1-1) begin
						if(map[i1][0:4] && map[i1][5:9] && map[i1][10:14] && map[i1][15:19] && map[i1][20:24] && map[i1][25:29] && map[i1][30:34] && map[i1][35:39] && map[i1][40:44] && map[i1][45:49] && bottom) begin
							for(j1 = i1; j1 > 0; j1 = j1-1) begin
								map[j1] <= map[j1-1];
							end
							map[0] <= new;
						end
					end
					
					if (~SHAPE_CLK) begin 
						y_shape <= y_shape + 1;
						bottom <= 0;
					end
				end
				
				
				
				else begin
				
					if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
						if(~KEY[1] && x_shape > 5 && map[y_shape][(x_shape-10)+:5] == 0) begin				
							x_shape <= x_shape - 5;
						end
						else if(~KEY[0] && x_shape < 35 && map[y_shape][(x_shape+15)+:5] == 0) begin
							x_shape <= x_shape + 5;
						end
						else if(~KEY[2] && x_shape > 0 && x_shape < 50 && y_shape < 18 && map[y_shape-1][(x_shape)+:5] == 0 && map[y_shape+1][(x_shape)+:5] == 0 && map[y_shape+2][(x_shape)+:5] == 0) begin
							rot_id <= 0;
						end
					end

					op_passada <= KEY;
					
					if(map[y_shape+1][(x_shape-5)+:5] != 0 || map[y_shape+1][(x_shape)+:5] != 0 || map[y_shape+1][(x_shape+5)+:5] != 0 || map[y_shape+1][(x_shape+10)+:5] != 0 || y_shape == 19) begin 
							
						map[y_shape][(x_shape-5)+:5] <= 5;
						map[y_shape][(x_shape)+:5] <= 5;
						map[y_shape][(x_shape+5)+:5] <= 5;
						map[y_shape][(x_shape+10)+:5] <= 5;	
						
						y_shape <= 1;
						x_shape <= 20;
						bottom <= 1;
						rot_id <= 0;
						
						shape_id <= 2;
					end
					for(i1 = 19; i1 > 0; i1  = i1-1) begin
						if(map[i1][0:4] && map[i1][5:9] && map[i1][10:14] && map[i1][15:19] && map[i1][20:24] && map[i1][25:29] && map[i1][30:34] && map[i1][35:39] && map[i1][40:44] && map[i1][45:49] && bottom) begin
							for(j1 = i1; j1 > 0; j1 = j1-1) begin
								map[j1] <= map[j1-1];
							end
							map[0] <= new;
						end
					end
					if(~SHAPE_CLK) begin
						y_shape <= y_shape + 1;
						bottom <= 0;
					end
				end
			end
			
					2: begin // cor = 12
				
			if(rot_id == 0) begin
				
				if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
					if(~KEY[1] && x_shape > 5 && map[y_shape-1][(x_shape-5)+:5] == 0 && map[y_shape][(x_shape-10)+:5] == 0) begin
						x_shape <= x_shape - 5;
					end
					else if(~KEY[0] && x_shape < 40 && map[y_shape-1][(x_shape+10)+:5] == 0 && map[y_shape][(x_shape+5)+:5] == 0) begin
						x_shape <= x_shape + 5;
					end
					else if(~KEY[2] && y_shape < 19 && map[y_shape][(x_shape+5)+:5] == 0 && map[y_shape+1][(x_shape+5)+:5] == 0) begin
						rot_id <= 1;				
					end
				end

				op_passada <= KEY;
				
				if(map[y_shape][(x_shape+5)+:5] != 0 || map[y_shape+1][x_shape+:5] != 0 || map[y_shape+1][(x_shape-5)+:5] != 0 || y_shape == 19) begin 
					map[y_shape-1][x_shape+:5] <= 2;
					map[y_shape-1][(x_shape+5)+:5] <= 2;
					map[y_shape][(x_shape-5)+:5] <= 2;
					map[y_shape][x_shape+:5] <= 2;
					
					y_shape <= 1;
					x_shape <= 20;
					bottom <= 1;
					
					shape_id <= 0;
				end
				for(i1 = 19; i1 > 0; i1  = i1-1) begin
					if(map[i1][0:4] && map[i1][5:9] && map[i1][10:14] && map[i1][15:19] && map[i1][20:24] && map[i1][25:29] && map[i1][30:34] && map[i1][35:39] && map[i1][40:44] && map[i1][45:49] && bottom) begin
						for(j1 = i1; j1 > 0; j1 = j1-1) begin
							map[j1] <= map[j1-1];
						end
						map[0] <= new;
					end
				end
				
				if (~SHAPE_CLK) begin 
					y_shape <= y_shape + 1;
					bottom <= 0;
				end
			end
			
			
			
			else begin
			
				if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
					if(~KEY[1] && x_shape > 0 && map[y_shape-1][(x_shape-5)+:5] == 0 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape+1][x_shape+:5] == 0) begin
						x_shape <= x_shape - 5;
					end
					else if(~KEY[0] && x_shape < 40 && map[y_shape-1][(x_shape+5)+:5] == 0 && map[y_shape][(x_shape+10)+:5] == 0 && map[y_shape+1][(x_shape+10)+:5] == 0) begin
						x_shape <= x_shape + 5;
					end
					else if(~KEY[2] && x_shape > 0 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape-1][(x_shape+5)+:5] == 0) begin
						rot_id <= 0;				
					end
				end

				op_passada <= KEY;
				
				if(map[y_shape+2][(x_shape+5)+:5] != 0 || map[y_shape+1][x_shape+:5] != 0 || y_shape == 18) begin 
					map[y_shape-1][x_shape+:5] <= 2;
					map[y_shape][x_shape+:5] <= 2;
					map[y_shape][(x_shape+5)+:5] <= 2;
					map[y_shape+1][(x_shape+5)+:5] <= 2;
					
					y_shape <= 1;
					x_shape <= 20;
					bottom <= 1;
					rot_id <= 0;
					
					shape_id <= 0;
				end
				for(i1 = 19; i1 > 0; i1  = i1-1) begin
					if(map[i1][0:4] && map[i1][5:9] && map[i1][10:14] && map[i1][15:19] && map[i1][20:24] && map[i1][25:29] && map[i1][30:34] && map[i1][35:39] && map[i1][40:44] && map[i1][45:49] && bottom) begin
						for(j1 = i1; j1 > 0; j1 = j1-1) begin
							map[j1] <= map[j1-1];
						end
						map[0] <= new;
					end
				end
				
				if (~SHAPE_CLK) begin 
					y_shape <= y_shape + 1;
					bottom <= 0;
				end
			end
		end

	endcase
		
	
	
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
                case(map[i][j*5 +: 5])
                    0: begin //fundo cod 0
                        VGA_R = ativo ? 90 : 0;
                        VGA_G = ativo ? 90 : 0;
                        VGA_B = ativo ? 90 : 0;
                    end
                    1, 11: begin //branco cod 1 ou 11
                        VGA_R = ativo ? 255 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 255 : 0;
                    end
                    2, 12: begin //ciano cod 2 ou 12
                        VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 255 : 0;
                    end
                    3, 13: begin //amarelo cod 3 ou 13
                        VGA_R = ativo ? 255 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 0 : 0;
                    end
                    4, 14: begin //roxo cod 4 ou 14
                        VGA_R = ativo ? 128 : 0;
                        VGA_G = ativo ? 0 : 0;
                        VGA_B = ativo ? 128 : 0;
                    end
                    5, 15: begin //verde cod 5 ou 15
                        VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 0 : 0;
                    end
                    6, 16: begin //vermelho cod 6 ou 16
                        VGA_R = ativo ? 255 : 0;
                        VGA_G = ativo ? 0 : 0;
                        VGA_B = ativo ? 0 : 0;
                    end
                    7, 17: begin //azul cod 7 ou 17
                        VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 0 : 0;
                        VGA_B = ativo ? 255 : 0;
                    end
                    8, 18: begin //laranja cod 8 ou 18
                        VGA_R = ativo ? 255 : 0;
                        VGA_G = ativo ? 127 : 0;
                        VGA_B = ativo ? 0 : 0;
                    end
                    9, 19: begin //cinza cod 9 ou 19
                        VGA_R = ativo ? 127 : 0;
                        VGA_G = ativo ? 127 : 0;
                        VGA_B = ativo ? 127 : 0;
                    end
                    default: begin
                        VGA_R = 0;
                        VGA_G = 0;
                        VGA_B = 0;
                    end
                endcase
					case(shape_id)
						0: begin //Quadrado = Amarelo
							if((i == y_shape && j*5 == x_shape) || (i == y_shape && j*5 == x_shape+5) ||  (i == y_shape+1 && j*5 == x_shape) || (i == y_shape+1 && j*5 == x_shape+5)) begin
								VGA_R = ativo ? 255 : 0;
								VGA_G = ativo ? 255 : 0;
								VGA_B = ativo ? 0 : 0;
							end
						end
						1: begin // Barra = verde
							if(rot_id == 0 && ((i == y_shape-1) || (i == y_shape) || (i == y_shape+1) || (i == y_shape+2)) && 5*j == x_shape) begin
                        VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 0 : 0;
							end
							else if(rot_id == 1 && (i == y_shape) && ((5*j == x_shape-5) || (5*j == x_shape) || (5*j == x_shape+5) || (5*j == x_shape+10))) begin
								VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 0 : 0;
							end
						end
						2: begin // S = ciano
							if(rot_id == 0 && ((i == y_shape && 5*j == x_shape) || (i == y_shape && 5*j == x_shape-5) || (i == y_shape-1 && 5*j == x_shape) || (i == y_shape-1 && 5*j == x_shape+5))) begin
                        VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 255 : 0;
							end
							else if(rot_id == 1 && ((i == y_shape && 5*j == x_shape) || (i == y_shape && 5*j == x_shape+5) || (i == y_shape-1 && 5*j == x_shape) || (i == y_shape+1 && 5*j == x_shape+5))) begin
                        VGA_R = ativo ? 0 : 0;
                        VGA_G = ativo ? 255 : 0;
                        VGA_B = ativo ? 255 : 0;
							end
						end
					
					endcase
            end
        end
    end
	end
	//else if x, y dentro da regiao da bag ou do carrosel (NAO sera implementado futuramente)
	else begin 
		VGA_R = ativo ? 128 : 0;
		VGA_G = ativo ? 0 : 0;
		VGA_B = ativo ? 128 : 0;
	end
	
	 
end

endmodule

