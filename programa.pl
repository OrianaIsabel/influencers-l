% Aquí va el código.

% Punto 1

canal(ana, youtube, 3000000).
canal(ana, instagram, 2700000).
canal(ana, tiktok, 1000000).
canal(ana, twitch, 2).

canal(beto, twitch, 120000).
canal(beto, youtube, 6000000).
canal(beto, instagram, 1100000).

canal(cami, tiktok, 2000).

canal(dani, youtube, 1000000).

canal(evelyn, instagram, 1).

% Punto 2

listaSeg(Persona, ListaSeg):-
    canal(Persona,_,_),
    findall(Seguidores, canal(Persona,_, Seguidores), ListaSeg).

influencer(Persona):-
    canal(Persona,_,_),
    listaSeg(Persona, ListaSeg),
    sum_list(ListaSeg, SeguidoresTotal),
    SeguidoresTotal > 10000.

omnipresente(Persona):-
    canal(Persona,_,_),
    forall(canal(_, Cuenta,_), canal(Persona, Cuenta,_)).

exclusivo(Persona):-
    canal(Persona,_,_),
    forall((canal(Persona, Cuenta1,_), canal(Persona, Cuenta2,_)), Cuenta1 = Cuenta2).

% Punto 3

publico(ana, tiktok, video([beto, evelyn], 1)).
publico(ana, tiktok, video([ana], 1)).
publico(ana, instagram, foto([ana])).

publico(beto, instagram, foto([])).

publico(cami, twitch, stream(leagueOfLegends)).
publico(cami, youtube, video([cami], 5)).

publico(evelyn, instagram, foto([evelyn, cami])).

videojuego(leagueOfLegends).
videojuego(minecraft).
videojuego(aoe).

% Punto 4

postAdictivo(video(_, Duracion)):-
    publico(_,_, video(_, Duracion)),
    Duracion < 3.

postAdictivo(stream(Tematica)):-
    publico(_,_, stream(Tematica)),
    videojuego(Tematica).

postAdictivo(foto(Participantes)):-
    publico(_,_, foto(Participantes)),
    length(Participantes, CuantosHay),
    CuantosHay < 4.

adictiva(Red):-
    canal(_, Red,_),
    forall(publico(_, Red, Post), postAdictivo(Post)).

aparece(Persona, video(Participantes,_)):-
    canal(Persona,_,_),
    publico(_,_, video(Participantes,_)),
    member(Persona, Participantes).

aparece(Persona, foto(Participantes)):-
    canal(Persona,_,_),
    publico(_,_, foto(Participantes)),
    member(Persona, Participantes).

colaboran(Persona1, Persona2):-
    publico(Persona1,_, Post),
    Persona1 \= Persona2,
    aparece(Persona2, Post).

colaboran(Persona1, Persona2):-
    colaboran(Persona2, Persona1).

caminoALaFama(Persona):-
    canal(Persona,_,_),
    not(influencer(Persona)),
    influencer(Influencer),
    publico(Influencer,_, Post),
    aparece(Persona, Post).

caminoALaFama(Persona):-
    canal(Persona,_,_),
    not(influencer(Persona)),
    publico(Otro,_, Post),
    aparece(Persona, Post),
    caminoALaFama(Otro).