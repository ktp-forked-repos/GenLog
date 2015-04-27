%% kinship.pl
%% sdcl for kinship relations
%% ----------------------------------------------------------------------
%%
%% Why do you hear Brenda is Susanna's mother? Because we are talking
%% about Susanna. And because you want to communicate to me the
%% property of grandmother. And because Susanna's mother is Amy and
%% her grandmother is Brenda.

hear(X, Y) ---> number(X, Z), hear(Z, Y).
hear(X, Y) --->
        number(X, Z),
        count(X, Y | X, Z).

count(X, Z | X, Z) :: 0.9.
count(X, Y | X, Z) --->
        next(Z, U | X, Z),
        count(Z, Y | Z, U)            :: 0.1.

macro(
      ( next1([N2|X], X | [N1|Y], Y) :- number_lex(N2), number_lex(N1))      
      ).

% next1([two|X], X | [one|Y], Y).
% next1([three|X], X | [two|Y], Y).
% next1([four|X], X | [three|Y], Y).
% next1([five|X], X | [four|Y], Y).
% next1([six|X], X | [five|Y], Y).
% next1([seven|X], X | [six|Y], Y).
% next1([eight|X], X | [seven|Y], Y).
% next1([nine|X], X | [eight|Y], Y).
% next1([ten|X], X | [nine|Y], Y).

next(A1, A2 | B1, B2) ---> next1(A1, A2 | B1, B2).
next([D, Y | X], X | [D, Z | W], W) --->           
        next1([Y|Q], Q | [Z | Q1], Q1).

number(X, Z) --->
        decade(X, Z).
number(X, Z) --->
        decade(X, U),
        number1(U, Z).
number(X, Z) --->
        number1(X, Z).

number([ten|X], X).

number1([one|X], X).
number1([two|X], X).
number1([three|X], X).
number1([four|X], X).
number1([five|X], X).
number1([six|X], X).
number1([seven|X], X).
number1([eight|X], X).
number1([nine|X], X).


decade([twenty|X], X).
decade([thirty|X], X).
decade([forty|X], X).
decade([fifty|X], X).
decade([sixty|X], X).
decade([seventy|X], X).
decade([eighty|X], X).
decade([ninety|X], X).







