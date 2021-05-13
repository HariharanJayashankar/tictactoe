

function create_board(nrow = 3, ncol = 3)
    
    board = Array{String}(undef, nrow, ncol)
    board[:] .= ""

    return board

end

function whos_turn(board)

    if sum(board .!= "") == 0
        turn = "X"
    elseif sum(board .!= "") % 2 == 0
        turn = "X"
    else
        turn = "O"
    end

    return turn

end



function allsame(x) 
    
    return all(y -> y == first(x), x)

end


function checkwinner(board)

    n, m = size(board)
    winner = ""
    
    # horizontal
    for i in 1:n
        if allsame(board[i, :]) && board[i, 1] != ""
            winner = board[i, 1]
        end
    end
    # vertical
    for j in 1:m
        if allsame(board[:, j]) && board[1, j] != ""
            winner = board[1, j]
        end
    end
    # diagonal
    straightdiag = board[diagind(board)]
    if allsame(straightdiag)
        winner = straightdiag[1]
    end
    revdiag = board[diagind(board[:, end:-1:1])]
    if allsame(revdiag)
        winner = straightdiag[1]
    end

    return winner
end

function isgameover(board)

    over = false
    if sum(board .== "") == 0
        over = true
    elseif checkwinner(board) != ""
        over = true
    end
    
    return over

end


function parseinput(input)

    #==
    parse input properly
    ==#

    inputs = split(input, ",")
    inputs_array = [parse(Int, a) for a in inputs]

    return inputs_array


end


function playgame(nrow = 3, ncol = 3)

    board = create_board(nrow, ncol)
    nmaxturns = nrow * ncol
    gameoutcome = "Tie"

    # start game
    for i in 1:nmaxturns

        println("Turn number: $i")

        display(board)

        player = whos_turn(board)
        println("Enter input:")
        input = readline()
        input = parseinput(input)

        row, col = input
        board[row, col] = player

        gameover = isgameover(board)
        println(gameover)
        if gameover
            winner = checkwinner(board)

            if winner == ""
                gameoutcome = "Tie!"
            else
                gameoutcome = "$winner wins!"
            end

            break
        end
  
    end

    return gameoutcome

end
