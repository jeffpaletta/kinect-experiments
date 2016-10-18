————————————————————————————————————————

 Interactive Graphics Assignment
 TextRainStudent
 Kenny Bello, Kohei Hisakuni
 02/09/2015

————————————————————————————————————————

This is the README file for the TextRainStudent program.

Design decisions:

To store the information about each character that appears to be falling on the screen, we created several arrays. The xPos array contains the x positions, while the yPos array contains the y positions of each character. These coordinates correspond to each letter in the displayedChar array. The poemChar array initially holds all the character that is read in.

The displayedChar array gradually gets populated gradually as the program runs. The characters in the displayedChar array get looped through each frame, and the foreground color is calculated. If the color is less than the threshold color, the character gets redrawn higher in the screen. If the color is not less than the threshold color, the y position of the character gets incremented.

The threshold color gets incremented or decremented depending on the user arrow key input. This is done by incrementing or decrementing the RGB values of the threshold color. In debug mode, the foreground and background can be visibly be seen changing. This is done by incrementing or decrementing the parameter that the filter() method takes in. The number that gets passed into the filter() method corresponds with the amount the threshold color gets changed.