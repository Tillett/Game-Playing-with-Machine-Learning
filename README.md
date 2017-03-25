# Game Playing with Genetic Algorithms

This is an academic AI project geared towards a broader understanding of Genetic Algorithms. 
The idea for this project came from projects similar to this one (Google's Deepmind, implementations of the NEAT algorithm for game playing, etc.). 
The goal was to use a pure genetic algorithm(no use of artificial neural networks) to complete a level of Super Mario Bros. 
The project went from using simple methods for crossover, selection, and mutation, to creating our own algorithm for the project. 
Our algorithm was made up from hours of research into many different machine learning techniques and utilizes these ideas. 
The algorithm is detailed in the commenting of the code(Ongoing).
This is a fun and very engaging project that led to a much deeper understanding of learning as a whole. 

Things you will need:

For Super Mario Bros.
1. FCEUX Emulator - http://www.fceux.com/web/download.html
2. A ROM of Super Mario Bros. (Japan, USA)
3. Put the copy of the .fcs file in the fcs folder(savestate folder)
3. The code.

Pop the code into a folder, start up a new game and once the level starts, run the main script through FCEUX.
You can speed up the Emulation using the Turbo function in FCEUX.
Level 1-1 can be completed too easily just based on random chance alone, so I recommend playing up to level 1-2 and starting the script.
As of now our Genetic Algorithm converges on a solution in around 16 generations for Level 1-2. Results may vary though.
SMB is still being tested.

For Super Mario World 
1. Bizhawk Emulator - http://tasvideos.org/BizHawk/ReleaseHistory.html
2. A ROM of Super Mario World (USA)
3. Create a savestate and name is "SS.State"
3. The code(in folder "SMW AI").

Pop the code into a folder, start up a new game and once the level starts, run the main script through Bizhawk.
You can speed up the Emulation using the Unthrottled function in Bizhawk.
Bizhawk may be mildly unstable on some systems.
As of now our Genetic Algorithm converges on a solution in only 6 generations for Level "Yoshi's island 2". Results may vary.
Super Mario World is currently being tested.

The project is ongoing and will be used with different games in time. 