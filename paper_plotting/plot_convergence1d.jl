using Tenkai
using Tenkai: utils_dir

include("$utils_dir/plot_python_solns.jl")

# TODO - Move this function to utils
function plot_python_ndofs_vs_y(files::Vector{String}, labels::Vector{String};
                                saveto, degree = 3,
                                theo_factor_even = 0.8, theo_factor_odd = 0.8,
                                title = nothing, log_sub = "2.5",
                                error_norm = "l2",
                                ticks_formatter = format_with_powers,
                                figsize = (6.4, 4.8))
    # @assert error_type in ["l2","L2"] "Only L2 error for now"
    fig_error, ax_error = plt.subplots(figsize = figsize)
    colors = ["orange", "royalblue", "green", "m", "c", "y", "k"]
    markers = ["D", "o", "*", "^"]
    @assert length(files) == length(labels)
    n_plots = length(files)

    for i in 1:n_plots
        data = readdlm(files[i])
        marker = markers[i]
        ax_error.loglog(data[:, 1] * (degree + 1), data[:, 2], marker = marker, c = colors[i],
                        mec = "k", fillstyle = "none", label = labels[i])
    end

    data = readdlm(files[1])
    marker = markers[1]
    add_theo_factors!(ax_error, (degree + 1) * data[:, 1], data[:, 2], degree, 1,
                      theo_factor_even, theo_factor_odd)
    ax_error.set_xlabel("Degrees of freedom")
    ax_error.set_ylabel(error_label(error_norm))

    set_ticks!(ax_error, log_sub, ticks_formatter; dim = 1)

    ax_error.grid(true, linestyle = "--")

    if title !== nothing
        ax_error.set_title(title)
    end
    ax_error.legend()

    fig_error.savefig("$saveto.pdf")
    fig_error.savefig("$saveto.png")

    return fig_error
end

files_gl_bflux_compared = ["paper_results/burg1d/cRK44()3_EA_D2_radau_gl.txt", "paper_results/burg1d/cRK44()3_AE_D2_radau_gl.txt"]
labels_bflux_compared = ["EA", "AE"]

mkpath("paper_figures")

plot_python_ndofs_vs_y(files_gl_bflux_compared, labels_bflux_compared, title = "GL, Radau",
                       saveto = joinpath("paper_figures", "burger_bflux"))


