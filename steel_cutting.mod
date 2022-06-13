/*
	Dupla: 
		Sabrina Suellen 1814122
		Victor Hugo      1824050
	Artigo: One-Dimensional Cutting Stock Problem with Divisible Items: A Case Study in Steel Industry
*/

# ---------------------------- Conjuntos ---------------------------- #
set Pecas := {1..3};
set Barras := {1..3};
set K{Pecas};

# ---------------------------- Par�metros ---------------------------- #

param n, integer, >=0;  # barras de perfil em estoque 
param m, integer, >=0;   # quantidade de pe�as

param beta,  integer, >=0; # limite inferior para perca de material
param theta integer, >=0; # limite inferior para soldagem
param gamma, integer, >=0; # custo de 1mm de perda de material
param delta, integer, >=0; # custo de uma opera��o de soldagem
param alfa{i in Pecas, j in Barras, k in K[i]}, integer, >=0; # indica o comprimento da Pe�a i dividida da Barra j

param c; # comprimento do estoque
param v{j in Barras}, integer, >=0; # quantidade demandada da pe�a i
param w{i in Pecas}, integer, >=0; # comprimento da pe�a i

param t{j in Barras}, integer, >= 0; # indica comprimento da sobra do estoque j

# ---------------------------- Vari�veis de Decis�o ---------------------------- #

# valor de perda da barra j (sobras com comprimento menor que N) 


# indica o indice do pe�a que foi cortado
var x{i in Pecas, j in Barras}, integer, >=0;

# indica se a Pe�a i foi dividida na Barra j
var z{i in Pecas, j in Barras, k in K[i]}, binary;

# indica se a parte residual da k-�sima parte dividida do Pe�a i � usada na  
# Barra j (b=1 se a k-�sima pe�a do item i foi usada no estoque j) 
var b{i in Pecas, j in Barras, k in K[i]}, binary;

# indica se a barra j tem sobras
var u{j in Barras}, binary;

# indica se a barra j ser� usada
var y{j in Barras}, binary;


# ---------------------------- Fun��es Objetivo Avaliadas ---------------------------- #

# FO: Minimizar as perdas de material e opera��o de soldagem
minimize barras_e_perdas: gamma * sum{j in Barras} t[j]*u[j] + delta * 
sum{i in Pecas,k in K[i], j in Barras} z[i,j,k];


# ---------------------------- Restri��es ---------------------------- #

# Restri��o 8: O padr�o de corte ideal para cada um dos estoques � definido por vari�veis de decis�o
s.t. padraoIdeal{j in Barras}: sum{i in Pecas} x[i,j]*w[i]
+ sum{i in Pecas, k in K[i]} z[i,j,k] *(w[i]-alfa[i,j,k]) 
+ sum{i in Pecas, l in Barras, k in K[i]: l != j} b[i,j,k]*alfa[i,l,k]+t[j] = c*y[j];

# Restri��o 9: garante que todas as demandas de cada item ser�o atendidas
s.t. demanda{i in Pecas}: sum{j in Barras} x[i, j]+ sum{j in Barras, k in K[i]} z[i, j, k] = v[i];

#  Restri��o 10: garante que partes residuais de pecas divididos sejam usadas.
s.t. pecasUsadas{i in Pecas}: sum{j in Barras, k in K[i]} z[i,j,k] = sum{k in K[i], j in Barras}b[i,j,k];

#  Restri��o 11: controla que apenas uma pe�a n�o dividida pode ser dividida e usada em um �nico padr�o de corte.
s.t. sePecaUsada: sum{i in Pecas, j in Barras, k in K[i]} z[i,j,k] <= 1;

# Restri��o 12: controlam que os comprimentos das pe�as de um barra dividido s�o maiores ou iguais que o limite inferior predefinido.
s.t. controleDivisaoAlfa{i in Pecas, j in Barras, k in K[i]}: alfa[i,j,k] >= theta;

# Restri��o 13: controlam que os comprimentos das pe�as de um barra dividido s�o maiores ou iguais que o limite inferior predefinido.
s.t. controleSobras{i in Pecas, j in Barras, k in K[i]}: w[i] - alfa[i,j,k] >= theta;

# Restri��o 14: Determina se sobras dos estoques podem ser utilizadas no futuro
s.t. sobrasUteissobrasUteis{j in Barras}: v[j] = if (t[j] >= theta) then 0 else 1;
#param v{j in Pecas} := if t[j] > beta then 0 else 1;

# Restri��es de 15 a 18 definidas na declara��o das vari�veis

solve;

data;

set K[1]:= 1, 2, 3;
set K[2]:= 1, 2, 3;
set K[3]:= 1, 2, 3;

param m := 3;
param n := 3;
param c := 100;

param beta := 5;
param theta := 4;
param gamma := 3;
param delta := 2;

param v := 
	1 6
	2 12
	3 24;

param w := 
	1 20
	2 10
	3 15;

param t :=
	1 14
	2 20
	3 8;

param alfa :=
[*, *, 1]: 1 2 3 :=
	1 25 50 25
	2 50 25 25
	3 25 25 50
[*, *, 2]: 1 2 3 :=
	1 10 60 30
	2 20 50 30
	3 5 90 5
[*, *, 3]: 1 2 3 :=
	1 15 15 70 
	2 50 25 25
	3 25 25 50;

end;
