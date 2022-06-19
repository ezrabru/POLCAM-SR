/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * deinterlaceQuadrants_terminate.c
 *
 * Code generation for function 'deinterlaceQuadrants_terminate'
 *
 */

/* Include files */
#include "deinterlaceQuadrants_terminate.h"
#include "_coder_deinterlaceQuadrants_mex.h"
#include "deinterlaceQuadrants_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void deinterlaceQuadrants_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void deinterlaceQuadrants_terminate(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (deinterlaceQuadrants_terminate.c) */
