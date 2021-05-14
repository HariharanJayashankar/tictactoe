scores = Dict(
    "X" => 1,
    "O" => -1,
    "" => 0
)

player_inv = Dict(
    "X" => "O",
    "O" => "X"
)

function choose_player_input()

    input = ""
    while true
        println("Enter which piece you want to play as (X or O):")
        input = readline()
        input = uppercase(input)
        println("Input chosen as $input")
        if (input == "X") | (input == "O")
            break
        else
            println("Please choose either X or O")
        end
    end
    return input
end


function have_we_won(board, ai)

    havewon = false
    winner = checkwinner(board)
    havewon = ai == winner ? true : false

    return havewon

end


function whosplaying(depth, scoreprofile)
    # since we start with ai. every odd depth is ai's turn
    # i.e. the turn of teh score profile with score +1
    if depth % 2 == 1
        player = [k for (k,v) in scoreprofile if v == 1][1]
    else 
        player = [k for (k,v) in scoreprofile if v == -1][1]
    end

    return player

end

function minimax(board, scoreprofile; maximizer, depth = 1)
    #==
    score profile is a dictionary which shows whether X or O
    gets the +1 and -1
    ==#

    bestscore = nothing
    winner = checkwinner(board)
    player = whosplaying(depth, scoreprofile)
    if winner != ""
        bestscore = scoreprofile[winner]
    else
        possiblemoves = legal_moves(board)

        if maximizer
            bestscore = -10
            for move in possiblemoves      
                if islegal(board[move...])
                    boardcopy = copy(board)
                    boardcopy[move...] = player
                    score = minimax(boardcopy, scoreprofile, maximizer = false, depth = depth + 1)
                    bestscore = max(score, bestscore)
                end

            end
        else
            bestscore = 10
            for move in possiblemoves  
                if islegal(board[move...])
                    boardcopy = copy(board)
                    boardcopy[move...] = player
                    score = minimax(boardcopy, scoreprofile, maximizer = true, depth = depth + 1)
                    bestscore = min(score, bestscore)
                end

            end
        end
        
    end

    return bestscore
end

function ai_move!(board, ai)
    
    possiblemoves = legal_moves(board)
    scoreprofile = Dict(
        ai => 1,
        player_inv[ai] => -1,
        "Tie" => 0
    )
    bestscore = -10
    bestmove = (nothing, nothing)
    for move in possiblemoves

        boardcopy = copy(board)
        boardcopy[move...] = ai
        score = minimax(boardcopy, scoreprofile, maximizer = false, depth = 2)
        if score > bestscore
            bestscore = score
            bestmove = move
        end
    end

    board[bestmove...] = ai

end

function playgame_ai(nrow=3, ncol=3)

    board = create_board(nrow, ncol)
    nmaxturns = nrow * ncol
    gameoutcome = "Tie"

    human = choose_player_input()
    ai = player_inv[human]

    for i in 1:nmaxturns

        println("Turn number: $i")

        display(board)

        player = whos_turn(board)

        if player == human
            play_legal_move!(board)
        elseif player == ai
            ai_move!(board, ai)
        else
            println("Something went wrong with choosing which player plays")
        end

        gameover = isgameover(board)
        if gameover
            winner = checkwinner(board)

            if winner == "Tie"
                gameoutcome = "Tie!"
            else
                gameoutcome = "$winner wins!"
            end

            break
        end

    end

    return gameoutcome

end



    

