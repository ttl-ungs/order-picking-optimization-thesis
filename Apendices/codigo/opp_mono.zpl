##############################################################################
# OPP-Mono: the monolithic formulation.
#
# Solves the same problem as OPP-Split (opp_split_stage1_routing.zpl +
# opp_split_stage2_scheduling.zpl) as one MIP: routing, assignment and
# sequencing are decided together.
#   - Picker speeds (V_p): the speed scales only the travel + service time of
#     the route (r_b), not the setup or the picking (T_setup, T_pick), so a
#     batch lasts F_b[b] + r_b[b] / V_p[p].
#   - Cold chain: a batch can go to a picker only if, at that picker's speed,
#     F_b[b] + r_b[b] / V_p[p] <= T_cold (+ EPS, the tolerance every model
#     uses).
# With V_p = 1 for every picker and a very large T_cold (what
# dat_files_builder writes when the scenario does not define them) it reduces
# to the problem without speeds or cold chain.
#
# Linear programming assumptions:
#   Proportionality : every term of the objective and the constraints is
#                     linear in its variables.
#   Additivity      : no products between decision variables.
#   Divisibility    : the continuous variables (ta_n, ea_n, r_b, u_pb, c_pb,
#                     c_b, q_ijb) take any real value >= 0.
#   Certainty       : every parameter (distances, capacities, weights, due
#                     dates) is known and fixed.
##############################################################################


##############################################################################
# SETS
##############################################################################

# N : customer orders
set N := { read "../dat_files/data_N.dat" as "<1s>" comment "#" };

# V : warehouse locations (includes v_start and v_end)
set V := { read "../dat_files/data_V.dat" as "<1s>" comment "#" };

# P : pickers
set P := { read "../dat_files/data_P.dat" as "<1s>" comment "#" };

# B : batches of orders
set B := { read "../dat_files/data_B.dat" as "<1s>" comment "#" };

# E : arcs of the location graph
set E := { read "../dat_files/data_E.dat" as "<1s,2s>" comment "#" };


##############################################################################
# PARAMETERS
##############################################################################

# Depot and final node of every route
param v_start := read "../dat_files/depot.dat" as "1s" comment "#";
param v_end   := read "../dat_files/final.dat" as "1s" comment "#";

# Objective weights: completion time, penalties (earliness + tardiness),
# earliness, tardiness
param W_c   := read "../dat_files/params.dat" as "1n" skip 0 comment "#";
param W_pen := read "../dat_files/params.dat" as "1n" skip 1 comment "#";
param W_e   := read "../dat_files/params.dat" as "1n" skip 2 comment "#";
param W_t   := read "../dat_files/params.dat" as "1n" skip 3 comment "#";

# Time per unit of distance, setup time per batch, picking time per unit of
# capacity
param T_travel := read "../dat_files/params.dat" as "1n" skip 4 comment "#";
param T_setup  := read "../dat_files/params.dat" as "1n" skip 5 comment "#";
param T_pick   := read "../dat_files/params.dat" as "1n" skip 6 comment "#";

# Big-M. (Row 7 of params.dat is the vehicle capacity C_v: batches are data,
# so the capacity is validated before solving and the model does not read it.)
param M         := read "../dat_files/params.dat" as "1n" skip 8 comment "#";

# V_p[p] : speed factor of picker p (1.0 = reference; > 1 = faster)
param V_p[P]    := read "../dat_files/velocities.dat" as "<1s> 2n" comment "#";

# T_cold : longest time (same units as the batch duration) a batch may spend
#          out of the cold room while it is assembled
param T_cold := read "../dat_files/cold.dat" as "1n" comment "#";

# EPS : floating-point tolerance of the cold-chain check (the same in every
#       model)
param EPS := 1e-9;

# C_n[n] : capacity order n needs
param C_n[N]    := read "../dat_files/cap_n.dat"      as "<1s> 2n" comment "#";

# T_due_n[n] : due date of order n
param T_due_n[N] := read "../dat_files/due_date.dat"   as "<1s> 2n" comment "#";

# D_ij[i,j] : distance of arc (i,j)
param D_ij[E]    := read "../dat_files/distances.dat"  as "<1s,2s> 3n" comment "#";

# S_i[i] : service time at location i
param S_i[V]    := read "../dat_files/service_time.dat" as "<1s> 2n" comment "#";

# A_ni[n,i] : 1 if order n must visit location i
param A_ni[N * V] := read "../dat_files/a_ni.dat"    as "<1s,2s> 3n" comment "#";

# B_nb[n,b] : 1 if batch b contains order n
param B_nb[N * B] := read "../dat_files/B_nb.dat"      as "<1s,2s> 3n" comment "#";

# L_b[b] : number of distinct locations batch b must visit (the load of
#          the Gavish-Graves flow)
param L_b[<b> in B] :=
    sum <i> in V with (i != v_start and i != v_end and (sum <n> in N : A_ni[n,i] * B_nb[n,b]) >= 1) : 1;

# F_b[b] : part of the batch's duration that does not depend on the route
#          (setup + picking), and therefore not on the picker either
param F_b[<b> in B] :=
    T_setup + T_pick * (sum <n> in N: C_n[n] * B_nb[n,b]);

# M_seq : big-M of the sequencing constraints
param M_seq := read "../dat_files/params.dat" as "1n" skip 9 comment "#";

##############################################################################
# VARIABLES
##############################################################################

# ta_n[n] : tardiness of order n
var ta_n[N]         >= 0;

# ea_n[n] : earliness of order n
var ea_n[N]         >= 0;

# r_b[b] : travel + service time of the route chosen for batch b. It is
#          what Stage 1 of OPP-Split hands to Stage 2; here it is decided
#          together with everything else.
var r_b[B]          >= 0;

# c_b[b] : completion time of batch b, whoever runs it
var c_b[B]          >= 0;

# u_pb[p,b] : processing time of batch b when picker p runs it.
#
# The upper bound is the cold chain: if x_pb = 1, (15) forces
# u_pb >= F_b[b] + r_b[b] / V_p[p], so that duration stays <= T_cold + EPS
# (the condition of PB_elig in opp_split_stage2_scheduling.zpl); if x_pb = 0
# the bound restricts nothing because u_pb can be 0.
var u_pb[P * B]     >= 0 <= T_cold + EPS;

# c_pb[p,b] : completion time of batch b in picker p's schedule
var c_pb[P * B]     >= 0;

# z_ijb[i,j,b] : 1 if the route of batch b uses arc (i,j)
var z_ijb[E * B] binary;

# q_ijb[i,j,b] : Gavish-Graves load flow: required locations of batch b
#                still to visit when the route crosses arc (i,j). It only
#                exists to eliminate subtours.
var q_ijb[E * B] >= 0;

# x_pb[p,b] : 1 if batch b is assigned to picker p
var x_pb[P * B] binary;

# y_bk[b,k] : 1 if batch b goes before batch k on the picker they share
#             (defined for b < k only)
var y_bk[<b,k> in B * B with b < k] binary;

##############################################################################
# OBJECTIVE FUNCTION
#
# min  W_c * sum_b c_b[b]
#    + W_pen * ( W_e * sum_n ea_n[n]  +  W_t * sum_n ta_n[n] )
#
# The completion time is priced on c_b, which (18) ties to the c_pb of the
# picker that runs the batch. Summing c_pb over every pair (p,b) would also
# charge a c_pb > 0 forced on a pair that is not assigned.
##############################################################################

minimize obj:
      W_c  * (sum <b> in B: c_b[b])
    + W_pen * (  W_e * (sum <n> in N: ea_n[n])
                 + W_t * (sum <n> in N: ta_n[n])
                );


##############################################################################
# CONSTRAINTS
##############################################################################

################################ Batch routes ################################

# (1) Every batch leaves the depot once
subto start_from_depot:
  forall <b> in B:
      sum <i, j> in E with i == v_start:
          z_ijb[i, j, b] == 1;

# (2) Every batch enters the final node once
subto finish_at_end:
   forall <b> in B:
       sum <i, j> in E with j == v_end:
           z_ijb[i, j, b] == 1;

# (3) No arc returns to the depot
subto no_inflow_depot:
    forall <b> in B:
        sum <i, j> in E with j == v_start and v_start != v_end:
            z_ijb[i, j, b] == 0;

# (4) No arc leaves the final node
subto no_outflow_final:
    forall <b> in B:
        sum <i, j> in E with i == v_end and v_start != v_end:
            z_ijb[i, j, b] == 0;

####################### Visits and flow conservation #########################

# (5) Every required location is entered
subto force_visit_inflow:
   forall <b> in B:
       forall <j> in V with j != v_start and j != v_end:
           sum <i, j> in E:
               z_ijb[i, j, b]
           >= if (sum <n> in N: A_ni[n,j] * B_nb[n,b]) >= 1 then 1 else 0 end;

# (6) Every required location is left
subto force_visit_outflow:
    forall <b> in B:
        forall <j> in V with j != v_start and j != v_end:
            sum <j, i> in E:
                z_ijb[j, i, b]
            >= if (sum <n> in N: A_ni[n,j] * B_nb[n,b]) >= 1 then 1 else 0 end;

# (7) Flow conservation at intermediate nodes
subto route_flow_conservation:
    forall <b> in B:
        forall <i> in V with i != v_start and i != v_end:
            (sum <g, i> in E: z_ijb[g, i, b])
            - (sum <i, j> in E: z_ijb[i, j, b]) == 0;

# (8) At most one arc into every node: with (9), a route is a simple path
#     and never goes through the same location twice
subto one_input_arc_per_node:
    forall <b> in B:
        forall <i> in V with i != v_start:
            sum <j, i> in E:
                z_ijb[j, i, b] <= 1;

# (9) At most one arc out of every node
subto one_output_arc_per_node:
    forall <b> in B:
        forall <i> in V with i != v_end:
            sum <i, j> in E:
                z_ijb[i, j, b] <= 1;

#################### Subtour elimination (load flow) #########################

# (10) The load flows only on used arcs (Gavish-Graves)
subto load_flow_bound:
    forall <b> in B:
        forall <i, j> in E:
            q_ijb[i, j, b] - L_b[b] * z_ijb[i, j, b] <= 0;

# (11) The whole load leaves the depot
subto load_flow_source:
    forall <b> in B:
        sum <i, j> in E with i == v_start:
            q_ijb[i, j, b] == L_b[b];

# (12) One unit of load is dropped at every required location
subto load_flow_conservation:
    forall <b> in B:
        forall <i> in V with i != v_start and i != v_end:
            (sum <g, i> in E: q_ijb[g, i, b])
            - (sum <i, j> in E: q_ijb[i, j, b])
            == if (sum <n> in N: A_ni[n,i] * B_nb[n,b]) >= 1 then 1 else 0 end;

######################## Execution and completion time #######################

# (13) Route time of the batch: travel (distance * T_travel) plus service at
# every visited location. T_setup and T_pick are in F_b: they do not depend
# on the route. Same definition as define_route_time in
# opp_split_stage1_routing.zpl.
subto define_route_time:
    forall <b> in B:
        r_b[b] ==
              T_travel * (sum <i,j> in E with i != v_end and j != v_start:
                               D_ij[i,j] * z_ijb[i,j,b])
            + (sum <i> in V with i != v_start and i != v_end:
                   S_i[i] * (sum <i, j> in E: z_ijb[i, j, b]));

########################## Assignment and sequencing #########################

# (14) Every batch goes to exactly one picker
subto assign_exactly_one_picker:
    forall <b> in B:
        sum <p> in P: x_pb[p,b] == 1;

# (15) The processing time is at least the batch's duration at the picker's
# speed, F_b[b] + r_b[b] / V_p[p] (T_exec_pb in
# opp_split_stage2_scheduling.zpl), when the batch is assigned to the picker
subto batch_execution_time_lower:
    forall <p,b> in P * B:
        F_b[b] + r_b[b] / V_p[p] - M * (1 - x_pb[p,b]) <= u_pb[p,b];

# (16) ... and at most that duration, so u_pb equals it when x_pb = 1
subto batch_execution_time_upper:
    forall <p,b> in P * B:
        u_pb[p,b] <= F_b[b] + r_b[b] / V_p[p] + M * (1 - x_pb[p,b]);

# (17) A batch completes no earlier than its processing time
subto processing_le_completion:
    forall <p,b> in P * B:
        u_pb[p,b] <= c_pb[p,b];

# (18) c_b[b] is the completion time of the batch on the picker that runs it
subto c_b_lower_bound:
    forall <p,b> in P * B:
        c_pb[p,b] - M * (1 - x_pb[p,b]) <= c_b[b];

######################## Sequencing without overlap ##########################

# (19) Two batches of the same picker run one after the other: k after b
# when y_bk = 1. The duration is the one at the picker's speed.
subto non_overlap_1:
    forall <p> in P:
        forall <b, k> in B * B with b < k:
            c_pb[p,k] >= c_pb[p,b] + F_b[k] + r_b[k] / V_p[p]
                         - M_seq * (3 - x_pb[p,b] - x_pb[p,k] - y_bk[b,k]);

# (20) ... and b after k when y_bk = 0
subto non_overlap_2:
    forall <p> in P:
        forall <b, k> in B * B with b < k:
            c_pb[p,b] >= c_pb[p,k] + F_b[b] + r_b[b] / V_p[p]
                         - M_seq * (2 - x_pb[p,b] - x_pb[p,k] + y_bk[b,k]);

########################## Earliness and tardiness ###########################

# Rows exist only for the orders of each batch (B_nb[n,b] == 1): for any
# other pair the row would never bind.

# (21) Tardiness of an order: how long after its due date its batch completes
subto tardiness_definition:
    forall <p,b,n> in P * B * N with B_nb[n,b] == 1:
        c_pb[p,b] - T_due_n[n] - M * (2 - x_pb[p,b] - B_nb[n,b]) <= ta_n[n];

# (22) Earliness of an order: how long before its due date its batch completes
subto earliness_definition:
    forall <p,b,n> in P * B * N with B_nb[n,b] == 1:
        T_due_n[n] - c_pb[p,b] - M * (2 - x_pb[p,b] - B_nb[n,b]) <= ea_n[n];
