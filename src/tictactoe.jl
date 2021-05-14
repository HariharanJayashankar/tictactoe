
module tictactoe

using LinearAlgebra
using DelimitedFiles

include("create_game.jl")
include("minimax.jl")

export playgame, playgame_ai

end
