/*
	Dupla: 
		Sabrina Suellen 1814122
		Victor Hugo      1824050
	Artigo: One-Dimensional Cutting Stock Problem with Divisible Items: A Case Study in Steel Industry
*/

# ---------------------------- Conjuntos ---------------------------- #
set M := {1..3};
set N := {1..3};
set K{M};

# ---------------------------- Par�metros ---------------------------- #

param beta,  integer, >=0; # limite inferior para perca de material
param theta integer, >=0; # limite inferior para soldagem
param gamma, integer, >=0; # custo de 1mm de perda de material
param delta, integer, >=0; # custo de uma opera��o de soldagem
param alfa{i in N, j in M, k in K[i]}, integer, >=0; # indica o comprimento da Pe�a i dividida da Barra j

param c; # comprimento do estoque
param w{i in N}, integer, >=0; # comprimento da pe�a i
param v{i in N}, integer, >=0; # quantidade demandada da pe�a i
param t{j in M}, integer, >= 0; # indica comprimento da sobra do estoque j

# ---------------------------- Vari�veis de Decis�o ---------------------------- #

# indica o indice do pe�a que foi cortado
var x{i in N, j in M}, integer, >=0;

# indica se a barra j ser� usada
var y{j in M}, binary;

# indica se a Pe�a i foi dividida na Barra j
var z{i in N, j in M, k in K[i]}, binary;

# indica se a parte residual da k-�sima parte dividida do Pe�a i � usada na  
# Barra j (b=1 se a k-�sima pe�a do item i foi usada no estoque j) 
var b{i in N, j in M, k in K[i]}, binary;

# indica se a barra j tem sobras
var u{j in M}, binary;


# ---------------------------- Fun��es Objetivo Avaliadas ---------------------------- #

# FO: Minimizar as perdas de material e opera��o de soldagem
minimize barras_e_perdas: gamma * sum{j in M} t[j]*u[j] + delta * 
sum{i in N,k in K[i], j in M} z[i,j,k];


# ---------------------------- Restri��es ---------------------------- #

# Restri��o 8: O padr�o de corte ideal para cada um dos estoques � definido por vari�veis de decis�o
s.t. padraoIdeal{j in M}: sum{i in N} x[i,j]*w[i]
+ sum{i in N, k in K[i]} z[i,j,k] *(w[i]-alfa[i,j,k]) 
+ sum{i in N, k in K[i], l in M: l != j} b[i,j,k]*alfa[i,l,k]+t[j] = c*y[j];

# Restri��o 9: garante que todas as demandas de cada item ser�o atendidas
s.t. demanda{i in N}: sum{j in M} x[i, j] + sum{k in K[i], j in M} z[i, j, k] = v[i];

#  Restri��o 10: garante que partes residuais de pecas divididos sejam usadas.
s.t. pecasUsadas{i in N}: sum{k in K[i], j in M} z[i,j,k] = sum{k in K[i], j in M} b[i,j,k];

#  Restri��o 11: controla que apenas uma pe�a n�o dividida pode ser dividida e usada em um �nico padr�o de corte.
s.t. sePecaUsada{j in M}: sum{i in N, k in K[i]} z[i,j,k] <= 1;

# Restri��o 12: controlam que os comprimentos das pe�as de um barra dividido s�o maiores ou iguais que o limite inferior predefinido.
s.t. controleDivisaoAlfa{i in N, j in M, k in K[i]}: alfa[i,j,k] >= theta;

# Restri��o 13: controlam que os comprimentos das pe�as de um barra dividido s�o maiores ou iguais que o limite inferior predefinido.
s.t. controleSobras{i in N, j in M, k in K[i]}: (w[i] - alfa[i,j,k]) >= theta;

# Restri��o 14: Determina se sobras dos estoques podem ser utilizadas no futuro
s.t. sobrasUteissobrasUteis{j in M}: v[j] = if (t[j] >= theta) then 0 else 1;

# Restri��es de 15 a 18 definidas na declara��o das vari�veis

solve;

data;

set K[1]:= 1, 2, 3;
set K[2]:= 1, 2, 3;
set K[3]:= 1, 2, 3;

param c := 12000;

param beta := 1000;
param theta := 200;
param gamma := 300;
param delta := 100;

param v := 
	1 6
	2 12
	3 24;

param w := 
	1 100
	2 100
	3 100;

param t :=
	1 200
	2 120
	3 340;

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
