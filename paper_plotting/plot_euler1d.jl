include("base_plotting.jl")

files = ["paper_results/blast_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend", "tvb"]]
plot_solns(files, ["MH", "FO", "TVB"], test_case = "blast", xlims = (0.55,0.9),
           outdir = "paper_figures/blast")

files = ["paper_results/shuosher_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend", "tvb"]]
plot_solns(files, ["MH", "FO", "TVB"], test_case = "shuosher", xlims = (0.4, 2.4),
ylims = (2.6, 4.8),
           outdir = "paper_figures/shuosher")
plot_solns(files, ["MH", "FO", "TVB"], test_case = "shuosher", xlims = (1.4, 2.0),
ylims = (4.3, 4.7),
           outdir = "paper_figures/shuosher_superzoom")

files = ["paper_results/titarev_toro_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend", "tvb"]]
plot_solns(files, ["MH", "FO", "TVB"], test_case = "titarev_toro", outdir = "paper_figures/titarev_toro")

files = ["paper_results/titarev_toro_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend", "tvb"]]
plot_solns(files, ["MH", "FO", "TVB"], test_case = "titarev_toro", xlims = (-2.0, -1.0), ylims = (1.3, 1.7),
           outdir = "paper_figures/titarev_toro_zoom")

test = "sedov_blast"
files = ["paper_results/sedov_blast_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend", "tvb"]]
plot_solns(files, ["MH", "FO", "TVB"], test_case = "sedov1d", outdir = "paper_figures/sedov_blast")
plot_solns(files, ["MH", "FO", "TVB"], test_case = "sedov1d", outdir = "paper_figures/sedov_blast_log",
           yscale = :log)


test = "shuosher"
plot_test(test)
outdir = joinpath(Tenkai.base_dir, "figures", test*"_zoomed")
plot_solns([f_lwfr(test), f_mdrk(test)], ["LWFR", "MDRK"], test_case = test, xlims = (0.4, 2.4),
            ylims = (2.6, 4.8), outdir = outdir)

plot_test("sedov1d")
plot_test("double_rarefaction")
test = "leblanc"
plot_solns([f_lwfr(test), f_mdrk(test)], ["LWFR", "MDRK"], test_case = test, xlims = (-5.0,10.0),
            yscale = "log")


test = "titarev_toro"
plot_solns([f_mdrk_mh(test), f_mdrk_fo(test)], ["MH", "FO"], test_case = test,
            # xlims = (-5.0,10.0), yscale = "log"
            )

plot_solns([f_mdrk_mh(test), f_mdrk_fo(test)], ["MH", "FO"], test_case = test,
            xlims = (-2.0,-1.0), ylims = (1.3, 1.7),
            outdir = joinpath(Tenkai.base_dir, "figures", "$(test)_zoomed")
            )

test = "leblanc"
files = ["paper_results/leblanc_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend"]]
plot_solns(files, ["MH", "FO"], test_case = "leblanc", outdir = "paper_figures/leblanc")
plot_solns(files, ["MH", "FO"], test_case = "leblanc", outdir = "paper_figures/leblanc_log",
           yscale = :log)

test = "double_rarefaction"
files = ["paper_results/double_rarefaction_$(limiter)/sol.txt"
         for limiter in ["mh_blend", "fo_blend"]]
plot_solns(files, ["MH", "FO"], test_case = "double_rarefaction",
           outdir = "paper_figures/double_rarefaction")

test = "large_density"
files = ["paper_results/large_density_$(limiter)/sol.txt" for limiter in ["mh_blend", "fo_blend", "tvb"]]
# plot_solns(files, ["MH", "FO"], test_case = "leblanc", outdir = "paper_figures/leblanc")
plot_solns(files, ["MH", "FO", "TVB"], test_case = "large_density", outdir = "paper_figures/large_density_log",
           yscale = :log)
