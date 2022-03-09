var documenterSearchIndex = {"docs":
[{"location":"short_answer/#Short-answer-questions","page":"Short answer questions","title":"Short answer questions","text":"","category":"section"},{"location":"short_answer/","page":"Short answer questions","title":"Short answer questions","text":"Moodle.short_answer_question","category":"page"},{"location":"short_answer/#Moodle.short_answer_question","page":"Short answer questions","title":"Moodle.short_answer_question","text":"The data structure to hold a short answer type Moodle question. \n\nstruct short_answer_question\n\ntitle::AbstractString\ntext::AbstractString\nanswer::Union{Number, String}\npenalty::Float64\ntags::Vector{String}\ndefgrade::Int64\n\nOne can use two methods to create a short anwser question. For example:\n\nq1 = short_answer_question( \"Question 1\", L\"What is the sum of $2$ and $-3$?\", -1 );\n\nThis line creates a short answer question that asks for the sum of 2 and -3. Note that the question text is a LaTeXString.\n\nThe second way is to create questions with parameter. For example\n\nq2 = short_answer_question( \"Question 1\", L\"What is the remainder of $[[1]]$ modulo $[[2]]$?\", (15,10), (x,y) -> x % y )\n\nIn the second case, the first and second arguments are the question title and the question string. The third argument is the question parameter. The two entries of this argument are going to be substtuted in the placeholders \"[[1]]\" and \"[[2]]\" in the question text. The fourth parameter is a function that has the same number of inputs as the number of entries in the question parameter; the function computes the right answer.\n\nIn the case of this simple example, the question q2 is the same as the question created by the following line.\n\nq1 = short_answer_question( \"Question 1\", L\"What is the remainder of 15 modulo 10?\", 5 );\n\nHowever, using the parametrised version, one can more easily create a larger number of questions. \n\nparams = [ (a,b) for b in 10:20 for a in b+1:2*b ];\nqs = [ short_answer_question( \"Question 1\", L\"What is the remainder of $[[1]]$ modulo $[[2]]$?\", par, (x,y) -> x % y ) for par in params ];\n\nThese last two lines create 165 questions, one for each entry in the array params.\n\nBoth methods accept the optional arguments penalty, defgrade and tags. For the meaning of penalty and defgrade, consult the documentation of Moodle. The argument tags is a list of strings that will appear as tags for the question once imported from Moodle.\n\nThe second version also accepts the optional argument sep_left and/or sep_right that are strings marking the beginning and the end of the placeholders. The default values are \"[[\" and \"]]\", but these can be changed if the user needs these characters for other purposes. \n\n\n\n\n\n","category":"type"},{"location":"#Moodle.jl","page":"Moodle.jl","title":"Moodle.jl","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"An experimental Julia package for creating Moodle questions.","category":"page"},{"location":"#Package-Features","page":"Moodle.jl","title":"Package Features","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"Currently the package can be used to create the following types of questions:","category":"page"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"short answer questions;\nmatching question;\nmultiple choice questions;\ncloze questions;\nessey questions;","category":"page"},{"location":"#Installing-the-package","page":"Moodle.jl","title":"Installing the package","text":"","category":"section"},{"location":"","page":"Moodle.jl","title":"Moodle.jl","text":"Will write here how to install the package once it's written as a module.","category":"page"},{"location":"#Creating-a-Moodle-quiz","page":"Moodle.jl","title":"Creating a Moodle quiz","text":"","category":"section"},{"location":"multiple_choice/#Multiple-choice-questions","page":"Multiple choice questions","title":"Multiple choice questions","text":"","category":"section"},{"location":"multiple_choice/","page":"Multiple choice questions","title":"Multiple choice questions","text":"Moodle.multiple_choice_question","category":"page"},{"location":"multiple_choice/#Moodle.multiple_choice_question","page":"Multiple choice questions","title":"Moodle.multiple_choice_question","text":"The data structure to hold a multiple choice type Moodle question\n\nstruct multiple_choice_question\n\ntitle::AbstractString\ntext::AbstractString\nanswers::Vector{Tuple}\npenalty::Float64\ntags::Vector{String}\ndefgrade::Int64\nsingle::Bool\nshuffle::Bool\nwrongmarkzero::Bool\n\nThere are several ways to create multiple choice questions. The following line creates a multiple choice question that asks the students to mark the even numbers among 0, -1, and 2.\n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [(0,true),(-1,false),(2,true)])\n\nThe same question can be created by specifying separately the list of right answers and the list of wrong answers as follows. \n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [0,2], [-1] )\n\nAlternatively, one might define this question by specifying the list of options and defining a boolean function that can be applied to these options and decides whether a certain option is right or wrong.\n\nq = multiple_choice_question( \"Even numbers\", \"Which of the following numbers are even?\", [0,2,-2], x -> x%2 == 0 )\n\nMultiple choice questions can also be defined by using parameters. Consider, for example, the following line.\n\nq = multiple_choice_question( \"Remainder\", \"Mark the integers that give remainder $[[1]]$ modulo $[[2]]$.\", (2,4,(0,2,4,6,8,10)), (x,y,z) -> z % y == x )\n\nThis line creates a question asking which of the numbers 0, 2, 4, 6, 8, 10 give remainder 2 modulo 4. The first two arguments are the name of the question and the question text, respectively. The third argument is a tuple whose first two entries are substituted in the placeholders [[1]] and [[2]], while the third argument is itself a tuple containing the options that appear among the possible answers. The last argument is a boolean function with three arguments. This function is applied to the first two entries of the tuple and to each entry of the third entry to calculate which of the answers are correct.\n\nThis parametric form can be used to create a large number of questions that correspond to a list of parameters. Take, for instance, the following example.\n\nparams = [ (a,b,(b,b+1,b+2,b+3,b+4)) for b in 10:20 for a in 1:4 ]\nq = [ multiple_choice_question( \"Divisible numbers\", \"Mark the integers that give remainder $[[1]]$ modulo $[[2]]$.\", par, (x,y,z) -> z % y == x ) for par in params ]\n\nIn each of these versions, the function multiplechoicequestion has the following optional arguments:\n\npenalty: see the Moodle system for documentation;\ntags: array of strings specifying the tags that appear on Moodle after import;\ndefgrade: see the Moodle system for documentation;\nsingle: true or false; if true then there is only one correct answer and the options appear on Moodle with radio buttons;\nshuffle: true or false; controls if the answers should or should not be shuffled;\nwrongmarkzero: true or false; controls if marking an incorrect answer should result in the reduction of the mark recieved by the student. The default is true and the marks for the answers are calculated in such a way that the students receive zero marks if they click all the options, and also when they leave all the options unclicked. \n\nThe parametric version also accepts the optional argument sep_left and/or sep_right that are strings marking the beginning and the end of the placeholders. The default values are \"[[\" and \"]]\", but these can be changed if the user needs these characters for other purposes.\n\n\n\n\n\n","category":"type"}]
}
