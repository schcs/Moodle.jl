var documenterSearchIndex = {"docs":
[{"location":"index_old/#Moodle.jl","page":"Moodle.jl","title":"Moodle.jl","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"An experimental Julia package for creating Moodle questions.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"A simple change.","category":"page"},{"location":"index_old/#Package-Features","page":"Moodle.jl","title":"Package Features","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Currently the package can be used to create the following types of questions:","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"short answer type questions;\nmatching question;\nmultiple choice questions.","category":"page"},{"location":"index_old/#Installing-the-package","page":"Moodle.jl","title":"Installing the package","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Will write here how to install the package once it's written as a module.","category":"page"},{"location":"index_old/#Short-answer-type-question","page":"Moodle.jl","title":"Short answer type question","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The standard way of creating a short answer type question is to call short_answer_question.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) #hide\r\ntitle = \"What is the GCD?\";\r\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\r\nanswer = 2;\r\nq1 = short_answer_question( title, text, answer, 0.1, [ \"Q1\", \"T0\"], 1 )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The first input string is the tile of the question, the second is the text of the  question, while the third argument is the right answer. The next argument defines the  value of \"penalty\", then there is the list of tags (used in Moodle), while the final argument is the value of the default grade. [We should explain penalty and defgrade.]","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"One may omit the last three arguments supplying only the question title, the question  text and the right answer. In this form,  any combination of the remaining three arguments can  be given with the optional parameters penalty, defgrade, and tags. Consider the following example. ","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) #hide\r\ntitle = \"What is the GCD?\"; \r\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\r\nanswer = 2;\r\nq2 = short_answer_question( title, text, answer, tags = [ \"Q1\", \"T0\"] )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Another way of creating a short answer type question is using a list of mathematical objects and a Julia function that will compute the right answer.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) #hide\r\nimport LinearAlgebra\r\ntitle = \"Determinant\"; \r\ntext = \"What is the determinant of the product \\\\(AB\\\\) where \\\\(A=[[1]]\\\\) and \\\\(B=[[2]]\\\\)?\";\r\nA = [1 2; -1 2 ]; B = [1 -1; 0 2 ];\r\nfunc(x,y) = Integer( round( LinearAlgebra.det( x*y )))\r\nq3 = ShortAnswerQuestion( title, text, (A,B), func )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"In the last form, the first two arguments are the same as for short_answer_question, but the question text contains the markers [[1]], [[2]], etc, that show where the mathematical objects in the third argument should be placed in the question text. The third argument is a tuple of objects and func is a Julia function that can be applied to the objects in the third argument. The output given by the function on these arguments will be the correct answer for the question.","category":"page"},{"location":"index_old/#Multiple-choice-questions","page":"Moodle.jl","title":"Multiple choice questions","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"To be written.","category":"page"},{"location":"index_old/#Matching-questions","page":"Moodle.jl","title":"Matching questions","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"To be written.","category":"page"},{"location":"index_old/#Creating-a-questionnaire-and-writing-it-into-an-XML-file","page":"Moodle.jl","title":"Creating a questionnaire and writing it into an XML file","text":"","category":"section"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Once the questions are generated, a Moodle questionnaire can be created by the moodle_questionnaire function","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) \r\ntitle = \"What is the GCD?\";\r\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\r\nanswer = 2;\r\nq1 = short_answer_question( title, text, answer, 0.1, [ \"Q1\", \"T0\"], 1 )\r\ntitle = \"What is the GCD?\"; \r\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\r\nanswer = 2;\r\nq2 = short_answer_question( title, text, answer, tags = [ \"Q1\", \"T0\"] )\r\nimport LinearAlgebra\r\ntitle = \"Determinant\"; \r\ntext = \"What is the determinant of the product \\\\(AB\\\\) where \\\\(A=[[1]]\\\\) and \\\\(B=[[2]]\\\\)?\";\r\nA = [1 2; -1 2 ];B = [1 -1; 0 2 ];\r\nfunc(x,y) = LinearAlgebra.det( x*y )\r\nq3 = ShortAnswerQuestion( title, text, (A,B), func )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"category = \"MyQuestionnaire\"; \r\nq = moodle_questionnaire( category, [ q1, q2, q3 ])","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The first argument is a string defining the category of the questionnaire (as required by Moodle) while the second is the list of questions.","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"The questionnaire can be written to an XML file using the MoodleQuestionnaireToXML function. ","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"include( \"/home/csaba/Projects/Moodle.jl/main.jl\" ) \r\ntitle = \"What is the GCD?\";\r\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\r\nanswer = 2;\r\nq1 = short_answer_question( title, text, answer, 0.1, [ \"Q1\", \"T0\"], 1 )\r\ntitle = \"What is the GCD?\"; \r\ntext = \"What is the GCD of \\\\(5\\\\) and \\\\(7\\\\)?\";\r\nanswer = 2;\r\nq2 = short_answer_question( title, text, answer, tags = [ \"Q1\", \"T0\"] )\r\nimport LinearAlgebra\r\ntitle = \"Determinant\"; \r\ntext = \"What is the determinant of the product \\\\(AB\\\\) where \\\\(A=[[1]]\\\\) and \\\\(B=[[2]]\\\\)?\";\r\nA = [1 2; -1 2 ];B = [1 -1; 0 2 ];\r\nfunc(x,y) = Int(round(LinearAlgebra.det( x*y )))\r\nq3 = ShortAnswerQuestion( title, text, (A,B), func )\r\ncategory = \"MyQuestionnaire\"; \r\nq = moodle_questionnaire( category, [ q1, q2, q3 ])","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"MoodleQuestionnaireToXML( q, \"testfile.xml\" )","category":"page"},{"location":"index_old/","page":"Moodle.jl","title":"Moodle.jl","text":"Calling MoodleQuestionnaireToXML as above creates a file called testfile.xmlin the current directory and writes the questions into this file which, in turn, can be imported into Moodle.","category":"page"},{"location":"#Moodle.jl","page":"Home","title":"Moodle.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"An experimental Julia package for creating Moodle questions.","category":"page"},{"location":"","page":"Home","title":"Home","text":"A simple change.","category":"page"},{"location":"#Package-Features","page":"Home","title":"Package Features","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Currently the package can be used to create the following types of questions:","category":"page"},{"location":"","page":"Home","title":"Home","text":"short answer type questions;\nmatching question;\nmultiple choice questions.","category":"page"},{"location":"#Installing-the-package","page":"Home","title":"Installing the package","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Will write here how to install the package once it's written as a module.","category":"page"},{"location":"#Short-answer-type-question","page":"Home","title":"Short answer type question","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.","category":"page"},{"location":"#Matching-questions","page":"Home","title":"Matching questions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Generates a question that takes a list of statements or mathematical objects, and asks the student to match each object with an item from a list of numbers or statements (the list of items to be matched cannot contain LaTeX).","category":"page"},{"location":"","page":"Home","title":"Home","text":"The question is created by typing \"matching_question( title, text, subquestions)\", where","category":"page"},{"location":"","page":"Home","title":"Home","text":"\"title\" is the name of the question, it's a string\n\"text\" is the text of the question.  It must be a string and can contain LaTeX (though for the time being it has to be written in Moodle mode)\n\"subquestions\" is a list of two-element lists Xi, where the first element of each Xi is the object to presented, while the second element of Xi is the correct matching.  Both elements of Xi are strings.  The string S can be added to the list of options without necessarily corresponding to an object, by defining some X_i = [\"\", \"S\"].","category":"page"},{"location":"","page":"Home","title":"Home","text":"For example:","category":"page"},{"location":"","page":"Home","title":"Home","text":"include( (@__DIR__)*\"/../../src/main.jl\" ) #hide\r\nimport LinearAlgebra #hide\r\ntitle = \"Find Determinant\"; \r\ntext = \"Match each of the following matrices with its determinant\";\r\nsubquestions = [ \r\n[\"\\\\(\\\\begin{pmatrix} 1 & 2 \\\\\\\\ 0 & 2 \\\\end{pmatrix}\\\\)\", \"2\"], \r\n[\"\\\\(\\\\begin{pmatrix} 2 & 0 \\\\\\\\ 5 & 2 \\\\end{pmatrix}\\\\)\", \"4\"], \r\n[\"\\\\(\\\\begin{pmatrix} 2 & 0 \\\\\\\\ 0 & 1 \\\\end{pmatrix}\\\\)\", \"2\"], \r\n[\"\", 1], \r\n[\"\", 3] ]\r\nq = matching_question( title, text, subquestions )\r\nq","category":"page"},{"location":"","page":"Home","title":"Home","text":"Importing the output to the moodle using [SECTION DESCRIBING HOW TO DO THIS], the following question is produced:","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: question)","category":"page"}]
}
