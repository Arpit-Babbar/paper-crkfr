julia  -e 'using Pkg; Pkg.add(PackageSpec(name = "JuliaFormatter", version="1.0.60"))'
julia  -e 'using JuliaFormatter; format(["elixirs", "examples", "src", "utils",
                                         "paper_generate_results"])'
