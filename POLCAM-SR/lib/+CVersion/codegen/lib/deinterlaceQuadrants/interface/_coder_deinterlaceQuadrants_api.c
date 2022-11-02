/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_deinterlaceQuadrants_api.c
 *
 * Code generation for function 'deinterlaceQuadrants'
 *
 */

/* Include files */
#include "_coder_deinterlaceQuadrants_api.h"
#include "_coder_deinterlaceQuadrants_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;

emlrtContext emlrtContextGlobal = {
    true,                                                 /* bFirstTime */
    false,                                                /* bInitialized */
    131611U,                                              /* fVersionInfo */
    NULL,                                                 /* fErrorFunction */
    "deinterlaceQuadrants",                               /* fFunctionName */
    NULL,                                                 /* fRTCallStack */
    false,                                                /* bDebugMode */
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, /* fSigWrd */
    NULL                                                  /* fSigMem */
};

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId,
                               emxArray_real_T *y);

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               emxArray_real_T *ret);

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *img,
                             const char_T *identifier, emxArray_real_T *y);

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);

static void emxEnsureCapacity_real_T(emxArray_real_T *emxArray,
                                     int32_T oldNumel);

static void emxFree_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray);

static void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId,
                               emxArray_real_T *y)
{
  c_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                               const emlrtMsgIdentifier *msgId,
                               emxArray_real_T *ret)
{
  static const int32_T dims[2] = {-1, -1};
  int32_T iv[2];
  int32_T i;
  const boolean_T bv[2] = {true, true};
  emlrtCheckVsBuiltInR2012b((emlrtCTX)sp, msgId, src, (const char_T *)"double",
                            false, 2U, (void *)&dims[0], &bv[0], &iv[0]);
  ret->allocatedSize = iv[0] * iv[1];
  i = ret->size[0] * ret->size[1];
  ret->size[0] = iv[0];
  ret->size[1] = iv[1];
  emxEnsureCapacity_real_T(ret, i);
  ret->data = (real_T *)emlrtMxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *img,
                             const char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  b_emlrt_marshallIn(sp, emlrtAlias(img), &thisId, y);
  emlrtDestroyArray(&img);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  static const int32_T iv[2] = {0, 0};
  const mxArray *m;
  const mxArray *y;
  const real_T *u_data;
  u_data = u->data;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u_data[0]);
  emlrtSetDimensions((mxArray *)m, &u->size[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static void emxEnsureCapacity_real_T(emxArray_real_T *emxArray,
                                     int32_T oldNumel)
{
  int32_T i;
  int32_T newNumel;
  void *newData;
  if (oldNumel < 0) {
    oldNumel = 0;
  }
  newNumel = 1;
  for (i = 0; i < emxArray->numDimensions; i++) {
    newNumel *= emxArray->size[i];
  }
  if (newNumel > emxArray->allocatedSize) {
    i = emxArray->allocatedSize;
    if (i < 16) {
      i = 16;
    }
    while (i < newNumel) {
      if (i > 1073741823) {
        i = MAX_int32_T;
      } else {
        i *= 2;
      }
    }
    newData = emlrtCallocMex((uint32_T)i, sizeof(real_T));
    if (emxArray->data != NULL) {
      memcpy(newData, emxArray->data, sizeof(real_T) * oldNumel);
      if (emxArray->canFreeData) {
        emlrtFreeMex(emxArray->data);
      }
    }
    emxArray->data = (real_T *)newData;
    emxArray->allocatedSize = i;
    emxArray->canFreeData = true;
  }
}

static void emxFree_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray)
{
  if (*pEmxArray != (emxArray_real_T *)NULL) {
    if (((*pEmxArray)->data != (real_T *)NULL) && (*pEmxArray)->canFreeData) {
      emlrtFreeMex((*pEmxArray)->data);
    }
    emlrtFreeMex((*pEmxArray)->size);
    emlrtRemoveHeapReference((emlrtCTX)sp, (void *)pEmxArray);
    emlrtFreeEmxArray(*pEmxArray);
    *pEmxArray = (emxArray_real_T *)NULL;
  }
}

static void emxInit_real_T(const emlrtStack *sp, emxArray_real_T **pEmxArray)
{
  emxArray_real_T *emxArray;
  int32_T i;
  *pEmxArray = (emxArray_real_T *)emlrtMallocEmxArray(sizeof(emxArray_real_T));
  emlrtPushHeapReferenceStackEmxArray((emlrtCTX)sp, true, (void *)pEmxArray,
                                      (void *)&emxFree_real_T, NULL, NULL,
                                      NULL);
  emxArray = *pEmxArray;
  emxArray->data = (real_T *)NULL;
  emxArray->numDimensions = 2;
  emxArray->size = (int32_T *)emlrtMallocMex(sizeof(int32_T) * 2U);
  emxArray->allocatedSize = 0;
  emxArray->canFreeData = true;
  for (i = 0; i < 2; i++) {
    emxArray->size[i] = 0;
  }
}

void deinterlaceQuadrants_api(const mxArray *const prhs[5], int32_T nlhs,
                              const mxArray *plhs[4])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  emxArray_real_T *img;
  emxArray_real_T *img00;
  emxArray_real_T *img01;
  emxArray_real_T *img10;
  emxArray_real_T *img11;
  emxArray_real_T *mask00;
  emxArray_real_T *mask01;
  emxArray_real_T *mask10;
  emxArray_real_T *mask11;
  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &img);
  emxInit_real_T(&st, &mask00);
  emxInit_real_T(&st, &mask01);
  emxInit_real_T(&st, &mask10);
  emxInit_real_T(&st, &mask11);
  emxInit_real_T(&st, &img00);
  emxInit_real_T(&st, &img01);
  emxInit_real_T(&st, &img10);
  emxInit_real_T(&st, &img11);
  /* Marshall function inputs */
  img->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "img", img);
  mask00->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "mask00", mask00);
  mask01->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "mask01", mask01);
  mask10->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[3]), "mask10", mask10);
  mask11->canFreeData = false;
  emlrt_marshallIn(&st, emlrtAlias(prhs[4]), "mask11", mask11);
  /* Invoke the target function */
  deinterlaceQuadrants(img, mask00, mask01, mask10, mask11, img00, img01, img10,
                       img11);
  /* Marshall function outputs */
  img00->canFreeData = false;
  plhs[0] = emlrt_marshallOut(img00);
  emxFree_real_T(&st, &img00);
  emxFree_real_T(&st, &mask11);
  emxFree_real_T(&st, &mask10);
  emxFree_real_T(&st, &mask01);
  emxFree_real_T(&st, &mask00);
  emxFree_real_T(&st, &img);
  if (nlhs > 1) {
    img01->canFreeData = false;
    plhs[1] = emlrt_marshallOut(img01);
  }
  emxFree_real_T(&st, &img01);
  if (nlhs > 2) {
    img10->canFreeData = false;
    plhs[2] = emlrt_marshallOut(img10);
  }
  emxFree_real_T(&st, &img10);
  if (nlhs > 3) {
    img11->canFreeData = false;
    plhs[3] = emlrt_marshallOut(img11);
  }
  emxFree_real_T(&st, &img11);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

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
  deinterlaceQuadrants_xil_terminate();
  deinterlaceQuadrants_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void deinterlaceQuadrants_initialize(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
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

/* End of code generation (_coder_deinterlaceQuadrants_api.c) */
