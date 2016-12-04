% Author: Manu Dot Datta At Gmail dot com

-module(p99).
-compile(export_all).% 1.26
%1.26
% Generate the combinations of K distinct objects chosen from the N elements of a list 
% usage: p99:combination(N,List) N < length(L) is length of combinations 
% example:
%p99:combination(3,[a,b,c]).  =>  [[a,b,c],[a,c,b],[b,a,c],[b,c,a],[c,a,b],[c,b,a]]

combination(1,L) ->
    [[X] || X <- L];
combination(N,L) ->
   [ [H|Res] || H <- L , Res <- combination(N-1,L) , false == lists:member(H,Res) ].  

% 1.25
% Generate a random permutation of the elements of a list. 
% usage: p99:rnd_permu(List)
% example:
%p99:rnd_permu([a,b,c,d,e,f]). =>  [c,a,e,d,b,f]
rnd_permu(L)->
    rnd_select(my_length(L),L).
% 1.24
% Draw N different random numbers from the set 1..M.
% usage: p99:lotto(N,End) N = Number of elements to be randomly selected from 1..End range 
% example:
% p99:lotto(6,49).     => [30,45,33,22,28,7]
lotto(N,End)->
    rnd_select(N,range(1,End)).

% 1.23
% Extract a given number of randomly selected elements from a list
% usage: p99:rnd_select(N,List) N = Number of elements to be randomly selected from list
% example:
% p99:rnd_select(3,[a,b,c,d,e,f,g,h]). =>  [d,f,a]

rnd_select(0,_)->
    [];
rnd_select(N,L)->
    Pos = random:uniform( my_length( L ) ),
    {X,T} = remove_at (L,Pos),
    [X|rnd_select(N-1,T)].

% 1.22
% Create a list containing all integeers within given range
% usage: p99:range(StartIndex,StopIndex)
%example:
% p99:range(4,9). =>  [4,5,6,7,8,9]

range(Max,Max,L)->
    L;
range(Min,Max,L)->
    [Min|range(Min+1,Max,L)].
    range(Min,Max)->
    range(Min,Max+1,[]).

% 1.21
% insert an element at a given position into a list. First Index = 1
% usage: p99:insert_at(List,ElementToBeInserted,IndexAt)
% example: 
% p99:insert_at([a,b,c,d],alfa,2). =>  [a,alfa,b,c,d]
insert_at(L1,[],_,0)->
    L1;
insert_at(L1,[H|T],Elem,0)->
    [H|insert_at(L1,T,Elem,0)];
insert_at(L1,L2,Elem,1)->
    [Elem|insert_at(L1,L2,Elem,0)];
insert_at(L1,[H|T],Elem,Pos)->
    [H|insert_at(L1,T,Elem,Pos-1)].
insert_at(L,Elem,Pos)->
    insert_at([],L,Elem,Pos).

% 1.20
% remove the kth element from a list
% usage: p99:remove_at(List,IndexAt) return removed element First Index = 1
% example: 
% p99:remove_at([a,b,c,d,e,f,g,h,i],3). =>  {c,[a,b,d,e,f,g,h,i]}
% p99:remove_at([a,b,c,d],2). =>  {b,[a,c,d]}

remove_at(L1,L2,1)->
    [L1,L2];
remove_at(L,[H|T],Pos)->
    [L1,L2]=remove_at(L,T,Pos-1),
    [[H|L1],L2].
remove_at(L,Pos)->
    [FL,[X|SL]]=remove_at([],L,Pos),
    {X,merge(SL,FL)}.

% 1.19
% rotate a list N placed to the left
% usage: p99:rotate(List,Length)
%example:
% p99:rotate([a,b,c,d,e,f],3). =>  [d,e,f,a,b,c]

merge([],[])->
    [];
merge([H|T],[])->
    [H|merge(T,[])];
merge(L1,[H|T])->
    [H|merge(L1,T)].

rotate(L,N)->
    [L1,L2]=split(L,N),
    merge(L1,L2).

% 1.18
% Slice the list
% usage: p99:slice(List,Start,End)
%example:
% p99:slice([a,b,c,d,e,f,g,h,i,k],3,7). =>  [c,d,e,f,g]

slice([H|_],_,End,_,End)->
    [H];
slice([H|T],Start,EndN,Start,End)->
    [H|slice(T,Start,EndN+1,Start,End)];
slice([_|T],X,Start,Start,End)->
    slice(T,X+1,Start,Start,End).
slice(_,X,X)->
    [];
slice(L,Start,End)->
    slice(L,1,Start,Start,End).

% 1.17
% Split a list into two parts; the length of the first part is given.
% usage: p99:split(List,Length)
% example:
% p99:split([a,b,c],2). =>  [[a,b],[c]]
% p99:split([a,b,c],1). =>  [[a],[b,c]]

split([],_)->
    [];
split([H|T],1)->
    [[H],T];
split([H|T],Index)->
    [RH,RT]=split(T,Index-1),
    [[H|RH],RT].

% 1.16
% Drop every N'th element from a list.
% usage: p99:drop_nth(List)
%example:
% p99:drop_nth([a,b,c],2). => [a,c]
% p99:drop_nth([a,b,c],3).  => [a,b]
% p99:drop_nth([a,b,c,d,e,f,g,h,i,k],3). =>  [a,b,d,e,g,h,k]

drop_nth([],_,_)->
    [];
drop_nth([_|T],1,N)->
    drop_nth(T,N,N);
drop_nth([H|T],Ner,N)->
    [H|drop_nth(T,Ner-1,N)].
drop_nth([],_)->
    [];
drop_nth(L,N)->
    drop_nth(L,N,N).

% 1.15
% Duplicate the elements of a list a given number of times.
% usage: p99:dupli_times(List,N)
%example:
% p99:dupli_times([a,b,c],3). =>  [a,a,a,b,b,b,c,c,c]
% p99:dupli_times([a,b,c],0). =>  []
% p99:dupli_times([a,b,c],1). =>  [a,b,c]
% p99:dupli_times([a,b,c],2). =>  [a,a,b,b,c,c]
dupli_times([],_,_)->
    [];
dupli_times([_|T],0,Times)->
    dupli_times(T,Times,Times);
    dupli_times([H|T],N,Times)->
    [H|dupli_times([H|T],N-1,Times)].
dupli_times([],_)->
    [];
dupli_times([H|T],Times)->
    dupli_times([H|T],Times,Times).

% 1.14
% Duplicate the elements of a list.
% usage: p99:dupli(List)
%example:
%p99:dupli([a,b,c,c,d]). =>  [a,a,b,b,c,c,c,c,d,d]
dupli([])->
    [];
dupli([H|T])->
    [H|[H|dupli(T)]].

% 1.13
% decode run-length encoded list
% usage: p99:decode_modified(List)
%example:
% p99:decode_modified([[5,a],[3,c]]). =>  [a,a,a,a,a,c,c,c]
% p99:decode_modified([[5,a],d,[3,c]]). =>  [a,a,a,a,a,d,c,c,c]
% p99:decode_modified([b,[5,a],d,[3,c]]). =>  [b,a,a,a,a,a,d,c,c,c]

decode_modified([])->
    [];
decode_modified([[2,X]|[]])->
    [X,X];
decode_modified([[N,X]|[]])->
    [X|decode_modified([[N-1,X]])];
decode_modified([[2,X]|T])->
    [X|[X|decode_modified(T)]];
decode_modified([[N,X]|T])->
    [X|decode_modified([[N-1,X]|T])];
decode_modified([H|[[N,X]|T]])->
    [H|decode_modified([[N,X]|T])];
decode_modified([H|[]])->
    [H].

% 1.12
% modified run length encoding.
% usage: p99:encode_modified(List)
% examples:
% p99:encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e]). =>  [[4,a],b,[2,c],[2,a],d,[4,e]]
% p99:encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e,f]). =>  [[4,a],b,[2,c],[2,a],d,[4,e],f]

encode_modified([])->
    [];
encode_modified([[N,E]|[E|[]]])->
    [[N+1,E]];
encode_modified([[N,E]|[E|T]])->
    encode_modified([[N+1,E]|T]);
encode_modified([[N,E1]|[E2|[]]])->
    [[N,E1],E2];
encode_modified([[N,E1]|[E2,E2|T]])->
    [[N,E1]|encode_modified([[2,E2]|T])];
encode_modified([[N,E1]|[E2|T]])->
    [[N,E1]|encode_modified([E2|T])];
encode_modified([E1,E1|T])->
    encode_modified([[2,E1]|T]);
encode_modified([E1,E2|T])->
    [E1|encode_modified([E2|T])].

% 1.11
%run length encoding
% usage: p99:encode(List)
%example:
% p99:encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e,f]). =>  [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e],[1,f]]
% p99:encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e]). =>  [[4,a],[1,b],[2,c],[2,a],[1,d],[4,e]]
encode([])->
    [];
encode([[N,E]|[E|[]]])->
    [[N+1,E]];
encode([[N,E]|[E|T]])->
    encode([[N+1,E]|T]);
encode([[N,E1]|[E2|[]]])->
    [[N,E1]|[[1,E2]]];
encode([[N,E1]|[E2|T]])->
    [[N,E1]|encode([[1,E2]|T])];
encode([H|T])->
    encode([[1,H]|T]).


% 1.10
% pack duplicates into sublists
% usage: p99:pack(List)
% examples:
% p99:pack([a,a,a,a,b,c,c]). => [[a,a,a,a],[b],[c,c]]
% p99:pack([a,a,a,a,b,c,c,d]). =>  [[a,a,a,a],[b],[c,c],[d]]
pack([])->
    [];
pack([H|[]])->
    [H];
pack([[H|T1]|[H|T2]])->
    pack([[H|[H|T1]]|T2]);
pack([[H1|T1]|[H2|[]]])->
    [[H1|T1],[H2]];
pack([[H1|T1]|[H2|T2]])->
    [[H1|T1]|pack([H2|T2])];
pack([H|[H|T]])->
    pack([[H,H]|T]);
pack([H1|[H2|T]])->
    [[H1]|pack([H2|T])].

% 1.9
%remove consecutive duplicates
% usage: compress(List)
%example:
% p99:compress([a,a,a,b,c,c,c,c]). =>  [a,b,c]
% p99:compress([a,a,a,b,c]). =>  [a,b,c]
compress([])->
    [];
compress([H|[]])->
    [H];
compress([H|[H|T]])->
    compress([H|T]);
compress([H|[H1|T]])->
    [H|compress([H1|T])].

% 1.8
% flatten a list
% usage: my_flatten(List)
%example:
% p99:my_flatten([a,b,[[[c,d],g,g],h],e,f]). =>  [a,b,c,d,g,g,h,e,f]
% p99:my_flatten([a,b,[c,d],g,g,h,e,f]). =>  [a,b,c,d,g,g,h,e,f]
% p99:my_flatten([]). =>  []
% p99:my_flatten([x]). =>  [x]
% p99:my_flatten([x,[]]). =>  [x]
my_flatten([])->
    [] ;
my_flatten([[]|T])->
    my_flatten(T);
my_flatten([[H|T]|T2])->
    my_flatten([H|[T|T2]]);
my_flatten([H|T])->
    [H|my_flatten(T)].

% 1.7
% check if two lists are equal 
% usage: p99:my_equal(ListOne,ListTwo) 
%example:
% p99:my_palindrome([r,e,v,e,r,s,e]). =>  false
%  p99:my_palindrome([a,b,b,a]). =>  true
%  p99:my_palindrome([]). =>  true
%  p99:my_palindrome([x]). =>  true
%  p99:my_palindrome([x,y]). =>  false
my_equal([],[]) ->
    true;
my_equal([H|T1],[H|T2]) ->
    my_equal(T1,T2);
my_equal(_,_) ->
    false.

% 1.6
% check if two lists are palindrome
% usage: p99:my_equal(ListOne,ListTwo) 
%example:
% p99:my_palindrome([r,e,v,e,r,s,e]). =>  false
% p99:my_palindrome([a,b,b,a]). =>  true
% p99:my_palindrome([]). =>  true
% p99:my_palindrome([x]). =>  true
% p99:my_palindrome([x,y]). =>  false
my_palindrome(L1,L2) ->
    my_equal(L1,my_reverse(L2)).
my_palindrome(L) ->
    my_palindrome(L,L).

% 1.5
% reverse a list
% usage = p99:my_reverse(List)
%example:
% p99:my_reverse([r,e,v,e,r,s,e]). =>  [e,s,r,e,v,e,r]
my_reverse(L) -> 
    my_reverse(L,[]) .
my_reverse([],L) -> 
    L;

my_reverse([H|T],L) ->
    my_reverse(T,[H|L]).
%1.4
% Find length of a List 
% usage = p99:my_length(List)
%example:
% p99:my_length([a,[b,b1],c,d,e]). =>  5
% p99:my_length([a,b,c,d,e]). =>  5
my_length([]) ->
    0;
my_length(L) ->
    my_length(L,0).

my_length([],Length) ->
    Length;
my_length([_|T],Length) ->
    my_length(T,Length+1).

%1.3
% Find kth element
% usage = p99:element_at(List,K)
%example:
% p99:element_at([a,b,c,d,e],3). =>  d
% p99:element_at([a,[b,b1],c,d,e],2). =>  c
element_at([E|_], 0 ) ->
    E;
element_at([_|T],K) ->
    element_at(T,K-1).

%1.2
% Find penultimate (second last) element of the list
% usage = p99:my_penultimate(List) List should have more than two elements
%example:
% p99:my_penultimate([a,b,c,d]). =>  c
% p99:my_penultimate([a,d]). =>  a
% p99:my_penultimate([a,d,c,[d,e]]). =>  c
% p99:my_penultimate([a,d,c,[d,e],f]). => [d,e]
my_penultimate([P|[_Last|_Empty=[]]])->
    P;
my_penultimate([_|T])->
    my_penultimate(T).

%1.1
% Find last element of the list
% usage = p99:my_last(List) List should have at least one element 
%example:
% p99:my_last([a,b,c,d]). => d 
my_last([H|[]])->
    H;
my_last([_|T])->
    my_last(T). 
