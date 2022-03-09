# this is the main file of the package
# it has to be included to use the functions
module Moodle
using StatsBase, LinearAlgebra, LaTeXStrings, Latexify, DocStringExtensions, LatexPrint


export matching_question,
        multiple_choice_question,
        short_answer_question,
        VF_CLOZE_question,
        cloze_question,
        cloze_subquestion,
        essay_question
        moodle_quiz_to_file


current_dir = @__DIR__

include( current_dir*"/short_question.jl" )
include( current_dir*"/matching_question.jl" )
include( current_dir*"/VF_using_CLOZE.jl" )
include( current_dir*"/multiple_choice.jl" )
include( current_dir*"/essay.jl" )
include( current_dir*"/cloze.jl" )
include( current_dir*"/quiz.jl" )
include( current_dir*"/auxfunctions.jl" )


end #Module


