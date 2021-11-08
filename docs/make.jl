# Inside make.jl
push!(LOAD_PATH,"../")
include( "/home/csaba/Projects/Moodle/src/main.jl" )
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