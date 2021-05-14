using LinearAlgebra

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

    if sum(board .== "") == 0
        winner = "Tie"
    end
    
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
    if allsame(straightdiag) && straightdiag[1] != ""
        winner = straightdiag[1]
    end
    revboard = board[:, end:-1:1]
    revdiag = revboard[diagind(revboard)]
    if allsame(revdiag) && revdiag[1] != ""
        winner = revdiag[1]
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
    inputs_array = Tuple([parse(Int, a) for a in inputs])

    return inputs_array


end

function islegal(boardspot)

    legal = boardspot == ""

    return legal

end

function legal_moves(board)

    legalmoves = Tuple.(findall(i->(i==""), board))

    return legalmoves

end

function play_legal_move!(board)

    movelegal = false
    while movelegal == false

        player = whos_turn(board)
        println("Enter input:")
        input = readline()
        input = parseinput(input)

        if input in legal_moves(board)
            row, col = input
            board[row, col] = player
            movelegal = true
        else
            println("Made illegal move. Please try again")
        end
    end

end

function playgame(nrow = 3, ncol = 3)

    board = create_board(nrow, ncol)
    nmaxturns = nrow * ncol
    gameoutcome = "Tie"

    # start game
    for i in 1:nmaxturns

        println("==========================")
        println("Turn number: $i")
        writedlm(stdout, board,  "\t|\t")
        play_legal_move!(board)
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
    
    println("==========================")
    writedlm(stdout, board,  "\t|\t")
    return gameoutcome

end
