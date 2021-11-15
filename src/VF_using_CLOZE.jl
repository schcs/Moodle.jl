# this file contains the functions related to questions
# of V/F type using the CLOZE type question of Moodle

# THIS ISN'T DONE YET:
@doc """
The data structure to hold a VF_CLOZE type Moodle question
""" ->

struct VF_CLOZE_question
    title::String                   # the title of the question
    initial_text::String            # the inicial text of the question
    list_of_statements::Vector      # list of TF statements in form (statement , true/false)
 #   defgrade::Int64                 # required by Moodle, usually 1
 #   penalty::Float64                # we're not sure about this.  required by Moodle, it's usually 0.1
    tags::Vector{String}            # list of tags
end 

# most basic implementation, with initial text "Para cada das seguintes afirmações, decida se ela é verdadeira ou falsa:"
function VF_CLOZE_question( title, initial_text, list_of_statements ; tags = [] )
    
    return VF_CLOZE_question( moodle_string( title ), 
              moodle_string( initial_text ), list_of_statements, tags )
end 



# Given a pair (Statement, 1/0), where Statement is a string and 1 means it's true and 0 means it's false, gives as output
# the xml code for a question in the list of True/False statements.  At the moment, the string "text" has to be written in XML
# with moodle latex commands

function TF_Question_For_CLOZE_In_XML( text :: String , TF :: Bool )
    local output :: String

    if TF
        output = "{1:MULTICHOICE:%100%Verdadeira~%-100%Falsa~%0%Prefiro não responder}&nbsp; &nbsp; &nbsp;"*text

    else
        output = "{1:MULTICHOICE:%-100%Verdadeira~%100%Falsa~%0%Prefiro não responder}&nbsp; &nbsp; &nbsp;"*text

    end

return output
end





# this function uses "sample" which requires the package StatsBase
# This first version chooses NumQuest statements randomly from the list Statements
function Choose_TF_Statements( Statements :: Vector, NumQuest :: Int64)
  local QuestionsTaken :: Vector

  QuestionsTaken = sample(Statements, NumQuest, replace = false)

  return QuestionsTaken
end




# This second version has a third variable, "NumTrue", which allows the user to choose how many of the NumQuest
# statements chosen are true
function Choose_TF_Statements( Statements :: Vector, NumQuest :: Int64, NumTrue :: Int64 )
  local TrueList :: Vector, FalseList :: Vector, X :: Vector, NumFalse :: Int64

  NumFalse = NumQuest - NumTrue

  TrueList = [ Statements[i] for i in 1:length(Statements) if Statements[i][2] == true ]
  FalseList = [ Statements[i] for i in 1:length(Statements) if Statements[i][2] == false ]

  TruesTaken = sample(TrueList, NumTrue, replace = false)
  FalsesTaken = sample(FalseList, NumFalse, replace = false)

  X = [TruesTaken; FalsesTaken]

  return sample(X, length(X), replace = false)
end



#title :: String, initial_text :: String ,  list_of_statements :: Vector

# Padrão initial text suggestion: Para cada das seguintes afirmações, decida se ela é verdadeira ou falsa:

# makes a string of all the statements in XML
function QuestionToXML(  question :: VF_CLOZE_question )
    local i :: Int64, XMLversion :: Vector,  output :: String


    XMLversion = [ "\n<p dir=\"ltr\"><br><br></p><p dir=\"ltr\"></p><p dir=\"ltr\">\n"*TF_Question_For_CLOZE_In_XML( moodle_string( i[1] ), i[2] ) for i in question.list_of_statements ]
    output = ""

    xmlstring = "
      <question type=\"cloze\">
        <name>
          <text>"*question.title*"</text>
        </name>
        <questiontext format=\"html\">
          <text><![CDATA[<p dir=\"ltr\" style=\"text-align: left;\"></p><p dir=\"ltr\">"*question.initial_text*"</p>"*
          prod(XMLversion)*
          "</p><p dir=\"ltr\"><br></p><br><p></p>]]></text>
          </questiontext>
          <generalfeedback format=\"html\">
            <text></text>
          </generalfeedback>
          <penalty>0.3333333</penalty>
          <hidden>0</hidden>
          <idnumber></idnumber>"

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



    






 



