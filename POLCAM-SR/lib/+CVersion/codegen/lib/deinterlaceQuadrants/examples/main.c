/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include files */
#include "main.h"
#include "deinterlaceQuadrants.h"
#include "deinterlaceQuadrants_emxAPI.h"
#include "deinterlaceQuadrants_terminate.h"
#include "deinterlaceQuadrants_types.h"

/* Function Declarations */
static double argInit_real_T(void);

static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void);

static void main_deinterlaceQuadrants(void);

/* Function Definitions */
static double argInit_real_T(void)
{
  return 0.0;
}

static emxArray_real_T *c_argInit_UnboundedxUnbounded_r(void)
{
  emxArray_real_T *result;
  double *result_data;
  int idx0;
  int idx1;
  /* Set the size of the array.
Change this size to the value that the application requires. */
  result = emxCreate_real_T(2, 2);
  result_data = result->data;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < result->size[0U]; idx0++) {
    for (idx1 = 0; idx1 < result->size[1U]; idx1++) {
      /* Set the value of the array element.
Change this value to the value that the application requires. */
      result_data[idx0 + result->size[0] * idx1] = argInit_real_T();
    }
  }
  return result;
}

static void main_deinterlaceQuadrants(void)
{
  emxArray_real_T *img;
  emxArray_real_T *img00;
  emxArray_real_T *img01;
  emxArray_real_T *img10;
  emxArray_real_T *img11;
  emxArray_real_T *mask00;
  emxArray_real_T *mask01;
  emxArray_real_T *mask10;
  emxArray_real_T *mask11;
  emxInitArray_real_T(&img00, 2);
  emxInitArray_real_T(&img01, 2);
  emxInitArray_real_T(&img10, 2);
  emxInitArray_real_T(&img11, 2);
  /* Initialize function 'deinterlaceQuadrants' input arguments. */
  /* Initialize function input argument 'img'. */
  img = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'mask00'. */
  mask00 = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'mask01'. */
  mask01 = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'mask10'. */
  mask10 = c_argInit_UnboundedxUnbounded_r();
  /* Initialize function input argument 'mask11'. */
  mask11 = c_argInit_UnboundedxUnbounded_r();
  /* Call the entry-point 'deinterlaceQuadrants'. */
  deinterlaceQuadrants(img, mask00, mask01, mask10, mask11, img00, img01, img10,
                       img11);
  emxDestroyArray_real_T(img11);
  emxDestroyArray_real_T(img10);
  emxDestroyArray_real_T(img01);
  emxDestroyArray_real_T(img00);
  emxDestroyArray_real_T(mask11);
  emxDestroyArray_real_T(mask10);
  emxDestroyArray_real_T(mask01);
  emxDestroyArray_real_T(mask00);
  emxDestroyArray_real_T(img);
}

int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_deinterlaceQuadrants();
  /* Terminate the application.
You do not need to do this more than one time. */
  deinterlaceQuadrants_terminate();
  return 0;
}

/* End of code generation (main.c) */
