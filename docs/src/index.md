# Moodle.jl
*An experimental Julia package for creating Moodle questions.*


## Package Features
Currently the package can be used to create the following types of questions:
- [short answer questions](short_answer.md);
- [matching question](matching);
- [multiple choice questions](multiple_choice.md);
- [cloze questions](cloze.md);
- [essay questions](essay.md);

## Installing the package
The package can be installed and activated by typing 
```@repl
 import Pkg; Pkg.add( url="https://github.com/schcs/Moodle.jl.git" )
 using Moodle
```


## Creating a Moodle quiz

