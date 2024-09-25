TITLE:

Functional Connectivity Analysis with MATLAB

DESCRIPTION:

This MATLAB code calculates functional connectivity (FC) matrices for a given set of time series signals. The FC matrix represents the similarity between each pair of signals, as measured by a specified method.

FEATURES:

Inputs==> Signals: An n x m matrix where n is the number of time series and m is the length of each series.
method: A string specifying the similarity measure to use. Valid options include:
correlation: Pearson correlation
mutual_information: Mutual information
transfer_entropy: Transfer entropy

Output==> fc_matrix: An n x n matrix representing the functional connectivity between the input signals.
