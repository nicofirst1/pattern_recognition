# Pattern recognition 

Pattern Recognition course in Groningen University, INMPR-08.2019-2020.1B

## Exercises

Here goes the list of exercises

### EX1
- [data link](https://nestor.rug.nl/bbcswebdav/pid-9602002-dt-content-rid-17708239_2/xid-17708239_2)
- [web page link](https://nestor.rug.nl/webapps/blackboard/content/listContent.jsp?course_id=_388922_1&content_id=_9601958_1)

#### Assignment 1

Correlation coefficients

Consider the 24x3 array in the file lab1_1.mat. Each row is a three-dimensional (3D) feature vector. The first element of each vector is the height of a person in centimeters; the second element is the age in years; the third element is the body weight in kilograms.

1. Compute the pair-wise correlation coefficients ci,j between the features (elements of the vectors), where i and j are the indices of the columns in the considered 24x3 array. The correlation coefficient of two features is equal to their (unbiased) covariance divided by the square root of the product of their variances, see the file `Statistics reminder', week0 in section 'Lecture slides'.

2. Create 2D scatter plots of the data points with x- and y-axis being:

    plot A: the two features for which the correlation coefficient is largest,
    plot B: the two features for which the correlation coefficient is second largest.

#### Assignment 2


##### PART 1
The Hamming distance (HD) of two binary iris codes is the number of positions (bits) in which the two codes (binary feature vectors) differ.

a) Compute two sets S and D of 1000 normalized HD values each as follows:
For set S: Choose randomly one of the files person[i].mat, i = 1,...,20. Choose randomly two rows in that file. Compute the HD of these two rows. Normalize the HD by dividing it by the length of the rows 30. (If you use a Matlab function that computes the normalized HD, you need not divide by 30.) Repeat this process 10000 times to obtain 10000 such normalized HD values.
Hint 1: Use the function sprintf to generate the filename for a person. For example sprintf(’person%02d.mat’,3) gives ’person03.mat’.
Hint 2: Create a string array containing the strings ’person01.mat’, ’person02.mat’ etc, using the function char, to be able to select from it the name of a random file and to load that file.

b) For set D: Choose randomly two different files person[i].mat and person[j].mat, i = 1,...,20; j = 1,...,20; i /= j. Choose randomly one row from each of these two files. Compute the HD of these two rows. Normalize the HD by dividing it by 30. Repeat this process 10000 times to obtain 10000 such normalized HD values.

##### PART 2
The distribution associated with the set S is the class-conditional probability density function that we measure a given HD value for two iris codes of the same person. The distribution associated with the set D is the class-conditional probability density function that we measure a given HD value for two iris codes of two different persons.

Our Null-hypothesis H0 is that two iris patterns are different. We choose a given value of the decision criterion d and compare the HD between the two iris patterns to d. If d < HD, we consider this as confirmation of our assumption that the two iris codes are different. If HD < d, we consider that our assumption that the two iris codes are different is not confirmed, i.e. we accept that they come from the same person. Note however that the normal distribution associated with D has a tail for HD < d. The integral under this tail gives the false acceptance rate.

Below you will be asked to compute a value of the decision criterion d such that it leads to a given false acceptance rate. For this purpose, you can use the Matlab function normcdf and compute its value for different values of d to find one which leads to the given value of the false acceptance rate. Alternatively, you can use erfinv in an appropriate way.

False rejection rate is the value of the integral of the distribution corresponding to the set S for HD > d.
