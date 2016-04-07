#!/usr/bin/swipl
:- consult('praktikum_1.pl').
:- consult('readsentence.pl').

lex(wer, ip, m).
lex(wer, ip, f).
lex(was, ip, n).
lex(wessen, ip, _).
lex(wen, ip, m).
lex(wen, ip, f).
lex(wem, ip, m).
lex(welcher, ip, m).

lex(ist, v).
lex(hat, v).
lex(gehoert, v).
lex(verheiratet, v).

lex(der, a, m).
lex(die, a, f).
lex(das, a, n).

% Ueberprueft ob es eine 2-Stellige Funktion gibt, die wie X heisst (bruder, mutter, onkel, ...)
% Das Cut("!") ist wichtig, damit es keine doppel-Ausgaben gibt.
%lex(X, n) :- Y =.. [X, _A, _B], Y, !.
lex(bruder, n, m).
lex(schwester, n, f).
lex(opa, n, m).
lex(oma, n, f).
lex(eletern, n, f).

lex(von, pr).
lex(mit, pr).

lex(X, en, m) :- maennlich(X).
lex(X, en, f) :- weiblich(X).

s(X) :- read_sentence(S), s(X, S, []), X.

% wer ist der onkel von jeff
s(F) --> ip(G1), vp(B, G1), pp(P, G2), [?], { F =.. [B, X, P] }.
% von wem ist corinna die schwester
% von = präposition
% wem = Interrogativpronomen
% ist = verb
% corinna = eignename
% die = artikel
% schwester = nomen
s(F) --> p, ip(G), vp(P, G), np(B, _), [?], { F =.. [B, P, X] }.
% ist hannes der onkel von jeff
s(F) --> vp(P1, G), np(B, G), pp(P2, _), [?], {F =.. [B, P1, P2]}.
ip(G) --> [X], { lex(X, ip, G) }.
v --> [X], { lex(X, v) }.
vp(X, G) --> v,np(X, G).
vp(_, _) --> v.
np(X, G) --> en(X, G).
np(X, G) --> a(G),n(X, G).
np(X, G) --> a(G),n(X, G),pp(_, _).
en(X, G) --> [X], { lex(X, en, G) }.
n(X, G) --> [X], { lex(X, n, G) }.
a(G) --> [X], { lex(X, a, G) }.
pp(X, G) --> p, np(X, G).
p --> [X], { lex(X, pr) }.

