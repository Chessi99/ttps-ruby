require 'rn/paths'
require 'terminal-table'
module RN
  module Commands
    module Books
      class Create < Dry::CLI::Command
        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
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
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]
          if name == "Cuaderno global"
            puts "No se puede eliminar este directorio"
            return
          end
          directory_path=File.join(Paths.get_rootPath, name)
          if Dir.exist?(directory_path)
            Dir.foreach(directory_path) do |file|
              if !file == "." || !file == ".."
                File.delete(file) 
              end
            end
            Dir.delete(directory_path)
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List books'
        example [
          '          # Lists every available book'
        ]

        def call(*)
          table = Terminal::Table.new :headings => ['Directorios']
          Dir.foreach(Paths.get_rootPath) do |directory|
            if directory 
              table.add_row [directory] unless directory.include?(".")
            end
            
          end
          puts table
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          directory_path=File.join(Paths.get_rootPath, old_name)
          directory_path2=File.join(Paths.get_rootPath, new_name)
          regex=/[*?!|<>.|\/|\|\\|]+/
          if Dir.exist?(directory_path) 
            if !regex.match(new_name)
              File.rename(directory_path,directory_path2)
            else
              puts "El nombre del nuevo libro es incorrecto"
            end
          else
              puts "El directorio buscado no existe"
          end
        end
      end
    end
  end
end
