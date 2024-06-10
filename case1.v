//ainda aparece um rastro, roxo dessa vez (sempre quando a peca esta descendo)
//talvez seja possivel evitar o rastro trocando os codigos das cores no always do vga por algo mais propicio
  1: begin
				
			if(rot_id == 0) begin
				
				map[y_shape-1][x_shape+:5] <= 15;
				map[y_shape][x_shape+:5] <= 15;
				map[y_shape+1][x_shape+:5] <= 15;
				map[y_shape+2][(x_shape)+:5] <= 15;
				
				if (~SHAPE_CLK) begin 
					map[y_shape-1][x_shape+:5] <= 0;
					map[y_shape][x_shape+:5] <= 0;
					map[y_shape+1][x_shape+:5] <= 0;
					map[y_shape+2][(x_shape)+:5] <= 0;
				end
				
				if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
					if(~KEY[1] && x_shape > 0 && map[y_shape-1][(x_shape-5)+:5] == 0 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape+1][(x_shape-5)+:5] == 0 && map[y_shape+2][(x_shape-5)+:5] == 0) begin
						map[y_shape-1][x_shape+:5] <= 0;
						map[y_shape][x_shape+:5] <= 0;
						map[y_shape+1][x_shape+:5] <= 0;
						map[y_shape+2][(x_shape)+:5] <= 0;
						
						x_shape <= x_shape - 5;
					end
					else if(~KEY[0] && x_shape < 45 && map[y_shape-1][(x_shape+5)+:5] == 0 && map[y_shape][(x_shape+5)+:5] == 0 && map[y_shape+1][(x_shape+5)+:5] == 0 && map[y_shape+2][(x_shape+5)+:5] == 0) begin
						map[y_shape-1][x_shape+:5] <= 0;
						map[y_shape][x_shape+:5] <= 0;
						map[y_shape+1][x_shape+:5] <= 0;
						map[y_shape+2][(x_shape)+:5] <= 0;
						
						x_shape <= x_shape + 5;
					end
					else if(~KEY[2] && x_shape > 0 && x_shape < 40 && map[y_shape][(x_shape-5)+:5] == 0 && map[y_shape][(x_shape+5)+:5] == 0 && map[y_shape][(x_shape+10)+:5] == 0) begin
					
						map[y_shape-1][x_shape+:5] <= 0;
						map[y_shape][x_shape+:5] <= 0;
						map[y_shape+1][x_shape+:5] <= 0;
						map[y_shape+2][(x_shape)+:5] <= 0;

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
			
				map[y_shape][(x_shape-5)+:5] <= 15;
				map[y_shape][(x_shape)+:5] <= 15;
				map[y_shape][(x_shape+5)+:5] <= 15;
				map[y_shape][(x_shape+10)+:5] <= 15;
				
				if (~SHAPE_CLK) begin 
					map[y_shape][(x_shape-5)+:5] <= 0;
					map[y_shape][(x_shape)+:5] <= 0;
					map[y_shape][(x_shape+5)+:5] <= 0;
					map[y_shape][(x_shape+10)+:5] <= 0;	
				end
				
				if(faz_alguma_coisa) begin //movimento para os lados (mef com keys)
					if(~KEY[1] && x_shape > 5 && map[y_shape][(x_shape-10)+:5] == 0) begin
						map[y_shape][(x_shape-5)+:5] <= 0;
						map[y_shape][(x_shape)+:5] <= 0;
						map[y_shape][(x_shape+5)+:5] <= 0;
						map[y_shape][(x_shape+10)+:5] <= 0;	
						
						x_shape <= x_shape - 5;
					end
					else if(~KEY[0] && x_shape < 35 && map[y_shape][(x_shape+15)+:5] == 0) begin
						map[y_shape][(x_shape-5)+:5] <= 0;
						map[y_shape][(x_shape)+:5] <= 0;
						map[y_shape][(x_shape+5)+:5] <= 0;
						map[y_shape][(x_shape+10)+:5] <= 0;	
						
						x_shape <= x_shape + 5;
					end
					else if(~KEY[2] && x_shape > 0 && x_shape < 50 && y_shape < 18 && map[y_shape-1][(x_shape)+:5] == 0 && map[y_shape+1][(x_shape)+:5] == 0 && map[y_shape+2][(x_shape)+:5] == 0) begin
					
						map[y_shape][(x_shape-5)+:5] <= 0;
						map[y_shape][(x_shape)+:5] <= 0;
						map[y_shape][(x_shape+5)+:5] <= 0;
						map[y_shape][(x_shape+10)+:5] <= 0;	
			
						rot_id <= 0;
					end
				end

				op_passada <= KEY;
				
				if(map[y_shape+1][(x_shape-5)+:5] != 0 || map[y_shape+1][(x_shape)+:5] != 0 || map[y_shape+1][(x_shape+5)+:5] != 0 || map[y_shape+1][(x_shape+10)+:5] != 0 || y_shape == 19) begin 
						
					map[y_shape][(x_shape-5)+:5] <= 5;
					map[y_shape][(x_shape)+:5] <= 5;
					map[y_shape][(x_shape+5)+:5] <= 5;
					map[y_shape][(x_shape+10)+:5] <= 5;	
					
					y_shape <= 0;
					x_shape <= 20;
					bottom <= 1;
					rot_id <= 0;
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
