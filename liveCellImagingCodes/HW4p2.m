% HW4 part 2

% Problem 3. Cell Tracking

%The folder in this repository contains code implementing a Tracking
%algorithm to match cells (or anything else) between successive frames. 
% It is an implemenation of the algorithm described in this paper: 
%
% Sbalzarini IF, Koumoutsakos P (2005) Feature point tracking and trajectory analysis 
% for video imaging in cell biology. J Struct Biol 151:182?195.
%
%The main function for the code is called MatchFrames.m and it takes three
%arguments: 
% 1. A cell array of data called peaks. Each entry of peaks is data for a
% different time point. Each row in this data should be a different object
% (i.e. a cell) and the columns should be x-coordinate, y-coordinate,
% object area, tracking index, fluorescence intensities (could be multiple
% columns). The tracking index can be initialized to -1 in every row. It will
% be filled in by MatchFrames so that its value gives the row where the
% data on the same cell can be found in the next frame. 
%2. a frame number (frame). The function will fill in the 4th column of the
% array in peaks{frame-1} with the row number of the corresponding cell in
% peaks{frame} as described above.
%3. A single parameter for the matching (L). In the current implementation of the algorithm, 
% the meaning of this parameter is that objects further than L pixels apart will never be matched. 


% Part 1. First test the algorithm.
% Generate some appropriate synthetic data for peaks{1}. Assume there are 100 cells (100 rows). 
%columns 1 and 2 should contain random x and y coordinates (in pixels between 1 and 1024)
%column 3, random areas (in pixels, assume a mean area of 300 pixels with std 50 pixels),
%and column 4 should be initialized with -1 in all rows. 
%Now fill peaks{2} with a random permutation of the rows in the
%peaks{1}, that is, the rows should be the same but in a different order
%(Hint: see the built in function randperm.m). Since the coordinates of the
%objects are the same in peaks{1} and peaks{2}, there should be an exact 1
%to 1 correspondence between them. Run MatchFrames to find this
%correspondence. You can use a value of L = 1. Verify that it works by writing code to find the mean difference between the
%coordinates in frame 1 and frame 2. 

% Part 2. Now add some random noise to the data in peaks{2} by adding a
% random integer between 0 and 40 to the x and y position of each data
% point. Rerun Match frames. Write some code to visualize the matches overlaid on the image
% and look at the resulting match. What happened? 
% Raise the L parameter to 50. What happens now? Explain your results? 

% Part 3. Download this movie file. 
% https://www.dropbox.com/s/dyjlrgufwl304ne/stemCellMovie.tif?dl=0
% The movie shows 1 bright cell and 1 dim cell, and the bright cell divides
% into two cells about halfway through. Use any method to segment the movie and
% fill a cell array called peaks with 5 columns of data for each as above. The columns
% should be: the x,y coordinates , the area , -1 (initialize tracking),
% mean fluorescence in that order. Run MatchFrames in a loop
% to fill in the fourth column of peaks for every frame. Note you may need to optimize
% the L parameter to acheive the best results. 

% Part 4. The tracking algorithm works by minimizing a cost function. The
% function is encoded in the file CostMatrix.m which makes a matrix that
% assigns the cost of matching two cells as the distance between them. The
% code then minimizes this cost function. Alter the function CostMatrix.m
% so that it also considers intensities and areas in matching cells (i.e. it prefers
% to match cells with similar intensities and areas). 
%
% Part 5. Write code to use the matching index and fluorescence intensities
% in the peaks array to plot intensities for the three cells as a function
% of time. If cells are not tracked all the way through, decide how to 
% represent the data and implement this. Make these plots for both the
% original cost function and your modified function from part 4. Which
% performs better?