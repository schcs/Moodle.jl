# this file contains the functions related to questions
# of type matching

@doc """
The data structure to hold a matching type Moodle question
""" ->

struct matching_question
    title::String                   # the title of the question
    text::String                    # the text of the question
    subquestions::Vector{Vector}    # things to be matched
    defgrade::Int64                 # required by Moodle, usually 1
    penalty::Float64                # we're not sure about this.  required by Moodle, it's usually 0.1
    shuffle::Bool                  # Csaba says "1 if we want answers permuted" -- I guess it's 0 if not?
    tags::Vector{String}            # list of tags
end 



# the idea is that the question will take 4 inputs title, text, subquestions, shuffle.  
# penalty will be 0.1, defgrade will be 1, and tags will be empty.  I'm testing to see if I can avoid taking the first 4 entries above.

function matching_question( title, text, subquestions; defgrade = 1, penalty = 0.1, shuffle = true, tags = [] )
    
    return matching_question( title, text, subquestions, defgrade, penalty, shuffle, tags )
end 



function MoodleSubQuestion( QApair :: Vector )
    question = QApair[1] 
    answer = QApair[2]

    if question != "" 

        text = "<subquestion format=\"html\">\n"* 
                "<text><![CDATA[<p>"*
                moodle_latex_form(question) *
                "</p>]]></text>\n"*
                "<answer><text>"*  string(answer) * "</text></answer>\n"* 
                "</subquestion>\n"
    else 

        text = "<subquestion format=\"html\">\n"* 
                "<text></text>\n"*
                "<answer><text>"*  string(answer) * "</text></answer>\n"* 
                "</subquestion>\n"
    end

    return text

end




@doc """
converts matching type question to XML string
""" ->

function QuestionToXML( question::matching_question )


    xmlstring = "<question type=\"matching\">\n<name format=\"html\">\n"*
            "<text><![CDATA["* question.title* "]]></text>\n"*
            "</name>\n"* 
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"* question.text* "</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>"* string( question.defgrade )* "</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>"* string(question.penalty)* "</penalty>\n"*
            "<hidden>0</hidden>\n"*
            "<shuffleanswers>"* string( question.shuffle )* "</shuffleanswers>\n" 
   


    for ans in question.subquestions
        xmlstring *= MoodleSubQuestion( ans )
    end


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
 






#@doc """ 
#Show function to short_answer_question
#"""

# I'm ignoring this for now

#function Base.show( io::IO, q::short_answer_question )  
#        print(io, "Short answer question\n\tTitle: ", q.title, 
#                "\n\tText: ", q.text[1:min(length(q.text),20)]*"...", 
#                "\n\tAnswer: ", q.answer  )
#end


 



#= (this is in auxfunctions.jl)
function QApairs( ListOfAnswers::Tuple , func )
    QAlist = []
    for i in 1:length(ListOfAnswers)
        QAlist[i] = [ListOfAnswers[i], func(ListOfAnswers[i])]
    end

    return QAlist
end
=#





#=
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
            question.answer*"</text>\n</answer>\n"

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
 =#



