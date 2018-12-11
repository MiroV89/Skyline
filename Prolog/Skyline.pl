edificio(ed(X1,X2,H)).
coordenada(c(X1,Xh)).
skyline([c(X1,Xh)|R]).

% Funcion edificioAskyline: devuelve las coordenadas inicio y final de
% un edificio.
edificioAskyline(ed(A,B,C),[c(A,C),c(B,0)]).

%Funcion clear: limpia la pantalla.
clear :-write('\033[2J').

% Funcion divide: divide una lista de edificios en dos mitades,
% posiciones impares en la primera mitad y pares en la segunda.
divide([],[],[]).
divide([ed(X1,X2,Hx)],[ed(X1,X2,Hx)],[]).
divide([ed(X1,X2,Hx),ed(Y1,Y2,Hy)|Rxy],[ed(X1,X2,Hx)|Rx],[ed(Y1,Y2,Hy)|Ry]):-divide(Rxy,Rx,Ry).

% Funcion resuelveSkyline: funcion principal del programa que dada una
% lista de edificios devuelve un Skyline haciendo uso de las funciones
% -edificioAskyline
% -divide
% -combina
resuelveSkyline([],[]).
resuelveSkyline([ed(X1,X2,Hx)],X):-edificioAskyline(ed(X1,X2,Hx),X),!.
resuelveSkyline([ed(X1,X2,Hx),ed(Y1,Y2,Hy)|Rxy],X):-
	divide([ed(X1,X2,Hx),ed(Y1,Y2,Hy)|Rxy],Y,Z),
	resuelveSkyline(Y,T),resuelveSkyline(Z,U),combina(T,U,X),!.

% Funcion combina: dadas dos listas de coordenadas devuelve un skyline
% haciendo uso de la funcion auxiliar combinar
combina([],[],[]).
combina([],[c(X1,X2)|Rx],[c(X1,X2)|Rx]).
combina([c(X1,X2)|Rx],[],[c(X1,X2)|Rx]).
combina([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],L):-
	combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],0,0,0,L).

% Funcion auxiliar recursiva de combina que dadas dos listas de
% coordenadas devuelve un skyline. Hace uso de la funcion max.
combinar([],[],_,_,_,_).
combinar([],L,_,_,_,L).
combinar(L,[],_,_,_,L).
combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],_,_,LastH,[c(X1,Max)|L]):-
      X1==Y1,max(X2,Y2,Max),Max\=LastH,combinar(Rx,Ry,X2,Y2,Max,L).

combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],_,_,LastH,L):-
      X1==Y1,combinar(Rx,Ry,X2,Y2,LastH,L).

combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],_,LastY,LastH,[c(X1,Max)|L]):-
      X1<Y1,max(X2,LastY,Max),Max\=LastH,combinar(Rx,[c(Y1,Y2)|Ry],X2,LastY,Max,L).

combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],_,LastY,_,L):-
      X1<Y1,max(X2,LastY,Max),combinar(Rx,[c(Y1,Y2)|Ry],X2,LastY,Max,L).

combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],LastX,_,LastH,[c(Y1,Max)|L]):-
      X1>Y1, max(Y2,LastX,Max),Max\=LastH,combinar([c(X1,X2)|Rx],Ry,LastX,Y2,Max,L).

combinar([c(X1,X2)|Rx],[c(Y1,Y2)|Ry],LastX,_,_,L):-
      X1>Y1,max(Y2,LastX,Max),combinar([c(X1,X2)|Rx],Ry,LastX,Y2,Max,L).

%Funcion max devuelve el maximo entre dos elementos.
max(X,Y,Max):-(X>Y ->Max=X;Max=Y).

%Funcion maxLista devuelve el elemento con mayor valor de una lista.
maxLista([],[]).
maxLista([X],X).
maxLista([X,Y|L],Z):-maxLista([Y|L],U),max(X,U,Z),!.

% Funcion dibuja: dada una lista de coordenadas devuelve su dibujo en un
% String haciendo uso de las siguientes funciones auxiliares:
% -dibujar
% -dibujaLinea
% -divideCoordenadas
% -maxLista
dibujaSkyline(Lista):-dibujaSkyline(Lista,Sol),write(Sol).
dibujaSkyline([],[]).
dibujaSkyline(Lista,R):-divideCoordenadas(Lista,0,0,X),
	maxLista(X,Z),dibujar(X,Z,R),!.

% Funcion dibujar: auxiliar de dibuja. Dada una lista de alturas dibuja
% recursivamente linea a linea (mediante dibujaLinea) por pantalla su
% correspondiente dibujo.
dibujar([],_,[]).
dibujar([X|Rx],N,R):-N>0,dibujaLinea([X|Rx],N,S),M is N-1,
	dibujar([X|Rx],M,T),concat(S,T,R),!.
dibujar([X|Rx],N,R):-N==0,dibujaLinea([X|Rx],N,S),concat("",S,R),!.

% Funcion dibujaLinea: auxiliar de dibujar. Dada una lista de alturas
% dibuja la linea de la altura N.
dibujaLinea([],_,"\n").
dibujaLinea([_|Rx],N,R):-N==0,dibujaLinea(Rx,N,S),concat("-",S,R),! .
dibujaLinea([X|Rx],N,R):-N>0,X>=N,dibujaLinea(Rx,N,S),concat("*",S,R),! .
dibujaLinea([_|Rx],N,R):-dibujaLinea(Rx,N,S),concat(" ",S,R),! .

% Funcion divideCoordenadas: auxiliar de dibujar. Dadas unas coordenadas
% (Skyline) devuelve una lista de alturas.
divideCoordenadas([],_,_,[]).
divideCoordenadas([c(X1,X2)|Rx],N,LastH,[LastH|L]):- X1>N,
	divideCoordenadas([c(X1,X2)|Rx],(N+1),LastH,L),!.
divideCoordenadas([c(_,X2)|Rx],N,_,[X2|L]):-
	divideCoordenadas(Rx,(N+1),X2,L),!.
