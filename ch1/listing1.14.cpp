#include <Rcpp.h>
using namespace Rcpp;

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
