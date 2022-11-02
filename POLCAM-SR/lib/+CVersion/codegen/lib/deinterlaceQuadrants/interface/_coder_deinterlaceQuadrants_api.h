/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_deinterlaceQuadrants_api.h
 *
 * Code generation for function 'deinterlaceQuadrants'
 *
 */

#ifndef _CODER_DEINTERLACEQUADRANTS_API_H
#define _CODER_DEINTERLACEQUADRANTS_API_H

/* Include files */
#include "emlrt.h"
#include "tmwtypes.h"
#include <string.h>

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T {
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};
#endif /* struct_emxArray_real_T */
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /* typedef_emxArray_real_T */

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void deinterlaceQuadrants(emxArray_real_T *img, emxArray_real_T *mask00,
                          emxArray_real_T *mask01, emxArray_real_T *mask10,
                          emxArray_real_T *mask11, emxArray_real_T *img00,
                          emxArray_real_T *img01, emxArray_real_T *img10,
                          emxArray_real_T *img11);

void deinterlaceQuadrants_api(const mxArray *const prhs[5], int32_T nlhs,
                              const mxArray *plhs[4]);

void deinterlaceQuadrants_atexit(void);

void deinterlaceQuadrants_initialize(void);

void deinterlaceQuadrants_terminate(void);

void deinterlaceQuadrants_xil_shutdown(void);

void deinterlaceQuadrants_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_deinterlaceQuadrants_api.h) */
