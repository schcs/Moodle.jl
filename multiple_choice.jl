# this file contains the functions related to 
# multiple choice questions

@doc """
The data structure to hold a multiple choice type Moodle question
""" ->

struct multiple_choice_question
    title::String                   # the title of the question
    text::String                    # the text of the question
    answers::Vector{Tuple}          # the right answers
    penalty::Float64                # required by Moodle, it's usually 0.1
    tags::Vector{String}            # list of tags
    defgrade::Int64                 # required by Moodle, usually 1
    single::Bool                    # true for radio button type question
    shuffle::Bool                   # true of questions are shuffled
    wrongmarkzero::Bool             # true of wrong mark gets zero point
end 

# the following function creates multiple_choice_question from the first 
# three attributes -- the others will take the default value

function multiple_choice_question( title, text, answers; 
                                    penalty = 0.1, 
                                    tags = [], 
                                    defgrade = 1, 
                                    single = false,
                                    shuffle = true,
                                    wrongmarkzero = false )
    
    return multiple_choice_question( title, text, answers, penalty, 
                                    tags, defgrade, single, shuffle, wrongmarkzero )
end 

# in the following function we can create multiple choice question specifying the 
# lists of right and wrong answers

function multiple_choice_question_by_lists( title, text, rightanswers, wronganswers;  
    penalty = 0.1, 
    tags = [], 
    defgrade = 1, 
    single = false,
    shuffle = true, 
    wrongmarkzero = true )

    answers = [ (x,true) for x in rightanswers ]
    append!( answers, [ (x,false) for x in wronganswers ])

return multiple_choice_question( title, text, answers, penalty, 
    tags, defgrade, single, shuffle, wrongmarkzero )
end 


function Base.show( io::IO, q::multiple_choice_question )  
        print(io, "Multiple choice question\n\tTitle: ", q.title, 
                "\n\tText: ", q.text[1:min(length(q.text),40)]*"...", 
                "\n\t", length( q.answers ), " options" )
end


function moodle_answer( answer, value )

    text = "<answer fraction=\""*string( value )*"\" format=\"html\">\n"* 
            "<text><![CDATA[<p>"*string( answer )*
            "</p>]]></text>\n</answer>\n"

    return text
end


function QuestionToXML( question::multiple_choice_question )
   
    xmltext = "<question type=\"multichoice\">\n<name format=\"html\">\n"*
            "<text><![CDATA["*question.title*"]]></text>\n"*
            "</name>\n"*
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"*question.text*"</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>"*string( question.defgrade )*"</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>"*string( question.penalty )*"</penalty>\n"*
            "<hidden>0</hidden>\n"*
            "<single>"*string( question.single )*"</single>\n"* 
            "<shuffleanswers>"*string( Int64( question.shuffle ))*
            "</shuffleanswers>\n"* 
            "<answernumbering>abc</answernumbering>\n"
    
    rightanswers = [ x[1] for x in question.answers if x[2]]
    wronganswers = [ x[1] for x in question.answers if !x[2]]
    
    wrongmarks = [ "-100", "-50", "-33.33333", "-25", "-20" ]
    rightmarks = [ "100", "50", "33.33333", "25", "20" ]
    rightmark = rightmarks[length( rightanswers )]
            
    if question.wrongmarkzero 
        wrongmark = 0;
    else
        wrongmark = wrongmarks[Length(wronganswers)];
    end
        

    for ans in question.answers 
        if ans[2]
            xmltext *= moodle_answer( ans[1], rightmark )
        else
            xmltext *= moodle_answer( ans[1], wrongmark )
        end
    end

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