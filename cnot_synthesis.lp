g(1, 1, 0). g(1, 2, 0). g(1, 3, 0). g(1, 4, 1). 
g(2, 1, 1). g(2, 2, 0). g(2, 3, 0). g(2, 4, 1). 
g(3, 1, 0). g(3, 2, 1). g(3, 3, 1). g(3, 4, 1). 
g(4, 1, 1). g(4, 2, 1). g(4, 3, 1). g(4, 4, 0). 

f(1, 1, 1). f(1, 2, 0). f(1, 3, 1). f(1, 4, 1). 

#const n = 4.
#const k = 1.
#const l = 8.


variable_node(1..n).
step(1..l).
f_node(1..k).

%% ------------------- EDGES CONSTRAINTS -------------------

% edge(X, Y, I) :- l'arco numerato I va da X a Y. 

% un arco per step (forse non vero perché posso avere componenti sconnesse che posso fare in parallelo?)
1{edge(X, Y, I) : variable_node(Y), variable_node(X)}1 :- step(I).
:- edge(X, X, I), step(I), variable_node(X).

has_incoming_in_step(X, I) :- step(I), variable_node(X), variable_node(Y), edge(Y, X, I). 

neighbour(X, Y) :- edge(X, Y, I), step(I).

%% ------------------- VALUE OF A NODE -------------------

% val(X, i) : la funzione di X al tempo i (del tipo x_1 xor x_5 xor x_6)
% node_value(X, i, Y) <-> Y \in val(X, i) 
% x1 -> x3  val(x3, 1): val(x1, 0) xor val(x3, 0)
node_value(X, 0, X) :- variable_node(X).
node_value(X, I, Y) :- node_value(X, I - 1, Y), variable_node(Y), step(I), not has_incoming_in_step(X, I), I > 0. 
% se invece ci sono archi entranti, allora ha tutti quelli di prima più i nuovi. 

node_value(X, I, Y) :- variable_node(X), variable_node(Y), variable_node(Z), edge(Z, X, I), node_value(Z, I - 1, Y), not node_value(X, I - 1, Y).
node_value(X, I, Y) :- variable_node(X), variable_node(Y), variable_node(Z), edge(Z, X, I), not node_value(Z, I - 1, Y), node_value(X, I - 1, Y).

%% ------------------- ROWS FIXED NOT IN THE LAST STEP ------------------- 

%% DA RISCRIVERE A SINGOLA VARIABILE PERCHé tanto F è gestita sotto


% % la differenza tra il valore della riga X (aka var X) al tempo I e la riga Y di g
% val_row_difference(X, Y, I, S1, S2) :- variable_node(X), variable_node(Y), step(I), S1 = #count{Z : variable_node(Z), g(Y, Z, 1), not node_value(X, I, Z)}, S2 = #count{Z : variable_node(Z), g(Y, Z, 0), node_value(X, I, Z)}.

% %scarico i due zeri che mi stanno antipatici
% same_value(X, Y, I) :- variable_node(X), variable_node(Y), step(I), I = #min{J : val_row_difference(X, Y, J, 0, 0), step(J), J < l}. 

% % una riga al tempo J è fixed se esiste un tempo I <= J in cui era fixed
% row_fixed(Y, J) :- variable_node(Y), variable_node(X), same_value(X, Y, I), I <= J, step(J).

% % se la variabile X rappresenta la riga X di g al tempo I, non ha senso che sia modificata 
% :- same_value(X, X, I), has_incoming_in_step(X, J), J > I, step(J).

% % % Quante righe sono state fixate almeno una volta prima dell'istante J.
% fixed_rows(S, J) :- S = #count{X : row_fixed(X, J)}, step(J), J < l.

% % % deve rimanere una sola riga da fixare al tempo J. 
% :- fixed_rows(S, l-1), n - S > 1.



% Per ogni riga F_j, deve esistere una variabile X e un tempo I tali che value(X, I) = F_j.

val_f_difference(X, Y, I, S1, S2) :- variable_node(X), f_node(Y), step(I), S1 = #count{Z : variable_node(Z), f(Y, Z, 1), not node_value(X, I, Z)}, S2 = #count{Z : variable_node(Z), f(Y, Z, 0), node_value(X, I, Z)}.

same_f_value(X, Y, I) :- variable_node(X), f_node(Y), step(I), I = #min{J : val_f_difference(X, Y, J, 0, 0), step(J)}. 

f_fixed(Y, J) :- f_node(Y), variable_node(X), same_f_value(X, Y, I), I <= J, step(J).

fixed_f(S, J) :- S = #count{X : f_fixed(X, J)}, step(J).

:- fixed_f(S, l), S != k. 


%% ------------------- CONNECTED COMPONENTS STUFF -------------------

same_cc(X, X) :- variable_node(X).
same_cc(X, Y) :- same_cc(Y, X).
same_cc(X, Y) :- same_cc(X, Z), same_cc(Z, Y).
same_cc(X, Y) :- X != Y, variable_node(Z), same_cc(X, Z), neighbour(Z, Y).


max_in_cc(X, C) :- variable_node(X), C = #max{I : has_incoming_in_step(Z, I), same_cc(X, Z)}.
min_in_cc(X, C) :- variable_node(X), C = #min{I : has_incoming_in_step(Z, I),  same_cc(X, Z)}.
max_in_cc(Y, C) :- max_in_cc(X, C), same_cc(X, Y).
min_in_cc(Y, C) :- min_in_cc(X, C), same_cc(X, Y).

%% il rappresentante è il nodo da cui esce l'arco con peso minimo in una CC. (dato un peso C, l'arco con quel peso è in una CC)
cc_representative(X) :- variable_node(X), min_in_cc(X, C), variable_node(Y), edge(X, Y, C).

% %% ------------------- SIMMETRY BREAKING (diverse CC) -------------------

% Se il max arco in una CC ha peso Ma, e il min arco in una CC ha peso Mi, allora devono esserci anche Mi+1, Mi+2, ..., Ma-1.
:- max_in_cc(X, Ma), min_in_cc(X, Mi), cc_representative(X), Ma != Mi, edge(Y, Z, J), step(J), variable_node(Y), variable_node(Z), not same_cc(X, Z), J > Mi, J < Ma.

% Se X è il rappresentante con arco uscente C e Y è il rappresentante con arco uscente C1, allora X < Y -> C < C1.
:- cc_representative(X), cc_representative(Y), min_in_cc(X, C), min_in_cc(Y, C1), X < Y, C1 < C.

%% ------------------- SIMMETRY BREAKING (stesse CC) -------------------

candidate_swap(J, K) :- edge(X, V, J), edge(W, Z, K), J < K. 

% un possible swap (i, j) [i < j] è effettuabile se mantiene i valori 

% devo cambiare i risultati di node_value per l'arco J, l'arco K e per tutti i tempi compresi tra J e K. 

% L'unico tempo al di fuori dell'intervallo {J, J+1, ..., K} che ci interessa è J - 1 per la chiamata ricorsiva.
node_value_fake(X, I, Y, J, K) :- node_value(X, I, Y), candidate_swap(J, K), I = J - 1. 

% l'arco J ora incide dove incide l'arco K e viceversa.
% J = X -> V e K = W -> Z. Al Tempo J di Z (nodo su cui incide K), devo modificare il suo valore.
%                          Al Tempo K di V (nodo su cui incide J), devo modificare il suo valore

%% gestisco il tempo J e il tempo K.

% Se Z è destinazione dell'arco K, cambio come valuto il suo tempo J (supponendo che l'arco numerato K sia fatto a tempo J).
node_value_fake(Z, J, Y, J, K) :- candidate_swap(J, K), edge(W, Z, K), node_value_fake(W, J - 1, Y, J, K), not node_value_fake(Z, J - 1, Y, J, K).
node_value_fake(Z, J, Y, J, K) :- candidate_swap(J, K), edge(W, Z, K), not node_value_fake(W, J - 1, Y, J, K), node_value_fake(Z, J - 1, Y, J, K).

% Se V è destinazione dell'arco J, cambio come valuto il suo tempo K (supponendo che l'arco numerato J sia fatto a tempo K).
node_value_fake(V, K, Y, J, K) :- candidate_swap(J, K), edge(X, V, J), node_value_fake(X, K - 1, Y, J, K), not node_value_fake(V, K - 1, Y, J, K).
node_value_fake(V, K, Y, J, K) :- candidate_swap(J, K), edge(X, V, J), not node_value_fake(X, K - 1, Y, J, K), node_value_fake(V, K - 1, Y, J, K).

% Se U non è destinazione dell'arco K, al tempo J non cambia niente per lui
node_value_fake(U, J, Y, J, K) :- candidate_swap(J, K), edge(W, Z, K), U != Z, node_value_fake(U, J - 1, Y, J, K). 

% % Se U non è destinazione dell'arco J, al tempo K non cambia niente per lui
node_value_fake(U, K, Y, J, K) :- candidate_swap(J, K), edge(X, V, J), U != V, node_value_fake(U, K - 1, Y, J, K). 

% %% tutti gli altri tempi

% % I node_value al tempo {J+1, J+2, ..., K-1} di nodi che non hanno archi entranti in quei tempi, sono invariati
node_value_fake(X, I, Y, J, K) :- candidate_swap(J, K), I > J, I < K, node_value_fake(X, I - 1, Y, J, K), not has_incoming_in_step(X, I).

% % I node_value al tempo {J+1, J+2, ..., K-1} di nodi che hanno archi entranti in quei tempi, sono da cambiare
node_value_fake(X, I, Y, J, K) :- candidate_swap(J, K), I > J, I < K, edge(Z, X, I), node_value_fake(Z, I - 1, Y, J, K), not node_value_fake(X, I - 1, Y, J, K).
node_value_fake(X, I, Y, J, K) :- candidate_swap(J, K), I > J, I < K, edge(Z, X, I), not node_value_fake(Z, I - 1, Y, J, K), node_value_fake(X, I - 1, Y, J, K).

errors_in_swap(J, K) :- candidate_swap(J, K), variable_node(X), variable_node(Y), node_value_fake(X, K, Y, J, K), not node_value(X, K, Y), has_incoming_in_step(X, I), step(I), I >= J, I <= K. 
errors_in_swap(J, K) :- candidate_swap(J, K), variable_node(X), variable_node(Y), not node_value_fake(X, K, Y, J, K), node_value(X, K, Y), has_incoming_in_step(X, I), step(I), I >= J, I <= K. 

valid_swap(J, K) :- candidate_swap(J, K), not errors_in_swap(J, K).

% fisso un ordine per i possible swap che partono dallo stesso nodo. 
% sia l'arco J = X -> V, e l'arco K = X -> Z. J < K -> V < Z
:- valid_swap(J, K), edge(X, V, J), edge(X, Z, K), Z < V.

% fisso un ordine per i possibili swap che arrivano nello stesso nodo. 
% sia l'arco J = X -> V, e l'arco K = W -> V. J < K -> X < W
:- valid_swap(J, K), edge(X, V, J), edge(W, V, K), W < X.

% fisso un ordine per tutti gli altri tipi di swap. 
% sia l'arco J = X -> V, e l'arco K = W -> Z. J < K -> V < Z
:- valid_swap(J, K), edge(X, V, J), edge(W, Z, K), X != W, Z < V. 

% finding dependency.

% come gestisco gli archi 'nel mezzo' di un valid swap?
% sono archi che possono essere fatti anche se uno swap avviene. 
% quindi quello swap per loro è ininfluente, continuano a farsi gli affari propri.

% faccio in modo che con lo swap si blocchino meno archi possibili. 

%% ------------------ FINAL CONSTRAINTS ------------------

%% i valori indotti devono coincidere con g
:- g(X, Y, 1), not node_value(X, l, Y).
:- node_value(X, l, Y), g(X, Y, 0).

%% ------------------ MINIMIZATION ------------------ 

% edges_count(S) :- S = #count{edges(X, Y, I): variable_node(X), variable_node(Y), step(I)}. 

% swap_count(S) :- S = #count{valid_swap(J, K) : step(J), step(K)}.

#show edge/3.
% #show blocked/1.
% #show has_incoming_in_step/2.
% #show same_value/3.
% #show fixed_rows/2.
% #show errors_in_swap/2.
% #show node_value_fake/5.
% #show min_in_cc/2.
% #show max_in_cc/2.
% #show cc_representative/1.
% #show same_cc/2.
% #show node_value/3.


