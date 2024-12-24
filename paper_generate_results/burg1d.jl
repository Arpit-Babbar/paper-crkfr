using Tenkai, Tenkai
using TrixiBase: trixi_include
using DelimitedFiles
using Tenkai: fo_blend
Eq = Tenkai.EqBurg1D
equation = Eq.get_equation()

function bf2str(bflux)
    if bflux == evaluate
        return "EA"
    else
        @assert bflux == extrapolate
        return "AE"
    end
end

crk_data_dir = joinpath(".", "paper_results")

function trixi_convergence(test, solver, nx_array;
                           bflux = evaluate, corr = "radau", diss = "2", points = "gl",
                           degree = 3,
                           outdir = nothing)
    if outdir === nothing
        my_base_dir = joinpath(crk_data_dir, test)
        mkpath(my_base_dir)
        filename = "$(solver)$(degree)_$(bf2str(bflux))_D$(diss)_$(corr)_$(points).txt"
        outdir = joinpath(my_base_dir, filename)
    end
    M = length(nx_array)
    data = zeros(M, 2)
    for i in eachindex(nx_array)
        sol = trixi_include("$(@__DIR__)/../examples/1d/run_$test.jl",
                            solver = solver, degree = 3, bflux = bflux,
                            solution_points = points, diss = diss,
                            correction_function = corr, nx = nx_array[i])
        data[i, 1] = nx_array[i]
        data[i, 2] = sol["errors"]["l2_error"]
    end
    writedlm(outdir, data)
    return
end

nx_array = [20, 40, 80, 160, 320]

for bflux in (evaluate, extrapolate)
    trixi_convergence("burg1d", cRK22(), degree = 1, nx_array, bflux = bflux, diss = "2")
    trixi_convergence("burg1d", cRK33(), degree = 2, nx_array, bflux = bflux, diss = "2")
    trixi_convergence("burg1d", cRK44(), nx_array, bflux = bflux, diss = "2")
    for degree in 1:3
        trixi_convergence("burg1d", "lwfr", nx_array, bflux = bflux, diss = "2")
    end
end
