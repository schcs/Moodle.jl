# Moodle.jl
*An experimental Julia package for creating Moodle questions.*
## Package Features
Currently the package can be used to create the following types of questions:
- short answer type questions
- matching question

## Short answer type question
In the case of short answer type questions, Moodle displays a question and provides the students with a text box where they can put in their answers. The answer is compared to the stored correct answer and points will be given if they agree.

The standard way of creating a short answer type question is to call short_answer_question.
```@repl
include( "/home/csaba/Projects/Moodle.jl/main.jl" ) #hide
q1 = short_answer_question( "What is the GCD?", "What is the GCD of \\(5\\) and \\(7\\)?", 1, 0.1, [ "Q1", "T0"], 1 )
```

