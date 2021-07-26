
# regression matrix for a model with two variables
a <- matrix(data=c(0.5,0.1,0.1,0.5), nrow=2)

# some normally distributed error
# a model with two variables
u <- matrix(data=rnorm(10000)
        ,ncol=2)

rSim <- function(coeff, errors) {
    # generate empty matrix
    simdata <- matrix(data=0, nrow(errors), ncol(errors))

    for (row in 2:nrow(errors))
    {
        # multiply the coefficient with the previous row of values
        # (this is an autoregressive model so you cannot simply 
        # multiply coefficients with terms as in a normal model
        simdata[row,] <- coeff %*% simdata[(row-1),] + errors[row,]
    }

    return(simdata)
}

rData <- rSim(coeff=a, errors=u)
