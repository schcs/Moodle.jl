#struct CLOZE_question
#    title :: String
#    test :: String 
#    subquestions :: String 
#end

#CLOZEsubQ = Dict(
#
#)



# make short answer (non case-sensitive) string for CLOZE.  
#The input is a list of tuples like this: ("Answer", Mark).
# Mark can be: true (full marks), false (wrong) or an integer between 2 and 100 (gives that percentage of the full mark).
# so in practice true and 100 give the same result. 
function SACLOZEq(AnswerPairs)

    Astring = ""


    for x in AnswerPairs
        if x[2] == true 
            Astring = Astring*"="*x[1]*"~"
        elseif x[2] == false 
            Astring = Astring*x[1]*"~"
        elseif 1 < x[2] && x[2] <= 100
            Astring = Astring*"%"*string(x[2])*"%"*x[1]*"~"
        end
    end


    output = "{1:SA:"*Astring*"}"

    output = replace(output, "~}"=>"}")

    return output
end



# a radio-button (single choice) multiple choice question with drop-down list.  The input is a list of tuples like this: ("Answer", Mark).
# For now Mark can be: true (full marks), false (wrong) or an integer between 2 and 100 (gives that percentage of the full mark)
function MCCLOZEq(AnswerPairs)

    Astring = ""


    for x in AnswerPairs
        if x[2] == true 
            Astring = Astring*"="*x[1]*"~"
        elseif x[2] == false 
            Astring = Astring*x[1]*"~"
        elseif 1 < x[2] && x[2] <= 100
            Astring = Astring*"%"*string(x[2])*"%"*x[1]*"~"
        end
    end


    output = "{1:MC:"*Astring*"}"

    output = replace(output, "~}"=>"}")

    return output
end






