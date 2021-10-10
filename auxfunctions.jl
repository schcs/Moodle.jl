using LinearAlgebra



# IntZeroMat(m,n) gives an mxn integer 0 matrix
function IntZeroMat(m :: Int64, n :: Int64)
    return Int64[0 for j in 1:m, i in 1:n]
end


# RandomSquareMatrix(n , min, max) gives an nxn integer matrix with entries in the range [min, max] 
function RandomSquareMatrix( n::Int64, rangemin :: Int64, rangemax :: Int64 )
    A = IntZeroMat(n,n)

    for i in 1:n 
        for j in 1:n 
            A[i,j] = rand(rangemin : rangemax)
         end
    end
    return A
end

# Gives determinant of integer matrix by converting it to a rational matrix, using the det function, 
# and converting the answer back to an integer (just using det can give floating points!)
function IntDet( A :: Array{2,Integer})
    return Int(det(A//1))
end

# Given a tuple of things [X_1 , ... , X_n] and a function f taking X_i as an input, returns 
# [ [X_1 , f(X_1)] , .... , [X_n , f(X_n)] ].  "QAlist" is Question-Answer list
function QApairs( ListOfAnswers::Tuple , func )
    QAlist = [];
    for i in 1:length(ListOfAnswers)
        push!(QAlist , [ListOfAnswers[i], func(ListOfAnswers[i])])
    end

    return QAlist
end