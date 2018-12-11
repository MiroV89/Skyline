module Skyline where

-- Cabecera del programa Skyline.hs
-- Práctica de Teoría de los Lenguajes de Programación
-- Curso 2015-2016

type Edificio = (Int,Int,Int)
type Coordenada = (Int,Int)
type Skyline = [Coordenada]

--Funcion edificioAskyline: devuelve las coordenadas inicio y final de
--un edificio.
edificioAskyline [(a,b,c)] 
  | a < b = [(a,c),(b,0)]
  |otherwise = error ("Coordenadas mal introducidas: ("++ (show a)++ ","++(show b)++","++(show c)++").")

--Funcion resuelveSkyline: funcion principal del programa que dada una
--lista de edificios devuelve un Skyline haciendo uso de las funciones
-- edificioAskyline
-- divide
-- combina
resuelveSkyline:: [Edificio] -> Skyline
resuelveSkyline [] = []
resuelveSkyline [x] = edificioAskyline [x]
resuelveSkyline (x:xs) = combina (resuelveSkyline(fst (divide(x:xs)))) 
                                 (resuelveSkyline(snd (divide(x:xs))))

--Funcion divide: divide una lista de edificios en dos mitades.
divide [] = ([],[])
divide (x:xs) = (take (div (length(x:xs)) 2) (x:xs),drop (div (length (x:xs)) 2) (x:xs))

--Funcion combina: dadas dos listas de coordenadas devuelve un skyline
--haciendo uso de la funcion auxiliar combina'
combina:: Skyline -> Skyline -> Skyline
combina [] [] = []
combina [] ((y1,y2):ys) = (y1,y2):ys
combina ((x1,x2):xs) [] = (x1,x2):xs
combina ((x1,x2):xs) ((y1,y2):ys) = combina' ((x1,x2):xs) ((y1,y2):ys) 0 0 0

--Funcion auxiliar recursiva de combina que dadas dos listas de
--coordenadas devuelve un skyline.
combina' [] [] _ _ _= []
combina' [] ((y1,y2):ys) _ _ _= (y1,y2):ys
combina' ((x1,x2):xs) [] _ _ _ = (x1,x2):xs
combina' ((x1,x2):xs) ((y1,y2):ys) lastx lasty lasth
  | x1==y1 =  if (max x2 y2)/=lasth then (x1,(max x2 y2)) :combina' xs ys x2 y2 (max x2 y2)
              else combina' xs ys x2 y2 lasth
  | x1<y1 =   if (max x2 lasty)/=lasth  then (x1,max x2 lasty) :combina' xs ((y1,y2):ys) x2 lasty (max x2 lasty)
              else combina' xs ((y1,y2):ys) x2 lasty (max x2 lasty)
  | otherwise = if (max y2 lastx)/=lasth then (y1,max y2 lastx) :combina' ((x1,x2):xs) ys lastx y2 (max y2 lastx)
              else combina' ((x1,x2):xs) ys lastx y2 (max y2 lastx)

--Funcion dibuja: dada una lista de coordenadas devuelve su dibujo en un
--String haciendo uso de las siguientes funciones auxiliares:
-- dibujar
-- dibujaLinea
-- divideCoordenadas

dibujaSkyline [] = []
dibujaSkyline (x:xs) = dibujar (divideCoordenadas (x:xs) 0 0) (maximum(divideCoordenadas (x:xs) 0 0))

--Funcion dibujar: auxiliar de dibuja. Dada una lista de alturas dibuja
--recursivamente linea a linea (mediante dibujaLinea) por pantalla su
--correspondiente dibujo.
dibujar [] n = []
dibujar (x:xs) n 
  | n >=0 = dibujaLinea (x:xs) n ++ "\n" ++ dibujar (x:xs) (n-1)
  |otherwise = []

--Funcion dibujaLinea: auxiliar de dibujar. Dada una lista de alturas
--dibuja la linea de la altura N.
dibujaLinea [] _ = []
dibujaLinea (x:xs) n
  | n==0 = '-':dibujaLinea xs n
  | x>=n = '*':dibujaLinea xs n
  | otherwise = ' ':dibujaLinea xs n
  
--Funcion divideCoordenadas: auxiliar de dibujar. Dadas unas coordenadas
--(Skyline) devuelve una lista de alturas.
divideCoordenadas [] _ _= []
divideCoordenadas ((x1,x2):xs) n lastH 
  | x1>n = lastH :divideCoordenadas ((x1,x2):xs) (n+1) lastH
  | otherwise = x2:divideCoordenadas xs (n+1) x2
