#!/usr/bin/swipl
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
maenlich(michael).

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
weiblich(mia).
weiblich(corinna).

verheiratet(georg, linda).
verheiratet(georg, mia).
verheiratet(markus, andrea).
verheiratet(thorsten, lea).
verheiratet(jonas, julia).
verheiratet(bernd, tanja).
verheiratet(dennis, vanessa).
verheiratet(paul, maria).
verheiratet(robert, claudia).

% Thorsten ist das Kind von Robert und Claudia.
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
kind(michael, georg, mia).
kind(corinna, georg, mia).

% A ist die Tochter von B(Vater) und C(Mutter)
tochter(A, B, C) :- weiblich(A), kind(A, B, C).
% A ist der Sohn von B(Vater) und C(Mutter)
sohn(A, B, C) :- maenlich(A), kind(A, B, C).


geschwister(A, B) :- kind(A, C, D), kind(B, C, D), A \= B.
% A ist der Bruder von B
bruder(A, B) :- maenlich(A), geschwister(A, B).
% A ist die Schwester von B
schwester(A, B) :- weiblich(A), geschwister(A, B).

eltern(A, B) :- kind(B, A, _) ; kind(B, _, A).
% A ist der Vater von B
vater(A, B) :- maenlich(A), eltern(A, B).
% A ist die Mutter von B
mutter(A, B) :- weiblich(A), eltern(A, B).

grosseltern(A, B) :- eltern(A, C), eltern(C, B).
% A ist die Oma von B
oma(A, B) :- weiblich(A), grosseltern(A, B).
% A ist der Opa von B
opa(A, B) :- maenlich(A), grosseltern(A, B).

% B ist der Onkel von A
onkel(B, A) :- kind(A, C, D), (bruder(B, C); bruder(B, D)).
% B ist die Tante von A.
tante(B, A) :- kind(A, C, D), (schwester(B, C); schwester(B, D)).
% B ist der Pate. (von A)
pate(B, A) :- kind(A, C, D), (geschwister(B, C); geschwister(B, D)).

% B ist der cousin von A
cousin(B, A) :- pate(C, A), (kind(B, C, _); kind(B, _, C)), B \= A.

% A ist das Halbgeschwister von B
halbgeschwister(A, B) :- kind(A, C, D), kind(B, C, E), A \= B, D \= E.
halbgeschwister(A, B) :- kind(A, C, D), kind(B, E, D), A \= B, C \= E.
% A ist der HalbBruder von B
halbbruder(A, B) :- maennlich(A), halbgeschwister(A, B).
% A ist die HalbSchwester von B
halbschwester(A, B) :- weiblich(A), halbgeschwister(A, B).

enkelkind(A, B) :- grosseltern(B, A). 
