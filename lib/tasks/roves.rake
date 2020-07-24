namespace :rovers do
  desc 'Movimenta rovers com base em um arquivo'
  task :move, [:file_path] => :environment do |_, args|
    puts 'File path é obrigatorio' unless args[:file_path]

    MoveRoversService.perform!(args[:file_path])
  end
end
