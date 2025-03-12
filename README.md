# DigitalCommProject2

#### The following is the description of the optional (bonus) project in EECS 241B:

* The project is the comparison of a number of equalization algorithms. You can use any programming language or environment you wish, MATLAB, C, C++. Do not use the standard packages in the MATLAB Toolbox. The work should be of your own, please do not copy someone else's work.

## Here is the set-up for the parameters of the LMS algorithm:

Channel coefficients: h_0 = 0.2194, h_1 = 1.000, h_2 = 0.2194
Step size Delta (3 different values) = 0.0550, 0.0275, 0.0138
Noise power (linear) = 0.001
Number of filter coefficents = 11
Number of transmitted symbols = 500
Number of independent runs = 200

Assume the data transmitted is a sequence of +1 and -1 values.

Show the *average convergence* plot for each of the Delta values (you may use the logarithmic scale on the y axis if needed).

Show representative time plots (say samples 475-500 for a sample run) for the input signal, signal after channel, and the signal after equalizer.

Repeat the above for RLS with lambda values 0.9, 0.7, and 0.5.

In generating the error signal, let the desired response be the N-sample delayed version of the channel input. In this simulation, take N=7.

Your final report should include a copy of the programs and the plots described above. Comment as much as possible on the results of your simulation.