require './game.rb'
require './q_learning_player.rb'

p = QLearningPlayer.new
g = Game.new( p )
p.game = g

1000.times do
  p.load_qtable
  g.run
  p.save_qtable
  g.reset
end

p.print_table


puts ""
