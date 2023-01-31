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

/* Function Definitions */
void deinterlaceQuadrants(const emxArray_real_T *img,
                          const emxArray_real_T *mask00,
                          const emxArray_real_T *mask01,
                          const emxArray_real_T *mask10,
                          const emxArray_real_T *mask11, emxArray_real_T *img00,
                          emxArray_real_T *img01, emxArray_real_T *img10,
                          emxArray_real_T *img11)
{
  emxArray_int32_T *r;
  emxArray_int32_T *r2;
  emxArray_int32_T *r3;
  emxArray_int32_T *r4;
  const double *img_data;
  const double *mask00_data;
  const double *mask01_data;
  const double *mask10_data;
  const double *mask11_data;
  double *img00_data;
  int end;
  int i;
  int trueCount;
  int *r1;
  mask11_data = mask11->data;
  mask10_data = mask10->data;
  mask01_data = mask01->data;
  mask00_data = mask00->data;
  img_data = img->data;
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
  end = mask00->size[0] * mask00->size[1] - 1;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask00_data[i] == 1.0) {
      trueCount++;
    }
  }
  emxInit_int32_T(&r);
  i = r->size[0];
  r->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r, i);
  r1 = r->data;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask00_data[i] == 1.0) {
      r1[trueCount] = i + 1;
      trueCount++;
    }
  }
  i = img00->size[0] * img00->size[1];
  img00->size[0] = (int)((double)img->size[0] / 2.0);
  img00->size[1] = (int)((double)img->size[1] / 2.0);
  emxEnsureCapacity_real_T(img00, i);
  img00_data = img00->data;
  trueCount =
      (int)((double)img->size[0] / 2.0) * (int)((double)img->size[1] / 2.0);
  for (i = 0; i < trueCount; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(&r);
  end = mask01->size[0] * mask01->size[1] - 1;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask01_data[i] == 1.0) {
      trueCount++;
    }
  }
  emxInit_int32_T(&r2);
  i = r2->size[0];
  r2->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r2, i);
  r1 = r2->data;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask01_data[i] == 1.0) {
      r1[trueCount] = i + 1;
      trueCount++;
    }
  }
  i = img01->size[0] * img01->size[1];
  img01->size[0] = (int)((double)img->size[0] / 2.0);
  img01->size[1] = (int)((double)img->size[1] / 2.0);
  emxEnsureCapacity_real_T(img01, i);
  img00_data = img01->data;
  trueCount =
      (int)((double)img->size[0] / 2.0) * (int)((double)img->size[1] / 2.0);
  for (i = 0; i < trueCount; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(&r2);
  end = mask10->size[0] * mask10->size[1] - 1;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask10_data[i] == 1.0) {
      trueCount++;
    }
  }
  emxInit_int32_T(&r3);
  i = r3->size[0];
  r3->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r3, i);
  r1 = r3->data;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask10_data[i] == 1.0) {
      r1[trueCount] = i + 1;
      trueCount++;
    }
  }
  i = img10->size[0] * img10->size[1];
  img10->size[0] = (int)((double)img->size[0] / 2.0);
  img10->size[1] = (int)((double)img->size[1] / 2.0);
  emxEnsureCapacity_real_T(img10, i);
  img00_data = img10->data;
  trueCount =
      (int)((double)img->size[0] / 2.0) * (int)((double)img->size[1] / 2.0);
  for (i = 0; i < trueCount; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(&r3);
  end = mask11->size[0] * mask11->size[1] - 1;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask11_data[i] == 1.0) {
      trueCount++;
    }
  }
  emxInit_int32_T(&r4);
  i = r4->size[0];
  r4->size[0] = trueCount;
  emxEnsureCapacity_int32_T(r4, i);
  r1 = r4->data;
  trueCount = 0;
  for (i = 0; i <= end; i++) {
    if (mask11_data[i] == 1.0) {
      r1[trueCount] = i + 1;
      trueCount++;
    }
  }
  i = img11->size[0] * img11->size[1];
  img11->size[0] = (int)((double)img->size[0] / 2.0);
  img11->size[1] = (int)((double)img->size[1] / 2.0);
  emxEnsureCapacity_real_T(img11, i);
  img00_data = img11->data;
  trueCount =
      (int)((double)img->size[0] / 2.0) * (int)((double)img->size[1] / 2.0);
  for (i = 0; i < trueCount; i++) {
    img00_data[i] = img_data[r1[i] - 1];
  }
  emxFree_int32_T(&r4);
}

/* End of code generation (deinterlaceQuadrants.c) */
