require 'rubygems'
require 'terminal-table'

class StatesSpace  
  class State
    attr_reader :row, :column
    attr_accessor :goal, :value
    def initialize(row, column)
      @row, @column = row, column
      @goal = false
      @value = 0
    end
    
    def eq(s)
      row == s.row && column == s.column
    end
    
    def to_s
      "(#{row}, #{column})"
    end
  end
  
  include Enumerable
  
  def initialize(height, width)
    @width, @height = width, height
    @states = {}
    (1..@height).each do |row|
      (1..@width).each do |column|
        @states[[row, column]] = State.new(row, column)
      end
    end 
  end
  
  def [](row, column)
    @states[[row, column]]
  end
  
  def each(&block)
    @states.values.each(&block)
  end
  
  def actions
    [:north, :east, :south, :west]
  end
  
  def reverse(action)
    actions[(actions.index(action) + 2) % 4]
  end
  
  def apply(action, state)
    [[0.8, next_state(action, state)], [0.2, next_state(reverse(action), state)]]
  end
  
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end
  
  def total_value
    inject(0) { |sum, state| sum + state.value  }
  end
  
  def to_s
    table = Terminal::Table.new do |t|
      (1..@height).each do |row|
        vs = []
        (1..@width).each do |column|
          vs << self[row, column].value
        end
        t << vs
        t.add_separator unless row == @height
      end
    end
    table.to_s
  end
  
  private
  def next_state(action, state)
    case action
    when :north
      self[state.row - 1, state.column] || state
    when :east
      self[state.row, state.column + 1] || state
    when :south
      self[state.row + 1, state.column] || state
    when :west
      self[state.row, state.column - 1] || state
    end
  end
end


space = StatesSpace.new(2, 4)
space[2, 1].value = -100
space[2, 4].value = 100
space[2, 1].goal = true
space[2, 4].goal = true


def value_iteration(space, rs)
  while (x = single_backup(space, rs)) > 0.00001
    print('.')
  end
  puts
end

def single_backup(space, rs)
  old_space = space.deep_clone
  space.each do |state|
    next if state.goal
    state.value = old_space.actions.collect do |action|
      old_space.apply(action, state).inject(0) { |sum, q| sum + q.first * q.last.value }
    end.max + rs
  end
  space.total_value - old_space.total_value
end

def pi_s(space, row, column)
  result = {}
  state = space[row, column]
  space.actions.each do |action|
    result[action] = space.apply(action, state).inject(0) { |sum, q| sum + q.first * q.last.value }
  end
  result
end

value_iteration(space, -4)
puts space
p pi_s(space, 2, 3)












