% ============================================================
% Queries - Formula 1 2024 - Knowledge Engine
% resultado(piloto, equipe, corrida, ano, grid, posicao, pontos, voltas).
% ============================================================

% Predicado auxiliar: lista todos os pilotos unicos
piloto(P) :-
    resultado(P, _, _, _, _, _, _, _).

% Predicado auxiliar: lista todas as equipes unicas
equipe(E) :-
    resultado(_, E, _, _, _, _, _, _).

% ============================================================
% PERGUNTA 1: Ranking de pilotos por pontos totais
% "Qual foi a classificacao final do campeonato de 2024?"
%
% Como usar:
% ?- classificacao_pilotos(Tabela).
% ============================================================

pontos_piloto(Piloto, Total) :-
    piloto(Piloto),
    findall(P, resultado(Piloto, _, _, _, _, _, P, _), Lista),
    sum_list(Lista, Total).

classificacao_pilotos(Tabela) :-
    setof(Total-Piloto, pontos_piloto(Piloto, Total), ListaOrd),
    reverse(ListaOrd, Tabela).

% ============================================================
% PERGUNTA 2: Melhor recuperacao de grid
% "Quais pilotos mais recuperaram posicoes em relacao a largada?"
%
% Como usar:
% ?- melhor_recuperacao(Piloto, Corrida, Grid, Posicao, Recuperacao).
% ============================================================

recuperacao(Piloto, Corrida, Grid, Posicao, Recuperacao) :-
    resultado(Piloto, _, Corrida, _, Grid, Posicao, _, _),
    number(Grid),
    number(Posicao),
    Grid > Posicao,
    Recuperacao is Grid - Posicao.

melhor_recuperacao(Piloto, Corrida, Grid, Posicao, Recuperacao) :-
    recuperacao(Piloto, Corrida, Grid, Posicao, Recuperacao),
    \+ (recuperacao(_, _, _, _, R2), R2 > Recuperacao).

% ============================================================
% PERGUNTA 3: Ranking de equipes por pontos totais
% "Qual equipe somou mais pontos ao longo da temporada?"
%
% Como usar:
% ?- classificacao_equipes(Tabela).
% ============================================================

pontos_equipe(Equipe, Total) :-
    equipe(Equipe),
    findall(P, resultado(_, Equipe, _, _, _, _, P, _), Lista),
    sum_list(Lista, Total).

classificacao_equipes(Tabela) :-
    setof(Total-Equipe, pontos_equipe(Equipe, Total), ListaOrd),
    reverse(ListaOrd, Tabela).
