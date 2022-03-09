# this file contains the functions related to questions
# of type shortanswer

@doc """
The data structure to hold a short answer type Moodle question. 

$(TYPEDEF)
$(TYPEDFIELDS)

One can use two methods to create a short anwser question. For example:

```@repl
q1 = short_answer_question( "Question 1", L"What is the sum of \$2\$ and \$-3\$?", -1 );
```
This line creates a short answer question that asks for the sum of 2 and -3. Note that the question text is a LaTeXString.

The second way is to create questions with parameter. For example

```@repl
q2 = short_answer_question( "Question 1", L"What is the remainder of \$[[1]]\$ modulo \$[[2]]\$?", (15,10), (x,y) -> x % y )
```

In the second case, the first and second arguments are the question title and the question string. The third argument is the question parameter. The two entries of this argument are going to be substtuted in the placeholders "[[1]]" and "[[2]]" in the question text. The fourth parameter is a function that has the same number of inputs as the number of entries in the question parameter; the function computes the right answer.

In the case of this simple example, the question q2 is the same as the question created by the following line.

```@repl
q1 = short_answer_question( "Question 1", L"What is the remainder of 15 modulo 10?", 5 );
```

However, using the parametrised version, one can more easily create a larger number of questions. 

```@repl
params = [ (a,b) for b in 10:20 for a in b+1:2*b ];
qs = [ short_answer_question( "Question 1", L"What is the remainder of \$[[1]]\$ modulo \$[[2]]\$?", par, (x,y) -> x % y ) for par in params ];
```

These last two lines create 165 questions, one for each entry in the array params.

Both methods accept the optional arguments penalty, defgrade and tags. For the meaning of penalty and defgrade, consult the documentation of Moodle. The argument tags is a list of strings that will appear as tags for the question once imported from Moodle.

The second version also accepts the optional argument `sep_left` and/or `sep_right` that are strings marking the beginning and the end of the placeholders. The default values are "[[" and "]]", but these can be changed if the user needs these characters for other purposes. 
""" ->
 
struct short_answer_question
    title::AbstractString                   # the title of the question
    text::AbstractString                    # the text of the question
    answer::Union{String,Number}            # the right answer
    penalty::Float64                        # required by Moodle, it's usually 0.1
    tags::Vector{String}                    # list of tags
    defgrade::Int64                         # required by Moodle, usually 1
end 


@doc """
Version 1:

$(SIGNATURES)
""" ->

function short_answer_question( title::AbstractString, text::AbstractString, answer::Union{String,Number}; 
                        penalty = 0.1, tags = [], defgrade = 1 )

    return short_answer_question( title, text, answer, penalty, tags, defgrade )
end 

@doc """
Version 2:

$(SIGNATURES)
""" ->

function short_answer_question( title::String, text::AbstractString, 
    param::Tuple, func; 
    sep_left = "[[", sep_right = "]]", 
    penalty = 0.1, tags = [], defgrade = 1 )::short_answer_question

text = substitute_latex_string( text, param, sep_left = sep_left, sep_right = sep_right )
return short_answer_question( title, text, func(param...), 
                tags = tags, penalty = penalty, defgrade = defgrade  ) 
end 

# prints a short answer question on the terminal

function Base.show( io::IO, q::short_answer_question )  
        print( "Short answer question\n\tTitle: ", q.title, 
                "\n\tText: ", q.text[1:min(length(q.text),20)]*"...", 
                "\n\tAnswer: ", q.answer  )
end

function Base.display( q::short_answer_question )  
    print( LaTeXString( write_latex( q )))
end


@doc """
Writes a Moodle question into a LaTeX string.

$(SIGNATURES)
""" ->

function write_latex( q::short_answer_question )   
    return L"{\bf Title:} %$(q.title)\\\smallskip\\{\bf Type:} Short Answer\\\smallskip\\{\bf Text:} %$(q.text)\\\smallskip\\{\bf Answer: }%$(q.answer)"
end

@doc """
Shows a question or a list of questions as a pdf document. Requires external LaTeX engines for proper functioning.

$(SIGNATURES)
""" ->

show_pdf( q::short_answer_question ) = render( write_latex( q ), MIME( "application/pdf" ))

@doc """ 
    Writes a Moodle question into an XML string.

$(SIGNATURES)
""" ->

function question_to_xml( question::short_answer_question )
   
    xmlstring = "<question type=\"shortanswer\">\n<name format=\"html\">\n"*
            "<text><![CDATA["*moodle_string( question.title )*"]]></text>\n"*
            "</name>\n"*
            "<questiontext format=\"html\">\n"*
            "<text><![CDATA[<p>"*moodle_string( question.text )*"</p>]]></text>\n"*
            "</questiontext>\n"*
            "<defaultgrade>"*string( question.defgrade )*"</defaultgrade>\n"* 
            "<generalfeedback format=\"html\"><text/></generalfeedback>\n"*
            "<penalty>"*string( question.penalty )*"</penalty>\n"*
            "<hidden>0</hidden>\n"*
            "<usecase>0</usecase>\n"* 
            "<answer fraction=\"100\" format=\"plain_text\"><text>"*
            string( question.answer )*"</text>\n</answer>\n"

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
 