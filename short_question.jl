# this file contains the functions related to questions
# of type shortanswer

@doc """
The data structure to hold a short answer type Moodle question
""" ->

struct short_answer_question
    title::String               # the title of the question
    text::String                # the text of the question
    answer::String              # the right answer
    penalty::Float64            # required by Moodle, it's usually 1.0
    tags::Vector{String}        # list of tags
    defgrade::Int64             # required by Moodle, usuall 1
end 

# the following function creates short_answer_question from the first 
# three attributes -- the others will take the default value

function short_answer_question( title, text, answer )
    
    return short_answer_question( title, text, answer, 0.1, [], 1 )
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
            question.answer*"</text>\n</answer>\n"

    # if question has at least one tag, then they are added
    if length( question.tags ) > 0  
        xmlstring *= "<tags>\n"
        for tag in question.tags 
            xmlstring *= "<tag>\n<text>"*tag*"</text>\n</tag>\n"
        end 
        xmlstringtext *= "</tags>\n"
    end

    # end of question
    xmlstring *= "</question>\n" 
    return xmlstring
end
 