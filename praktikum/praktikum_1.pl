#!/usr/bin/swipl
maennlich(georg).
maennlich(jeff).
maennlich(hannes).
maennlich(markus).
maennlich(thorsten).
maennlich(jonas).
maennlich(bernd).
maennlich(dennis).
maennlich(paul).
maennlich(robert).
maennlich(lukas).
maennlich(michael).

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

% Thorsten ist das Kind von Robert
kind(thorsten, robert).
kind(thorsten, cluadia).
kind(lea, paul).
kind(lea, maria).
kind(jonas, dennis).
kind(jonas, vanessa).
kind(julia, bernd).
kind(julia, tanja).
kind(georg, thorsten).
kind(georg, lea).
kind(andrea, thorsten).
kind(andrea, lea).
kind(hannes, thorsten).
kind(hannes, lea).
kind(jana, markus).
kind(jana, andrea).
kind(linda, jonas).
kind(linda, julia).
kind(sarah, jonas).
kind(sarah, julia).
kind(jeff, georg).
kind(jeff, linda).
kind(tina, georg).
kind(tina, linda).
kind(lukas, georg).
kind(lukas, linda).
kind(michael, georg).
kind(michael, mia).
kind(corinna, georg).
kind(corinna, mia).

% A ist die Tochter von B
tochter(A, B) :- weiblich(A), kind(A, B).
% A ist der Sohn von B
sohn(A, B) :- maennlich(A), kind(A, B).


geschwister(A, B) :- kind(A, C), kind(B, C), kind(A, D), kind(B, D), verheiratet(C, D), A \= B.
% A ist der Bruder von B
bruder(A, B) :- maennlich(A), geschwister(A, B).
% A ist die Schwester von B
schwester(A, B) :- weiblich(A), geschwister(A, B).

eltern(A, B) :- kind(B, A).
% A ist der Vater von B
vater(A, B) :- maennlich(A), eltern(A, B).
% A ist die Mutter von B
mutter(A, B) :- weiblich(A), eltern(A, B).

grosseltern(A, B) :- eltern(A, C), eltern(C, B).
% A ist die Oma von B
oma(A, B) :- weiblich(A), grosseltern(A, B).
% A ist der Opa von B
opa(A, B) :- maennlich(A), grosseltern(A, B).

% B ist der Onkel von A
onkel(B, A) :- kind(A, C), bruder(B, C).
% B ist die Tante von A.
tante(B, A) :- kind(A, C), schwester(B, C).
% B ist der Pate. (von A)
pate(B, A) :- kind(A, C), geschwister(B, C).

% A ist der Neffe von B
neffe(A, B) :- maennlich(A), pate(B, A).
% A ist die Nichte von B
nichte(A, B) :- weiblich(A), pate(B, A).

% B ist der cousin von A
cousin(B, A) :- pate(C, A), kind(B, C), B \= A.

% A ist das Halbgeschwister von B
halbgeschwister(A, B) :- kind(A, C), kind(B, C), not(geschwister(A, B)), A \= B.
% A ist der HalbBruder von B
halbbruder(A, B) :- maennlich(A), halbgeschwister(A, B).
% A ist die HalbSchwester von B
halbschwester(A, B) :- weiblich(A), halbgeschwister(A, B).

enkelkind(A, B) :- grosseltern(B, A). 
