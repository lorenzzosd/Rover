class Rover
  RIGHT_COMMAND = {
    'N' => 'E',
    'E' => 'S',
    'S' => 'O',
    'O' => 'N'
  }.freeze

  LEFT_COMMAND = {
    'N' => 'O',
    'O' => 'S',
    'S' => 'E',
    'E' => 'N'
  }.freeze

  def initialize(line, upper_right_coordinates)
    @line = line
    @upper_right_coordinates = upper_right_coordinates
  end

  def run_command!(command)
    attrs = if valid_command?(command)
      command == 'M' ? move! : set_next_direction(command)

      { sucess?: true, error: nil }
    else
      { sucess?: false, error: 'Comando invalido'}
    end

    OpenStruct.new(attrs)
  end

  def final_position
    "#{@position[:x]}#{@position[:y]}#{@direction}"
  end

  def set_attributes
    attrs = if valid_start_line?
      @position, @direction = parse_start_position, parse_start_direction

      { sucess?: true, error: nil }
    else
      { sucess?: false, error: 'Posição inicial ou direção invalida' }
    end

    OpenStruct.new(attrs)
  end

  private

  def move!
    case @direction
    when 'S' then @position[:y] -= 1
    when 'N' then @position[:y] += 1
    when 'O' then @position[:x] -= 1
    when 'E' then @position[:x] += 1
    end
  end

  def set_next_direction(command)
    if command == 'R'
      @direction = Rover::RIGHT_COMMAND[@direction]
    else
      @direction = Rover::LEFT_COMMAND[@direction]
    end
  end

  def parse_start_position
    {
      x: @line[0].to_i,
      y: @line[1].to_i
    }
  end

  def parse_start_direction
    @line[2]
  end

  def valid_start_line?
    @line.size == 3 && %w[S N O E].include?(@line.last)
  end

  def valid_command?(command)
    %w[L R M].include?(command)
  end
end
