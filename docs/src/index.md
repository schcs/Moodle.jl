# Moodle.jl
*An experimental Julia package for creating Moodle questions.*

## Authors
- Lucas Calixto (lhcalixto.mat@gmail.com)
- [John MacQuarrie](https://johnmacquarrie.github.io) (john.macquarrie@googlemail.com)
- [Csaba Schneider](https://schcs.github.io/WP) (csaba.schneider@gmail.com)


## Package Features
Currently the package can be used to create the following types of questions:
- [short answer questions](short_answer.md);
- [matching question](matching);
- [multiple choice questions](multiple_choice.md);
- [cloze questions](cloze.md);
- [essay questions](essay.md);

## Installing the package
The package can be installed and activated by typing 
```repl
 import Pkg; Pkg.add( url="https://github.com/schcs/Moodle.jl.git" )
 using Moodle
```


## Creating a Moodle quiz

A simple moodle quiz can be created as follows. First we create two questions 

```repl
using LaTeXStrings
q1 = short_answer_question( "Question 1", L"What is the sum of $2$ and $-3$?", -1 );
q2 = multiple_choice_question( "Even numbers", "Which of the following numbers are even?", [(0,true),(-1,false),(2,true)])
```

Then we write the array of these two questions into an XML file as follows.

```repl
moodle_quiz_to_file( "Category A", [q1, q2], "questions.xml" )
```
The first argument is the name of the category that will be used in the Moodle system. The last line creates the file `questions.xml` that can be imported from the Moodle system.

Note that the question text for the first question is a `LaTeXString`; this type of string is supported throughout the package.