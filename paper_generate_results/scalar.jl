using Tenkai, Tenkai
using Tenkai: cRKSolver
using TrixiBase: trixi_include
using DelimitedFiles
using Tenkai: fo_blend
Eq = Tenkai.EqBurg1D
equation = Eq.get_equation()

include("base_run_convergence.jl")

crk_data_dir = joinpath(".", "paper_results")

function trixi_convergence(test, solver, nx_array;
                           bflux = evaluate, corr = "radau", diss = "2", points = "gl",
                           degree = 3, cfl = 0.0,
                           dim = "1d",
                           outdir = nothing)
    if outdir === nothing
        my_base_dir = joinpath(crk_data_dir, test)
        mkpath(my_base_dir)
        solver_ = solver2string(solver)
        filename = "$(solver_)_$(degree)_$(bf2str(bflux))_D$(diss)_$(corr)_$(points).txt"
        outdir = joinpath(my_base_dir, filename)
    end
    M = length(nx_array)
    data = zeros(M, 2)
    for i in eachindex(nx_array)
        sol = trixi_include("$(@__DIR__)/../examples/$dim/run_$test.jl",
                            solver = solver, degree = degree, bflux = bflux,
                            solution_points = points, diss = diss,
                            correction_function = corr, nx = nx_array[i],
                            cfl = cfl)
        data[i, 1] = nx_array[i]
        data[i, 2] = sol["errors"]["l2_error"]
    end
    writedlm(outdir, data)
    return
end

nx_array = [64, 128, 256, 512]

cfl_radau = [0.226, 0.117, 0.072, 0.049]

# Linear advection
for degree in 1:3
    crk_solver = degree2solver(degree)()
    for diss in ("1", "2")
        trixi_convergence("linadv1d", crk_solver, degree = degree, nx_array, bflux = evaluate,
                        # diss = diss, cfl = cfl_radau[degree]
                        )
        trixi_convergence("linadv1d", crk_solver, degree = degree, nx_array, bflux = evaluate,
                        corr = "g2", points = "gll",
                        diss = diss)
    end
end

# Variable advection

nx_array = [32, 64, 128, 256]

for degree in 1:3
    for bflux in (evaluate, extrapolate)
        crk_solver = degree2solver(degree)()
        for diss in ("1", "2")
            trixi_convergence("or2", crk_solver, nx_array, bflux = bflux, degree = degree,
                                diss = diss)
            trixi_convergence("or2", crk_solver, nx_array, bflux = bflux, degree = degree,
                                corr = "g2", points = "gll",
                                diss = diss)
        end
        trixi_convergence("or2", "lwfr", nx_array, degree = degree, bflux = bflux, diss = diss)
        trixi_convergence("or2", "lwfr", nx_array, degree = degree, bflux = bflux,
                            corr = "g2", points = "gll",
                            diss = "2")
    end
    trixi_convergence("or2", "rkfr", nx_array, degree = degree, bflux = evaluate, diss = diss)
end

# Burgers' equation

nx_array = [64, 128, 256, 512]

for degree in 1:3
    diss = "2"
    for bflux in (evaluate, extrapolate)
        crk_solver = degree2solver(degree)()
        trixi_convergence("burg1d", crk_solver, nx_array, bflux = bflux, degree = degree,
                          diss = diss)
        trixi_convergence("burg1d", crk_solver, nx_array, bflux = bflux, degree = degree,
                          corr = "g2", points = "gll",
                          diss = diss)
    end
    trixi_convergence("burg1d", "rkfr", nx_array, degree = degree, bflux = evaluate, diss = diss)
    trixi_convergence("burg1d", "rkfr", nx_array, degree = degree, bflux = evaluate, diss = diss,
                       corr = "g2", points = "gll")
end

function nx_array_for_degree(degree)
    return [64, 128, 256, 512]
end

for degree in 2:3
    diss = "2"
    crk_solver = degree2solver(degree)()
    nx_array = nx_array_for_degree(degree)
    trixi_convergence("isentropic_blend", crk_solver, nx_array, bflux = evaluate, degree = degree,
                      diss = diss, dim = "2d")
    trixi_convergence("isentropic", crk_solver, nx_array, bflux = evaluate, degree = degree,
                      diss = diss, dim = "2d")
end
