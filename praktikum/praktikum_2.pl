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
	[BEZIEHUNG, Person1, Person2] = F,
	(lex(BEZIEHUNG, _, n, Gender, Numerus); !, write('die beziehung '), write(BEZIEHUNG), write(' wurde nicht gefunden.'), fail),
	(lex(Artikel, a, Gender, Numerus, no); !, write('der artikel '), write(Artikel), write(' wurde nicht gefunden.'), fail),
	(lex(Verb, v, Numerus); !, write('das verb '), write(Verb), write(' wurde nicht gefunden.'), fail),
	((
		answer(X, Artikel, BEZIEHUNG, Person1, Person2, Verb)
	); (
		write('meine datenbank weiss nichts ueber die beziehung '),
		write(BEZIEHUNG), write(' zwischen '),
		write(Person1), write(' und '),
		write(Person2), write('.'), nl
	)), !.
answer(X, Artikel, BEZIEHUNG, Person1, Person2, Verb) :-
		atom(Person1),
		findall(Person2, X, Y),
		Y \= [],
		write(Person1), write(' '),
		write(Verb), write(' '),
		write(Artikel), write(' '),
		write(BEZIEHUNG), write(' von '),
		write_list(Y),
		write('.'), nl.
answer(X, Artikel, BEZIEHUNG, Person1, Person2, Verb) :-
		atom(Person2),
		findall(Person1, X, Y),
		Y \= [],
		write(Artikel), write(' '),
		write(BEZIEHUNG), write(' von '),
		write(Person2), write(' '),
		write(Verb), write(' '),
		write_list(Y),
		write('.'), nl.

write_list([Name]) :- write(Name).
write_list([Name|Rest]) :- Rest \= [], write(Name), write(' und '), write_list(Rest).

% wer ist der onkel von jeff
s(F) --> ip(Gender1, Kausus), vp(Relation, Gender1, _, Kausus), pp(Person, _, _, Kausus), [?],
         { F =.. [Relation, _, Person] }.
% von wem ist corinna die schwester
% von = praeposition
% wem = Interrogativpronomen
% ist = verb
% corinna = eignename
% die = artikel
% schwester = nomen
s(F) --> p, ip(Gender, da), vp(Person, Gender, Numerus, da), np(Relation, _, Numerus, _), [?],
         { F =.. [Relation, Person, _] }.
% ist hannes der onkel von jeff
s(F) --> v(Numerus), np(Person1, _, Numerus, Kausus), np(Relation, _, Numerus, Kausus),
         pp(Person2, _, _, Kausus), [?], {F =.. [Relation, Person1, Person2]}.
ip(Gender, Kausus) --> [X], { lex(X, ip, Gender, Kausus) }.
v(Numerus) --> [X], { lex(X, v, Numerus) }.
vp(X, Gender, Numerus, Kausus) --> v(Numerus), np(X, Gender, Numerus, Kausus).
vp(_, _, Numerus, _) --> v(Numerus).
np(X, Gender, sg, _) --> en(X, Gender).
np(X, Gender, Numerus, Kausus) --> a(Gender, Numerus, Kausus), n(X, Gender, Numerus).
%np(X, Gender, Numerus, Kausus) --> a(Gender, Numerus, Kausus),n(X, Gender, Numerus),pp(_, _, Numerus, Kausus).
en(X, Gender) --> [X], { lex(X, en, Gender) }.
n(Relation, Gender, Numerus) --> [X], { lex(X, Relation, n, Gender, Numerus) }.
a(Gender, Numerus, Kausus) --> [X], { lex(X, a, Gender, Numerus, Kausus) }.
pp(X, Gender, Numerus, Kausus) --> p, np(X, Gender, Numerus, Kausus).
p --> [X], { lex(X, pr) }.


:- s, halt.
