// Generated by cpp11: do not edit by hand
// clang-format off


#include "cpp11/declarations.hpp"
#include <R_ext/Visibility.h>

// InPoly.cpp
integers InPoly_cpp(doubles xx, doubles yy, doubles px, doubles py);
extern "C" SEXP _insidecpp11_InPoly_cpp(SEXP xx, SEXP yy, SEXP px, SEXP py) {
  BEGIN_CPP11
    return cpp11::as_sexp(InPoly_cpp(cpp11::as_cpp<cpp11::decay_t<doubles>>(xx), cpp11::as_cpp<cpp11::decay_t<doubles>>(yy), cpp11::as_cpp<cpp11::decay_t<doubles>>(px), cpp11::as_cpp<cpp11::decay_t<doubles>>(py)));
  END_CPP11
}

extern "C" {
static const R_CallMethodDef CallEntries[] = {
    {"_insidecpp11_InPoly_cpp", (DL_FUNC) &_insidecpp11_InPoly_cpp, 4},
    {NULL, NULL, 0}
};
}

extern "C" attribute_visible void R_init_insidecpp11(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
