


# this file contains the functions related to questions
# of V/F type using the CLOZE type question of Moodle


# THIS ISN'T DONE YET:
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



    






 



