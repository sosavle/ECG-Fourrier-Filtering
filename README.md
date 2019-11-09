# What's this?

This is a MATLAB-based GUI that plots and filters your ECG data from noise with the power of Fourrier transforms. 
Noise is an inevitable part of any data, but Fourrier transforms allow us to get rid of constant-frequency noise signals. In the particular case of ECG data, for example, one may want to remove frequencies that are significantly faster than than those normally observed in the human heartbeat, as they may be caused by artificial AC signals from the equipment used.

# How to use

You will need to have MATLAB installed in your computer before being able to execute the program. But aside from that, it's simple! Open up ECG_Filter.m and browse for the .mat file you wish to use. Then use the radio buttons to control the filter type, and the scroll bar and numerical input fields to select which frequencies you wish to filter.

# Wanna demo?

I've included the file sample.mat, taken directly from physionet's public archives. You're free to use it, browse up other files, or even your own data!

Here's a screenshot of sample output:

![Screenshot](https://github.com/sosavle/ECG-Fourrier-Filtering/blob/master/Sample.PNG)

The original signal is drawn in blue, filtered signals are drawn in orange
