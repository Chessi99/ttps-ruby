class Paths
    #attr_reader :path
    @@path=""
    def self.global_notebook
        @@path=File.join(Dir.home, ".my_rns")
        if !Dir.exist?(@@path)
            Dir.mkdir(@@path)
            path=File.join(@@path, "Cuaderno Global")
            Dir.mkdir(@path)
        end
    end

    def self.get_rootPath
        return @@path
    end
    def self.get_globalPath
        return File.join(@@path,"Cuaderno global")
    end
end