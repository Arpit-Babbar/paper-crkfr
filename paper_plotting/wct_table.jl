using DelimitedFiles
using PrettyTables

files_isentropic_t1_gl = Vector{String}()

A = Vector{Any}()
header = [" "]

for i in 1:3
    pr = "paper_results"
    data_isentropic_t1_gl_ = [readdlm("$pr/isentropic_t1_verbose/isentropic_$(solver)$(i)_radau_gl_no_limiter.txt")[:,3]
                            for solver in ("lw", "crk")]
    ratio = data_isentropic_t1_gl_[1] ./ data_isentropic_t1_gl_[2]
    push!(A, data_isentropic_t1_gl_...)
    push!(A, ratio)
    push!(header, ("LW", "cRK", "Ratio")...)
end

A = hcat(["50", "100", "200", "400"],A...)

pretty_table(A, header = header, backend = Val(:latex))
