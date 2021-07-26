PKG_CXXFLAGS="-I/Library/Frameworks/R.framework/Versions/4.1/Resources/library/Rcpp/include" \
    PKG_LIBS="-L-I/Library/Frameworks/R.framework/Versions/4.1/Resources/library/Rcpp/lib -lRcpp" \
   R CMD SHLIB fibonacci.cpp
g++ -I
