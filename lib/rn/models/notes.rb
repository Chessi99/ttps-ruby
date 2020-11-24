require 'rn/paths'
require 'terminal-table'
module RN
    class Note
        def self.create_note(title,book)
            if book.nil? 
                note=Paths.get_globalPath
            else
                note=File.join(Paths.get_rootPath,book)
            end
            note=File.join(note,title + ".rn")
            regex=/[*?!|<>.|\/|\|\\|]+/
            if !regex.match(title)
                if !File.exist?(note)
                  File.new(note,"w+")
                  puts "La nota se creo exitosamente"
                else
                  puts "El nombre de la nota ya existe"
                end
            else
                puts "El nombre de la nota es incorrecto"
            end
        end

        def self.delete_note(title,book)
            if book.nil? 
                note=Paths.get_globalPath
            else
                note=File.join(Paths.get_rootPath,book)
            end
            note=File.join(note,title +".rn")
            if File.exist?(note)
                File.delete(note)
                puts "La nota se elimino exitosamente"
            else
                puts "El nombre de la nota no existe"
            end 
        end

        def self.edit_note(title,book)
            if book.nil? 
                note=Paths.get_globalPath
            else
                note=File.join(Paths.get_rootPath,book)
            end
            note=File.join(note,title + ".rn")
            if File.exist?(note)
                TTY::Editor.open(note)
            else
                puts "La nota ingresada no existe"
            end
        end

        def self.retitle_note(old_title,new_title,book)
            if book.nil?
                note=Paths.get_globalPath
            else
                note=File.join(Paths.get_rootPath,book)
            end
            old_note=File.join(note,old_title + ".rn")
            new_note=File.join(note,new_title + ".rn")
            regex=/[*?!|<>.|\/|\|\\|]+/
            if !regex.match(new_title)
                puts File.exist?(old_note)
                puts old_note
                puts new_note
                if File.exist?(old_note)
                  File.rename(old_note,new_note)
                end
            else
                puts "El nombre nuevo es incorrecto"
            end
        end

        def self.list_notes(global,book)
            table = Terminal::Table.new :title => "Notas"
            if global
                note=Paths.get_globalPath
                Dir.each_child( note ) {| file | table.add_row [file] }
            elsif book
                note=File.join(Paths.get_rootPath,book)
                Dir.each_child( note ) {| file | table.add_row [file] }
            else
                note=File.join(Paths.get_rootPath)
                Dir.each_child( note ) {| directoryname | Dir.each_child(File.join(note, directoryname)) {| file | table.add_row [file] }  unless directoryname.include? "." }
            end
            puts table
        end
    

        def self.show_notes(title,book)
            if book.nil?
                note=Paths.get_globalPath
            else
                note=File.join(Paths.get_rootPath,book)
            end
            note=File.join(note,title + ".rn")
            if File.exist?(note)
                if !File.empty?(note)
                  table = Terminal::Table.new do |t|
                    t.title = title
                    File.open(note).each do |line|
                      t.add_row [line] 
                    end
                  end
                  puts table
                else
                  puts "La nota esta vacia"
                end
            else
                  puts "La nota no existe"
            end
        end

        def self.export_note(title,book)
            if title    
                if book.nil?
                    nameFile=Paths.get_globalPath
                else
                    nameFile=File.join(Paths.get_rootPath,book)
                end
                if !File.exist?(nameFile)
                    puts "El cuaderno #{book} no existe"
                    return
                end

                nameFile=File.join(nameFile,title)
                if File.exist?(nameFile)      
                    create_export_file(nameFile)
                else
                    puts "No existe la nota #{title}"
                end
                return
            end
            if !book.nil? && File.exist?(File.join(Paths.get_rootPath,book))
                export_book(book)
                return
            end
            export_all_notes()
        end

        def self.export_book(book)
            note=File.join(Paths.get_rootPath,book)
            Dir.each_child( note ) {| file | create_export_file(File.join(note,file)) }
        end

        def self.export_all_notes()
            Dir.each_child( Paths.get_rootPath ) {| directoryname | Dir.each_child(File.join(Paths.get_rootPath, directoryname)) {| file | create_export_file(File.join(Paths.get_rootPath, directoryname,file)) }  unless directoryname.include? "." }
        end
        def self.create_export_file(nameFile)
            content=File.read(nameFile).to_s
            markdown= Redcarpet::Markdown.new(Redcarpet::Render::HTML,autolink: true, tables: true)
            new_content =markdown.render(content)
            File.open(nameFile.gsub(".rn",".html"), 'w') { |f| f.write new_content}
        end
    end
end