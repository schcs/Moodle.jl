# this file contains the functions related to questions
# of essay type


# THIS ISN'T DONE YET:
@doc """
The data structure to hold an essay question.

$(TYPEDEF)
$(TYPEDFIELDS)

At the moment an essay question can be created as follows. 

```@repl
q = essay_question( "Galois Theory.", "State and prove the Fundamental Theorem of Galois Theory", tags = ["Q1" ] )
```

Note that the optional arguments defgrade and penalty are not yet implemented for essay questions. Also there is no paramentric version and the functions write_latex and Base.show are not yet implemented for this type of questions.
""" ->

struct essay_question
    title::String                   # the title of the question
    question_text::String            # the inicial text of the question
 #  list_of_statements::Vector      # list of TF statements in form (statement , true/false)
 #   defgrade::Int64                 # required by Moodle, usually 1
 #   penalty::Float64                # we're not sure about this.  required by Moodle, it's usually 0.1
    tags::Vector{String}            # list of tags
end 

# most basic implementation, with title, question title and tags (optional)

@doc """
$(SIGNATURES)
""" ->

function essay_question( title, question_text; tags = [] )
    
    return essay_question( title, question_text, tags )
end 



#title :: String, initial_text :: String ,  list_of_statements :: Vector
# Padrão initial text suggestion: Para cada das seguintes afirmações, decida se ela é verdadeira ou falsa:
# makes a string of all the statements in XML
@doc """ 
    Writes a Moodle question into an XML string.

$(SIGNATURES)
""" ->
function question_to_xml(  question :: essay_question )
    
    xmlstring = "<question type=\"essay\">
    <name>
      <text>"*question.title*"</text>
    </name>
    <questiontext format=\"html\">
      <text><![CDATA[<p dir=\"ltr\" style=\"text-align: left;\">"*question.question_text*"</p>]]></text>
    </questiontext>
    <generalfeedback format=\"html\">
      <text></text>
    </generalfeedback>
    <defaultgrade>1</defaultgrade>
    <penalty>0</penalty>
    <hidden>0</hidden>
    <idnumber></idnumber>
    <responseformat>editor</responseformat>
    <responserequired>0</responserequired>
    <responsefieldlines>15</responsefieldlines>
    <attachments>-1</attachments>
    <attachmentsrequired>0</attachmentsrequired>
    <filetypeslist>*</filetypeslist>
    <graderinfo format=\"html\">
      <text></text>
    </graderinfo>
    <responsetemplate format=\"html\">
      <text></text>
    </responsetemplate>"
    

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