# this file contains the functions related to questions
# of type shortanswer

@doc """
The data structure to hold a short answer type Moodle question
""" ->

struct short_answer_question
    title::String                   # the title of the question
    text::String                    # the text of the question
    answer::Union{String,Number}    # the right answer
    penalty::Float64                # required by Moodle, it's usually 0.1
    tags::Vector{String}            # list of tags
    defgrade::Int64                 # required by Moodle, usually 1
end 

# the following function creates short_answer_question from the first 
# three attributes -- the others will take the default value

function short_answer_question( title, text, answer; 
                        penalty = 0.1, tags = [], defgrade = 1 )
    
    return short_answer_question( title, text, answer, penalty, tags, defgrade )
end 

@doc """ 
Show function to short_answer_question
"""

function Base.show( io::IO, q::short_answer_question )  
        print(io, "Short answer question\n\tTitle: ", q.title, 
                "\n\tText: ", q.text[1:min(length(q.text),20)]*"...", 
                "\n\tAnswer: ", q.answer  )
end

@doc """
Creates short answer question with title. The text of the question is text in which 
[[i]] is replaced by the latex form of the i-th entry in mobj. The answer is obtained
by applying the function func to mobj.

julia> using LinearAlgebra

julia> A = [1 2;3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> B = [-1 0 ; 0 1 ]
2×2 Matrix{Int64}:
 -1  0
  0  1

julia> func(x,y) = LinearAlgebra.det( x*y )
func (generic function with 1 method)

julia> q = ShortAnswerQuestion( "Determinant", "Qual é o determinante de \\(AB\\) onde \\[A=[[1]]\\] e \\[B=[[2]].\\]", (A,B), func )
Short answer question
        Title: Determinant
        Text: Qual é o determinan...
        Answer: 2.0

""" ->
 
function ShortAnswerQuestion( title::String, 
            text::String, mobj::Tuple, func )::short_answer_question

    for i in 1:length(mobj)
        text = replace( text, "[["*string(i)*"]]" => latex_form( mobj[i] ))
    end 
    
    result = func( mobj... )
    return short_answer_question( title, text, string( result ))
end

@doc """
converts short answer type question to XML string
""" ->

function QuestionToXML( question::short_answer_question )
   
    xmlstring = "<question type=\"shortanswer\">\n<name format=\"html\">\n"*
            "<text><![CDATA["*question.title*"]]></text>\n"*
            "</name>\n"*
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"*question.text*"</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>"*string( question.defgrade )*"</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>"*string( question.penalty )*"</penalty>\n"*
            "<hidden>0</hidden>\n"*
            "<usecase>0</usecase>\n"* 
            "<answer fraction=\"100\" format=\"plain_text\"><text>"*
            string( question.answer )*"</text>\n</answer>\n"

    # if question has at least one tag, then they are added
    if length( question.tags ) > 0  
        xmlstring *= "<tags>\n"
        for tag in question.tags 
            xmlstring *= "<tag>\n<text>"*tag*"</text>\n</tag>\n"
        end 
        xmlstring *= "</tags>\n"
    end

    # end of question
    xmlstring *= "</question>\n" 
    return xmlstring
end
 