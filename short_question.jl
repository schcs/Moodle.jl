struct short_answer_question
    title::String
    text::String
    answer::String
    penalty::Float64
    tags::Vector{String}
    defgrade::Int64
end 

function short_answer_question( title, text, answer )
    
    return short_answer_question( title, text, answer, 0.1, [], 1 )
end 

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

    if length( question.tags ) > 0  
        xmlstring *= "<tags>\n"
        for tag in question.tags 
            xmlstring *= "<tag>\n<text>"*tag*"</text>\n</tag>\n"
        end 
        xmlstringtext *= "</tags>\n"
    end

    xmlstring *= "</question>\n" 
    return xmlstring
end
 