/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * deinterlaceQuadrants_initialize.c
 *
 * Code generation for function 'deinterlaceQuadrants_initialize'
 *
 */

/* Include files */
#include "deinterlaceQuadrants_initialize.h"
#include "_coder_deinterlaceQuadrants_mex.h"
#include "deinterlaceQuadrants_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void deinterlaceQuadrants_initialize(void)
{
  static const volatile char_T *emlrtBreakCheckR2012bFlagVar = NULL;
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mex_InitInfAndNan();
  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (deinterlaceQuadrants_initialize.c) */
