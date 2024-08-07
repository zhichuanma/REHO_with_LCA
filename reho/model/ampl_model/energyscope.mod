set INDICATORS;

set TECHNOLOGIES;
let TECHNOLOGIES := Units;

set RESOURCES;
let RESOURCES := ResourceBalances;

param lcia_constr {INDICATORS,TECHNOLOGIES} default 1e-12;
param lcia_op {INDICATORS,TECHNOLOGIES} default 1e-12;
param lcia_res {INDICATORS, RESOURCES} default 1e-12;
var lca_constr_units{INDICATORS,TECHNOLOGIES};
var lca_op_units{INDICATORS,TECHNOLOGIES};
var lca_res{INDICATORS,RESOURCES};

var TotalLCIA{INDICATORS} >= 0;

#--------------------------------------------------------------------------------------------------------------------#
#---Energyscope (new)
#--------------------------------------------------------------------------------------------------------------------#

#-------------------------#
#---CONSTRUCTION LCA
#-------------------------#

subject to LCA_construction_cst{k in INDICATORS, u in Units}:
lca_constr_units[k, u] >= (1/0.01) *Units_Mult[u]*lcia_constr[k, u];

#-------------------------#
#---OPERATION LCA
#-------------------------#

subject to LCA_operation_units{k in INDICATORS, u in Units}:
lca_op_units[k, u] >= sum{l in ResourceBalances, p in PeriodStandard, t in Time[p]} (lcia_op[k,u] * Units_supply[l,u,p,t]) * dp[p] * dt[p]);

#-------------------------#
#---RESOURCES LCA
#-------------------------#

subject to LCA_resources{k in INDICATORS, l in ResourceBalances}:
lca_res[k, l] >= sum{p in PeriodStandard,t in Time[p]} lcia_res[k, l] * (Network_supply[l,p,t] - Network_demand[l,p,t]) *dp[p]*dt[p];

#-------------------------#
#---TOTAL LCA
#-------------------------#

subject to LCA_tot{k in INDICATORS}:
LCA_tot[k] = sum{u in Units} lca_constr_units[k, u]/lifetime[u] + sum{u in Units} lca_op_units[k, u] + sum{l in ResourceBalances} lca_res[k, l];

subject to LCA_tot_house{k in Lca_kpi, h in House}:
LCA_tot_house[k, h] = sum{u in UnitsOfHouse[h]} lca_constr_units[k, u]/lifetime[u] + sum{l in ResourceBalances,p in PeriodStandard,t in Time[p]} lca_res[k, l] * (Grid_supply[l,h,p,t]-Grid_demand[l,h,p,t]) *dp[p]*dt[p];

var TotalCost default 0;

subject to TotalCost_penalties_relationship:
TotalCost = penalties * 1e6;

# Define TotalLCIA
subject to equal_to_LCA_tot{k in INDICATORS}:
TotalLCIA[k] = LCA_tot[k];

# LCIA construction
# subject to lcia_constr_calc {id in INDICATORS, i in TECHNOLOGIES}:
# LCIA_constr[id,i] >= (1/0.01) * lcia_constr[id,i] * F_Mult[i];

# LCIA operation
# subject to lcia_op_calc {id in INDICATORS, i in TECHNOLOGIES}:
# LCIA_op[id,i] >= lcia_op[id,i] * sum {t in PERIODS} (t_op[t] * F_Mult_t[i, t]);

# LCIA resources
# subject to lcia_res_calc {id in INDICATORS, r in RESOURCES}:
# LCIA_res[id,r] >= lcia_res[id,r] * sum {t in PERIODS} (t_op[t] * F_Mult_t[r, t]);

# subject to totalLCIA_calc_r {id in INDICATORS}:
# TotalLCIA[id] = sum {i in TECHNOLOGIES} (LCIA_constr[id,i] / lifetime[i]  + LCIA_op[id,i]) + sum{r in RESOURCES} (LCIA_res[id,r]);

var TotalLCIA_CCEQL;
subject to LCIA_CCEQL_cal:
  TotalLCIA_CCEQL = TotalLCIA['CCEQL'] + TotalCost*1e-6;

var TotalLCIA_CCEQS;
subject to LCIA_CCEQS_cal:
  TotalLCIA_CCEQS = TotalLCIA['CCEQS'] + TotalCost*1e-6;

var TotalLCIA_CCHHL;
subject to LCIA_CCHHL_cal:
  TotalLCIA_CCHHL = TotalLCIA['CCHHL'] + TotalCost*1e-6;

var TotalLCIA_CCHHS;
subject to LCIA_CCHHS_cal:
  TotalLCIA_CCHHS = TotalLCIA['CCHHS'] + TotalCost*1e-6;

var TotalLCIA_FWA;
subject to LCIA_FWA_cal:
  TotalLCIA_FWA = TotalLCIA['FWA'] + TotalCost*1e-6;

var TotalLCIA_FWEXL;
subject to LCIA_FWEXL_cal:
  TotalLCIA_FWEXL = TotalLCIA['FWEXL'] + TotalCost*1e-6;

var TotalLCIA_FWEXS;
subject to LCIA_FWEXS_cal:
  TotalLCIA_FWEXS = TotalLCIA['FWEXS'] + TotalCost*1e-6;

var TotalLCIA_FWEU;
subject to LCIA_FWEU_cal:
  TotalLCIA_FWEU = TotalLCIA['FWEU'] + TotalCost*1e-6;

var TotalLCIA_HTXCL;
subject to LCIA_HTXCL_cal:
  TotalLCIA_HTXCL = TotalLCIA['HTXCL'] + TotalCost*1e-6;

var TotalLCIA_HTXCS;
subject to LCIA_HTXCS_cal:
  TotalLCIA_HTXCS = TotalLCIA['HTXCS'] + TotalCost*1e-6;

var TotalLCIA_HTXNCL;
subject to LCIA_HTXNCL_cal:
  TotalLCIA_HTXNCL = TotalLCIA['HTXNCL'] + TotalCost*1e-6;

var TotalLCIA_HTXNCS;
subject to LCIA_HTXNCS_cal:
  TotalLCIA_HTXNCS = TotalLCIA['HTXNCS'] + TotalCost*1e-6;

var TotalLCIA_IREQ;
subject to LCIA_IREQ_cal:
  TotalLCIA_IREQ = TotalLCIA['IREQ'] + TotalCost*1e-6;

var TotalLCIA_IRHH;
subject to LCIA_IRHH_cal:
  TotalLCIA_IRHH = TotalLCIA['IRHH'] + TotalCost*1e-6;

var TotalLCIA_LOBDV;
subject to LCIA_LOBDV_cal:
  TotalLCIA_LOBDV = TotalLCIA['LOBDV'] + TotalCost*1e-6;

var TotalLCIA_LTBDV;
subject to LCIA_LTBDV_cal:
  TotalLCIA_LTBDV = TotalLCIA['LTBDV'] + TotalCost*1e-6;

var TotalLCIA_MAL;
subject to LCIA_MAL_cal:
  TotalLCIA_MAL = TotalLCIA['MAL'] + TotalCost*1e-6;

var TotalLCIA_MAS;
subject to LCIA_MAS_cal:
  TotalLCIA_MAS = TotalLCIA['MAS'] + TotalCost*1e-6;

var TotalLCIA_MEU;
subject to LCIA_MEU_cal:
  TotalLCIA_MEU = TotalLCIA['MEU'] + TotalCost*1e-6;

var TotalLCIA_OLD;
subject to LCIA_OLD_cal:
  TotalLCIA_OLD = TotalLCIA['OLD'] + TotalCost*1e-6;

var TotalLCIA_PMF;
subject to LCIA_PMF_cal:
  TotalLCIA_PMF = TotalLCIA['PMF'] + TotalCost*1e-6;

var TotalLCIA_PCOX;
subject to LCIA_PCOX_cal:
  TotalLCIA_PCOX = TotalLCIA['PCOX'] + TotalCost*1e-6;

var TotalLCIA_TRA;
subject to LCIA_TRA_cal:
  TotalLCIA_TRA = TotalLCIA['TRA'] + TotalCost*1e-6;

var TotalLCIA_TPW;
subject to LCIA_TPW_cal:
  TotalLCIA_TPW = TotalLCIA['TPW'] + TotalCost*1e-6;

var TotalLCIA_WAVFWES;
subject to LCIA_WAVFWES_cal:
  TotalLCIA_WAVFWES = TotalLCIA['WAVFWES'] + TotalCost*1e-6;

var TotalLCIA_WAVHH;
subject to LCIA_WAVHH_cal:
  TotalLCIA_WAVHH = TotalLCIA['WAVHH'] + TotalCost*1e-6;

var TotalLCIA_WAVTES;
subject to LCIA_WAVTES_cal:
  TotalLCIA_WAVTES = TotalLCIA['WAVTES'] + TotalCost*1e-6;

var TotalLCIA_TTEQ;
subject to LCIA_TTEQ_cal:
  TotalLCIA_TTEQ = TotalLCIA['TTEQ'] + TotalCost*1e-6;

var TotalLCIA_TTHH;
subject to LCIA_TTHH_cal:
  TotalLCIA_TTHH = TotalLCIA['TTHH'] + TotalCost*1e-6;

minimize TotalLCIA_CCEQL:
TotalLCIA_CCEQL + TotalCost*1e-6;