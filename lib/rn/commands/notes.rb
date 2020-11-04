require 'rn/paths'
require 'terminal-table'
module RN
  module Commands
    module Notes
      class Create < Dry::CLI::Command
        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book.nil? 
            note=Paths.get_globalPath
          else
            note=File.join(Paths.get_rootPath,book)
          end
          note=File.join(note,title + ".rn")
          if !File.exist?(note)
            File.new(note,"w+")
            puts "La nota se creo exitosamente"
          else
            puts "El nombre de la nota ya existe"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book.nil? 
            note=Paths.get_globalPath
          else
            note=File.join(Paths.get_rootPath,book)
          end
          note=File.join(note,title)
          if !File.exist?(note)
            File.delete(note)
            puts "La nota se elimino exitosamente"
          else
            puts "El nombre de la nota no existe"
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if book.nil? 
            note=Paths.get_globalPath
          else
            note=File.join(Paths.get_rootPath,book)
          end
          note=File.join(note,title)
          puts "Agregar la extension .rn para la edicion de una nota"
          if File.exist?(note)
            TTY::Editor.open(note)
          end
        end
      end

      class Retitle < Dry::CLI::Command
        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]
          if book.nil?
            note=Paths.get_globalPath
          else
            note=File.join(Paths.get_rootPath,book)
          end
          old_note=File.join(note,old_title)
          new_note=File.join(note,new_title)
          if File.exist?(note)
            File.rename(old_note,new_note)
          end
        end
      end
      class List < Dry::CLI::Command #FALTA HACER EL LIST
        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]
          if global
            note=Paths.get_globalPath
            directorios="Directorio del Cuaderno Global:"
          elsif book
            note=File.join(Paths.get_rootPath,book)
            directorios="Directorio '#{book}':"
          else
            note=File.join(Paths.get_rootPath)
            directorios="Todos los directorios:"
          end
          table = Terminal::Table.new :title => "#{directorios}'", :headings => ['Notas']
          Dir.foreach(note) do |directory|
            Dir.foreach(directory) do |file|
              table.add_row [file]
            end
          end
          puts table
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          if !book.nil? and !book.empty
            note=Paths.get_globalPath
          else
            note=File.join(Paths.get_rootPath,book)
          end
          note=File.join(note,title)
          if File.exist?(note)
            if File.empty?(note)
              table = Terminal::Table.new do |t|
                t.title = title
                File.open(path).each do |line|
                  t.add_row [line] 
                end
              end
            else
              puts "La nota esta vacia"
            end
          else
              puts "La nota no existe"
          end
        end
      end

    end
  end
end

