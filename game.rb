class TicTacToe
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @config = {}
    @mark = "O"
  end     

  #Set somes user preferences before starts 
  def config
    puts "Pre-game Configuration \n\n"
    
    #Insert the game mode
    @config[:gamemode] = insert(
      ['humanvshuman', 'cpuvscpu', 'humanvscpu'], 
      'GameMode [humanvshuman, cpuvscpu and humanvscpu]'
    )
    
    #Insert the cpu difficulty. If gamemode's 'humanvshuman', do not execute
    @config[:difficulty] = insert(
      ['easy', 'medium', 'hard'], 
      'Difficulty [easy, medium, hard]'
    ) if @config[:gamemode] != "humanvshuman"

    #Clear the log every turn
    @config[:response_turn] = insert(['Y','n'], 'Clear log every turn? [Y,n]')
  end
  
  #Toggle between "O" and "X" every move
  def toggle_mark
    @mark = (@mark == "O"? "X": "O")
  end
  
  #Main method. Controls game
  def start_game
    #Set your preferences before game
    config
    
    # Loop through until the game was won or tied
    until has_combination(@board) || tie(@board)
      clear_log
    
      # Start by printing the board
      show_board
      
      #Depending of gamemode, we change de players
      case @config[:gamemode]
      when 'humanvshuman'
        get_human_spot
        clear_log
        show_board
        
        get_human_spot if !has_combination(@board) && !tie(@board)
        
      when 'cpuvscpu'
        get_cpu_spot
        puts 'Press Enter to next move'
        gets
        clear_log
        show_board
        
        get_cpu_spot if !has_combination(@board) && !tie(@board)
        puts 'Press Enter to next move'
        gets
      else
        get_human_spot
        get_cpu_spot if !has_combination(@board) && !tie(@board)
      end
    end
    clear_log
    show_board
  
    puts ( tie(@board) ? "It's a tie!" : get_winner )
    puts "Game over!"
  end
  
  def get_winner
    counts = Hash.new(0)
    @board.each { |name| counts[name] += 1 }
    who_won = counts["O"] > counts["X"] #The highest number of marks is the winner!
    
    case @config[:gamemode]
    when 'humanvshuman'
      who_won ? 'Player 1 Wins!' : 'Player 2 Wins!'
    when 'cpuvscpu'
      who_won ? 'CPU 1 Wins!' : 'CPU 2 Wins!'
    else
      who_won ? 'Player Wins!' : 'CPU Wins!'
    end
  end
  
  #Insert value. Also, validates the entry  
  def insert(valid, message = "")
    puts message unless message.empty?
    validated_message = gets.chomp
    raise unless valid.include?(validated_message)
    validated_message
  rescue
    puts 'Select a valid option!'
    retry
  end
  
  #Clear log as set in config
  def clear_log
    puts `clear` if @config[:response_turn] == "Y"
  end
  
  #Show board
  def show_board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
  end

  #Set the mark in a spot
  def get_human_spot
    spot = nil
    player_number = @mark == "O" ? 1 : 2 #Player 1's O and Player 2's X
    
    until spot
      spot = insert(
        ["0", "1", "2", "3" , "4", "5", "6", "7", "8"], 
        "Player #{player_number}, enter your spot [0-8]:"
      ).to_i
      
      if @board[spot] != "X" && @board[spot] != "O"
        @board[spot] = @mark
      else
        puts "Already marked spot. Choose another one."
        spot = nil
      end
    end
    toggle_mark
  end
  
  #Set the mark in a spot for cpu
  def get_cpu_spot
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = @mark
      else
        spot = get_best_move(@board, @mark)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @mark
        else
          spot = nil
        end
      end
    end
    toggle_mark
  end

  #RNG System to make the cpu hit the best move depending of the difficulty
  def best_move_difficulty
    #Gets the percentage depending of the difficulty
    number = {'easy' => 60, 'medium' => 80, 'hard' => 100}[@config[:difficulty]]
    
    #Randomly decide if the cpu will make the best move
    case Random.rand(100)
    when 0...number then true
    when number...100 then false
    end
  end
  
  #Analise possibilities and hits the best move
  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    
    board.each do |s|
      if s != "X" && s != "O"
        available_spaces << s
      end
    end
    
    available_spaces.each do |as|
      board[as.to_i] = @mark
      
      if has_combination(board) && best_move_difficulty
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        #Check the opponents turn 
        board[as.to_i] = @mark
        
        if has_combination(board) && best_move_difficulty
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    
    n = rand(0..available_spaces.count)
    return available_spaces[n].to_i
  end

  #Verify if we have a combination
  def has_combination(b)
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end
  
  #Verify if tied
  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

end

game = TicTacToe.new
game.start_game
