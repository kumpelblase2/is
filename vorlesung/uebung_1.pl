mag(frank, Gericht) :- italienisch(Gericht).
mag(frank, Gericht) :- indisch(Gericht), mild(Gericht).

mag(anna, Gericht) :- indisch(Gericht).
mag(anna, hamburger).

mag(kurt, pizza).
mag(kurt, Gericht) :- mag(anna, Gericht).

italienisch(pizza).
italienisch(spaghetti).

indisch(dahl).
indisch(curry).
mild(dahl).
scharf(curry).
