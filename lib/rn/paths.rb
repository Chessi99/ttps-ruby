class Paths
    #attr_reader :path
    @@path=""
    def self.global_notebook
        @@path=File.join(Dir.home, ".my_rns")
        if !Dir.exist?(@@path)
            Dir.mkdir(@@path)
            global_book = File.join(@@path, "Cuaderno Global")
            Dir.mkdir(global_book)
        end
    end

    def self.get_rootPath
        return @@path
    end
    def self.get_globalPath
        return File.join(@@path,"Cuaderno Global")
    end

end