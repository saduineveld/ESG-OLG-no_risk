# ESG-OLG-no_risk
Matlab code for ESG-OLG model without risk, and two periods (Climvest)

Model description: "esg_hetero_olgT2"

Calibration, results, analysis, figures:

To get results:
1) Run calibration of OLG part "cal_OLG/cal_OLG_T2_v3"
2) Run calibration ESG: "cal1_het_int_tax_OLG_T2_loop"
3) Run calibration ESG: "cal2_het_int_tax_OLG_T2_loop"
4) Compute optimal Pigouvian tax (only non-ESG): "opt_tax_het_int_OLG_T2_smpl()"
5) Get results over grids:
    a) tax = 0: "res_het_int_tax_OLG_T2_loop_gammaweight"
    b) gamma scale =1: "res_het_int_tax_OLG_T2_loop_taxweight": RESULTS\res_het_int_tax_OLG_T2_cal2_taxoptXXX_fixgamma1
    c) Optimal emission tax:   "res_het_int_tax_OLG_T2_opttax_loopweight"
    d) Optimal Pigouvian tax:  "res_het_int_tax_OLG_T2_pigtax_loopweight"
6) Analyze the results (post-processing) with:
    a) analyze_het_int_tax_OLG_T2_fxtax0
    b) analyze_het_int_tax_OLG_T2_fxgamma1: RESULTS\ana_het_int_tax_OLG_T2_cal2_taxoptXXX_fixgamma1
5) Plot results with "plots"
    a) plots_het_int_tax_OLG_T2_cal2_fxtax0
    b) plots_het_int_tax_OLG_T2_cal2_fxgamma1
