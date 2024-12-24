using Tenkai
using Tenkai: utils_dir
using Tenkai: cRKSolver
include("$utils_dir/plot_python_solns.jl")

include("../paper_generate_results/base_run_convergence.jl")

function add_theo_factors_degrees!(ax, ncells, error, degree, i,
                                   theo_factor_even, theo_factor_odd)
    if degree isa Int64
        d = degree
    else
        d = parse(Int64, degree)
    end
    min_y = minimum(error[1:(end - 1)])
    @show error, min_y
    xaxis = ncells[(end - 1):end]
    slope = d + 1
    if iseven(slope)
        theo_factor = theo_factor_even
    else
        theo_factor = theo_factor_odd
    end
    y0 = theo_factor * min_y
    y = (1.0 ./ xaxis) .^ slope * y0 * xaxis[1]^slope
    markers = ["s", "o", "*", "^"]
    local label_
    if i == 1
        label_ = "\$N+1\$"
    else
        label_ = ""
    end
    # if i == 1
    ax.loglog(xaxis, y,
            #   label = "\$ O(M^{-$(d + 1)})\$",
              label = label_,
              linestyle = "--",
            #   marker = markers[i],
              c = "grey",
              fillstyle = "none")
    # else
    # ax.loglog(xaxis,y, linestyle = "--", c = "grey")
    # end
end

function my_set_ticks!(ax, log_sub, ticks_formatter; dim = 2, base_major = 2.0)
    # Remove scientific notation and set xticks
    # https://stackoverflow.com/a/49306588/3904031

    function anonymous_formatter(y, _)
        if y > 1e-4
            # y_ = parse(Int64, y)
            y_ = Int64(y)
            if dim == 2
                return "\$$y_^2\$"
            else
                return "\$$y_\$"
            end
        else
            return @sprintf "%.4E" y
        end
    end

    formatter = plt.matplotlib.ticker.FuncFormatter(ticks_formatter)
    # (y, _) -> format"{:.4g}".format(int(y)) ) # format"{:.4g}".format(int(y)))
    # https://stackoverflow.com/questions/30887920/how-to-show-minor-tick-labels-on-log-scale-with-plt.matplotlib
    x_major = plt.matplotlib.ticker.LogLocator(base = base_major, subs = (log_sub,),
                                               numticks = 20) # ticklabels at base_major^i*log_sub
    x_minor = plt.matplotlib.ticker.LogLocator(base = 2.0,
                                               subs = LinRange(1.0, 9.0, 9) * 0.1,
                                               numticks = 10)
    #  Used to manipulate tick labels. See help(plt.matplotlib.ticker.LogLocator) for details)
    ax.xaxis.set_major_formatter(anonymous_formatter)
    ax.xaxis.set_minor_formatter(plt.matplotlib.ticker.NullFormatter())
    ax.xaxis.set_major_locator(x_major)
    ax.xaxis.set_minor_locator(x_minor)
    ax.tick_params(axis = "both", which = "major")
    ax.tick_params(axis = "both", which = "minor")
end

function plot_python_ndofs_vs_y_degrees(files::Vector{String}, labels::Vector{String},
                                        degrees::Vector{Int}, markers, colors,;
                                        saveto,
                                        theo_factor_even = 0.8, theo_factor_odd = 0.8,
                                        title = nothing, log_sub = "2.5",
                                        error_norm = "l2",
                                        ticks_formatter = format_with_powers,
                                        figsize = (6.4, 4.8),
                                        var_index = 2,
                                        base_major = 2.0,
                                        dim = 1,
                                        plt_type = "dofs")
    # @assert error_type in ["l2","L2"] "Only L2 error for now"
    fig_error, ax_error = plt.subplots(figsize = figsize)
    @assert length(files) == length(markers) == length(colors)
    n_plots = length(files)
    n_labels = length(labels)
    @assert plt_type in ("dofs", "cells")

    # add labels using white colour curves
    for i in 1:n_labels
        data = readdlm(files[i])
        marker = markers[i]
        degree = degrees[i]
        local x
        if plt_type == "dofs"
            x = data[:, 1] * (degree+1)
        else
            x = data[:, 1]
        end
        ax_error.loglog(x, data[:, var_index], marker = marker, c = "white",
                        mec = "k", fillstyle = "none", label = labels[i])
    end

    for i in 1:n_plots
        data = readdlm(files[i])
        marker = markers[i]
        degree = degrees[i]
        local x
        if plt_type == "dofs"
            x = data[:, 1] * (degree+1)
        else
            x = data[:, 1]
        end
        ax_error.loglog(x, data[:, var_index], marker = marker, c = colors[i],
                        mec = "k", fillstyle = "none")
    end

    for i in eachindex(unique(degrees)) # Assume degrees are not repeated
        data = readdlm(files[n_labels*i-1])
        degree = degrees[n_labels*i-1]
        local x
        if plt_type == "dofs"
            x = data[:, 1] * (degree+1)
        else
            x = data[:, 1]
        end
        add_theo_factors_degrees!(ax_error, x, data[:,var_index], degree, i,
                                  theo_factor_even, theo_factor_odd)
    end
    if plt_type == "dofs"
        ax_error.set_xlabel("Degrees of freedom")
    else
        ax_error.set_xlabel("Number of elements")
    end
    ax_error.set_ylabel(error_label(error_norm))

    my_set_ticks!(ax_error, log_sub, ticks_formatter; dim = dim, base_major = base_major)

    ax_error.grid(true, linestyle = "--")

    if title !== nothing
        ax_error.set_title(title)
    end
    ax_error.legend()

    fig_error.savefig("$saveto.pdf")
    fig_error.savefig("$saveto.png")

    return fig_error
end

markers_for_curve = ["s", "^", "o", "*", "D"]
colors_for_degree = ["orange", "royalblue", "green", "m", "c", "y", "k"]

files_d1_d2_gl = Vector{String}()
files_d1_d2_gll = Vector{String}()

files_or_ae = Vector{String}()
labels_or_ae = ["RK","cRK-AE"]
files_or_ea = Vector{String}()
labels_or_ea = ["RK","cRK-EA"]
files_or_ae_ea = Vector{String}()
labels_or_ae_ea = ["cRK-EA","cRK-AE"]

files_burg_gl = Vector{String}()
files_burg_gll = Vector{String}()
labels_burg = ["RK", "cRK-EA", "cRK-AE"]

labels_d1_d2 = ["D2", "D1"]

files_isentropic = Vector{String}()
files_isentropic_t1_gl = Vector{String}()
files_isentropic_t1_gll = Vector{String}()

labels_isentropic = ["No blending", "Blending"]

degrees_array = Vector{Int}()
degrees_burg = Vector{Int}()
colors_arr = Vector{String}()
colors_burg = Vector{String}()
markers_arr = Vector{String}()
markers_burg = Vector{String}()
for i in 1:3
    crk_solver = "cRK$(i+1)$(i+1)"
    pr = "paper_results"
    files_gl = ["$pr/linadv1d/$(crk_solver)_$(i)_EA_D$(diss)_radau_gl.txt"
                for diss in (2,1)]
    files_gll = ["$pr/linadv1d/$(crk_solver)_$(i)_EA_D$(diss)_g2_gll.txt"
                 for diss in (2,1)]
    files_or_ae_ = ["$pr/or2/rkfr_$(i)_EA_D2_radau_gl.txt",
                    "$pr/or2/$(crk_solver)_$(i)_AE_D2_radau_gl.txt"]
    files_or_ea_ = ["$pr/or2/$(solver)_$(i)_EA_D2_radau_gl.txt"
                    for solver in ("rkfr", crk_solver)]
    files_or_ae_ea_ = ["$pr/or2/$(crk_solver)_$(i)_$(bflux)_D2_radau_gl.txt"
                      for bflux in ("EA", "AE")]

    files_burg_gl_ = ["$pr/burg1d/rkfr_$(i)_EA_D2_radau_gl.txt",
                     ["$pr/burg1d/$(crk_solver)_$(i)_$(bflux)_D2_radau_gl.txt"
                      for bflux in ("EA", "AE")]...]

    files_burg_gll_ = ["$pr/burg1d/rkfr_$(i)_EA_D2_g2_gll.txt",
                       ["$pr/burg1d/$(crk_solver)_$(i)_$(bflux)_D2_g2_gll.txt"
                        for bflux in ("EA", "AE")]...]

    files_isentropic_ = ["$pr/$(test)/$(crk_solver)_$(i)_EA_D2_radau_gl.txt"
                         for test in ("isentropic", "isentropic_blend")]

    if i > 1
        files_isentropic_t1_gl_ = ["$pr/isentropic_t1_verbose/isentropic_crk$(i)_radau_gl_$(limiter).txt"
                                for limiter in ("no_limiter", "blend")]
        files_isentropic_t1_gll_ = ["$pr/isentropic_t1_verbose/isentropic_crk$(i)_g2_gll_$(limiter).txt"
                                for limiter in ("no_limiter", "blend")]
        push!(files_isentropic_t1_gl, files_isentropic_t1_gl_...)
        push!(files_isentropic_t1_gll, files_isentropic_t1_gll_...)
    end
    push!(files_d1_d2_gl, files_gl...)
    push!(files_d1_d2_gll, files_gll...)
    push!(files_or_ae, files_or_ae_...)
    push!(files_or_ea, files_or_ea_...)
    push!(files_or_ae_ea, files_or_ae_ea_...)
    push!(files_burg_gl, files_burg_gl_...)
    push!(files_burg_gll, files_burg_gll_...)
    push!(files_isentropic, files_isentropic_...)
    push!(degrees_array, [i, i]...)
    push!(degrees_burg, [i, i, i]...)
    c = colors_for_degree[i]
    m1 = markers_for_curve[1]
    m2 = markers_for_curve[2]
    m3 = markers_for_curve[3]
    push!(markers_arr, [m1, m2]...)
    push!(markers_burg, [m1, m2, m3]...)
    push!(colors_arr, [c, c]...)
    push!(colors_burg, [c, c, c]...)
end

plot_python_ndofs_vs_y_degrees(files_d1_d2_gl, labels_d1_d2, degrees_array, markers_arr,
                               colors_arr, title = "GL, Radau",
                               log_sub = "0.5",
                               theo_factor_even = 0.7, theo_factor_odd = 0.6,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "linadv1d_d1_d2_gl"))
plot_python_ndofs_vs_y_degrees(files_d1_d2_gll, labels_d1_d2, degrees_array, markers_arr,
                               colors_arr, title = "GLL, \$g_2\$",
                               log_sub = "0.5",
                               theo_factor_even = 0.7, theo_factor_odd = 0.6,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "linadv1d_d1_d2_gll"))

plot_python_ndofs_vs_y_degrees(files_or_ae, labels_or_ae, degrees_array, markers_arr,
                               colors_arr, title = "GL, Radau",
                               log_sub = "0.5",
                               theo_factor_even = 0.7, theo_factor_odd = 0.6,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "or_ae"))

plot_python_ndofs_vs_y_degrees(files_or_ea, labels_or_ea, degrees_array, markers_arr,
                               colors_arr, title = "GL, Radau",
                               log_sub = "0.5",
                               theo_factor_even = 0.7, theo_factor_odd = 0.6,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "or_ea"))

plot_python_ndofs_vs_y_degrees(files_or_ae_ea, labels_or_ae_ea, degrees_array, markers_arr,
                               colors_arr, title = "GL, Radau",
                               log_sub = "0.5",
                               theo_factor_even = 0.7, theo_factor_odd = 0.6,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "or_ae_ea"))

plot_python_ndofs_vs_y_degrees(files_burg_gl, labels_burg, degrees_burg, markers_burg,
                               colors_burg, title = "GL, Radau",
                               log_sub = "0.5",
                               theo_factor_even = 0.55, theo_factor_odd = 0.7,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "burg_gl"))

plot_python_ndofs_vs_y_degrees(files_burg_gll, labels_burg, degrees_burg, markers_burg,
                               colors_burg, title = "GLL, \$g_2\$",
                               log_sub = "0.5",
                               theo_factor_even = 0.55, theo_factor_odd = 0.7,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "burg_gll"))

plot_python_ndofs_vs_y_degrees(files_burg_gll, labels_burg, degrees_burg, markers_burg,
                               colors_burg, title = "GLL, \$g_2\$",
                               log_sub = "0.5",
                               theo_factor_even = 0.55, theo_factor_odd = 0.7,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "burg_gll"))

plot_python_ndofs_vs_y_degrees(files_isentropic_t1_gl, labels_isentropic, degrees_array[3:end],
                               markers_arr[3:end],
                               colors_arr[3:end], title = "GL, Radau",
                               log_sub = 25/8,
                               theo_factor_even = 0.55, theo_factor_odd = 0.7,
                               figsize = (6.0, 7.0),
                               plt_type = "cells",
                               dim = 2,
                               base_major = 2.0,
                               saveto = joinpath("paper_figures", "isentropic_t1"))

plot_python_ndofs_vs_y_degrees(files_isentropic_t1_gll, labels_isentropic, degrees_array[3:end],
                               markers_arr[3:end],
                               colors_arr[3:end], title = "GLL, \$g_2\$",
                               log_sub = "0.5",
                               theo_factor_even = 0.55, theo_factor_odd = 0.7,
                               figsize = (6.0, 7.0),
                               saveto = joinpath("paper_figures", "isentropic"))
