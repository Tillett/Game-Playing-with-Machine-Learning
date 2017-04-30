# Game Playing with AI and Machine Learning

This started out as an academic AI and Machine Learning project geared towards a broader understanding of Learning as a whole. 
The idea for this project came from projects similar to this one (Google's Deepmind, implementations of the NEAT algorithm for game playing, etc.). 

There are Currently three Game Playing method's implemented. A pure Genetic Algorithm, an implementation of the NEAT algorithm, and the A* pathfinding
Algorithm.

-------------------------------------------------------------------------------------------------------------------------------------------------------

The information for the **Genetic Algorithm**:

This Algorithm was developed from the ground up by **Austin Auger** and **Michael Tillett**.
Initial setup done by **Austin Auger** and **Catherine Dougherty**.
The goal was to use a pure genetic algorithm(no use of artificial neural networks) to complete a level of Super Mario Bros. 
The project went from using simple methods for crossover, selection, and mutation, to creating our own algorithm for the project. 
Our algorithm was made up from hours of research into many different machine learning techniques and utilizes these ideas. 
The algorithm is detailed in the commenting of the code.
This is a fun and very engaging project that led to a much deeper understanding of learning as a whole. 

Things you will need:

For Super Mario Bros.
1. FCEUX Emulator - http://www.fceux.com/web/download.html
2. A ROM of Super Mario Bros. (Japan, USA)
3. Put the copy of the .fcs file in the fcs folder(savestate folder)
3. The code stored in the GA folder.

Pop the code into a folder, start up a new game and once the level starts, run the main script through FCEUX.
You can speed up the Emulation using the Turbo function in FCEUX.
Level 1-1 can be completed too easily just based on random chance alone, so I recommend playing up to level 1-2 and starting the script.
As of now our Genetic Algorithm converges on a solution in around 16 generations for Level 1-2. Results may vary though.

For Super Mario World 
1. Bizhawk Emulator - http://tasvideos.org/BizHawk/ReleaseHistory.html
2. A ROM of Super Mario World (USA)
3. Create a savestate and name it "SS.State"
3. The code(in folder "GA\SMW AI")

SMW implementation built by **Michael Tillett**

Pop the code into a folder, start up a new game and once the level starts, run the main script through Bizhawk.
You can speed up the Emulation using the Unthrottled function in Bizhawk.
Bizhawk may be mildly unstable on some systems.
As of now our Genetic Algorithm converges on a solution in only 6 generations for Level "Yoshi's island 2". Results may vary.
*Super Mario World is currently being tested.*

--------------------------------------------------------------------------------------------------------------------------------------------

Information for the **NEAT Algorithm**:

This method was originally created by **SethBling** in his implementation of Mar/IO. Reworked for the FCEUX emulator by **Michael Tillett**

*WIP*

--------------------------------------------------------------------------------------------------------------------------------------------

Information for the **A-star algorithm**:

This method was developed by **Aleksandr Fritz**.

*WIP*

--------------------------------------------------------------------------------------------------------------------------------------------

### The project is ongoing and will be used with different games, different learning techniques, 
and possibly different problem sets aside from game playing in time. 