module Search
  class Path
    attr_reader :parent_path
    def initialize(state, parent_path=nil)
      @state = state
      @parent_path = parent_path
    end

    def last
      @state
    end

    def append(state)
      self.class.new(state, self)
    end

    def length
      return 1 unless parent_path
      parent_path.length + 1
    end

    def ==(another)
      last == another.last && parent_path == another.parent_path
    end

    def to_s
      return @state.to_s unless parent_path
      parent_path.to_s + ">" + @state.to_s
    end
  end

  module BreathFirst
    module_function
    def remove_choise(fontier, problem)
      fontier.sort_by!(&:length).shift
    end
  end

  module DepthFirst
    module_function
    def remove_choise(fontier, problem)
      fontier.sort_by!(&:length).pop
    end
  end

  module AStar
    module_function
    def remove_choise(fontier, problem)
      fontier.sort_by! do |path|
        g = path.length
        h = problem.estimate_cost(path.last)
        g + h
      end.shift
    end
  end

  
  class << self
    def tree_search(problem, algrithom=BreathFirst)
      fontier = [Path.new(problem.initial_state)]
      loop do
        return 'failed' if fontier.empty?
        path = algrithom.remove_choise(fontier, problem)

        puts "examing path: #{path}"
        s = path.last
        return path if problem.goal?(s)
        problem.actions(s).each do |a|
          fontier.push(path.append(problem.apply(s, a)))
        end
      end
    end

    def graph_search(problem, algrithom=BreathFirst)
      fontier = [Path.new(problem.initial_state)]
      explored = []
      loop do
        return 'failed' if fontier.empty?
        path = algrithom.remove_choise(fontier, problem)

        puts "examing path: #{path}"
        s = path.last
        explored.push(s)
        return path if problem.goal?(s)
        problem.actions(s).each do |a|
          new_state = problem.apply(s, a)
          fontier.push(path.append(new_state)) unless explored.include?(new_state)
        end
      end
    end

  end
end



class TablePathProblem
  def initial_state
    [1, 1]
  end

  def goal?(state)
    state == [6, 4]
  end

  def actions(state)
    result = []
    result << :left if state.first > 1
    result << :right if state.first < 6
    result << :up if state.last > 1
    result << :down if state.last < 4
    result
  end

  def apply(state, action)
    case action
    when :left
      [state.first - 1, state.last]
    when :right
      [state.first + 1, state.last]
    when :up
      [state.first, state.last - 1]
    when :down
      [state.first, state.last + 1]
    else
      raise 'unknow action'
    end
  end

  def estimate_cost(state)
    return 0 if goal?(state)
    return 1 if state.last == 4
    return 1 if state.first == 6
    return 2 if state.last == 3
    return 2 if state.first == 5
    return 3 if state.last == 2
    return 3 if state.first == 4
    return 4 if state.last == 1
    raise 'huu?'
  end
end


ret = Search.graph_search(TablePathProblem.new, Search::AStar)

puts "result -> #{ret}"
puts "length -> #{ret.length}"

