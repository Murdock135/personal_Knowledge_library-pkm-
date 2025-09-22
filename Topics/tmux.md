tmux- **T**mux **Mu**ltiple**x**r

# tmux server and clients
**tmux keeps all its state in a single main process**, called the tmux server. This runs in the background and manages all the programs running inside tmux and keeps track of their output. The tmux server is started automatically when the user runs a tmux command and by default exits when there are no running programs.