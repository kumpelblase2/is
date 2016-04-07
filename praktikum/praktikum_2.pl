#!/usr/bin/swipl
:- consult('praktikum_1.pl').
:- consult('readsentence.pl').

lex(von, pr).
%lex(mit, pr).

lex(X, en, m) :- maennlich(X).
lex(X, en, f) :- weiblich(X).

lex(wer, ip, m).
lex(wer, ip, f).
lex(was, ip, n).
lex(wessen, ip, _).
lex(wen, ip, m).
lex(wen, ip, f).
lex(wem, ip, m).
lex(welcher, ip, m).

lex(ist, v, sg).
lex(sind, v, pl).

lex(der, a, m, sg).
lex(die, a, f, sg).
lex(die, a, _, pl).
lex(das, a, n, sg).

% Ueberprueft ob es eine 2-Stellige Funktion gibt, die wie X heisst (bruder, mutter, onkel, ...)
% Das Cut('!') ist wichtig, damit es keine doppel-Ausgaben gibt.
%lex(X, n) :- Y =.. [X, _A, _B], Y, !.
lex(bruder, n, m, sg).
lex(schwester, n, f, sg).
lex(opa, n, m, sg).
lex(oma, n, f, sg).
lex(vater, n, m, sg).
lex(mutter, n, f, sg).
lex(halbbruder, n, m, sg).
lex(halbschwester, n, f, sg).
lex(onkel, n, m, sg).
lex(tante, n, f, sg).
lex(tochter, n, f, sg).
lex(sohn, n, m, sg).
lex(neffe, n, m, sg).
lex(nichte, n, f, sg).
lex(eltern, n, f, pl).

s :-
	read_sentence(S),
	%S = [wer, sind, die, eltern, von, michael, ?],
	(
		(s(X, S, []), !, answer(X));
		write('du sprechen deutsch?')
	).

answer(X) :-
	X =.. F,
	[BEZIEHUNG, P1, P2] = F,
	lex(BEZIEHUNG, n, Gender, Numerus),
	lex(Artikel, a, Gender, Numerus),
	lex(Verb, v, Numerus),
	findall(P1, X, Y),
	
	write(Artikel), write(' '),
	write(BEZIEHUNG), write(' von '),
	write(P2), write(' '),
	write(Verb), write(' '),
	write_list(Y),
	write('.'), nl.

write_list([Name]) :- write(Name).
write_list([Name|Rest]) :- Rest \= [], write(Name), write(' und '), write_list(Rest).

% wer ist der onkel von jeff
s(F) --> ip(G1), vp(B, G1, _N1), pp(P, _G2, _N2), [?], { F =.. [B, _X, P] }.
% von wem ist corinna die schwester
% von = präposition
% wem = Interrogativpronomen
% ist = verb
% corinna = eignename
% die = artikel
% schwester = nomen
s(F) --> p, ip(G), vp(P, G, N), np(B, _, N), [?], { F =.. [B, P, _X] }.
% ist hannes der onkel von jeff
s(F) --> vp(P1, G, N), np(B, G, N), pp(P2, _, _), [?], {F =.. [B, P1, P2]}.
ip(G) --> [X], { lex(X, ip, G) }.
v(N) --> [X], { lex(X, v, N) }.
vp(X, G, N) --> v(N), np(X, G, N).
vp(_, _, N) --> v(N).
np(X, G, sg) --> en(X, G).
np(X, G, N) --> a(G, N),n(X, G, N).
%np(X, G, N) --> a(G, N),n(X, G, N),pp(_, _, N).
en(X, G) --> [X], { lex(X, en, G) }.
n(X, G, N) --> [X], { lex(X, n, G, N) }.
a(G, N) --> [X], { lex(X, a, G, N) }.
pp(X, G, N) --> p, np(X, G, N).
p --> [X], { lex(X, pr) }.

