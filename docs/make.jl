# Inside make.jl
push!(LOAD_PATH,"../")
using Documenter
makedocs(
         sitename = "Moodle.jl",
         #modules  = [],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/schcs/Moodle.jl",
)