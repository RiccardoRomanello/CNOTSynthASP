#const n = 4. 
#const l = 2. 
% #const k = 1. 

% g \in n \times n 
% f \in k \times n

% ---------------- INPUT EXAMPLE ---------------------
%
% G = [[1, 1, 0, 0], [1, 0, 0, 0], [0, 1, 1, 1], [0, 1, 0, 1]]
%
%    g(1, 1, 1). g(1, 2, 1). g(1, 3, 0). g(1, 4, 0).
%    g(2, 1, 1). g(2, 2, 0). g(2, 3, 0). g(2, 4, 0).
%    g(3, 1, 0). g(3, 2, 1). g(3, 3, 1). g(3, 4, 1).
%    g(4, 1, 0). g(4, 2, 1). g(4, 3, 0). g(4, 4, 1).
%
% ---------------- END EXAMPLE -----------------

% g(1, 1, 1). g(1, 2, 0). g(1, 3, 0). g(1, 4, 1). g(1, 5, 0). g(1, 6, 0). g(1, 7, 1). g(1, 8, 1). 
% g(2, 1, 1). g(2, 2, 1). g(2, 3, 0). g(2, 4, 0). g(2, 5, 1). g(2, 6, 0). g(2, 7, 1). g(2, 8, 1). 
% g(3, 1, 1). g(3, 2, 0). g(3, 3, 1). g(3, 4, 1). g(3, 5, 0). g(3, 6, 1). g(3, 7, 0). g(3, 8, 0). 
% g(4, 1, 0). g(4, 2, 1). g(4, 3, 0). g(4, 4, 1). g(4, 5, 0). g(4, 6, 0). g(4, 7, 0). g(4, 8, 0). 
% g(5, 1, 0). g(5, 2, 0). g(5, 3, 0). g(5, 4, 0). g(5, 5, 1). g(5, 6, 1). g(5, 7, 0). g(5, 8, 0). 
% g(6, 1, 0). g(6, 2, 0). g(6, 3, 1). g(6, 4, 1). g(6, 5, 0). g(6, 6, 1). g(6, 7, 0). g(6, 8, 0). 
% g(7, 1, 0). g(7, 2, 1). g(7, 3, 0). g(7, 4, 0). g(7, 5, 1). g(7, 6, 0). g(7, 7, 1). g(7, 8, 1). 
% g(8, 1, 0). g(8, 2, 1). g(8, 3, 0). g(8, 4, 0). g(8, 5, 1). g(8, 6, 0). g(8, 7, 1). g(8, 8, 0). 

% f(1, 1, 1). f(1, 2, 0). f(1, 3, 0). f(1, 4, 1). f(1, 5, 0). f(1, 6, 0). f(1, 7, 1). f(1, 8, 1). 
% f(2, 1, 0). f(2, 2, 1). f(2, 3, 0). f(2, 4, 0). f(2, 5, 0). f(2, 6, 0). f(2, 7, 1). f(2, 8, 1). 
% f(3, 1, 1). f(3, 2, 0). f(3, 3, 1). f(3, 4, 0). f(3, 5, 0). f(3, 6, 0). f(3, 7, 0). f(3, 8, 0). 
% f(4, 1, 0). f(4, 2, 1). f(4, 3, 0). f(4, 4, 0). f(4, 5, 0). f(4, 6, 0). f(4, 7, 0). f(4, 8, 0). 
% f(5, 1, 0). f(5, 2, 0). f(5, 3, 0). f(5, 4, 0). f(5, 5, 1). f(5, 6, 0). f(5, 7, 0). f(5, 8, 0). 
% f(6, 1, 0). f(6, 2, 0). f(6, 3, 0). f(6, 4, 1). f(6, 5, 0). f(6, 6, 1). f(6, 7, 0). f(6, 8, 0). 

% g(1, 1, 1). g(1, 2, 0). g(1, 3, 0). g(1, 4, 1). g(1, 5, 0). g(1, 6, 0). g(1, 7, 1). 
% g(2, 1, 1). g(2, 2, 1). g(2, 3, 0). g(2, 4, 0). g(2, 5, 1). g(2, 6, 0). g(2, 7, 1). 
% g(3, 1, 1). g(3, 2, 0). g(3, 3, 1). g(3, 4, 1). g(3, 5, 0). g(3, 6, 1). g(3, 7, 0). 
% g(4, 1, 0). g(4, 2, 1). g(4, 3, 0). g(4, 4, 1). g(4, 5, 0). g(4, 6, 0). g(4, 7, 0). 
% g(5, 1, 0). g(5, 2, 0). g(5, 3, 0). g(5, 4, 0). g(5, 5, 1). g(5, 6, 1). g(5, 7, 0). 
% g(6, 1, 0). g(6, 2, 0). g(6, 3, 1). g(6, 4, 1). g(6, 5, 0). g(6, 6, 1). g(6, 7, 0). 
% g(7, 1, 0). g(7, 2, 1). g(7, 3, 0). g(7, 4, 0). g(7, 5, 1). g(7, 6, 0). g(7, 7, 1). 

% g(1, 1, 1). g(1, 2, 1). g(1, 3, 0). g(1, 4, 1). g(1, 5, 1). g(1, 6, 0).
% g(2, 1, 1). g(2, 2, 0). g(2, 3, 1). g(2, 4, 1). g(2, 5, 0). g(2, 6, 1).
% g(3, 1, 0). g(3, 2, 1). g(3, 3, 1). g(3, 4, 0). g(3, 5, 1). g(3, 6, 1).
% g(4, 1, 1). g(4, 2, 1). g(4, 3, 1). g(4, 4, 1). g(4, 5, 0). g(4, 6, 0).
% g(5, 1, 1). g(5, 2, 0). g(5, 3, 0). g(5, 4, 1). g(5, 5, 1). g(5, 6, 1).
% g(6, 1, 0). g(6, 2, 1). g(6, 3, 0). g(6, 4, 0). g(6, 5, 1). g(6, 6, 1).

% f(1, 1, 1). f(1, 2, 1). f(1, 3, 0). f(1, 4, 0). f(1, 5, 1). f(1, 6, 0).
% f(2, 1, 1). f(2, 2, 0). f(2, 3, 1). f(2, 4, 1). f(2, 5, 0). f(2, 6, 1).
% f(3, 1, 0). f(3, 2, 1). f(3, 3, 0). f(3, 4, 1). f(3, 5, 0). f(3, 6, 0).
% f(4, 1, 0). f(4, 2, 0). f(4, 3, 0). f(4, 4, 0). f(4, 5, 1). f(4, 6, 0).

% g(1, 1, 0). g(1, 2, 0). g(1, 3, 0). g(1, 4, 1). g(1, 5, 1). 
% g(2, 1, 1). g(2, 2, 1). g(2, 3, 0). g(2, 4, 0). g(2, 5, 1). 
% g(3, 1, 1). g(3, 2, 1). g(3, 3, 0). g(3, 4, 0). g(3, 5, 0). 
% g(4, 1, 1). g(4, 2, 0). g(4, 3, 0). g(4, 4, 1). g(4, 5, 1). 
% g(5, 1, 0). g(5, 2, 0). g(5, 3, 1). g(5, 4, 0). g(5, 5, 0). 

% f(2, 1, 0). f(2, 2, 0). f(2, 3, 0). f(2, 4, 1). f(2, 5, 0). 
% f(3, 1, 1). f(3, 2, 0). f(3, 3, 1). f(3, 4, 0). f(3, 5, 0). 
% f(5, 1, 1). f(5, 2, 1). f(5, 3, 0). f(5, 4, 1). f(5, 5, 1). 

g(1, 1, 1). g(1, 2, 1). g(1, 3, 0). g(1, 4, 0). 
g(2, 1, 0). g(2, 2, 1). g(2, 3, 0). g(2, 4, 1). 
g(3, 1, 0). g(3, 2, 1). g(3, 3, 1). g(3, 4, 0). 
g(4, 1, 0). g(4, 2, 0). g(4, 3, 0). g(4, 4, 1). 

% f(1, 1, 0). f(1, 2, 1). f(1, 3, 1). f(1, 4, 0).
% f(2, 1, 1). f(2, 2, 1). f(2, 3, 1). f(2, 4, 0).

% g(1, 1, 1). g(1, 2, 0). g(1, 3, 1).
% g(2, 1, 0). g(2, 2, 1). g(2, 3, 1).
% g(3, 1, 1). g(3, 2, 1). g(3, 3, 1).

% f(2, 1, 0). f(2, 2, 1). f(2, 3, 0).
% f(3, 1, 1). f(3, 2, 1). f(3, 3, 1).
