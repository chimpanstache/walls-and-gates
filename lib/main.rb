# frozen_string_literal: true

ROOM = 2_147_483_647
GATE = 0
WALL = -1

def walls_and_gates(rooms)
  rooms.reverse!
  updated_grid = []
  (0..(rooms.length - 1)).each do |abscissa|
    updated_row = []
    (0..(rooms[0].length - 1)).each do |ordinate|
      updated_row << updated_value(rooms, abscissa, ordinate)
    end
    updated_grid << updated_row
  end
  updated_grid.reverse!
end

def updated_value(rooms, abscissa, ordinate)
  rooms[abscissa][ordinate] == ROOM ? distance(rooms, abscissa, ordinate) : rooms[abscissa][ordinate]
end

def distance(rooms, abscissa, ordinate)
  path = shortest_path(rooms, abscissa, ordinate)
  path == ROOM ? ROOM : (path.flatten[0..-2].length / 2)
end

def shortest_path(rooms, abscissa, ordinate)
  queue = [] << [abscissa, ordinate]

  until queue.empty?
    current = queue.shift
    visited = []
    current.flatten.each_slice(2) { |slice| visited << slice }
    return current if shortest_path?(current, rooms)

    s_q = surrounding_squares(rooms, current[0], current[1])
    return ROOM if s_q.all? { |coordinates| rooms[coordinates[0]][coordinates[1]] == WALL }
    s_q.each do |square|
      next if visited.include?([square[0], square[1]]) || rooms[square[0]][square[1]] == WALL
      visited << [square[0], square[1]]
      square << current
      queue << square
    end
  end
  ROOM
end

def shortest_path?(current, rooms)
  return false if rooms[current[0]][current[1]] != GATE

  current.drop(2).flatten.each_slice(2) do |length, depth|
    return false if rooms[length][depth] != ROOM
  end
  true
end

def surrounding_squares(rooms, abscissa, ordinate)
  all_moves = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  squares = []
  all_moves.each do |move|
    calculation = [] << move << [abscissa, ordinate]
    calculation = calculation.transpose.map!(&:sum)
    squares << calculation if inside_grid?(calculation, rooms)
  end
  squares
end

def inside_grid?(calculation, rooms)
  calculation[0] >= 0 && calculation[0] <= (rooms.length - 1) && calculation[1] >= 0 && calculation[1] <= (rooms[0].length - 1)
end
