#include "mex.h"

// generate the optimzied code size distribution 
void cal_code_size(double *freq_rsv, double *code_size, int n)
{
#define MAX_CLEN 32		/* assumed maximum initial code length */
    int bits[MAX_CLEN+1];	/* bits[k] = # of symbols with code length k */
    int codesize[257];		/* codesize[k] = code length of symbol k */
    int others[257];		/* next symbol in current branch of tree */
    double freq[257];
    int c1, c2;
    int p, i, j;
    int ptr,tmp;
    long v;
    for (i = 0; i<n; i++)
        freq[i] = freq_rsv[i];
    for (i=n;i<256;i++)
        freq[i] = 0;
    freq[256] = 1;		/* make sure 256 has a nonzero count */
    for (i=0;i<=MAX_CLEN;i++)
        bits[i]=0;
    for (i = 0; i < 257; i++){
        others[i] = -1;		/* init links to empty */
        codesize[i] = 0;
    }
    for (;;) {
        c1 = -1;
        v = 1000000000L;
        for (i = 0; i < 257; i++) {
            if (freq[i] && freq[i] <= v) {
                v = freq[i];
                c1 = i;
            }
        }
        c2 = -1;
        v = 1000000000L;
        for (i = 0; i < 257; i++) {
            if (freq[i] && freq[i] <= v && i != c1) {
                v = freq[i];
                c2 = i;
            }
        }
        if (c2 < 0)
            break;
        freq[c1] += freq[c2];
        freq[c2] = 0;
        codesize[c1]++;
        while (others[c1] >= 0) {
            c1 = others[c1];
            codesize[c1]++;
        }
        others[c1] = c2;		/* chain c2 onto c1's tree branch */
        /* Increment the codesize of everything in c2's tree branch */
        codesize[c2]++;
        while (others[c2] >= 0) {
            c2 = others[c2];
            codesize[c2]++;
        }
    }
    
    /* Now count the number of symbols of each code length */
    for (i = 0; i < 257; i++) {
        if (codesize[i]) {
            bits[codesize[i]]++;
        }
    }
    for (i = MAX_CLEN; i > 16; i--) {
        while (bits[i] > 0) {
            j = i - 2;		/* find length of new prefix to be used */
            while (bits[j] == 0)
                j--;
            bits[i] -= 2;		/* remove two symbols */
            bits[i-1]++;		/* one goes in this length */
            bits[j+1] += 2;		/* two new symbols in this length */
            bits[j]--;		/* symbol of this length is now a prefix */
        }
    }
    while (bits[i] == 0)		/* find largest codelength still in use */
        i--;
    bits[i]--;
    ptr = 0;
    for (i = 0; i <= 16; i++) {
        tmp = bits[i];
        if (tmp > 0) {
            for(j=0;j<tmp;j++){
                code_size[ptr++] = i;
            }
        }
    }
}

/* The gateway function */
void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    double *inArray;
    int arraySize;
    double *outArray;
    inArray = mxGetPr(prhs[0]);
    arraySize = mxGetM(prhs[0]);
    plhs[0] = mxCreateDoubleMatrix(arraySize,1,mxREAL);
    outArray = mxGetPr(plhs[0]);
    cal_code_size(inArray,outArray,arraySize);
}