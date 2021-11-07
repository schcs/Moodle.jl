# this is the main file of the package
# it has to be included to use the functions
module Moodle

using LatexPrint, StatsBase, LinearAlgebra

current_dir = @__DIR__

include( current_dir*"/short_question.jl" )
include( current_dir*"/matching_question.jl" )
include( current_dir*"/VF_using_CLOZE.jl" )
include( current_dir*"/multiple_choice.jl" )
include( current_dir*"/quiz.jl" )
include( current_dir*"/auxfunctions.jl" )


end




