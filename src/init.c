#include <Rinternals.h>

void R_init_xrprof(DllInfo *info) {
  R_registerRoutines(info, NULL, NULL, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
}
