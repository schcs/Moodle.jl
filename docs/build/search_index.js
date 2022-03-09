var documenterSearchIndex = {"docs":
[{"location":"index_old/#Moodle.jl","page":"Moodle.jl","title":"Moodle.jl","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"An experimental Julia package for creating Moodle questions.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"A simple change.","category":"page"},{"location":"index_old/#Package-Features","page":"Moodle.jl","title":"Package Features","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Currently the package can be used to create the following types of questions:","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"short answer type questions;\nmatching question;\nmultiple choice questions.","category":"page"},{"location":"index_old/#Installing-the-package","page":"Moodle.jl","title":"Installing the package","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Will write here how to install the package once it's written as a module.","category":"page"},{"location":"index_old/#Short-answer-type-question","page":"Moodle.jl","title":"Short answer type question","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The standard way of creating a short answer type question is to call short_answer_question.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) #hide\ntitle = \"What is the GCD?\";\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\nanswer = 2;\nq1 = short_answer_question( title, text, answer, 0.1, [ \"Q1\", \"T0\"], 1 )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The first input string is the tile of the question, the second is the text of the  question, while the third argument is the right answer. The next argument defines the  value of \"penalty\", then there is the list of tags (used in Moodle), while the final argument is the value of the default grade. [We should explain penalty and defgrade.]","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"One may omit the last three arguments supplying only the question title, the question  text and the right answer. In this form,  any combination of the remaining three arguments can  be given with the optional parameters penalty, defgrade, and tags. Consider the following example. ","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) #hide\ntitle = \"What is the GCD?\"; \ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\nanswer = 2;\nq2 = short_answer_question( title, text, answer, tags = [ \"Q1\", \"T0\"] )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Another way of creating a short answer type question is using a list of mathematical objects and a Julia function that will compute the right answer.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) #hide\nimport LinearAlgebra\ntitle = \"Determinant\"; \ntext = \"What is the determinant of the product \\\\(AB\\\\) where \\\\(A=[[1]]\\\\) and \\\\(B=[[2]]\\\\)?\";\nA = [1 2; -1 2 ]; B = [1 -1; 0 2 ];\nfunc(x,y) = Integer( round( LinearAlgebra.det( x*y )))\nq3 = ShortAnswerQuestion( title, text, (A,B), func )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"In the last form, the first two arguments are the same as for short_answer_question, but the question text contains the markers [[1]], [[2]], etc, that show where the mathematical objects in the third argument should be placed in the question text. The third argument is a tuple of objects and func is a Julia function that can be applied to the objects in the third argument. The output given by the function on these arguments will be the correct answer for the question.","category":"page"},{"location":"index_old/#Multiple-choice-questions","page":"Moodle.jl","title":"Multiple choice questions","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"To be written.","category":"page"},{"location":"index_old/#Matching-questions","page":"Moodle.jl","title":"Matching questions","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"To be written.","category":"page"},{"location":"index_old/#Creating-a-questionnaire-and-writing-it-into-an-XML-file","page":"Moodle.jl","title":"Creating a questionnaire and writing it into an XML file","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Once the questions are generated, a Moodle questionnaire can be created by the moodle_questionnaire function","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) \ntitle = \"What is the GCD?\";\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\nanswer = 2;\nq1 = short_answer_question( title, text, answer, 0.1, [ \"Q1\", \"T0\"], 1 )\ntitle = \"What is the GCD?\"; \ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\nanswer = 2;\nq2 = short_answer_question( title, text, answer, tags = [ \"Q1\", \"T0\"] )\nimport LinearAlgebra\ntitle = \"Determinant\"; \ntext = \"What is the determinant of the product \\\\(AB\\\\) where \\\\(A=[[1]]\\\\) and \\\\(B=[[2]]\\\\)?\";\nA = [1 2; -1 2 ];B = [1 -1; 0 2 ];\nfunc(x,y) = LinearAlgebra.det( x*y )\nq3 = ShortAnswerQuestion( title, text, (A,B), func )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"category = \"MyQuestionnaire\"; \nq = moodle_questionnaire( category, [ q1, q2, q3 ])","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The first argument is a string defining the category of the questionnaire (as required by Moodle) while the second is the list of questions.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The questionnaire can be written to an XML file using the MoodleQuestionnaireToXML function. ","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) \ntitle = \"What is the GCD?\";\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\nanswer = 2;\nq1 = short_answer_question( title, text, answer, 0.1, [ \"Q1\", \"T0\"], 1 )\ntitle = \"What is the GCD?\"; \ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\nanswer = 2;\nq2 = short_answer_question( title, text, answer, tags = [ \"Q1\", \"T0\"] )\nimport LinearAlgebra\ntitle = \"Determinant\"; \ntext = \"What is the determinant of the product \\\\(AB\\\\) where \\\\(A=[[1]]\\\\) and \\\\(B=[[2]]\\\\)?\";\nA = [1 2; -1 2 ];B = [1 -1; 0 2 ];\nfunc(x,y) = Int(round(LinearAlgebra.det( x*y )))\nq3 = ShortAnswerQuestion( title, text, (A,B), func )\ncategory = \"MyQuestionnaire\"; \nq = moodle_questionnaire( category, [ q1, q2, q3 ])","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"MoodleQuestionnaireToXML( q, \"testfile.xml\" )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Calling MoodleQuestionnaireToXML as above creates a file called testfile.xmlin the current directory and writes the questions into this file which, in turn, can be imported into Moodle.","category":"page"},{"location":"short_answer/#Short-answer-questions","page":"Short answer questions","title":"Short answer questions","text":"","category":"section"},{"location":"short_answer/","page":"Short answer questions","title":"Short answer questions","text":"Moodle.short_answer_question","category":"page"},{"location":"short_answer/#Main.Moodle.short_answer_question","page":"Short answer questions","title":"Main.Moodle.short_answer_question","text":"The data structure to hold a short answer type Moodle question. \n\nstruct short_answer_question\n\ntitle::AbstractString\ntext::AbstractString\nanswer::Union{Number, String}\npenalty::Float64\ntags::Vector{String}\ndefgrade::Int64\n\nOne can use two methods to create a short anwser question. For example:\n\nq1 = short_answer_question( \"Question 1\", L\"What is the sum of $2$ and $-3$?\", -1 );\n\nThis line creates a short answer question that asks for the sum of 2 and -3. Note that the question text is a LaTeXString.\n\nThe second way is to create questions with parameter. For example\n\nq2 = short_answer_question( \"Question 1\", L\"What is the remainder of $[[1]]$ modulo $[[2]]$?\", (15,10), (x,y) -> x % y )\n\nIn the second case, the first and second arguments are the question title and the question string. The third argument is the question parameter. The two entries of this argument are going to be substtuted in the placeholders \"[[1]]\" and \"[[2]]\" in the question text. The fourth parameter is a function that has the same number of inputs as the number of entries in the question parameter; the function computes the right answer.\n\nIn the case of this simple example, the question q2 is the same as the question created by the following line.\n\nq1 = short_answer_question( \"Question 1\", L\"What is the remainder of 15 modulo 10?\", 5 );\n\nHowever, using the parametrised version, one can more easily create a larger number of questions. \n\nparams = [ (a,b) for b in 10:20 for a in b+1:2*b ];\nqs = [ short_answer_question( \"Question 1\", L\"What is the remainder of $[[1]]$ modulo $[[2]]$?\", par, (x,y) -> x % y ) for par in params ];\n\nThese last two lines create 165 questions, one for each entry in the array params.\n\nBoth methods accept the optional arguments penalty, defgrade and tags. For the meaning of penalty and defgrade, consult the documentation of Moodle. The argument tags is a list of strings that will appear as tags for the question once imported from Moodle.\n\nThe second version also accepts the optional argument sepleft and/or sepright that are string marking the beginning and the end of the placeholders. The default values are \"[[\" and \"]]\", but these can be changed if the user needs these characters for other purposes. \n\n\n\n\n\n","category":"type"},{"location":"#Moodle.jl","page":"Home","title":"Moodle.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"An experimental Julia package for creating Moodle questions.","category":"page"},{"location":"#Package-Features","page":"Home","title":"Package Features","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Currently the package can be used to create the following types of questions:","category":"page"},{"location":"","page":"Home","title":"Home","text":"short answer questions;\nmatching question;\nmultiple choice questions;\ncloze questions;\nessey questions;\nmultiple choice questions.","category":"page"},{"location":"#Installing-the-package","page":"Home","title":"Installing the package","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Will write here how to install the package once it's written as a module.","category":"page"},{"location":"#Short-answer-type-question","page":"Home","title":"Short answer type question","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.","category":"page"},{"location":"#Matching-questions","page":"Home","title":"Matching questions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Generates a question that takes a list of statements or mathematical objects, and asks the student to match each object with an item from a list of numbers or statements (the list of items to be matched cannot contain LaTeX).","category":"page"},{"location":"","page":"Home","title":"Home","text":"The question is created by typing \"matching_question( title, text, subquestions)\", where","category":"page"},{"location":"","page":"Home","title":"Home","text":"\"title\" is the name of the question, it's a string\n\"text\" is the text of the question.  It must be a string and can contain LaTeX (though for the time being it has to be written in Moodle mode)\n\"subquestions\" is a list of two-element lists Xi, where the first element of each Xi is the object to presented, while the second element of Xi is the correct matching.  Both elements of Xi are strings.  The string S can be added to the list of options without necessarily corresponding to an object, by defining some X_i = [\"\", \"S\"].","category":"page"},{"location":"","page":"Home","title":"Home","text":"For example:","category":"page"},{"location":"","page":"Home","title":"Home","text":"include( (@__DIR__)*\"/../../src/main.jl\" ) #hide\nimport LinearAlgebra #hide\ntitle = \"Find Determinant\"; \ntext = \"Match each of the following matrices with its determinant\";\nsubquestions = [ \n[\"\\\\(\\\\begin{pmatrix} 1 & 2 \\\\\\\\ 0 & 2 \\\\end{pmatrix}\\\\)\", \"2\"], \n[\"\\\\(\\\\begin{pmatrix} 2 & 0 \\\\\\\\ 5 & 2 \\\\end{pmatrix}\\\\)\", \"4\"], \n[\"\\\\(\\\\begin{pmatrix} 2 & 0 \\\\\\\\ 0 & 1 \\\\end{pmatrix}\\\\)\", \"2\"], \n[\"\", 1], \n[\"\", 3] ]\nq = matching_question( title, text, subquestions )\nq","category":"page"},{"location":"","page":"Home","title":"Home","text":"Importing the output to the moodle using [SECTION DESCRIBING HOW TO DO THIS], the following question is produced:","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: question)","category":"page"},{"location":"multiple_choice/#Multiple-choice-questions","page":"Multiple choice questions","title":"Multiple choice questions","text":"","category":"section"},{"location":"multiple_choice/","page":"Multiple choice questions","title":"Multiple choice questions","text":"Moodle.multiple_choice_question","category":"page"},{"location":"multiple_choice/#Main.Moodle.multiple_choice_question","page":"Multiple choice questions","title":"Main.Moodle.multiple_choice_question","text":"The data structure to hold a multiple choice type Moodle question\n\nstruct multiple_choice_question\n\ntitle::AbstractString\ntext::AbstractString\nanswers::Vector{Tuple}\npenalty::Float64\ntags::Vector{String}\ndefgrade::Int64\nsingle::Bool\nshuffle::Bool\nwrongmarkzero::Bool\n\nThere are several ways to create multiple choice questions. The following line creates a multiple choice question that asks the students to mark the even numbers among 0, -1, and 2.\n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [(0,true),(-1,false),(2,true)])\n\nThe same question can be created by specifying separately the list of right answers and the list of wrong answers as follows. \n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [0,2], [-1] )\n\nAlternatively, one might define this question by specifying the list of options and defining a boolean function that can be applied to these options and decides whether a certain option is right or wrong.\n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [0,2,-2], x -> x%2 == 0 )\n\nMultiple choice questions can also be defined by using parameters. Consider, for example, the following line.\n\nq = multiple_choice_question( \"Remainder\", \"Mark the integers that give remainder $[[1]]$ modulo $[[2]]$.\", (2,4,(0,2,4,6,8,10)), (x,y,z) -> z % y == x )\n\nThis line creates a question asking which of the numbers 0, 2, 4, 6, 8, 10 give remainder 2 modulo 4. The first two arguments are the name of the question and the question text, respectively. The third argument is a tuple whose first two entries are substituted in the placeholders [[1]] and [[2]], while the third argument is itself a tuple containing the options that appear among the possible answers. The last argument is a boolean function with three arguments. This function is applied to the first two entries of the tuple and to each entry of the third entry to calculate which of the answers are correct.\n\nThis parametric form can be used to create a large number of questions that correspond to a list of parameters. Take, for instance, the following example.\n\nparams = [ (a,b,(b,b+1,b+2,b+3,b+4)) for b in 10:20 for a in 1:4 ]\nq = [ multiple_choice_question( \"Divisible numbers\", \"Mark the integers that give remainder $[[1]]$ modulo $[[2]]$.\", par, (x,y,z) -> z % y == x ) for par in params ]\n\nIn each of these versions, the function multiplechoicequestion has the following optional arguments:\n\npenalty: see the Moodle system for documentation;\ntags: array of strings specifying the tags that appear on Moodle after import;\ndefgrade: see the Moodle system for documentation;\nsingle: true or false; if true then there is only one correct answer and the options appear on Moodle with radio buttons;\nshuffle: true or false; controls if the answers should or should not be shuffled;\nwrongmarkzero: true or false; controls if marking an incorrect answer should result in the reduction of the mark recieved by the student. The default is true and the marks for the answers are calculated in such a way that the students receive zero marks if they click all the options, and also when they leave all the options unclicked. \n\n\n\n\n\n","category":"type"}]
}
