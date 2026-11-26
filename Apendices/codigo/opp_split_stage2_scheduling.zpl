##############################################################################
# OPP-Split, Stage 2: assignment, sequencing and cold chain.
#
# Takes the route time of each batch from Stage 1 (R_b[b]) as data and
# decides which picker runs each batch and in which order, pricing the
# completion times and the earliness and tardiness of the orders.
#
#   - Picker speeds (V_p). The speed scales the travel + service time (R_b)
#     but not the setup or the picking itself (T_setup, T_pick), which belong
#     to the task and not to the walk.
#   - Because R_b[b] is data, the time picker p needs for batch b,
#     T_exec_pb[p,b] = F_b[b] + R_b[b] / V_p[p], is known before solving. It
#     is a parameter, so linking it to the completion time needs no big-M.
#   - Cold chain: a batch can go to a picker only if, at that picker's speed,
#     it is assembled within T_cold. It is enforced on the domain of the
#     variables (the set PB_elig), not as a constraint.
##############################################################################


##############################################################################
# SETS
##############################################################################

set N := { read "../dat_files/data_N.dat" as "<1s>" comment "#" };
set P := { read "../dat_files/data_P.dat" as "<1s>" comment "#" };
set B := { read "../dat_files/data_B.dat" as "<1s>" comment "#" };


##############################################################################
# PARAMETERS - read from the instance
##############################################################################

param W_c   := read "../dat_files/params.dat" as "1n" skip 0 comment "#";
param W_pen := read "../dat_files/params.dat" as "1n" skip 1 comment "#";
param W_e   := read "../dat_files/params.dat" as "1n" skip 2 comment "#";
param W_t   := read "../dat_files/params.dat" as "1n" skip 3 comment "#";

param T_setup := read "../dat_files/params.dat" as "1n" skip 5 comment "#";
param T_pick  := read "../dat_files/params.dat" as "1n" skip 6 comment "#";

param M     := read "../dat_files/params.dat" as "1n" skip 8 comment "#";
param M_seq := read "../dat_files/params.dat" as "1n" skip 9 comment "#";

param C_n[N]      := read "../dat_files/cap_n.dat"    as "<1s> 2n" comment "#";
param T_due_n[N]  := read "../dat_files/due_date.dat" as "<1s> 2n" comment "#";
param B_nb[N * B] := read "../dat_files/B_nb.dat"     as "<1s,2s> 3n" comment "#";

# R_b[b] : travel + service time of batch b on its best route (Stage 1)
param R_b[B] := read "../dat_files/route_time_b.dat" as "<1s> 2n" comment "#";

# V_p[p] : speed factor of picker p (1.0 = reference; > 1 = faster)
param V_p[P] := read "../dat_files/velocities.dat" as "<1s> 2n" comment "#";

# T_cold : longest time (same units as T_exec_pb) a batch may spend out of
#          the cold room while it is assembled
param T_cold := read "../dat_files/cold.dat" as "1n" comment "#";

##############################################################################
# PARAMETERS - derived
##############################################################################

# EPS : floating-point tolerance of the cold-chain check. It is the one
#       models/utils/cold_chain_validation.py and the heuristics use, so a
#       batch with T_exec_pb == T_cold up to rounding is eligible everywhere.
param EPS := 1e-9;

# F_b[b] : part of the batch's duration that does not depend on the route
#          (setup + picking), and therefore not on the picker either
param F_b[<b> in B] :=
    T_setup + T_pick * (sum <n> in N: C_n[n] * B_nb[n,b]);

# T_exec_pb[p,b] : time picker p needs to run batch b
param T_exec_pb[<p,b> in P * B] :=
    F_b[b] + R_b[b] / V_p[p];

# PB_elig : (picker, batch) pairs that respect the cold chain
set PB_elig := { <p,b> in P * B with T_exec_pb[p,b] <= T_cold + EPS };

# Batches no picker can run within T_cold. If there is one, the model is
# infeasible; models/utils/cold_chain_validation.py computes the same set in
# Python to report it before solving (ZIMPL rejects the empty sum of
# assign_exactly_one_picker when it compiles).
set B_no_eligible_picker := { <b> in B with (sum <p> in P with <p,b> in PB_elig: 1) == 0 };


##############################################################################
# VARIABLES
##############################################################################

# x_pb[p,b] : 1 if batch b is assigned to picker p (eligible pairs only)
var x_pb[PB_elig] binary;

# c_pb[p,b] : completion time of batch b in picker p's schedule
var c_pb[PB_elig] >= 0;

# c_b[b] : completion time of batch b, whoever runs it
var c_b[B] >= 0;

# y_bk[b,k] : 1 if batch b goes before batch k on the picker they share
var y_bk[<b,k> in B * B with b < k] binary;

# ta_n[n] / ea_n[n] : tardiness / earliness of order n
var ta_n[N] >= 0;
var ea_n[N] >= 0;


##############################################################################
# OBJECTIVE
##############################################################################

minimize obj:
      W_c  * (sum <b> in B: c_b[b])
    + W_pen * (  W_e * (sum <n> in N: ea_n[n])
                 + W_t * (sum <n> in N: ta_n[n])
                );


##############################################################################
# CONSTRAINTS
##############################################################################

################### Assignment (cold-chain eligible pairs) ###################

subto assign_exactly_one_picker:
    forall <b> in B:
        sum <p> in P with <p,b> in PB_elig:
            x_pb[p,b] == 1;

############################## Completion time ###############################

# T_exec_pb is a number, so "if x_pb = 1 then c_pb >= T_exec_pb" is linear
# as it stands.
subto batch_completion_floor:
    forall <p,b> in PB_elig:
        T_exec_pb[p,b] * x_pb[p,b] <= c_pb[p,b];

subto c_b_lower_bound:
    forall <p,b> in PB_elig:
        c_pb[p,b] - M * (1 - x_pb[p,b]) <= c_b[b];

######################## Sequencing without overlap ##########################
# The duration is the one of the picker that runs the batch (T_exec_pb[p,k]):
# with heterogeneous speeds a batch has no single duration.

subto non_overlap_1:
    forall <p> in P:
        forall <b,k> in B * B with b < k and <p,b> in PB_elig and <p,k> in PB_elig:
            c_pb[p,k] >= c_pb[p,b] + T_exec_pb[p,k]
                         - M_seq * (3 - x_pb[p,b] - x_pb[p,k] - y_bk[b,k]);

subto non_overlap_2:
    forall <p> in P:
        forall <b,k> in B * B with b < k and <p,b> in PB_elig and <p,k> in PB_elig:
            c_pb[p,b] >= c_pb[p,k] + T_exec_pb[p,b]
                         - M_seq * (2 - x_pb[p,b] - x_pb[p,k] + y_bk[b,k]);

########################## Earliness and tardiness ###########################
# Rows exist only for the orders of each batch (B_nb[n,b] == 1): for any
# other pair the row would never bind.

subto tardiness_definition:
    forall <p,b,n> in P * B * N with B_nb[n,b] == 1 and <p,b> in PB_elig:
        c_pb[p,b] - T_due_n[n] - M * (2 - x_pb[p,b] - B_nb[n,b]) <= ta_n[n];

subto earliness_definition:
    forall <p,b,n> in P * B * N with B_nb[n,b] == 1 and <p,b> in PB_elig:
        T_due_n[n] - c_pb[p,b] - M * (2 - x_pb[p,b] - B_nb[n,b]) <= ea_n[n];
