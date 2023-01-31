/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * deinterlaceQuadrants.c
 *
 * Code generation for function 'deinterlaceQuadrants'
 *
 */

/* Include files */
#include "deinterlaceQuadrants.h"
#include "deinterlaceQuadrants_emxutil.h"
#include "deinterlaceQuadrants_types.h"
#include "indexShapeCheck.h"
#include "reshapeSizeChecks.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = {
    23,                     /* lineNo */
    "deinterlaceQuadrants", /* fcnName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pathName */
};

static emlrtRSInfo b_emlrtRSI = {
    24,                     /* lineNo */
    "deinterlaceQuadrants", /* fcnName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pathName */
};

static emlrtRSInfo c_emlrtRSI = {
    25,                     /* lineNo */
    "deinterlaceQuadrants", /* fcnName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pathName */
};

static emlrtRSInfo d_emlrtRSI = {
    26,                     /* lineNo */
    "deinterlaceQuadrants", /* fcnName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pathName */
};

static emlrtRSInfo g_emlrtRSI = {
    29,                  /* lineNo */
    "reshapeSizeChecks", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2021b\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\reshapeSizeChecks.m" /* pathName */
};

static emlrtRTEInfo emlrtRTEI = {
    59,                  /* lineNo */
    23,                  /* colNo */
    "reshapeSizeChecks", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2021b\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\reshapeSizeChecks.m" /* pName */
};

static emlrtRTEInfo b_emlrtRTEI = {
    52,                  /* lineNo */
    13,                  /* colNo */
    "reshapeSizeChecks", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2021b\\toolbox\\eml\\eml\\+coder\\+"
    "internal\\reshapeSizeChecks.m" /* pName */
};

static emlrtBCInfo emlrtBCI = {
    -1,                     /* iFirst */
    -1,                     /* iLast */
    23,                     /* lineNo */
    21,                     /* colNo */
    "img",                  /* aName */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m", /* pName */
    0                                   /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = {
    -1,                     /* iFirst */
    -1,                     /* iLast */
    24,                     /* lineNo */
    21,                     /* colNo */
    "img",                  /* aName */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m", /* pName */
    0                                   /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = {
    -1,                     /* iFirst */
    -1,                     /* iLast */
    25,                     /* lineNo */
    21,                     /* colNo */
    "img",                  /* aName */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m", /* pName */
    0                                   /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = {
    -1,                     /* iFirst */
    -1,                     /* iLast */
    26,                     /* lineNo */
    21,                     /* colNo */
    "img",                  /* aName */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m", /* pName */
    0                                   /* checkKind */
};

static emlrtRTEInfo e_emlrtRTEI = {
    1,                      /* lineNo */
    38,                     /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo f_emlrtRTEI = {
    23,                     /* lineNo */
    1,                      /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo g_emlrtRTEI = {
    24,                     /* lineNo */
    1,                      /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo h_emlrtRTEI = {
    25,                     /* lineNo */
    1,                      /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo i_emlrtRTEI = {
    26,                     /* lineNo */
    1,                      /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo j_emlrtRTEI = {
    23,                     /* lineNo */
    21,                     /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo k_emlrtRTEI = {
    24,                     /* lineNo */
    21,                     /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo l_emlrtRTEI = {
    25,                     /* lineNo */
    21,                     /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

static emlrtRTEInfo m_emlrtRTEI = {
    26,                     /* lineNo */
    21,                     /* colNo */
    "deinterlaceQuadrants", /* fName */
    "C:\\Users\\ezrab\\Desktop\\20220307_0950_PolCamSMOLMAppOO\\polCAM\\lib\\+"
    "CVersion\\deinterlaceQuadrants.m" /* pName */
};

/* Function Definitions */
void deinterlaceQuadrants(const emlrtStack *sp, const emxArray_real_T *img,
                          const emxArray_real_T *mask00,
                          const emxArray_real_T *mask01,
                          const emxArray_real_T *mask10,
                          const emxArray_real_T *mask11, emxArray_real_T *img00,
                          emxArray_real_T *img01, emxArray_real_T *img10,
                          emxArray_real_T *img11)
{
  emlrtStack b_st;
  emlrtStack st;
  emxArray_int32_T *r;
  emxArray_int32_T *r2;
  emxArray_int32_T *r3;
  emxArray_int32_T *r4;
  const real_T *img_data;
  const real_T *mask00_data;
  const real_T *mask01_data;
  const real_T *mask10_data;
  const real_T *mask11_data;
  real_T varargin_1;
  real_T varargin_2;
  real_T *img00_data;
  int32_T end;
  int32_T i;
  int32_T nx;
  int32_T *r1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  mask11_data = mask11->data;
  mask10_data = mask10->data;
  mask01_data = mask01->data;
  mask00_data = mask00->data;
  img_data = img->data;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtCTX)sp);
  /*  DEINTERLACEQUADRANTS deinterlace the pixels of 1 image into 4 images */
  /*  using binary masks. This function will only work in the case of masks */
  /*  like those for a 4-channel polarisation camera. */
  /*  */
  /*  input: */
  /*    img    - nxm array, the input image */
  /*    mask00 - nxm array, binary mask specifying location pixels with */
  /*             polarizer at same orientation as pixel img(1,1) */
  /*    mask01 - nxm array, binary mask specifying location pixels with */
  /*             polarizer at same orientation as pixel img(1,2) */
  /*    mask10 - nxm array, binary mask specifying location pixels with */
  /*             polarizer at same orientation as pixel img(2,1) */
  /*    mask11 - nxm array, binary mask specifying location pixels with */
  /*             polarizer at same orientation as pixel img(2,2) */
  /*  */
  /*  output: */
  /*    img00 - pxq array, image formed by pixels in img masked by mask00 */
  /*    img01 - pxq array, image formed by pixels in img masked by mask01 */
  /*    img10 - pxq array, image formed by pixels in img masked by mask10 */
  /*    img11 - pxq array, image formed by pixels in img masked by mask11 */
  st.site = &emlrtRSI;
  indexShapeCheck(&st, *(int32_T(*)[2])img->size, *(int32_T(*)[2])mask00->size);
  end = mask00->size[0] * mask00->size[1] - 1;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask00_data[i] == 1.0) {
      nx++;
    }
  }
  emxInit_int32_T(sp, &r, &j_emlrtRTEI);
  i = r->size[0];
  r->size[0] = nx;
  emxEnsureCapacity_int32_T(sp, r, i, &e_emlrtRTEI);
  r1 = r->data;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask00_data[i] == 1.0) {
      r1[nx] = i + 1;
      nx++;
    }
  }
  nx = img->size[0] * img->size[1];
  end = r->size[0];
  for (i = 0; i < end; i++) {
    if ((r1[i] < 1) || (r1[i] > nx)) {
      emlrtDynamicBoundsCheckR2012b(r1[i], 1, nx, &emlrtBCI, (emlrtCTX)sp);
    }
  }
  st.site = &emlrtRSI;
  varargin_1 = (real_T)img->size[0] / 2.0;
  varargin_2 = (real_T)img->size[1] / 2.0;
  nx = r->size[0];
  b_st.site = &g_emlrtRSI;
  computeDimsData(&b_st, varargin_1, varargin_2);
  end = r->size[0];
  if (1 > r->size[0]) {
    end = 1;
  }
  nx = muIntScalarMax_sint32(nx, end);
  if ((int32_T)varargin_1 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  if ((int32_T)varargin_2 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  end = (int32_T)varargin_1 * (int32_T)varargin_2;
  if (end != r->size[0]) {
    emlrtErrorWithMessageIdR2018a(
        &st, &emlrtRTEI, "Coder:MATLAB:getReshapeDims_notSameNumel",
        "Coder:MATLAB:getReshapeDims_notSameNumel", 0);
  }
  i = img00->size[0] * img00->size[1];
  img00->size[0] = (int32_T)varargin_1;
  img00->size[1] = (int32_T)varargin_2;
  emxEnsureCapacity_real_T(sp, img00, i, &f_emlrtRTEI);
  img00_data = img00->data;
  for (i = 0; i < end; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(sp, &r);
  st.site = &b_emlrtRSI;
  indexShapeCheck(&st, *(int32_T(*)[2])img->size, *(int32_T(*)[2])mask01->size);
  end = mask01->size[0] * mask01->size[1] - 1;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask01_data[i] == 1.0) {
      nx++;
    }
  }
  emxInit_int32_T(sp, &r2, &k_emlrtRTEI);
  i = r2->size[0];
  r2->size[0] = nx;
  emxEnsureCapacity_int32_T(sp, r2, i, &e_emlrtRTEI);
  r1 = r2->data;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask01_data[i] == 1.0) {
      r1[nx] = i + 1;
      nx++;
    }
  }
  nx = img->size[0] * img->size[1];
  end = r2->size[0];
  for (i = 0; i < end; i++) {
    if ((r1[i] < 1) || (r1[i] > nx)) {
      emlrtDynamicBoundsCheckR2012b(r1[i], 1, nx, &b_emlrtBCI, (emlrtCTX)sp);
    }
  }
  st.site = &b_emlrtRSI;
  varargin_1 = (real_T)img->size[0] / 2.0;
  varargin_2 = (real_T)img->size[1] / 2.0;
  nx = r2->size[0];
  b_st.site = &g_emlrtRSI;
  computeDimsData(&b_st, varargin_1, varargin_2);
  end = r2->size[0];
  if (1 > r2->size[0]) {
    end = 1;
  }
  nx = muIntScalarMax_sint32(nx, end);
  if ((int32_T)varargin_1 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  if ((int32_T)varargin_2 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  end = (int32_T)varargin_1 * (int32_T)varargin_2;
  if (end != r2->size[0]) {
    emlrtErrorWithMessageIdR2018a(
        &st, &emlrtRTEI, "Coder:MATLAB:getReshapeDims_notSameNumel",
        "Coder:MATLAB:getReshapeDims_notSameNumel", 0);
  }
  i = img01->size[0] * img01->size[1];
  img01->size[0] = (int32_T)varargin_1;
  img01->size[1] = (int32_T)varargin_2;
  emxEnsureCapacity_real_T(sp, img01, i, &g_emlrtRTEI);
  img00_data = img01->data;
  for (i = 0; i < end; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(sp, &r2);
  st.site = &c_emlrtRSI;
  indexShapeCheck(&st, *(int32_T(*)[2])img->size, *(int32_T(*)[2])mask10->size);
  end = mask10->size[0] * mask10->size[1] - 1;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask10_data[i] == 1.0) {
      nx++;
    }
  }
  emxInit_int32_T(sp, &r3, &l_emlrtRTEI);
  i = r3->size[0];
  r3->size[0] = nx;
  emxEnsureCapacity_int32_T(sp, r3, i, &e_emlrtRTEI);
  r1 = r3->data;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask10_data[i] == 1.0) {
      r1[nx] = i + 1;
      nx++;
    }
  }
  nx = img->size[0] * img->size[1];
  end = r3->size[0];
  for (i = 0; i < end; i++) {
    if ((r1[i] < 1) || (r1[i] > nx)) {
      emlrtDynamicBoundsCheckR2012b(r1[i], 1, nx, &c_emlrtBCI, (emlrtCTX)sp);
    }
  }
  st.site = &c_emlrtRSI;
  varargin_1 = (real_T)img->size[0] / 2.0;
  varargin_2 = (real_T)img->size[1] / 2.0;
  nx = r3->size[0];
  b_st.site = &g_emlrtRSI;
  computeDimsData(&b_st, varargin_1, varargin_2);
  end = r3->size[0];
  if (1 > r3->size[0]) {
    end = 1;
  }
  nx = muIntScalarMax_sint32(nx, end);
  if ((int32_T)varargin_1 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  if ((int32_T)varargin_2 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  end = (int32_T)varargin_1 * (int32_T)varargin_2;
  if (end != r3->size[0]) {
    emlrtErrorWithMessageIdR2018a(
        &st, &emlrtRTEI, "Coder:MATLAB:getReshapeDims_notSameNumel",
        "Coder:MATLAB:getReshapeDims_notSameNumel", 0);
  }
  i = img10->size[0] * img10->size[1];
  img10->size[0] = (int32_T)varargin_1;
  img10->size[1] = (int32_T)varargin_2;
  emxEnsureCapacity_real_T(sp, img10, i, &h_emlrtRTEI);
  img00_data = img10->data;
  for (i = 0; i < end; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(sp, &r3);
  st.site = &d_emlrtRSI;
  indexShapeCheck(&st, *(int32_T(*)[2])img->size, *(int32_T(*)[2])mask11->size);
  end = mask11->size[0] * mask11->size[1] - 1;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask11_data[i] == 1.0) {
      nx++;
    }
  }
  emxInit_int32_T(sp, &r4, &m_emlrtRTEI);
  i = r4->size[0];
  r4->size[0] = nx;
  emxEnsureCapacity_int32_T(sp, r4, i, &e_emlrtRTEI);
  r1 = r4->data;
  nx = 0;
  for (i = 0; i <= end; i++) {
    if (mask11_data[i] == 1.0) {
      r1[nx] = i + 1;
      nx++;
    }
  }
  nx = img->size[0] * img->size[1];
  end = r4->size[0];
  for (i = 0; i < end; i++) {
    if ((r1[i] < 1) || (r1[i] > nx)) {
      emlrtDynamicBoundsCheckR2012b(r1[i], 1, nx, &d_emlrtBCI, (emlrtCTX)sp);
    }
  }
  st.site = &d_emlrtRSI;
  varargin_1 = (real_T)img->size[0] / 2.0;
  varargin_2 = (real_T)img->size[1] / 2.0;
  nx = r4->size[0];
  b_st.site = &g_emlrtRSI;
  computeDimsData(&b_st, varargin_1, varargin_2);
  end = r4->size[0];
  if (1 > r4->size[0]) {
    end = 1;
  }
  nx = muIntScalarMax_sint32(nx, end);
  if ((int32_T)varargin_1 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  if ((int32_T)varargin_2 > nx) {
    emlrtErrorWithMessageIdR2018a(&st, &b_emlrtRTEI,
                                  "Coder:toolbox:reshape_emptyReshapeLimit",
                                  "Coder:toolbox:reshape_emptyReshapeLimit", 0);
  }
  end = (int32_T)varargin_1 * (int32_T)varargin_2;
  if (end != r4->size[0]) {
    emlrtErrorWithMessageIdR2018a(
        &st, &emlrtRTEI, "Coder:MATLAB:getReshapeDims_notSameNumel",
        "Coder:MATLAB:getReshapeDims_notSameNumel", 0);
  }
  i = img11->size[0] * img11->size[1];
  img11->size[0] = (int32_T)varargin_1;
  img11->size[1] = (int32_T)varargin_2;
  emxEnsureCapacity_real_T(sp, img11, i, &i_emlrtRTEI);
  img00_data = img11->data;
  for (i = 0; i < end; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(sp, &r4);
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtCTX)sp);
}

/* End of code generation (deinterlaceQuadrants.c) */
