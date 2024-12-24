using Tenkai, Tenkai

using TrixiBase: trixi_include
using DelimitedFiles
import TimerOutputs as to

function sol_error(sol)
    return sol["errors"]["l2_error"]
end

function sol_time(sol)
    full_time = to.tottime(sol["aux"].timer)
    write_time = to.time(sol["aux"].timer["Write solution"])
    err_time = to.time(sol["aux"].timer["Compute error"])
    @show full_time, write_time, err_time
    return (full_time - write_time - err_time) * 1e-9
end

isentropic_run_file = joinpath(cRK_examples_dir(), "2d", "run_isentropic.jl")

final_time_global = 1.0 # 20 * sqrt(2.0) / 0.5
nx_array = [64, 128, 256, 512]
nx_length = length(nx_array)
arrays_crk = Vector([zeros(nx_length, 3) for _ in 1:3])
arrays_lwfr = Vector([zeros(nx_length, 3) for _ in 1:3])
arrays_rkfr = Vector([zeros(nx_length, 3) for _ in 1:3])

degree2crk = Dict(1 => cRK22(), 2 => cRK33(), 3 => cRK44())

for (i, nx) in enumerate(nx_array)
    for degree in 1:3
        trixi_include(isentropic_run_file, solver = degree2crk[degree],
                      degree = degree, final_time = 1e-6, nx = nx)
        sol_crk = trixi_include(isentropic_run_file, solver = degree2crk[degree],
                                degree = degree, final_time = final_time_global, nx = nx)
        error_crk = sol_error(sol_crk)
        time_crk = sol_time(sol_crk)
        arrays_crk[degree][i, 1:3] .= nx, error_crk, time_crk

        trixi_include(isentropic_run_file, solver = "lwfr", degree = degree,
                      final_time = 1e-6, nx = nx)
        sol_lwfr = trixi_include(isentropic_run_file, solver = "lwfr", degree = degree,
                                 final_time = final_time_global, nx = nx)
        error_lwfr = sol_error(sol_lwfr)
        time_lwfr = sol_time(sol_lwfr)
        arrays_lwfr[degree][i, :] .= nx, error_lwfr, time_lwfr

        # trixi_include(isentropic_run_file, solver = "rkfr", degree = degree,
        #               final_time = 1e-6, nx = nx)
        # sol_rkfr = trixi_include(isentropic_run_file, solver = "rkfr", degree = degree,
        #                          final_time = final_time_global, nx = nx)
        # error_rkfr = sol_error(sol_rkfr)
        # time_rkfr = sol_time(sol_rkfr)
        # arrays_rkfr[degree][i, :] .= nx, error_rkfr, time_rkfr
    end
end

for degree in 1:3
    writedlm(joinpath("paper_results", "isentropic_crk$(degree).txt"), arrays_crk[degree])
    writedlm(joinpath("paper_results", "isentropic_lw$(degree).txt"), arrays_lwfr[degree])
    writedlm(joinpath("paper_results", "isentropic_rk$(degree).txt"), arrays_rkfr[degree])
end
