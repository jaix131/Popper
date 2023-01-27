% Generated via https://github.com/tomsilver/popper-policies
% Example expected output:
% ********** SOLUTION **********
% Precision:1.00 Recall:1.00 TP:10 FN:0 TN:623 FP:0 Size:9
% pick(A,B,C,D):- free(C,D),gripper(C,D),room(B,D),ball(A,D),at_robby(B,D),at(A,B,D),goal_at(A,E,D),negated_at_robby(E,D).
% ******************************

% Set max bounds
max_body(10).
max_vars(6).

% Predicates
body_pred(at,3).
body_pred(at_robby,2).
body_pred(ball,2).
body_pred(carry,3).
body_pred(free,2).
body_pred(gripper,2).
body_pred(negated_at,3).
body_pred(negated_at_robby,2).
body_pred(negated_carry,3).
body_pred(negated_free,2).
body_pred(room,2).

% Goal predicates
body_pred(goal_at,3).

% Action
head_pred(pick,4).

% Type constraints
type(free,(object,ex_id)).
type(at,(object,object,ex_id)).
type(negated_at,(object,object,ex_id)).
type(room,(object,ex_id)).
type(negated_free,(object,ex_id)).
type(negated_at_robby,(object,ex_id)).
type(negated_carry,(object,object,ex_id)).
type(carry,(object,object,ex_id)).
type(gripper,(object,ex_id)).
type(at_robby,(object,ex_id)).
type(pick,(object,object,object,ex_id)).
type(goal_at,(object,object,ex_id)).
type(ball,(object,ex_id)).

% Example ID can only appear once
:- clause(C), #count{V : clause_var(C,V),var_type(C,V,ex_id)} != 1.

% Action preconditions (and suppress ASP warning)
#defined body_literal/4.
:- not body_literal(0,room,2,(1,3)).
:- not body_literal(0,free,2,(2,3)).
:- not body_literal(0,at,3,(0,1,3)).
:- not body_literal(0,ball,2,(0,3)).
:- not body_literal(0,gripper,2,(2,3)).
:- not body_literal(0,at_robby,2,(1,3)).
