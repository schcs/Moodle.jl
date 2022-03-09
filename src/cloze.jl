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

@doc """
The data structure to hold a cloze subquestion.

$(TYPEDEF)
$(TYPEDFIELDS)

The possible values of type are 
- MC: Multuple Choice;
- MCV: Multiple Choice Vertical; 
- MCH: Multuple Choice Horizontal; 
- SA: Short Answer; 
- NM: Numerical; 
- MCVS: Multichoice Vertical Radio Buttons

The following line creates a cloze_subquestion of type SA, grade 1 with correct answer 2.

```@repl
s1 = cloze_subquestion( "SA", 1, [(2,true)])
```

The following creates a multiple choice subquestion of grade 1 with correct answers 2, 4 and incorrect answers 3, 5.

```@repl
s2 = cloze_subquestion( "MC", 1, [(2,true),(4,true),(3,false),(5,false)])
```
""" ->

struct cloze_subquestion
    type::String
    grade::UInt64
    answers::Vector{Union{Tuple{Union{AbstractString,Number},Number},Tuple{Union{AbstractString,Number},Number,Number}}}
end 

@doc """
The data structure to hold a cloze subquestion.

$(TYPEDEF)
$(TYPEDFIELDS)

The simplest way to create a cloze question is to create the subquestions first (see above) and then the question itself.

```@repl 
q = cloze_question( "Even numbers", "Mark the even numbers from the following list {{1}}. How many numbers did you mark? {{2}}", [ s2, s1 ] )
```

The line above combines the two subquestions `s1` and `s2` into a single close type question.

One may supply the optional arguments `defgrade`, `penalty` (see the Moodle system documentation) and `tags`; the latter is an array of strings specifying the tags that appear with the question on Moodle.
""" ->

struct cloze_question 
        title::String                       # the title of the question
        text::AbstractString                        # the text of the question
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
            if isa( q.answers[i][1], AbstractString )
                q.answers[i] = ( q.answers[i][1], q.answers[i][2] )
            end
        end
    end 

    return cloze_question( title, text, subquestions, defgrade, penalty, tags )
end

# experimental parametric version

function cloze_question( title::AbstractString, text::AbstractString, 
            subquestions::Vector, params; 
            defgrade = 1, penalty = 1, tags = [], sep_left = "[[", sep_right = "]]" )
    
    text = substitute_latex_string( text, params, sep_left = sep_left, sep_right = sep_right )
    subquestions = [ Tuple( k == 1 ? substitute_latex_string( q[k], tuple ) : q[k] 
                    for k in 1:length( q )) for q in subquestions ]

    return cloze_question( title, text, subquestions, 
                defgrade == defgrade, penalty == penalty, tags = tags ) 
end 

function cloze_subquestion_to_string( sq::cloze_subquestion )

    val( x ) = x isa Bool ? ( x ? 100 : 0 ) : x 

    str = "{$(sq.grade):$(sq.type):"
    for k in 1:length(sq.answers)
        ans1 = sq.answers[k][1]
        if ans1 isa AbstractString
            ans1 = moodle_string( ans1 )
            ans1 = replace( ans1, "{" => "&#123;" )
            ans1 = replace( ans1, "}" => "&#125;" )
        end
        ans = ( ans1, sq.answers[k][2] )
        str *= "%$(val(ans[2]))%$(ans[1])$( sq.type == "NM" ? ":$(ans[3])" : "")~"
    end

    str = str[1:end-1]*"}"
    return str
end

function write_latex( sq::cloze_subquestion )
    
    types = Dict( "MC" => "Multuple Choice", "MCV" => "Multiple Choice Vertical", 
                "MCH" => "Multuple Choice Horizontal", "SA" => "Short Answer", 
                "NM" => "Numerical", "MCVS" => "Multichoice Vertical Radio Buttons" )

    str = "\\\\\\smallskip\\\\{\\bf Subquestion type:} $(types[sq.type])\\\\\\smallskip\\\\"
    for ans in sq.answers
        str *= prod( string( u )*"\\hskip 1cm " for u in ans )*"\\\\\\smallskip\\\\"
    end
    return LaTeXString( str ) 
end 

function write_latex( q::cloze_question )

    subquestions = write_latex.( q.subquestions )  
    str = L"{\bf Title:} %$(q.title)\\\smallskip\\{\bf Type:} Cloze\\\smallskip\\{\bf Text:} %$(q.text)"
    for i in 1:length( q.subquestions )
        str = replace( str, "{{$i}}" => subquestions[i] )
    end 
    return LaTeXString( str ) 
end 
    
show_pdf( q::cloze_question ) = render( write_latex( q ), MIME( "application/pdf" ))

function question_to_xml( question::cloze_question )

    qtext = moodle_string( question.text )
    
    i = 1
    while true
        ff = findfirst( "{{$i}}", qtext )
        if typeof( ff ) == Nothing    
            break
        end
        qtext = replace( qtext, "{{$i}}" => cloze_subquestion_to_string( question.subquestions[i]))
        i += 1
    end

    xmltext = "<question type=\"cloze\">\n<name format=\"html\">\n"*
            "<text><![CDATA[$(moodle_string( question.title ))]]></text>\n"*
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