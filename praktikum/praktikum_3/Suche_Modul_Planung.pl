% Die Schnittstelle umfasst
%   start_description	;Beschreibung des Startzustands
%   start_node          ;Test, ob es sich um einen Startknoten handelt
%   goal_node           ;Test, ob es sich um einen Zielknoten handelt
%   state_member        ;Test, ob eine Zustandsbeschreibung in einer Liste
%                        von Zustandsbeschreibungen enthalten ist
%   expand              ;Berechnung der Kind-Zustandsbeschreibungen
%   eval-path		;Bewertung eines Pfades


/*start_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4),  %mit Block4
  on(table,block2),
  on(table,block3),
  on(block2,block1),
  on(table,block4), %mit Block4
  clear(block1),
  clear(block3),
  clear(block4), %mit Block4
  handempty
  ]).*/
start_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4),  %mit Block4
  handempty,
  on(table, block3),
  on(table, block2),
  on(block2, block1),
  on(block1, block4),
  clear(block3),
  clear(block4)
]).

goal_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4),  %mit Block4
  handempty,
  on(table, block3),
  on(block3, block2),
  on(block2, block1),
  on(block1, block4),
  clear(block4)
]).

/*goal_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4), %mit Block4
  on(block4,block2), %mit Block4
  on(table,block3),
  on(table,block1),
  on(block1,block4), %mit Block4
%  on(block1,block2), %ohne Block4
  clear(block3),
  clear(block2),
  handempty
  ]).*/

start_node((start,_,_)).

goal_node((_,State,_)):-
  goal_description(End),
  mysubset(State, End),
  mysubset(End, State), !.

% Aufgrund der Komplexit�t der Zustandsbeschreibungen kann state_member nicht auf
% das Standardpr�dikat member zur�ckgef�hrt werden.
%
state_member(_,[]):- !,fail.

state_member(State,[FirstState|_]):-
  mysubset(FirstState, State),
  mysubset(State, FirstState), !.

%Es ist sichergestellt, dass die beiden ersten Klauseln nicht zutreffen.
state_member(State,[_|RestStates]):-
  %"rekursiver Aufruf".
  state_member(State, RestStates).

eval_state(State, Value) :-
  goal_description(Goal),
  subtract(Goal, State, Remaining),
  length(Remaining, Value).

eval_path([(_,State,Value)]) :- 
  eval_state(State, Value).

eval_path([(_,State,Value)|RestPath]):-
  eval_path(RestPath),
  length(RestPath, PreviousCost),
  eval_state(State, EstimateRemaining),
  % A* Suche ( Heuristik <= Restwert -> Zulaessige Heuristik)
  %Value is EstimateRemaining + PreviousCost.
  % Gierige Bestensuche:
  Value = EstimateRemaining.

action(pick_up(X),
       [handempty, clear(X), on(table,X)],
       [handempty, clear(X), on(table,X)],
       [holding(X)]).

action(pick_up(X),
       [handempty, clear(X), on(Y,X), block(Y)],
       [handempty, clear(X), on(Y,X)],
       [holding(X), clear(Y)]).

action(put_on_table(X),
       [holding(X)],
       [holding(X)],
       [handempty, clear(X), on(table,X)]).

action(put_on(Y,X),
       [holding(X), clear(Y)],
       [holding(X), clear(Y)],
       [handempty, clear(X), on(Y,X)]).


% Hilfskonstrukt, weil das PROLOG "subset" nicht die Unifikation von Listenelementen
% durchf�hrt, wenn Variablen enthalten sind. "member" unifiziert hingegen.
%
mysubset([],_).
mysubset([H|T],List):-
  member(H,List),
  mysubset(T,List).

apply_action(State, [CondList, DeleteList, AddList], NewState) :-
    mysubset(CondList, State),
    subtract(State, DeleteList, TempState),
    append(TempState, AddList, NewState).

expand_help(State,Name,NewState):-
  action(Name, CondList, DeleteList, AddList),
  apply_action(State, [CondList, DeleteList, AddList], NewState).

expand((_,State,_),Result):-
  findall((Name,NewState,_),expand_help(State,Name,NewState),Result).
