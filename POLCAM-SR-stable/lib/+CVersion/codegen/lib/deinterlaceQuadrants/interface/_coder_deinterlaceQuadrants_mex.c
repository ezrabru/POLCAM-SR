/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_deinterlaceQuadrants_mex.c
 *
 * Code generation for function 'deinterlaceQuadrants'
 *
 */

/* Include files */
#include "_coder_deinterlaceQuadrants_mex.h"
#include "_coder_deinterlaceQuadrants_api.h"

/* Function Definitions */
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&deinterlaceQuadrants_atexit);
  /* Module initialization. */
  deinterlaceQuadrants_initialize();
  /* Dispatch the entry-point. */
  unsafe_deinterlaceQuadrants_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  deinterlaceQuadrants_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2021a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL);
  return emlrtRootTLSGlobal;
}

void unsafe_deinterlaceQuadrants_mexFunction(int32_T nlhs, mxArray *plhs[4],
                                             int32_T nrhs,
                                             const mxArray *prhs[5])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[4];
  int32_T b_nlhs;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 5) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 5, 4,
                        20, "deinterlaceQuadrants");
  }
  if (nlhs > 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 20,
                        "deinterlaceQuadrants");
  }
  /* Call the function. */
  deinterlaceQuadrants_api(prhs, nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }
  emlrtReturnArrays(b_nlhs, &plhs[0], &outputs[0]);
}

/* End of code generation (_coder_deinterlaceQuadrants_mex.c) */
