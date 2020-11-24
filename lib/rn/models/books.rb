require 'rn/paths'
require 'terminal-table'
module RN
    class Book
        def self.create_book(name)
            if name == "Cuaderno global"
                puts "No se puede crear este directorio porque ya existe"
                return
            end
            regex=/[*?!|<>.|\/|\|\\|]+/
            if !Dir.exist?(File.join(Paths.get_rootPath, name))
            if !regex.match(name)
                Dir.mkdir(File.join(Paths.get_rootPath, name), 0700)
            else
                puts "El nombre del directorio es incorrecto"
            end
            else
                puts "El nombre del directorio ya existe, por favor ingrese otro."
            end
        end

        def self.delete_book(name, global)
            if name == "Cuaderno Global"
                puts "No se puede eliminar este directorio"
                return
            end
            if global
                directory_path=Paths.get_globalPath
                Dir.foreach(directory_path) do |file|
                  if !['.','..'].include?(file)
                    File.delete(File.join(directory_path,file)) 
                  end
                end
            else
                directory_path=File.join(Paths.get_rootPath, name)
                if Dir.exist?(directory_path)
                  Dir.foreach(directory_path) do |file|
                    if !['.','..'].include?(file)
                      File.delete(File.join(directory_path,file)) 
                    end
                  end
                  Dir.delete(directory_path)
                end
            end 
        end

        def self.list_book()
            table = Terminal::Table.new :headings => ['Directorios']
            Dir.foreach(Paths.get_rootPath) do |directory|
              table.add_row [directory] unless directory.include?(".")
            end
            puts table
        end

        def self.rename_book(old_name,new_name)
            directory_path=File.join(Paths.get_rootPath, old_name)
            directory_path2=File.join(Paths.get_rootPath, new_name)
            regex=/[*?!|<>.|\/|\|\\|]+/
            if old_name != "global" or new_name != "global"
              if Dir.exist?(directory_path) 
                if !regex.match(new_name)
                  File.rename(directory_path,directory_path2)
                else
                  puts "El nombre del nuevo libro es incorrecto"
                end
              else
                  puts "El directorio buscado no existe"
              end
            else
              puts "No se puede renombrar el cuaderno global"
            end
        end
    end
end