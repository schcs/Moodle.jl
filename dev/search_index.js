var documenterSearchIndex = {"docs":
[{"location":"essay/#Essay-questions","page":"Essay questions","title":"Essay questions","text":"","category":"section"},{"location":"essay/","page":"Essay questions","title":"Essay questions","text":"Moodle.essay_question","category":"page"},{"location":"essay/#Moodle.essay_question","page":"Essay questions","title":"Moodle.essay_question","text":"The data structure to hold an essay question.\n\nstruct essay_question\n\ntitle::String\nquestion_text::String\ntags::Vector{String}\n\nAt the moment an essay question can be created as follows. \n\nq = essay_question( \"Galois Theory.\", \"State and prove the Fundamental Theorem of Galois Theory\", tags = [\"Q1\" ] )\n\nNote that the optional arguments defgrade and penalty are not yet implemented for essay questions. Also there is no paramentric version and the functions write_latex and Base.show are not yet implemented for this type of questions.\n\n\n\n\n\n","category":"type"},{"location":"matching/#Matching-questions","page":"Matching questions","title":"Matching questions","text":"","category":"section"},{"location":"matching/","page":"Matching questions","title":"Matching questions","text":"Moodle.matching_question","category":"page"},{"location":"matching/#Moodle.matching_question","page":"Matching questions","title":"Moodle.matching_question","text":"The data structure to hold a matching question.\n\nstruct matching_question\n\ntitle::AbstractString\ntext::AbstractString\nsubquestions::Vector{Tuple}\ndefgrade::Int64\npenalty::Float64\nshuffle::Bool\ntags::Vector{String}\n\nThe standard way to create a matching question is the following. \n\nq = matching_question( \"Absolute value\", \"Combine each number with its absolute value.\", [(2,2),(-2,2),(0,0),(-1.5,1.5), (\"\",3),(\"\",-3)] )\n\nAs with the other types of questions, one can create a matching question with parameters. Consider the following example.\n\nq = matching_question( \"Additive inverse\", \"Match each number with its additive inverse modulo [[1]].\", (10,(3,4,5),(1,2,3)), (x,y) -> (-y) % x + x )\n\nThis line creates a question that is asking for matching the numbers 3, 4, 5 with their additive inverse modulo 10. The inverses are calculated by the function given as the fourth argument. The tuple (1,2,3) contains the list of answers that do not correspond to any of the listed options in the matching question. This last entry can be omitted and in this case each answer corresponds to an option in the first list. A check is performed to make sure that the dummy options do not in fact appear among the right answers. \n\nThis second form of the function is useful for creating lists of questions as was explaned in the documentation of short_answer_question and multiple_choice_question.\n\nBoth methods accept the optional arguments penalty, defgrade, shuffle and tags. For the meaning of penalty and defgrade, consult the documentation of Moodle. The argument tags is a list of strings that will appear as tags for the question once imported from Moodle. The argument shuffle is true or false and indicates whether the options need to appear in a random shuffle.\n\nThe second version also accepts the optional argument sep_left and/or sep_right that are strings marking the beginning and the end of the placeholders. The default values are \"[[\" and \"]]\", but these can be changed if the user needs these characters for other purposes. \n\n\n\n\n\n","category":"type"},{"location":"short_answer/#Short-answer-questions","page":"Short answer questions","title":"Short answer questions","text":"","category":"section"},{"location":"short_answer/","page":"Short answer questions","title":"Short answer questions","text":"Moodle.short_answer_question","category":"page"},{"location":"short_answer/#Moodle.short_answer_question","page":"Short answer questions","title":"Moodle.short_answer_question","text":"The data structure to hold a short answer type Moodle question. \n\nstruct short_answer_question\n\ntitle::AbstractString\ntext::AbstractString\nanswer::Union{Number, String}\npenalty::Float64\ntags::Vector{String}\ndefgrade::Int64\n\nOne can use two methods to create a short anwser question. For example:\n\nq1 = short_answer_question( \"Question 1\", L\"What is the sum of $2$ and $-3$?\", -1 );\n\nThis line creates a short answer question that asks for the sum of 2 and -3. Note that the question text is a LaTeXString.\n\nThe second way is to create questions with parameter. For example\n\nq2 = short_answer_question( \"Question 1\", L\"What is the remainder of $[[1]]$ modulo $[[2]]$?\", (15,10), (x,y) -> x % y )\n\nIn the second case, the first and second arguments are the question title and the question string. The third argument is the question parameter. The two entries of this argument are going to be substtuted in the placeholders \"[[1]]\" and \"[[2]]\" in the question text. The fourth parameter is a function that has the same number of inputs as the number of entries in the question parameter; the function computes the right answer.\n\nIn the case of this simple example, the question q2 is the same as the question created by the following line.\n\nq1 = short_answer_question( \"Question 1\", L\"What is the remainder of 15 modulo 10?\", 5 );\n\nHowever, using the parametrised version, one can more easily create a larger number of questions. \n\nparams = [ (a,b) for b in 10:20 for a in b+1:2*b ];\nqs = [ short_answer_question( \"Question 1\", L\"What is the remainder of $[[1]]$ modulo $[[2]]$?\", par, (x,y) -> x % y ) for par in params ];\n\nThese last two lines create 165 questions, one for each entry in the array params.\n\nBoth methods accept the optional arguments penalty, defgrade and tags. For the meaning of penalty and defgrade, consult the documentation of Moodle. The argument tags is a list of strings that will appear as tags for the question once imported from Moodle.\n\nThe second version also accepts the optional argument sep_left and/or sep_right that are strings marking the beginning and the end of the placeholders. The default values are \"[[\" and \"]]\", but these can be changed if the user needs these characters for other purposes. \n\n\n\n\n\n","category":"type"},{"location":"cloze/#Cloze-questions","page":"Cloze questions","title":"Cloze questions","text":"","category":"section"},{"location":"cloze/#Creating-cloze-subquestions","page":"Cloze questions","title":"Creating cloze subquestions","text":"","category":"section"},{"location":"cloze/","page":"Cloze questions","title":"Cloze questions","text":"Moodle.cloze_subquestion","category":"page"},{"location":"cloze/#Moodle.cloze_subquestion","page":"Cloze questions","title":"Moodle.cloze_subquestion","text":"The data structure to hold a cloze subquestion.\n\nstruct cloze_subquestion\n\ntype::String\ngrade::UInt64\nanswers::Vector{Union{Tuple{Union{AbstractString, Number}, Number}, Tuple{Union{AbstractString, Number}, Number, Number}}}\n\nThe possible values of type are \n\nMC: Multuple Choice;\nMCV: Multiple Choice Vertical; \nMCH: Multuple Choice Horizontal; \nSA: Short Answer; \nNM: Numerical; \nMCVS: Multichoice Vertical Radio Buttons\n\nThe following line creates a cloze_subquestion of type SA, grade 1 with correct answer 2.\n\ns1 = cloze_subquestion( \"SA\", 1, [(2,true)])\n\nThe following creates a multiple choice subquestion of grade 1 with correct answers 2, 4 and incorrect answers 3, 5.\n\ns2 = cloze_subquestion( \"MC\", 1, [(2,true),(4,true),(3,false),(5,false)])\n\n\n\n\n\n","category":"type"},{"location":"cloze/#Creating-a-cloze-question","page":"Cloze questions","title":"Creating a cloze question","text":"","category":"section"},{"location":"cloze/","page":"Cloze questions","title":"Cloze questions","text":"Moodle.cloze_question","category":"page"},{"location":"cloze/#Moodle.cloze_question","page":"Cloze questions","title":"Moodle.cloze_question","text":"The data structure to hold a cloze subquestion.\n\nstruct cloze_question\n\ntitle::String\ntext::AbstractString\nsubquestions::Vector{cloze_subquestion}\ndefgrade::Int64\npenalty::Float64\ntags::Vector{String}\n\nThe simplest way to create a cloze question is to create the subquestions first (see above) and then the question itself.\n\nq = cloze_question( \"Even numbers\", \"Mark the even numbers from the following list {{1}}. How many numbers did you mark? {{2}}\", [ s2, s1 ] )\n\nThe line above combines the two subquestions s1 and s2 into a single close type question. The two subquestions appear in the place of {{1}} and {{2}}.\n\nOne may supply the optional arguments defgrade, penalty (see the Moodle system documentation) and tags; the latter is an array of strings specifying the tags that appear with the question on Moodle.\n\n\n\n\n\n","category":"type"},{"location":"#Moodle.jl","page":"Moodle.jl","title":"Moodle.jl","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"An experimental Julia package for creating Moodle questions.","category":"page"},{"location":"#Authors","page":"Moodle.jl","title":"Authors","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"Lucas Calixto (lhcalixto.mat@gmail.com)\nJohn MacQuarrie (john.macquarrie@googlemail.com)\nCsaba Schneider (csaba.schneider@gmail.com)","category":"page"},{"location":"#Package-Features","page":"Moodle.jl","title":"Package Features","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"Currently the package can be used to create the following types of questions:","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"short answer questions;\nmultiple choice questions;\nmatching questions;\ncloze questions;\nessay questions.","category":"page"},{"location":"#Installing-the-package","page":"Moodle.jl","title":"Installing the package","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"The package can be installed and activated by typing ","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":" import Pkg; Pkg.add( url=\"https://github.com/schcs/Moodle.jl.git\" )\n using Moodle","category":"page"},{"location":"#Creating-a-Moodle-quiz","page":"Moodle.jl","title":"Creating a Moodle quiz","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"A simple moodle quiz can be created as follows. First we create two questions ","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"using LaTeXStrings\nq1 = short_answer_question( \"Question 1\", L\"What is the sum of $2$ and $-3$?\", -1 );\nq2 = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [(0,true),(-1,false),(2,true)])","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"(See the documentation of short_answer_question and multiple_choice_question for the specifics of these types.)","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"Then we write the array of these two questions into an XML file as follows.","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"moodle_quiz_to_file( \"Category A\", [q1, q2], \"questions.xml\" )","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"The first argument is the name of the category that will be used in the Moodle system. The last line creates the file questions.xml that can be imported from the Moodle system.","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"Note that the question text for the first question is a LaTeXString; this type of string is supported throughout the package.","category":"page"},{"location":"multiple_choice/#Multiple-choice-questions","page":"Multiple choice questions","title":"Multiple choice questions","text":"","category":"section"},{"location":"multiple_choice/","page":"Multiple choice questions","title":"Multiple choice questions","text":"Moodle.multiple_choice_question","category":"page"},{"location":"multiple_choice/#Moodle.multiple_choice_question","page":"Multiple choice questions","title":"Moodle.multiple_choice_question","text":"The data structure to hold a multiple choice type Moodle question\n\nstruct multiple_choice_question\n\ntitle::AbstractString\ntext::AbstractString\nanswers::Vector{Tuple}\npenalty::Float64\ntags::Vector{String}\ndefgrade::Int64\nsingle::Bool\nshuffle::Bool\nwrongmarkzero::Bool\n\nThere are several ways to create multiple choice questions. The following line creates a multiple choice question that asks the students to mark the even numbers among 0, -1, and 2.\n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [(0,true),(-1,false),(2,true)])\n\nThe same question can be created by specifying separately the list of right answers and the list of wrong answers as follows. \n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [0,2], [-1] )\n\nAlternatively, one might define this question by specifying the list of options and defining a boolean function that can be applied to these options and decides whether a certain option is right or wrong.\n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [0,2,-2], x -> x%2 == 0 )\n\nMultiple choice questions can also be defined by using parameters. Consider, for example, the following line.\n\nq = multiple_choice_question( \"Remainder\", L\"Mark the integers that give remainder $[[1]]$ modulo $[[2]]$.\", (2,4,(0,2,4,6,8,10)), (x,y,z) -> z % y == x )\n\nThis line creates a question asking which of the numbers 0, 2, 4, 6, 8, 10 give remainder 2 modulo 4. The first two arguments are the name of the question and the question text, respectively. The third argument is a tuple whose first two entries are substituted in the placeholders [[1]] and [[2]], while the third argument is itself a tuple containing the options that appear among the possible answers. The last argument is a boolean function with three arguments. This function is applied to the first two entries of the tuple and to each entry of the third entry to calculate which of the answers are correct.\n\nThis parametric form can be used to create a large number of questions that correspond to a list of parameters. Take, for instance, the following example.\n\nparams = [ (a,b,(b,b+1,b+2,b+3,b+4)) for b in 10:20 for a in 1:4 ]\nq = [ multiple_choice_question( \"Divisible numbers\", L\"Mark the integers that give remainder $[[1]]$ modulo $[[2]]$.\", par, (x,y,z) -> z % y == x ) for par in params ]\n\nIn each of these versions, the function multiple_choice_question has the following optional arguments:\n\npenalty: see the Moodle system for documentation;\ntags: array of strings specifying the tags that appear on Moodle after import;\ndefgrade: see the Moodle system for documentation;\nsingle: true or false; if true then there is only one correct answer and the options appear on Moodle with radio buttons;\nshuffle: true or false; controls if the answers should or should not be shuffled;\nwrongmarkzero: true or false; controls if marking an incorrect answer should result in the reduction of the mark recieved by the student. The default is true and the marks for the answers are calculated in such a way that the students receive zero marks if they click all the options, and also when they leave all the options unclicked. \n\nThe parametric version also accepts the optional argument sep_left and/or sep_right that are strings marking the beginning and the end of the placeholders. The default values are \"[[\" and \"]]\", but these can be changed if the user needs these characters for other purposes.\n\n\n\n\n\n","category":"type"}]
}