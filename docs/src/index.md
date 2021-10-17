# Moodle.jl
*An experimental Julia package for creating Moodle questions.*

## Package Features
Currently the package can be used to create the following types of questions:
- short answer type questions
- matching question

## Installing the package
Will write here how to install the package once it's written as a module.

## Short answer type question
In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.

The standard way of creating a short answer type question is to call `short_answer_question`.
```@repl
include( "/home/csaba/Projects/Moodle.jl/main.jl" ) #hide
title = "What is the GCD?";
text = "What is the GCD of \\(5\\) and \\(7\\)?";
answer = 2;
q1 = short_answer_question( title, text, answer, 0.1, [ "Q1", "T0"], 1 )
```
The first input string is the tile of the question, the second is the text of the  question, while the third argument is the right answer. The next argument defines the  value of "penalty", then there is the list of tags (used in Moodle), while the final argument is the value of the default grade. [We should explain penalty and defgrade.]

One may omit the last three arguments supplying only the question title, the question 
text and the right answer. In this form, 
any combination of the remaining three arguments can 
be given with the optional parameters `penalty`, `defgrade`, and `tags`. Consider the following example. 

```@repl
include( "/home/csaba/Projects/Moodle.jl/main.jl" ) #hide
title = "What is the GCD?"; 
text = "What is the GCD of \\(5\\) and \\(7\\)?";
answer = 2;
q2 = short_answer_question( title, text, answer, tags = [ "Q1", "T0"] )
```

Another way of creating a short answer type question is using a list of mathematical objects and a Julia function that will compute the right answer.

```@repl
include( "/home/csaba/Projects/Moodle.jl/main.jl" ) #hide
import LinearAlgebra
title = "Determinant"; 
text = "What is the determinant of the product \\(AB\\) where \\(A=[[1]]\\) and \\(B=[[2]]\\)?";
A = [1 2; -1 2 ];
B = [1 -1; 0 2 ];
func(x,y) = LinearAlgebra.det( x*y )
q3 = ShortAnswerQuestion( title, text, (A,B), func )
```

In the last form, the first two arguments are the same as for `short_answer_question`, but the question text contains the markers `[[1]]`, `[[2]]`, etc, that show where the mathematical objects in the third argument should be places in the question text. The third argument is a tuple of objects and `func` is a Julia function that can be applied to the objects in the third argument. The given by the function on these arguments will be the correct answer for the question.

## Multiple choice questions

## Creating a questionnaire and writing it into an XML file

Once the questions are generated, a Moodle questionnaire can be created by the `moodle_questionnaire` function
```@repl
include( "/home/csaba/Projects/Moodle.jl/main.jl" ) #hide
category = "MyQuestionnaire"; 
q = moodle_questionnaire( category, [ q1, q2, q3 ])
```

The first argument is a string defining the category of the questionnaire (as required by Moodle) while the second is the list of questions.

The questionnaire can be written to an XML file using the MoodleQuestionnaireToXML function. 
```@repl
include( "/home/csaba/Projects/Moodle.jl/main.jl" ) #hide
MoodleQuestionnaireToXML( q, "testfile.xml" )
```
Calling `MoodleQuestionnaireToXML` as above creates a file called `testfile.xml`in the current directory and write the questions into this file which, in turn, can be imported into Moodle.
