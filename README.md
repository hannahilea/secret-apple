# Secret Apple Project
...not so secret, this is a public git repo. BUT we are planning to rename it soon, so!

How to generate .wav files:
1. Install Julia
2. `cd` into this directory 
3. Do 
    ```
    julia --project=.
    ```
    which will get you into a Julia REPL 

4. In the REPL, do 
    ```
    using Pkg
    Pkg.instantiate(".")
    ```
    and you can then either copy in each of the commands in run.jl one by one (to see what happens!) or (still in the REPL) you can do
    ```
    include("run.jl")
    ```
    to have all of those commands run in sequence

To preview any of the audio, uncomment the `wavplay` commands!
