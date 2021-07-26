

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

ptm <- proc.time()
rData <- rSim(coeff=a, errors=u)
print(proc.time() - ptm)


# same exx as in listing 1.13 but now to compile C++ code on the fly
suppressMessages(require(inline))

code <- '
    arma::mat coeff = Rcpp::as<arma::mat> (a);
    arma::mat errors = Rcpp::as<arma::mat> (u);

    // get dimensions
    int m = errors.n_rows;
    int n = errors.n_cols;

    // generate matrix
    arma::mat simdata(m,n);

    // initialize the first row of the matrix
    // with zeros
    simdata.row(0) = arma::zeros<arma::mat>(1,n);

    // go through the subsequent rows and calculate
    // autoregressive model
    for (int row_idx=1; row_idx < m; ++row_idx) {
        simdata.row(row_idx) = simdata.row(row_idx-1)*trans(coeff) + errors.row(row_idx);
    }

    return Rcpp::wrap(simdata);
'

## create the compiled function
rcppSim <- cxxfunction(
        sig=signature(a="numeric",u="numeric")
        ,body=code
        ,plugin="RcppArmadillo"
        )

ptm <- proc.time()
rcppData <- rcppSim(a,u)
print(proc.time() - ptm)

stopifnot(all.equal(rData, rcppData))
