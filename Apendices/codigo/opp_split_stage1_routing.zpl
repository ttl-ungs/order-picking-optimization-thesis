##############################################################################
# OPP-Split, Stage 1: the route of each batch.
#
# No routing term depends on which picker runs a batch or on the order
# between batches, so the best route of each batch is found without knowing
# the assignment or the sequence. For every batch in B the model finds the
# path of least time (travel + service at each location) from the depot to
# the final node through the batch's required locations. Batches do not
# interact, which is why the runner can solve them one at a time.
#
# Output for Stage 2: r_b[b], the travel + service time of batch b on its
# best route, before the picker speed and without setup or picking time
# (neither depends on the route).
##############################################################################


##############################################################################
# SETS
##############################################################################

# N : customer orders
set N := { read "../dat_files/data_N.dat" as "<1s>" comment "#" };

# V : warehouse locations (includes v_start and v_end)
set V := { read "../dat_files/data_V.dat" as "<1s>" comment "#" };

# B : batches of orders
set B := { read "../dat_files/data_B.dat" as "<1s>" comment "#" };

# E : arcs of the location graph
set E := { read "../dat_files/data_E.dat" as "<1s,2s>" comment "#" };


##############################################################################
# PARAMETERS
##############################################################################

# v_start / v_end : depot and final node of every route
param v_start := read "../dat_files/depot.dat" as "1s" comment "#";
param v_end   := read "../dat_files/final.dat" as "1s" comment "#";

# T_travel : time per unit of distance
param T_travel := read "../dat_files/params.dat" as "1n" skip 4 comment "#";

# D_ij[i,j] : distance of arc (i,j)
param D_ij[E] := read "../dat_files/distances.dat" as "<1s,2s> 3n" comment "#";

# S_i[i] : service time at location i
param S_i[V] := read "../dat_files/service_time.dat" as "<1s> 2n" comment "#";

# A_ni[n,i] : 1 if order n must visit location i
param A_ni[N * V] := read "../dat_files/a_ni.dat" as "<1s,2s> 3n" comment "#";

# B_nb[n,b] : 1 if batch b contains order n
param B_nb[N * B] := read "../dat_files/B_nb.dat" as "<1s,2s> 3n" comment "#";

# L_b[b] : number of distinct locations batch b must visit (the load of
#          the Gavish-Graves flow)
param L_b[<b> in B] :=
    sum <i> in V with (i != v_start and i != v_end and (sum <n> in N : A_ni[n,i] * B_nb[n,b]) >= 1) : 1;


##############################################################################
# VARIABLES
##############################################################################

# z_ijb[i,j,b] : 1 if the route of batch b uses arc (i,j)
var z_ijb[E * B] binary;

# q_ijb[i,j,b] : Gavish-Graves load flow: required locations of batch b
#                still to visit when the route crosses arc (i,j). It only
#                exists to eliminate subtours.
var q_ijb[E * B] >= 0;

# r_b[b] : travel + service time of batch b on its route (what Stage 2
#          receives)
var r_b[B] >= 0;


##############################################################################
# OBJECTIVE
#
# Batches do not interact, so minimizing the sum minimizes each r_b[b].
##############################################################################

minimize obj:
    sum <b> in B: r_b[b];


##############################################################################
# CONSTRAINTS
##############################################################################

################################ Batch routes ################################

subto start_from_depot:
    forall <b> in B:
        sum <i, j> in E with i == v_start:
            z_ijb[i, j, b] == 1;

subto finish_at_end:
    forall <b> in B:
        sum <i, j> in E with j == v_end:
            z_ijb[i, j, b] == 1;

subto no_inflow_depot:
    forall <b> in B:
        sum <i, j> in E with j == v_start and v_start != v_end:
            z_ijb[i, j, b] == 0;

subto no_outflow_final:
    forall <b> in B:
        sum <i, j> in E with i == v_end and v_start != v_end:
            z_ijb[i, j, b] == 0;

####################### Visits and flow conservation #########################

subto force_visit_inflow:
    forall <b> in B:
        forall <j> in V with j != v_start and j != v_end:
            sum <i, j> in E:
                z_ijb[i, j, b]
            >= if (sum <n> in N: A_ni[n,j] * B_nb[n,b]) >= 1 then 1 else 0 end;

subto force_visit_outflow:
    forall <b> in B:
        forall <j> in V with j != v_start and j != v_end:
            sum <j, i> in E:
                z_ijb[j, i, b]
            >= if (sum <n> in N: A_ni[n,j] * B_nb[n,b]) >= 1 then 1 else 0 end;

subto route_flow_conservation:
    forall <b> in B:
        forall <i> in V with i != v_start and i != v_end:
            (sum <g, i> in E: z_ijb[g, i, b])
            - (sum <i, j> in E: z_ijb[i, j, b]) == 0;

# At most one arc in and one arc out of every node: a route is a simple
# path and never goes through the same location twice.
subto one_input_arc_per_node:
    forall <b> in B:
        forall <i> in V with i != v_start:
            sum <j, i> in E:
                z_ijb[j, i, b] <= 1;

subto one_output_arc_per_node:
    forall <b> in B:
        forall <i> in V with i != v_end:
            sum <i, j> in E:
                z_ijb[i, j, b] <= 1;

#################### Subtour elimination (load flow) #########################

subto load_flow_bound:
    forall <b> in B:
        forall <i, j> in E:
            q_ijb[i, j, b] - L_b[b] * z_ijb[i, j, b] <= 0;

subto load_flow_source:
    forall <b> in B:
        sum <i, j> in E with i == v_start:
            q_ijb[i, j, b] == L_b[b];

subto load_flow_conservation:
    forall <b> in B:
        forall <i> in V with i != v_start and i != v_end:
            (sum <g, i> in E: q_ijb[g, i, b])
            - (sum <i, j> in E: q_ijb[i, j, b])
            == if (sum <n> in N: A_ni[n,i] * B_nb[n,b]) >= 1 then 1 else 0 end;

############################## Batch route time ##############################

# Travel (distance * T_travel) plus service at every visited location.
# T_setup and T_pick are left out: they depend only on the batch's orders,
# not on the route, and Stage 2 adds them.
subto define_route_time:
    forall <b> in B:
        r_b[b] ==
              T_travel * (sum <i,j> in E with i != v_end and j != v_start:
                             D_ij[i,j] * z_ijb[i,j,b])
            + (sum <i> in V with i != v_start and i != v_end:
                   S_i[i] * (sum <i, j> in E: z_ijb[i, j, b]));
