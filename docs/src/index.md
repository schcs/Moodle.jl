# Moodle.jl
*An experimental Julia package for creating Moodle questions.*


## Package Features
Currently the package can be used to create the following types of questions:
- [short answer questions](short_answer.md);
- matching question;
- [multiple choice questions](multiple_choice.md);
- cloze questions;
- essey questions;
- multiple choice questions.
- etc

## Installing the package
Will write here how to install the package once it's written as a module.

## Short answer type question
In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.

## Matching questions

Generates a question that takes a list of statements or mathematical objects, and asks the student to match each object with an item from a list of numbers or statements (the list of items to be matched cannot contain LaTeX).

The question is created by typing "matching_question( title, text, subquestions)", where
- "title" is the name of the question, it's a string
- "text" is the text of the question.  It must be a string and can contain LaTeX (though for the time being it has to be written in Moodle mode)
- "subquestions" is a list of two-element lists X_i, where the first element of each X_i is the object to presented, while the second element of X_i is the correct matching.  Both elements of X_i are strings.  The string S can be added to the list of options without necessarily corresponding to an object, by defining some X_i = ["", "S"].

For example:
```@repl
include( (@__DIR__)*"/../../src/main.jl" ) #hide
import LinearAlgebra #hide
title = "Find Determinant"; 
text = "Match each of the following matrices with its determinant";
subquestions = [ 
["\\(\\begin{pmatrix} 1 & 2 \\\\ 0 & 2 \\end{pmatrix}\\)", "2"], 
["\\(\\begin{pmatrix} 2 & 0 \\\\ 5 & 2 \\end{pmatrix}\\)", "4"], 
["\\(\\begin{pmatrix} 2 & 0 \\\\ 0 & 1 \\end{pmatrix}\\)", "2"], 
["", 1], 
["", 3] ]
q = matching_question( title, text, subquestions )
q
```
Importing the output to the moodle using [SECTION DESCRIBING HOW TO DO THIS], the following question is produced:

![question](../img/MatchingExample.jpeg)