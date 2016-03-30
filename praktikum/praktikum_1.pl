maenlich(georg).
maenlich(jeff).
maenlich(hannes).
maenlich(markus).
maenlich(thorsten).
maenlich(jonas).
maenlich(bernd).
maenlich(dennis).
maenlich(paul).
maenlich(robert).
maenlich(lukas).

weiblich(linda).
weiblich(tina).
weiblich(anrea).
weiblich(jana).
weiblich(sarah).
weiblich(lea).
weiblich(julia).
weiblich(tanja).
weiblich(vanessa).
weiblich(maria).
weiblich(claudia).

verheiratet(georg, linda).
verheiratet(markus, andrea).
verheiratet(thorsten, lea).
verheiratet(jonas, julia).
verheiratet(bernd, tanja).
verheiratet(dennis, vanessa).
verheiratet(paul, maria).
verheiratet(robert, claudia).

kind(thorsten, robert, claudia).
kind(lea, paul, maria).
kind(jonas, dennis, vanessa).
kind(julia, bernd, tanja).
kind(georg, thorsten, lea).
kind(linda, jonas, julia).
kind(andrea, thorsten, lea).
kind(hannes, thorsten, lea).
kind(jana, markus, andrea).
kind(sarah, jonas, julia).
kind(jeff, georg, linda).
kind(tina, georg, linda).
kind(lukas, georg, linda).

tochter(A, B, C) :- weiblich(A), kind(A, B, C).
sohn(A, B, C) :- maenlich(A), kind(A, B, C).

geschwister(A, B) :- kind(A, C, D), kind(B, C, D), A \= B.
bruder(A, B) :- maenlich(A), geschwister(A, B).
schwester(A, B) :- weiblich(A), geschwister(A, B).

eltern(A, B) :- kind(B, A, _) ; kind(B, _, A).
vater(A, B) :- maenlich(A), eltern(A, B).
mutter(A, B) :- weiblich(A), eltern(A, B).

grosseltern(A, B) :- eltern(A, C), eltern(C, B).
oma(A, B) :- weiblich(A), grosseltern(A, B).
opa(A, B) :- maenlich(A), grosseltern(A, B).

onkel(B, A) :- kind(A, C, D), (bruder(B, C); bruder(B, D)).
tante(B, A) :- kind(A, C, D), (schwester(B, C); schwester(B, D)).
pate(B, A) :- kind(A, C, D), (geschwister(B, C); geschwister(B, D)).

cousin(B, A) :- pate(C, A), (kind(B, C, _); kind(B, _, C)), B \= A.
