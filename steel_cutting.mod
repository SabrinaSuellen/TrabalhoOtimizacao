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
display K[1];

# ---------------------------- Parâmetros ---------------------------- #

param n, integer, >=0;  # barras de perfil em estoque 
param m, integer, >=0;   # quantidade de peças

param beta,  integer, >=0; # limite inferior para perca de material
param theta integer, >=0; # limite inferior para soldagem
param gamma, integer, >=0; # custo de 1mm de perda de material
param delta, integer, >=0; # custo de uma operação de soldagem

param c; # comprimento da barra j
param v{i in Pecas}, integer, >=0; # quantidade demandada da peça i
param w{i in Pecas}, integer, >=0; # comprimento da peça i

param t{j in Barras}, integer, >= 0;

# ---------------------------- Variáveis de Decisão ---------------------------- #

# indica se a barra j será usada
var y{j in Barras}, binary;

# valor de perda da barra j (sobras com comprimento menor que N) 


# indica se a barra j tem sobras
var u{j in Barras}, binary;

# indica o indice do peça que foi cortado
var x{i in Pecas, j in Barras}, integer, >=0;

# indica se a Peça i foi dividida na Barra j
var z{i in Pecas, j in Barras, k in K[i]}, binary;

# indica o comprimento da Peça i dividida da Barra j
param alfa{i in Pecas, l in Barras, k in K[i]}, integer, >=0;

# indica se a parte residual da k-ésima parte dividida do Peça i é usada na  
# Barra j (b=1 se a k-ésima peça do item i foi usada no estoque j) 
var b{i in Pecas, j in Barras, k in K[i]}, binary;


# ---------------------------- Funções Objetivo Avaliadas ---------------------------- #

# FO: Minimizar as perdas de material e operação de soldagem
minimize barras_e_perdas: gamma * sum{j in Barras} t[j]*u[j] + delta * sum{i in Pecas,k in K[i], j in Barras} z[i,j,k];


# ---------------------------- Restrições ---------------------------- #

# O padrão de corte ideal para cada um dos estoques é definido por variáveis de decisão
s.t. padraoIdeal{j in Barras}: sum{i in Pecas} x[i,j]*w[i] + sum{i in Pecas, k in K[i]} z[i,j,k] *(w[i]-alfa[i,j,k]) + sum{i in Pecas, k in K[i], l in Barras: l != j} b[i,j,k]*alfa[i,l,k]+t[j] = c*y[j];

# garante que todas as demandas de cada item serão atendidas
#s.t. demanda{j in Barras}: sum{j in Barras}x[i]+ sum{j in Barras, k in K[i]}z[i, j] = v[i];

#  garante que partes residuais de pecas divididos sejam usadas.
s.t. pecasUsadas{i in Pecas}: sum{j in Barras} z[i,j] = sum{j in Barras}b[i,j];

#  controla que apenas uma peça não dividida pode ser dividida e usada em um único padrão de corte.
s.t. sePecaUsada: (sum{i in Pecas, j in Barras} z[i,j]) <= 1;

# controlam que os comprimentos das peças de um barra dividido são maiores ou iguais que o limite inferior predefinido.
s.t. controleDivisaoAlfa{i in Pecas, j in Barras}: alfa[i,j] >= theta;

# controlam que os comprimentos das peças de um barra dividido são maiores ou iguais que o limite inferior predefinido.
s.t. controleSobras{i in Pecas, j in Barras}: w[i] - alfa[i,j] >= theta;

# Determina se sobras dos estoques podem ser utilizadas no futuro
s.t. sobrasUteissobrasUteis{j in Barras}: v[j] = if (t[j] >= theta) then 0 else 1;
#param v{j in Pecas} := if t[j] > beta then 0 else 1; 

# Restrições de 15 a 18 definidas na declaração das variáveis

solve;

data;

set K[1]:= 1..6;
set K[2]:= 1..3;
set K[3]:= 1..4;

param m := 3;
param n := 3;

param beta := 1;
param theta := 2;
param gamma := 1;
param delta := 2;

param c := 
	1 20
	2 45
	3 37;
param v := 
	1 600
	2 330
	3 700;
param w := 
	1 20
	2 10
	3 15;
end;

# restrição 14
# inserir k's e l's
