using LatexPrint, StatsBase, LinearAlgebra, LaTeXStrings
current_dir = @__DIR__

include( current_dir*"/short_question.jl" )
include( current_dir*"/matching_question.jl" )
include( current_dir*"/VF_using_CLOZE.jl" )
include( current_dir*"/multiple_choice.jl" )
include( current_dir*"/cloze.jl" )
include( current_dir*"/quiz.jl" )
include( current_dir*"/auxfunctions.jl" )
