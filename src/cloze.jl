# The implementation of cloze question type for Moodle

#= 

{1:SHORTANSWER:=Berlin} is the capital of Germany.
Match the following cities with the correct state:
* San Francisco: {1:MULTICHOICE:=California#OK~Arizona#Wrong}
* Tucson: {1:MULTICHOICE:California#Wrong~%100%Arizona#OK}
* Los Angeles: {1:MULTICHOICE:=California#OK~Arizona#Wrong}
* Phoenix: {1:MULTICHOICE:%0%California#Wrong~=Arizona#OK}
The capital of France is {1:SHORTANSWER:%100%Paris#Congratulations!
~%50%Marseille#No, that is the second largest city in France (after
Paris).~*#Wrong answer. The capital of France is Paris, of course.}.

Which animal eats mice? (answer: the cat)
Testing MULTICHOICE {1:MULTICHOICE:=the cat#Yes, that's right~the dog#Nope!}
Testing MULTICHOICE_H {1:MULTICHOICE_H:=the cat#Yes, that's right~the dog#Nope!}
Testing MULTICHOICE_V{1:MULTICHOICE:=the cat#Yes, that's right~the dog#Nope!}

Questions consist of a passage of text (in Moodle format) that has various sub-questions embedded within it, including

    short answers (SHORTANSWER or SA or MW), case is unimportant,
    short answers (SHORTANSWER_C or SAC or MWC), case must match,
    numerical answers (NUMERICAL or NM),
    multiple choice (MULTICHOICE or MC), represented as a dropdown menu in-line in the text,
    multiple choice (MULTICHOICE_V or MCV), represented as a vertical column of radio buttons, or
    multiple choice (MULTICHOICE_H or MCH), represented as a horizontal row of radio-buttons,
    multiple choice (MULTIRESPONSE or MR), represented as a vertical row of checkboxes
    multiple choice (MULTIRESPONSE_H or MRH), represented as a horizontal row of checkboxes


    Shuffle sub questions

    When the quiz question behavior shuffle option is set to YES, the following special multiple choice sub-questions elements will be shuffled:
    
        multiple choice (MULTICHOICE_S or MCS), represented as a dropdown menu in-line in the text,
        multiple choice (MULTICHOICE_VS or MCVS), represented as a vertical column of radio buttons, or
        multiple choice (MULTICHOICE_HS or MCHS), represented as a horizontal row of radio-buttons.
        multiple choice (MULTIRESPONSE_S or MRS), represented as a vertical row of checkboxes
        multiple choice (MULTIRESPONSE_HS or MRHS), represented as a horizontal row of checkboxes

=#

#=
Short answer and multiple choice types:

SHORT ANSWER:
The answer here is maths with math worth half points, not case-sensitive: {1:SA:=Maths~%50%math}
The answer here is Maths with Math worth half points, case-sensitive: {1:SAC:=Maths~%50%Math}

NUMERICAL SHORT ANSWER
The answer here is 23.8 with the answer x being accepted for 23.7 <= x <= 23.9, half marks are awarded for 21.8 <= x <= 24.8: {2:NM:=23.8:0.1~%50%23.8:2}

MULTIPLE CHOICE (RADIO)
Multiple choice questions can be arranged in three ways:
"MC" arranges {1:MC:=as~a~dropdown~list}
"MCH" arranges {1:MCH:=as~=a~horizontal~list}
"MCV" arranges {1:MCV:=as~=a~vertical~list}
In these questions both "as" and "a" are correct.

MULTIPLE CHOICE (Multi response)
We can also have multiple choice where you can click several options, in two ways.  In these questions every answer except "list" is correct
"MR" arranges {1:MR:=as~=a~=vertical~list}
"MRH" arranges {1:MRH:=as~=a~=horizontal~list}

SHUFFLING ANSWERS
MC, MCH, MCV, MR and MRH can have their options shuffled by appending "S" at the end, giving MCS, MCHS, MCVS, MRS and MRHS.  For instance 
MRHS arranges {1:MRHS:=as~=a~=horizontal~list}
=#

struct cloze_subquestion
    type::String
    grade::UInt64
    answers::Vector{Union{Tuple{Union{String,Number},Number},Tuple{Union{String,Number},Number,Number}}}
end 

struct cloze_question 
        title::String                       # the title of the question
        text::String                        # the text of the question
        subquestions::Vector{cloze_subquestion}  # the answers
        defgrade::Int64                     # defgrade
        penalty::Float64                    # required by Moodle, it's usually 0.1
        tags::Vector{String}                # list of tags
end 

#= {1:SHORTANSWER:%100%Paris#Congratulations!
~%50%Marseille#No, that is the second largest city in France (after
Paris).~*#Wrong answer. The capital of France is Paris, of course.}
=#

function cloze_question( title::AbstractString, text::AbstractString, subquestions::Vector{cloze_subquestion}; defgrade = 1, penalty = 1, tags = [] )

    for q in subquestions
        for i in 1:length( q.answers )
            if isa( q.answers[i][1], String )
                q.answers[i] = ( moodle_string( q.answers[i][1] ), q.answers[i][2] )
            end
        end
    end 

    return cloze_question( moodle_string( title ), moodle_string( text ), subquestions, defgrade, penalty, tags )
end

function cloze_subquestion_to_string( sq::cloze_subquestion )

    val( x ) = isa( x, Bool ) ? ( x ? 100 : 0 ) : x 

    str = "{$(sq.grade):$(sq.type):"
    for k in 1:length(sq.answers)
        ans1 = sq.answers[k][1]
        ans1 = replace( ans1, "{" => "&#123;" )
        ans1 = replace( ans1, "}" => "&#125;" )
        ans = ( ans1, sq.answers[k][2] )
        str *= "%$(val(ans[2]))%$(ans[1])$( sq.type == "NM" ? ":$(ans[3])" : "")~"
    end

    str = str[1:end-1]*"}"
    return str
end

function QuestionToXML( question::cloze_question )

    qtext = question.text
    
    i = 1
    while true
        ff = findfirst( "[[$i]]", qtext )
        if typeof( ff ) == Nothing    
            break
        end
        qtext = replace( qtext, "[[$i]]" => cloze_subquestion_to_string( question.subquestions[i] ))
        i += 1
    end

    xmltext = "<question type=\"cloze\">\n<name format=\"html\">\n"*
            "<text><![CDATA[$(question.title)]]></text>\n"*
            "</name>\n"*
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>$(qtext)</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>$(question.defgrade)</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>$(question.penalty)</penalty>\n"*
            "<hidden>0</hidden>\n"    

    if length( question.tags ) > 0  
        xmltext *= "<tags>\n"
        for tag in question.tags 
            xmltext *= "<tag>\n<text>"*tag*"</text>\n</tag>\n"
        end
        xmltext *= "</tags>\n"
    end

    xmltext *= "</question>\n"
    return xmltext
end 


# John's code
#
#=
# make short answer (non case-sensitive) string for CLOZE.  
#The input is a list of tuples like this: ("Answer", Mark).
# Mark can be: true (full marks), false (wrong) or an integer between 2 and 100 (gives that percentage of the full mark).
# so in practice true and 100 give the same result. 
function SACLOZEq(AnswerPairs)

    Astring = ""


    for x in AnswerPairs
        if x[2] == true 
            Astring = Astring*"="x[1]"~"
        elseif x[2] == false 
            Astring = Astring*x[1]*"~"
        elseif 1 < x[2] && x[2] <= 100
            Astring = Astring*"%"string(x[2])"%"x[1]"~"
        end
    end


    output = "{1:SA:"Astring"}"

    output = replace(output, "~}"=>"}")

    return output
end



# a radio-button (single choice) multiple choice question with drop-down list.  The input is a list of tuples like this: ("Answer", Mark).
# For now Mark can be: true (full marks), false (wrong) or an integer between 2 and 100 (gives that percentage of the full mark)
function MCCLOZEq(AnswerPairs)

    Astring = ""


    for x in AnswerPairs
        if x[2] == true 
            Astring = Astring*"="x[1]"~"
        elseif x[2] == false 
            Astring = Astring*x[1]*"~"
        elseif 1 < x[2] && x[2] <= 100
            Astring = Astring*"%"string(x[2])"%"x[1]"~"
        end
    end


    output = "{1:MC:"Astring"}"

    output = replace(output, "~}"=>"}")

    return output
end

=#