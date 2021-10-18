


# this file contains the functions related to questions
# of V/F type using the CLOZE type question of Moodle

@doc """
The data structure to hold a VF_CLOZE type Moodle question
""" ->

struct VF_CLOSE_question
    title::String                   # the title of the question
    text::String                    # the text of the question
    statements::Vector{Vector}      # things to be matched
    defgrade::Int64                 # required by Moodle, usually 1
    penalty::Float64                # we're not sure about this.  required by Moodle, it's usually 0.1
    tags::Vector{String}            # list of tags
end 



# the idea is that the question will take 4 inputs title, text, subquestions, shuffle.  
# penalty will be 0.1, defgrade will be 1, and tags will be empty.  I'm testing to see if I can avoid taking the first 4 entries above.

function matching_question( title, text, subquestions, shuffle )
    
    return matching_question( title, text, subquestions, 1, 0.1, shuffle, [] )
end 


# Given a pair (Statement, 1/0), where Statement is a string and 1 means it's true and 0 means it's false, gives as output
# the xml code for a question in the list of True/False statements.  At the moment, the string "text" has to be written in XML
# with moodle latex commands

function TF_Question_For_CLOZE_In_XML( text :: String , TF :: Int64 )
    local output :: String

    if TF == 1
        output = "{1:MULTICHOICE:%100%Verdadeira~%-100%Falsa~%0%Prefiro não responder}&nbsp; &nbsp; &nbsp;"*text

    elseif TF == 0
        output = "{1:MULTICHOICE:%-100%Verdadeira~%100%Falsa~%0%Prefiro não responder}&nbsp; &nbsp; &nbsp;"*text

    else error("o segundo argumento deve ser ou 1 se for verdadeira, ou 0 se for falsa")
end

return output
end





# this function uses "sample" which requires the package StatsBase


function Choose_TF_Statements( Statements :: Vector, NumTrue :: Int64, NumFalse :: Int64 )
    local TrueList :: Vector, FalseList :: Vector, X :: Vector

    TrueList = [ Statements[i] for i in 1:length(Statements) if Statements[i][2] == 1 ]
    FalseList = [ Statements[i] for i in 1:length(Statements) if Statements[i][2] == 0 ]

    TruesTaken = sample(TrueList, NumTrue, replace = false)
    FalsesTaken = sample(FalseList, NumFalse, replace = false)

    X = [TruesTaken; FalsesTaken]

    return sample(X, length(X), replace = false)
end



# makes a string of all the statements in XML
function List_of_TF_Questions_In_XML( title :: String, List_of_statements :: Vector )
    local i :: Int64, XMLversion :: Vector,  output :: String

    XMLversion = [ "\\( \\medskip\\)<br></p><p dir=\"ltr\"></p><p dir=\"ltr\">"*TF_Question_For_CLOZE_In_XML( i[1], i[2] ) for i in List_of_statements ]
    output = ""

    output = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <quiz>
    <!-- question: 208923  -->
      <question type=\"cloze\">
        <name>
          <text>"*title*"</text>
        </name>
        <questiontext format=\"html\">
          <text><![CDATA[<p dir=\"ltr\" style=\"text-align: left;\"></p><p dir=\"ltr\">Para cada das seguintes afirmações, decida se ela é verdadeira ou falsa:</p><p dir=\"ltr\">"*
          prod(XMLversion)*
          "</p><p dir=\"ltr\"><br></p><br><p></p>]]></text>
          </questiontext>
          <generalfeedback format=\"html\">
            <text></text>
          </generalfeedback>
          <penalty>0.3333333</penalty>
          <hidden>0</hidden>
          <idnumber></idnumber>
        </question>
      
      </quiz>"
    
    return output
end



    



function MoodleSubQuestion( QApair :: Vector )
    question = QApair[1] 
    answer = QApair[2]

    if question != "" 

        text = "<subquestion format=\"html\">\n"* 
                "<text><![CDATA[<p>\\("*
                latex_form(question) *
                "\\)</p>]]></text>\n"*
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
 



