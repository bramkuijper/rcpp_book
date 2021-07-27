#!/usr/bin/env bash

PKG_CXXFLAGS=`Rscript -e 'Rcpp:::CxxFlags()'` \
    PGK_LIBS=`Rscript -e 'Rcpp:::LdFlags()'` \
    R CMD SHLIB ../ch1/fibonacci.cpp
