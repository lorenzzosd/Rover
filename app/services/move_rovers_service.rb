class MoveRoversService
  def self.perform!(file_path)
    @result = { success?: false, error: nil }

    begin
      File.open(file_path, 'r').each_with_index do |line, index|
        striped_line = line.strip
        if index.zero?
          process_coordinates_line(striped_line) ? next : break
        end

        if index.odd?
          break unless build_rover(striped_line, index)
        else
          break unless process_commands_line(striped_line, index)
        end
      end
    rescue Errno::ENOENT => e
      @result[:error] = 'Arquivo inesistente'
    end

    if @result[:success?]
      # puts 'Rovers movidos com sucesso'
    else
      puts @result[:error]
    end
  end

  private

  def self.build_rover(line, line_index)
    @current_rover = Rover.new(line, @upper_right_coordinates)

    attrs_result = @current_rover.set_attributes

    unless attrs_result.sucess?
      set_result_to_false(attrs_result.error, line_index)

      return false
    end

    true
  end

  def self.process_coordinates_line(line)
    unless valid_coordinates?(line)
      set_result_to_false('Coordenadas invalidas')

      return false
    end

    @upper_right_coordinates = { x: line[0], y: line[1] }

    @result[:success?] = true
  end

  def self.valid_coordinates?(line)
    line.size == 2 && line.chars.none? { |c| c.to_i.zero? }
  end

  def self.process_commands_line(line, line_index)
    line.each_char.with_index(1) do |command, i|
      command_result = @current_rover.run_command!(command)

      if command_result.sucess?
        puts @current_rover.final_position if line.size == i
      else
        set_result_to_false(command_result.error, line_index)

        return false
      end

      true
    end
  end

  def self.set_result_to_false(error, line_index = nil)
    @result[:success?] = false
    @result[:error] = if line_index.present?
                        "Linha: #{line_index + 1}, #{error}"
                      else
                        error
                      end
  end
end
