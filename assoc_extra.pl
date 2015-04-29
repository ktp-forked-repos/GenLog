

%% ----------------------------------------------------------------------
%% Auxiliary predicates over associations with numbers as values.
%%
%% add_assocs(V, Assoc1, +Assoc2, -AssocOut)
%%
%% AssocOut is the union of Assoc1 and Assoc2 with addition and
%% default value V.
add_assocs(V0, Assoc1, Assoc2, AssocOut) :-
        assoc_to_list(Assoc1, Pairs), 
        add_assocs1(V0, Pairs, Assoc2, AssocOut).

add_assocs1(_, [], AssocIn, AssocOut) :- !, AssocIn = AssocOut.
add_assocs1(V0, [K-V|Rest], AssocIn, AssocOut) :-
        (
         get_assoc(K, AssocIn, V1), !
         ;
         V1 = V0
        ),
        V2 is V1 + V,
        put_assoc(K, AssocIn, V2, AssocTmp),
        add_assocs1(V0, Rest, AssocTmp, AssocOut).

%% scalar_multiply_assoc(+V, +AssocIn, -AssocOut)
%% multiplies each value of AssocIn by V
scalar_multiply_assoc(V, AssocIn, AssocOut) :-
        map_assoc(call(prod, V), AssocIn, AssocOut).

prod(V, A, B) :-
        B is A * V.

%% scalar_add_assoc(+V, +AssocIn, -AssocOut)
%% adds each value of AssocIn to V
scalar_add_assoc(V, AssocIn, AssocOut) :-
        map_assoc(call(sum, V), AssocIn, AssocOut).

sum(V, A, B) :-
        B is A + V.

%% map_keys(+Goal, +Assoc0, -Assoc1) is det
%% Apply Goal to every key in Assoc0. Result is Assoc1.
map_keys(Goal, Assoc0, Assoc1) :-
        assoc_to_list(Assoc0, Xs),
        empty_assoc(Empty),         
        map_keys_list(Xs, Goal, Empty, Assoc1).

map_keys_list([], _, AssocIn, AssocIn) :- !.
map_keys_list([K-V|Xs], Goal, AssocIn, AssocOut) :-
        call(Goal, K, K1),!, 
        put_assoc(K1, AssocIn, V, AssocTmp),
        map_keys_list(Xs, Goal, AssocTmp, AssocOut).
        
        
%% constant_assoc(+Keys, +Value, -Assoc) is det
%% Make an assoc with keys Keys such that every key has the same value Value.
constant_assoc(Keys, Value, Assoc) :-
        findall(K-Value,
                member(K, Keys),
                KVs),
        list_to_assoc(KVs, Assoc).
                


:- begin_tests(assoc_extra). 

test(add_assocs,
     [set(K-V = [a-3, b-4, c-9])]
     ) :-
        list_to_assoc([a-1, b-4], Assoc1),
        list_to_assoc([a-2, c-9], Assoc2),
        add_assocs(0, Assoc1, Assoc2, Assoc),
        assoc_to_list(Assoc, List),
        member(K-V, List).

test(scalar_multiply_assoc,
     [set(K-V = [a-5, b-20])]
     ) :-
        list_to_assoc([a-1, b-4], Assoc),

        scalar_multiply_assoc(5, Assoc, Assoc1),
        assoc_to_list(Assoc1, List),
        member(K-V, List).


test(scalar_add_assoc,
     [set(K-V = [a-6, b-9])]
     ) :-
        list_to_assoc([a-1, b-4], Assoc),

        scalar_add_assoc(5, Assoc, Assoc1),
        assoc_to_list(Assoc1, List),
        member(K-V, List).

test(constant_assoc_is_constant,
     [all(V = [a, a, a, a])]) :-
        Keys = [1,2,3,4],
        Value = a,
        constant_assoc(Keys, Value, Assoc),
        assoc_to_values(Assoc, Vs),
        member(V, Vs).


     


:- end_tests(assoc_extra).