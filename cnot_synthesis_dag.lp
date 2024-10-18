% #const n = 4. 
% #const l = 3. 
% #const k = 1. 

% g(1, 1, 1). g(1, 2, 0). g(1, 3, 0). g(1, 4, 0).
% g(2, 1, 0). g(2, 2, 1). g(2, 3, 0). g(2, 4, 0).
% g(3, 1, 0). g(3, 2, 0). g(3, 3, 1). g(3, 4, 0).
% g(4, 1, 1). g(4, 2, 0). g(4, 3, 0). g(4, 4, 1).


variable_node(1..n). % nodes
layer(0..l). % layers
non_zero_layer(1..l).
% f(1..k). % number of F

% ora lavoriamo con un dag a livelli. 

% xor_node(X, Y, I) =        X   Y 
%                             \ /
% layer I                      X

xor_node(X, X, 0) :- variable_node(X).

:- xor_node(X, Y, 0), X != Y.

% :- xor_node(X, Y, I), xor_node(X, Y, J), J > I. 

% dato un layer e data una variabile X, in quel layer al massimo una volta posso cambiare X
0{xor_node(X, Y, I) : variable_node(Y)}1 :- non_zero_layer(I), variable_node(X).

% dato un layer, Y può essere messo in xor con al massimo n-1 altre variabili
% 0{xor_node(X, Y, I) : variable_node(X), layer(I)}n :- variable_node(Y).

% non auto xor
:- xor_node(X, X, I), non_zero_layer(I).

% non possono 'scambiarsi' i valori in un layer
:- xor_node(X, Y, I), xor_node(Y, X, I), non_zero_layer(I), Y != X.

% ------------------- NON ASPETTARE SE CI SONO PIù LAYER DEL DOVUTO -------------------

% se può fare un cnot tra X e Y a layer I, non deve aspettare.
% :- xor_node(X, Y, I), closer_xor(X, I, J), closer_xor(Y, I, J), I != J + 1, I > 0.
:- xor_node(X, Y, I), closer_xor(X, I, J), closer_xor(Y, I, K), K < J, I != J + 1, I > 0.
:- xor_node(X, Y, I), closer_xor(X, I, J), closer_xor(Y, I, K), K > J, I != K + 1, I > 0.

% ------------------- PARTIZIONE LAYER VUOTI / NON VUOTI -------------------

% Se c'è un layer vuoto, anche tutti quelli dopo lo devono essere
xor_in_layer(0).
xor_in_layer(I) :- xor_node(X, Y, I), non_zero_layer(I). 

% empty_layer(l+1).
% empty_layer(I) :- not xor_in_layer(I), layer(I).
% last_non_empty_layer(I) :- xor_in_layer(I), empty_layer(I + 1). 
% :- empty_layer(I - 1), xor_in_layer(I), I > 0.

last_non_empty_layer(I) :- xor_in_layer(I), not xor_in_layer(I + 1).
:- xor_in_layer(I), not layer(I).
:- xor_in_layer(J), last_non_empty_layer(I), J > I, non_zero_layer(J). 

%% ------------------- PER TROVARE GLI XOR ANDANDO ALL'INDIETRO -------------------

edited_in_layer(X, 0) :- variable_node(X).

% se una variabile è vittima di uno xor in un layer
edited_in_layer(X, I) :- variable_node(X), xor_node(X, Y, I), variable_node(Y), non_zero_layer(I).

% true se X è stata modificata in almeno un layer tra I e J (estremi esclusi)
edited_between(X, I, J) :- variable_node(X), non_zero_layer(I), layer(J), I > J, layer(K), edited_in_layer(X, K), K < I, K > J.
edited_between(X, I, J) :- variable_node(X), non_zero_layer(I), layer(J), I > J, layer(K), edited_between(X, I, K), K > J. 
edited_between(X, I, J) :- variable_node(X), non_zero_layer(I), layer(J), I > J, layer(K), edited_between(X, K, J), K < I.
:- edited_between(X, I, J), J > I. 

% partendo dal livello I, trova il massimo J < I tc X è il risultato di un nodo. 
closer_xor(X, 1, 0) :- variable_node(X). 
closer_xor(X, I, J) :- variable_node(X), non_zero_layer(I), I > J, layer(J), edited_in_layer(X, J), not edited_between(X, I, J).
closer_xor(X, I, J) :- variable_node(X), non_zero_layer(I), K > I, I > J, layer(J), closer_xor(X, K, J). 

% closer_xor(X, I, J) :- variable_node(X), layer(I), layer(J), J = #max{K : edited_in_layer(X, K), K < I, layer(K)}.

% ------------------- ORA CALCOLO IL VALORE -------------------

% il valore di X al livello I contiene Y.

% al layer I la variabile X ha solo se stessa nel valore 
xor_value(X, 0, X) :- variable_node(X).

% modifica value
xor_value(X, I, Y) :- non_zero_layer(I), xor_node(X, Z, I), xor_value(X, I - 1, Y), not xor_value(Z, I - 1, Y).
xor_value(X, I, Y) :- non_zero_layer(I), xor_node(X, Z, I), not xor_value(X, I - 1, Y), xor_value(Z, I - 1, Y).

% passaggio ricorsivo
xor_value(X, I, Y) :- non_zero_layer(I), not edited_in_layer(X, I), xor_value(X, I - 1, Y).

:- row_is_wrong(X, I), last_non_empty_layer(I), variable_node(X), layer(I).

:- xor_node(X, Y, I), xor_node(Y, X, I), layer(I), variable_node(X), variable_node(Y), X != Y.

% :- xor_value(X, I, Y), g(X, Y, 0), last_non_empty_layer(I).
% :- not xor_value(X, I, Y), g(X, Y, 1), last_non_empty_layer(I).

%% ------------------- QUANDO UNA RIGA E' SISTEMATA NON LA CAMBIARE ------------------- 

row_is_wrong(X, 0) :- variable_node(Y), g(X, Y, 1), X != Y.
row_is_wrong(X, I) :- not xor_value(X, I, Y), g(X, Y, 1), edited_in_layer(X, I), non_zero_layer(I).
row_is_wrong(X, I) :- xor_value(X, I, Y), g(X, Y, 0), edited_in_layer(X, I), non_zero_layer(I).
row_is_wrong(X, I) :- row_is_wrong(X, I - 1), not edited_in_layer(X, I), non_zero_layer(I). 
row_is_wrong(X, I) :- row_is_wrong(X, J), not edited_in_layer(X, I), closer_xor(X, I, J). 
row_is_wrong(X, I) :- row_is_wrong(X, J), not edited_in_layer(X, I), layer(J), not edited_between(X, I, J), row_is_wrong(X, J + 1), layer(I). 

row_is_ok(X, I) :- variable_node(X), not row_is_wrong(X, I), layer(I). 
row_is_ok(X, I) :- variable_node(X), row_is_ok(X, I - 1), non_zero_layer(I).
row_is_ok(X, I) :- variable_node(X), K < I, row_is_ok(X, K), non_zero_layer(I).

min_row_is_ok(X, 0) :- row_is_ok(X, 0), variable_node(X).
min_row_is_ok(X, I) :- row_is_ok(X, I), row_is_wrong(X, I - 1), variable_node(X), non_zero_layer(I).

% :- row_is_wrong(X, I), row_is_ok(X, I).
:- row_is_ok(X, I), row_is_wrong(X, I + 1), layer(I), I < n.
:- min_row_is_ok(X, I), layer(I), edited_in_layer(X, J), J > I, layer(J).

number_of_useful_nodes(S) :- S = #count{X, I : xor_node(X, Y, I), I > 0}.

%% ------------------- VINCOLO SU F -------------------

% per ogni f, deve esistere un istante in cui lo xor_value di una certa variabile sia esattamente f

%vera se la variabile X al layer I è diversa da f_J
% var_f_different(X, I, J) :- variable_node(X), layer(I), f(J), variable_node(Y), f(J, Y, 1), not xor_value(X, I, Y), edited_in_layer(X, I).
% var_f_different(X, I, J) :- variable_node(X), layer(I), f(J), variable_node(Y), f(J, Y, 0), xor_value(X, I, Y), edited_in_layer(X, I).
% var_f_different(X, I, J) :- variable_node(X), layer(I), f(J), variable_node(Y), var_f_different(X, I - 1, J), not edited_in_layer(X, I).
% % % var_f_different(X, I, J) :- variable_node(X), layer(I), f(J), var_f_different(X, K, J), layer(K), closer_xor(X, I, K), not edited_in_layer(X, I).

% var_f_same(X, I, J) :- not var_f_different(X, I, J), variable_node(X), layer(I), f(J).

% f_fixed(J) :- var_f_same(X, I, J), variable_node(X), layer(I), f(J).

% :- not f_fixed(J), f(J).

%% ------------------- COME SPACCO LE SIMMETRIE -------------------


% Non ha senso che se faccio uno xor tra X e Y a livello I e poi uno tra X e Y a livello J se nè X nè sono cambiati tra I e J. 
% :- xor_node(X, Y, I), xor_node(X, Y, J), J > I, closer_xor(Y, J, K), closer_xor(X, J, I), K < I.


#minimize{S : number_of_useful_nodes(S)}.

#show xor_node/3.