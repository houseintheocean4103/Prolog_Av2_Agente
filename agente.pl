:- dynamic posicao/1.
:- dynamic inventario/1.
:- dynamic visitados/1.

posicao(pos).
inventario([]).
visitados([]). 

conectado(estacao, republica).
conectado(estacao, veropeso).
conectado(estacao, maab).

conectado(republica, estacao).
conectado(republica, patiobelem).
conectado(republica, batista).

conectado(batista, republica).
conectado(batista, patiobelem).
conectado(batista, veropeso).

conectado(patiobelem, batista).
conectado(patiobelem, republica).
conectado(patiobelem, maab).

conectado(maab, batista).
conectado(maab, veropeso).
conectado(maab, estacao).

conectado(veropeso, estacao).
conectado(veropeso, batista).
conectado(veropeso, maab).

tem(estacao, sorvete).
tem(estacao, refeicao).
tem(republica, artesanato).
tem(republica, livro).
tem(batista, guarana).
tem(batista, agua).
tem(patiobelem, roupa).
tem(patiobelem, perfume).
tem(maab, quadro).
tem(maab, cafe).
tem(veropeso, fruta).
tem(veropeso, carne).

nome(patiobelem, "Pátio Belém").
nome(maab, "Museu de Arte").
nome(republica, "Praça da República").
nome(estacao, "Estação das Docas").
nome(veropeso, "Ver-o-Peso").
nome(batista, "Praça Batista Campos").

nome(sorvete, "Sorvete de Açaí").
nome(refeicao, "Refeição Regional").
nome(artesanato, "Artesanato Paraense").
nome(livro, "Livro Histórico").
nome(guarana, "Guaraná da Amazônia").
nome(agua, "Água Mineral").
nome(roupa, "Roupa Estilosa").
nome(perfume, "Perfume Importado").
nome(quadro, "Quadro Artístico").
nome(cafe, "Café Gelado").
nome(fruta, "Fruta Regional").
nome(carne, "Carne Fresca").

inicio(P) :- nome(P,A),
             retract(posicao(pos)),
             assert(posicao(P)),
             retract(visitados(V)),
             assert(visitados([A|V])),
             format('Você começou em ~w!\n', [A]).
             
estou :- posicao(P), nome(P,A), format('Você está em ~w\n', [A]).

esta_conectado(P) :- conectado(P,X), 
                     conectado(P,Y), 
                     Y \= X, 
                     conectado(P,Z), 
                     Z \= Y,
                     Z \= X,
                     nome(P, M),
                     nome(X, A),
                     nome(Y, B),
                     nome(Z, C),
                     format('O local ~w está conectado a ~w, ~w e ~w\n', [M, A, B, C]).

mover(Destino) :- posicao(Origem),
               conectado(Origem, Destino),
               nome(Origem,M),
               nome(Destino,N),
               retract(posicao(Origem)),
               assert(posicao(Destino)),
               retract(visitados(V)),
               assert(visitados([N|V])) ,
               format('Andou de ~w até ~w\n', [M, N]).

mover_para(Destino) :- ( 
                    mover(Destino), !
                    ; 
                    ( posicao(P),
                    nome(P, A),
                    nome(Destino, B),
                    format('Não é possível andar de ~w até ~w\n', [A, B] ), !)
                    ).

vende(P) :- tem(P, X), 
            tem(P, Y), 
            X \= Y,
            nome(P, A),
            nome(X, B),
            nome(Y, C),
            format('Em ~w vende-se ~w e ~w\n', [A, B, C]). 

comprar(Obj) :- posicao(P),
                tem(P, Obj),
                nome(P, A),
                nome(Obj, B),
                retract(inventario(L)),
                assert(inventario([B|L])),              
                format('Comprou ~w em ~w\n', [B, A]).

comprar(Obj) :- posicao(P),
                tem(X,Obj),
                nome(P, A),
                nome(Obj, B),
                nome(X, C),
                format('Não se vende ~w em ~w, somente em ~w\n', [B, A, C]).

devolver(Obj) :- inventario(L),
                 nome(Obj,A),
                 member(A, L),
                 ( 
                 posicao(P), 
                 tem(P, Obj) 
                 ->
                 delete(L, A, NovoL),
                 retract(inventario(L)),
                 assert(inventario(NovoL)),
                 nome(P, C),
                 format('Devolveu ~w em ~w\n', [A, C]) 
                 ; 
                 tem(X, Obj),               
                 nome(X, B),
                 format('Apenas é possível devolver ~w em ~w\n', [A, B])), !.

devolver(Obj) :- nome(Obj,A), format('Não existe ~w no inventário\n', [A]).

ver_compras :-
    inventario([]),
    format('Sacola vazia\n'), !.

ver_compras :-
    inventario(L),
    inverte(L, Lc),
    format('Compras: ~w\n', [Lc]).

ver_visitados :-
    visitados([]),
    format('Nenhum local visitado ainda\n'), !.

ver_visitados :-
    visitados(L),
    inverte(L, Lv),
    format('Locais visitados: ~w\n', [Lv]).

final :- format('Fim do passeio:\n'), ver_compras, ver_visitados.

tutorial :-
    writeln('==== Tutorial do Jogo ===='), nl,
    writeln('Seu objetivo é passear e realizar compras por Belém.'), nl,
    writeln('Utilize os seguintes átomos para realizar ações:'), nl,

    writeln('--- Lugares ---'),
    writeln('republica     (Praça da República)'),
    writeln('estacao       (Estação das Docas)'),
    writeln('maab          (Museu de Arte)'),
    writeln('batista       (Praça Batista Campos)'),
    writeln('patiobelem    (Pátio Belém)'),
    writeln('veropeso      (Ver-o-Peso)'), nl,

    writeln('--- Itens ---'),
    writeln('sorvete       (Sorvete de Açaí)'),
    writeln('refeicao      (Refeição Regional)'),
    writeln('artesanato    (Artesanato Paraense)'),
    writeln('livro         (Livro Histórico)'),
    writeln('guarana       (Guaraná da Amazônia)'),
    writeln('agua          (Água Mineral)'),
    writeln('roupa         (Roupa Estilosa)'),
    writeln('perfume       (Perfume Importado)'),
    writeln('quadro        (Quadro Artístico)'),
    writeln('cafe          (Café Gelado)'),
    writeln('fruta         (Fruta Regional)'),
    writeln('carne         (Carne Fresca)'), nl,

    writeln('--- Comandos ---'),
    writeln('inicio(L)             -> define o ponto L inicial do agente'),
    writeln('esta_conectado(L)     -> mostra as conexões do local L'),
    writeln('mover_para(L)         -> move o agente para o local L, se houver conexão'),
    writeln('estou                 -> mostra a posição atual do agente'),
    writeln('vende(L)              -> apresenta os itens vendidos no local L'),
    writeln('comprar(Item)         -> compra o Item se ele estiver disponível no local'),
    writeln('devolver(Item)        -> devolve o Item, se estiver no inventário e no local de devolução'),
    writeln('ver_compras           -> lista os itens que o agente possui'),
    writeln('ver_visitados         -> lista os locais já visitados'),
    writeln('final                 -> mostra as compras e os locais visitados'),
    writeln(' !                    -> encerra o programa'), nl,

    writeln('==========================').

inverte(L, R) :- inverte(L, [], R). 
inverte([], R, R) :- !.
inverte([X|Y], Inv, R) :- inverte(Y, [X|Inv], R).
