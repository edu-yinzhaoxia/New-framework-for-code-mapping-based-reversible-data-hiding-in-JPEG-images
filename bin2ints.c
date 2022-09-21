#include "mex.h"
#include "math.h"

void bin2ints(mxChar *binStr, double *ints, int arraySize, int size)
{
    int i, j;
    for (i=0;i<arraySize;i++){
        for (int j=0;j<size;j++){
            int temp = binStr[size*i+j]-48;
            if (temp == 1)
                ints[i] += pow(2,size-j-1);
        }
    }
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    mxChar *binStr;
    int size,arraySize;
    double *ints;
    binStr = mxGetChars(prhs[0]);
    size = mxGetScalar(prhs[1]);
    arraySize = mxGetN(prhs[0])/size;
    plhs[0] = mxCreateDoubleMatrix(1,arraySize,mxREAL);
    ints = mxGetPr(plhs[0]);
    bin2ints(binStr,ints,arraySize,size);
}