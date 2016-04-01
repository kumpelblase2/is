#!/usr/bin/swipl
:- consult('praktikum_1.pl').

lex(wer, ip).
lex(was, ip).
lex(wessen, ip).
lex(wen, ip).
lex(wem, ip).
lex(welcher, ip).

lex(ist, v).
lex(hat, v).
lex(gehoert, v).
lex(verheiratet, v).

lex(der, a).
lex(die, a).
lex(das, a).

% Ueberprueft ob es eine 2-Stellige Funktion gibt, die wie X heisst (bruder, mutter, onkel, ...)
% Das Cut("!") ist wichtig, damit es keine doppel-Ausgaben gibt.
lex(X, n) :- Y =.. [X, _A, _B], Y, !.

lex(von, pr).
lex(mit, pr).

lex(X, en) :- maennlich(X).
lex(X, en) :- weiblich(X).

% wer ist der onkel von jeff
s(F) --> ip, vp(B), pp(P), { F =.. [B, X, P] }.
% von wem ist corinna die schwester
% von = präposition
% wem = Interrogativpronomen
% ist = verb
% corinna = eignename
% die = artikel
% schwester = nomen
s(F) --> p, ip, vp(P), np(B), { F =.. [B, P, X] }.
ip --> [X], { lex(X, ip) }.
v --> [X], { lex(X, v) }.
vp(_) --> v.
vp(X) --> v,np(X).
np(X) --> en(X).
np(X) --> a,n(X).
np(X) --> a,n(X),pp(_).
en(X) --> [X], { lex(X, en) }.
n(X) --> [X], { lex(X, n) }.
a --> [X], { lex(X, a) }.
pp(X) --> p, np(X).
p --> [X], { lex(X, pr) }.


