# Inside make.jl
push!(LOAD_PATH, (@__DIR__)*"/../src" )
include( (@__DIR__)*"/../src/main.jl" )
using Documenter
makedocs(
         sitename = "Moodle.jl",
         modules  = Module[],
         pages=[
                "Home" => "index.md"
               ])
deploydocs(;
    repo="github.com/schcs/Moodle.jl",
)