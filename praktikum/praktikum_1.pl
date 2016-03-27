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

kind(thorsten, robert).
kind(lea, paul).
kind(jonas, dennis).
kind(julia, bernd).
kind(georg, thorsten).
kind(linda, jonas).
kind(andrea, thorsten).
kind(hannes, thorsten).
kind(jana, markus).
kind(sarah, jonas).
kind(jeff, georg).
kind(tina, georg).
kind(lukas, georg).
kind(A, B) :- verheiratet(C, B), kind(A, C).

tochter(A, B) :- weiblich(A), kind(A, B).
sohn(A, B) :- maenlich(A), kind(A, B).

geschwister(A, B) :- kind(A, C), kind(B, C).
bruder(A, B) :- maenlich(A), geschwisteR(A, B).
schwester(A, B) :- weiblich(A), geschwister(A, B).

eltern(A, B) :- kind(B, A); (verheiratet(A, C), kind(C, A)).
vater(A, B) :- maenlich(A), eltern(A, B).
mutter(A, B) :- weiblich(A), eltern(A, B).

großeltern(A, B) :- eltern(A, C), eltern(C, B).
oma(A, B) :- weiblich(A), großeltern(A, B).
opa(A, B) :- maenlich(A), großeltern(A, B).
