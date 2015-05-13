
:- multifile user:file_search_path/2.
:- dynamic   user:file_search_path/2.

:- getenv('GENLOG_DIR', Dir),
   asserta(file_search_path(genlog, Dir));
   true.
   
        
%% ----------------------------------------------------------------------

:- use_module(genlog(experiment)).

:- use_module(genlog(sdcl)).
:- use_module(genlog(compile)).

:- use_module(genlog(learn)).
:- use_module(genlog(pgen)).
:- use_module(genlog(pprint)).

:- use_module(genlog(data_utils)).


%% this file
:- absolute_file_name('./trivial.pl', Abs),
   set_setting(experiment:runner, Abs).

%% experiment data directory
:- set_setting(experiment:root, '../data').

%% genlog file 
:- getenv('GENLOG_DIR', Dir),
   atomic_list_concat([Dir, '/', '../experiments/gls', '/', 'trivial.gl'], Path),
   prolog_to_os_filename(Path, Path2),
   set_setting(experiment:genlog_file, Path2).

        
goal( s([a,a,a,a,a]-[]) ).
goal( s([a,a,b,b,a]-[]) ).
goal( s([b,b]-[]) ).
goal( s([a,a]-[]) ).
        

goals(Goals) :-
        findall(G, goal(G),
                 Goals).
        
main :-
        % experiment:setup_experiment,
        setting(experiment:genlog_file, GL_FILE), 
        compile_sdcl_file(GL_FILE),
        Options = [beam_width(500), time_limit_seconds(4)],
        set_rule_alphas(uniform),
        goals(Goals),
        list_to_random_choice(Goals, GoalGen),
        run_online_vbem(GoalGen, Data, Options),        
        writeln(Data).
  

        