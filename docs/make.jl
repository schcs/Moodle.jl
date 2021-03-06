
push!(LOAD_PATH, (@__DIR__)*"/../src" )
#import Pkg; Pkg.add( "Documenter" )
using Documenter
using Moodle

makedocs(
    sitename = "Moodle",
    format = Documenter.HTML(),
    modules = [Moodle]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "https://github.com/schcs/Moodle.jl"
)

