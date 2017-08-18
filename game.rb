class Game
  attr_accessor :score, :map_size
  MAX_SCORE = 7
  def initialize player
    @run = 0
    @map_size = 24
    @rows = 4
    @cheese_x = 15
    @start_position = rand(@cheese_x / 2) + @run + rand(@cheese_x / 2)
    @player = player
    reset
  end

  def params_description
    [@map_size, "places in", @rows, "rows", "cheese at", @cheese_x, "start at", @start].join(' ')
  end

  def clear_console
    puts "\e[H\e[2J"
  end

  def reset
    @player.x = @start_position
    @cheese_x = 15
    @pit_x = 0
    @score = 0.0
    @run += 1
    @moves = 0
  end

  def run
    while @score < MAX_SCORE && @score > -MAX_SCORE
      draw
      gameloop
      @moves += 1
    end

    # Draw one last time to update the
    draw

    if @score >= MAX_SCORE
      puts "  You win in #{@moves} moves!"
    elsif @score < MAX_SCORE * 10
      puts "  Game over"
    end

  end

  def line_size
    @map_size/@rows
  end

  def gameloop
    move = @player.get_input
    if move == :left
      @player.x = @player.x > 0 ? @player.x-1 : @map_size-1
    elsif move == :right
      @player.x = @player.x < @map_size-1 ? @player.x+1 : 0
    elsif move == :down
      @player.x = @player.x < line_size - 1 ? line_size : 0
    elsif move == :up
      @player.x = @player.x > line_size - 1 ? -line_size : 0
    end

    if @player.x == @cheese_x
      @score += 1
      @player.x = @start_position
    end

    if @player.x == @pit_x
      @score -= 1
      @player.x = @start_position
    end
  end

  def draw
    clear_console
    # Compute map line
    map_line = @map_size.times.map do |i|
      output = if @player.x == i
        'P'
      elsif @cheese_x == i
        'C'
      elsif @pit_x == i
        'O'
      else
        '='
      end

      output = "\n #{output}" if i % (@map_size / @rows) == 0
      output
    end
    map_line = "##{map_line.join}#\nScore #{@score}\nRun #{@run}"

    # Draw to console
    # use printf because we want to update the line rather than print a new one
    printf("%s", map_line)
  end
end
