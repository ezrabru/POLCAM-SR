/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_deinterlaceQuadrants_info.c
 *
 * Code generation for function 'deinterlaceQuadrants'
 *
 */

/* Include files */
#include "_coder_deinterlaceQuadrants_info.h"
#include "emlrt.h"
#include "tmwtypes.h"

/* Function Declarations */
static const mxArray *emlrtMexFcnResolvedFunctionsInfo(void);

/* Function Definitions */
static const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  static const int32_T iv[2] = {0, 1};
  const mxArray *m;
  const mxArray *nameCaptureInfo;
  nameCaptureInfo = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtAssign(&nameCaptureInfo, m);
  return nameCaptureInfo;
}

mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xEntryPoints;
  mxArray *xInputs;
  mxArray *xResult;
  const char_T *epFieldName[6] = {
      "Name",           "NumberOfInputs", "NumberOfOutputs",
      "ConstantInputs", "FullPath",       "TimeStamp"};
  const char_T *propFieldName[5] = {"Version", "ResolvedFunctions",
                                    "EntryPoints", "CoverageInfo",
                                    "IsPolymorphic"};
  xEntryPoints =
      emlrtCreateStructMatrix(1, 1, 6, (const char_T **)&epFieldName[0]);
  xInputs = emlrtCreateLogicalMatrix(1, 5);
  emlrtSetField(xEntryPoints, 0, (const char_T *)"Name",
                emlrtMxCreateString((const char_T *)"deinterlaceQuadrants"));
  emlrtSetField(xEntryPoints, 0, (const char_T *)"NumberOfInputs",
                emlrtMxCreateDoubleScalar(5.0));
  emlrtSetField(xEntryPoints, 0, (const char_T *)"NumberOfOutputs",
                emlrtMxCreateDoubleScalar(4.0));
  emlrtSetField(xEntryPoints, 0, (const char_T *)"ConstantInputs", xInputs);
  emlrtSetField(xEntryPoints, 0, (const char_T *)"FullPath",
                emlrtMxCreateString(
                    (const char_T *)"C:\\Users\\ezrab\\Desktop\\20220307_0950_"
                                    "PolCamSMOLMAppOO\\polCAM\\lib\\+"
                                    "CVersion\\deinterlaceQuadrants.m"));
  emlrtSetField(xEntryPoints, 0, (const char_T *)"TimeStamp",
                emlrtMxCreateDoubleScalar(738593.74989583332));
  xResult =
      emlrtCreateStructMatrix(1, 1, 5, (const char_T **)&propFieldName[0]);
  emlrtSetField(
      xResult, 0, (const char_T *)"Version",
      emlrtMxCreateString((const char_T *)"9.11.0.1873467 (R2021b) Update 3"));
  emlrtSetField(xResult, 0, (const char_T *)"ResolvedFunctions",
                (mxArray *)emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, (const char_T *)"EntryPoints", xEntryPoints);
  return xResult;
}

/* End of code generation (_coder_deinterlaceQuadrants_info.c) */
