#!/usr/bin/swipl
:- consult('praktikum_1.pl').
:- consult('readsentence.pl').

lex(von, pr).
%lex(mit, pr).

lex(X, en, m) :- maennlich(X).
lex(X, en, f) :- weiblich(X).

lex(ist, v, sg).
lex(sind, v, pl).

lex(wer, ip, m, no).
lex(wer, ip, f, no).
lex(was, ip, n, _).
%lex(wen, ip, m, ak).
%lex(wen, ip, f, ak).
lex(wem, ip, m, da).
lex(wem, ip, f, da).

lex(bruder, bruder, n, m, sg).
lex(brueder, bruder, n, m, pl).
lex(schwester, schwester, n, f, sg).
lex(schwestern, schwester, n, f, pl).
lex(opa, opa, n, m, sg).
lex(opas, opa, n, m, pl).
lex(oma, oma, n, f, sg).
lex(oma, omas, n, f, pl).
lex(vater, vater, n, m, sg).
lex(vaeter, vater, n, m, pl).
lex(mutter, mutter, n, f, sg).
lex(muetter, mutter, n, f, pl).
lex(halbbruder, halbbruder, n, m, sg).
lex(halbbrueder, halbbruder, n, m, pl).
lex(halbschwester, halbschwester, n, f, sg).
lex(halbschwestern, halbschwester, n, f, pl).
lex(halbgeschwister, halbgeschwister, n, f, pl).
lex(onkel, onkel, n, m, sg).
lex(onkel, onkel, n, m, pl).
lex(tante, tante, n, f, sg).
lex(tanten, tante, n, f, pl).
lex(tochter, tochter, n, f, sg).
lex(toechter, tochter, n, f, pl).
lex(sohn, sohn, n, m, sg).
lex(soehne, sohn, n, m, pl).
lex(neffe, neffe, n, m, sg).
lex(neffen, neffe, n, m, pl).
lex(nichte, nichte, n, f, sg).
lex(nichten, nichte, n, f, pl).
lex(eltern, eltern, n, f, pl).

lex(der, a, m, sg, no).
lex(die, a, f, sg, no).
lex(die, a, _, pl, _).
lex(das, a, n, sg, no).

s :-
	read_sentence(S),
	%S = [von, wem, ist, hannes, der,bruder, ?],
	(
		(s(X, S, []), !, answer(X));
		write('du sprechen deutsch?')
	).

answer(X) :-
	X =.. F,
	[BEZIEHUNG, P1, P2] = F,
	(lex(BEZIEHUNG, _, n, Gender, Numerus); !, write('die beziehung '), write(BEZIEHUNG), write(' wurde nicht gefunden.'), fail),
	(lex(Artikel, a, Gender, Numerus, no); !, write('der artikel '), write(Artikel), write(' wurde nicht gefunden.'), fail),
	(lex(Verb, v, Numerus); !, write('das verb '), write(Verb), write(' wurde nicht gefunden.'), fail),
	%((atom(P1), BekanntePerson = P1, UnbekanntePerson = P2); (atom(P2), BekanntePerson = P2, UnbekanntePerson = P1)), !,
	((
		answer(X, Artikel, BEZIEHUNG, P1, P2, Verb)
	); (
		write('meine datenbank weiss nichts ueber die beziehung '),
		write(BEZIEHUNG), write(' zwischen '),
		write(P1), write(' und '),
		write(P2), write('.'), nl
	)), !.
answer(X, Artikel, BEZIEHUNG, P1, P2, Verb) :-
		atom(P1),
		findall(P2, X, Y),
		Y \= [],
		write(P1), write(' '),
		write(Verb), write(' '),
		write(Artikel), write(' '),
		write(BEZIEHUNG), write(' von '),
		write_list(Y),
		write('.'), nl.
answer(X, Artikel, BEZIEHUNG, P1, P2, Verb) :-
		atom(P2),
		findall(P1, X, Y),
		Y \= [],
		write(Artikel), write(' '),
		write(BEZIEHUNG), write(' von '),
		write(P2), write(' '),
		write(Verb), write(' '),
		write_list(Y),
		write('.'), nl.

write_list([Name]) :- write(Name).
write_list([Name|Rest]) :- Rest \= [], write(Name), write(' und '), write_list(Rest).

% wer ist der onkel von jeff
s(F) --> ip(G1, K), vp(B, G1, _N1, K), pp(P, _G2, _N2, K), [?], { F =.. [B, _X, P] }.
% von wem ist corinna die schwester
% von = praeposition
% wem = Interrogativpronomen
% ist = verb
% corinna = eignename
% die = artikel
% schwester = nomen
s(F) --> p, ip(G, da), vp(P, G, N, da), np(B, _, N, _), [?], { F =.. [B, P, _X] }.
% ist hannes der onkel von jeff
s(F) --> v(N), np(P1, _, N, K), np(B, _, N, K), pp(P2, _, _, K), [?], {F =.. [B, P1, P2]}.
ip(G, K) --> [X], { lex(X, ip, G, K) }.
v(N) --> [X], { lex(X, v, N) }.
vp(X, G, N, K) --> v(N), np(X, G, N, K).
vp(_, _, N, _) --> v(N).
np(X, G, sg, _) --> en(X, G).
np(X, G, N, K) --> a(G, N, K),n(X, G, N).
%np(X, G, N, K) --> a(G, N, K),n(X, G, N),pp(_, _, N, K).
en(X, G) --> [X], { lex(X, en, G) }.
n(B, G, N) --> [X], { lex(X, B, n, G, N) }.
a(G, N, K) --> [X], { lex(X, a, G, N, K) }.
pp(X, G, N, K) --> p, np(X, G, N, K).
p --> [X], { lex(X, pr) }.


:- s, halt.
