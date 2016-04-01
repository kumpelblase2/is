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

lex(onkel, n).
lex(tante, n).
lex(tochter, n).
lex(sohn, n).
lex(vater, n).
lex(mutter, n).
lex(geschwister, n).
lex(oma, n).
lex(opa, n).
lex(frau, n).
lex(mann, n).

lex(von, pr).
lex(mit, pr).

lex(X, en) :- maennlich(X).
lex(X, en) :- weiblich(X).


s --> ip, vp.
ip --> [X], { lex(X, ip) }.
v --> [X], { lex(X, v) }.
vp --> v.
vp --> v,np.
np --> en.
np --> a,n.
np --> a,n,pp.
en --> [X], { lex(X, en) }.
n --> [X], { lex(X, n) }.
a --> [X], { lex(X, a) }.
pp --> p, np.
p --> [X], { lex(X, pr) }.


