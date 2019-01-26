require "thor"

module ScoringHorseRacing
  class CLI < Thor
    desc "hello", "Say Hello."
    def hello
      puts "hello"
    end

    desc "version", "Display version"
    def version
      puts ScoringHorseRacing::VERSION
    end
  end

    
end
