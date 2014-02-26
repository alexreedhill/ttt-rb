require_relative '../lib/player'

class MinimaxAi

  def generate(first_player_value)
    cells = []
    9.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    first_player = Player.new({:name => 'ai', :value => first_player_value})
    initial_game_state = GameState.new(first_player, cells, 1) 
  end
  
  def prune(game_state, alpha, beta)
    if alpha >= beta
      return
    elsif game_state.turn == 1 && game_state.current_player.name == 'ai'
      game_state.moves << force_first_move(game_state) 
      return
    else
      generate_moves(game_state, alpha, beta) 
    end
  end

  def generate_moves(game_state, alpha, beta)
    next_player = Player.new({:name => game_state.current_player.opposite_name, :value => game_state.current_player.opposite_value})
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, next_player, alpha, beta)
      end
    end
  end

  def force_first_move(game_state)
    game_state.cells[4].value.nil? ? game_state.cells[4].value = game_state.ai_value : game_state.cells[0].value = game_state.ai_value
    game_state
  end
  
  def generate_next_game_state(game_state, cell_id, next_player, alpha, beta)
    next_cells = game_state.cells.collect { |cell| cell.dup }
    next_cells[cell_id].value = game_state.current_player.value
    next_game_state = GameState.new(next_player, next_cells, (game_state.turn + 1))
    game_state.moves << next_game_state
    if next_game_state.final_state?
      next_game_state_rank = rank(next_game_state)      
      alpha = set_alpha(next_game_state_rank, next_player, alpha, beta)
      beta = set_beta(next_game_state_rank, next_player, alpha, beta)
    end
    prune(next_game_state, alpha, beta)
  end

  def set_alpha(next_game_state_rank, next_player, alpha, beta)
    alpha = next_game_state_rank if next_player.name == 'ai' && next_game_state_rank > alpha
    alpha
  end
  
  def set_beta(next_game_state_rank, next_player, alpha, beta)
    beta = next_game_state_rank if next_player.name == 'human' && next_game_state_rank < beta 
    beta
  end

  def next_move(game_state)
    game_state.moves.max { |a, b| rank(a) <=> rank(b) }
  end

  def rank(game_state)
    if game_state.final_state?
      final_state_rank(game_state)
    else
      intermediate_state_rank(game_state) * 0.9
    end
  end

  def intermediate_state_rank(game_state)
    ranks = game_state.moves.collect { |game_state| rank(game_state) }
    if game_state.current_player.name == 'ai'
      ranks.max
    else
      ranks.min
    end
  end

  def final_state_rank(game_state)
    winning_cell_results = game_state.winning_cells
    return 0 if game_state.draw?(winning_cell_results)
    if winning_cell_results.first.value == game_state.ai_value
      winning_cell_results.map { |winning_cell| winning_cell.win = true }
      1
    else
      -1
    end
  end


end
