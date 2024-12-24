include("base_plotting.jl")
EqTM = Tenkai.EqTenMoment1D
using Tenkai.EqTenMoment1D: sod_iv
s_dir = "paper_results"
file1 = "$s_dir/tenmom_homogeneous/sol.txt"
file2 = "$s_dir/tenmom_source/sol.txt"
files = [file1, file2]
labels = ["Homogeneous", "Non-Homog."]
plot_solns(files, labels; degree = 3, outdir = "paper_figures/tenmom_rare", plt_type = "sol",
           soln_line_width = 2.0, s_ind = 6, s_label = "\$P_{12}\$")

files = ["$s_dir/tenmom_realistic_nuT0.0/line_cut.txt",
         "reference_solns/line_cut_nu0.txt",
         "$s_dir/tenmom_realistic_nuT1.0/line_cut.txt",
         "reference_solns/line_cut_nu1.txt"]

num_solns = [readdlm(files[1]), readdlm(files[3])]
exact_solns = [readdlm(files[2]), readdlm(files[4])]

fig_density, ax_density = plt.subplots()
ax_density.set_xlabel("x")
ax_density.set_ylabel("Density")
ax_density.grid(true, linestyle = "--")
ax_density.scatter(num_solns[1][1:end,1], num_solns[1][1:end,2], label = "\$\\nu_T = 0.0\$",
                   facecolors="none", edgecolors="red", marker = "s"
                   )
ax_density.plot(exact_solns[1][:,1], exact_solns[1][:,2], label = "Ref. \$\\nu_T = 0.0\$",
                c = "k", linewidth = 1.0)
ax_density.scatter(num_solns[2][1:end,1], num_solns[2][1:end,2], label = "\$\\nu_T = 1.0\$",
                   facecolors="none", edgecolors="blue")
ax_density.plot(exact_solns[2][:,1], exact_solns[2][:,2], label = "Ref. \$\\nu_T = 1.0\$",
                c = "k", linewidth = 1.0, ls = "--")
ax_density.legend()
my_save_fig_python("Realistic", fig_density, "density.pdf", fig_dir = "paper_figures/tenmom_realistic")

