/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * deinterlaceQuadrants.h
 *
 * Code generation for function 'deinterlaceQuadrants'
 *
 */

#ifndef DEINTERLACEQUADRANTS_H
#define DEINTERLACEQUADRANTS_H

/* Include files */
#include "deinterlaceQuadrants_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void deinterlaceQuadrants(
    const emxArray_real_T *img, const emxArray_real_T *mask00,
    const emxArray_real_T *mask01, const emxArray_real_T *mask10,
    const emxArray_real_T *mask11, emxArray_real_T *img00,
    emxArray_real_T *img01, emxArray_real_T *img10, emxArray_real_T *img11);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (deinterlaceQuadrants.h) */
