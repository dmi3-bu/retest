module Retest
  class ListenOptions
    IGNORE_REGEX = /node_modules|tmp|\.sqlite|\.byebug_history/

    class << self
      def to_h(tool = GitTool.new)
        return {ignore: IGNORE_REGEX, relative: true} unless tool.installed?

        {only: regex_for(tool.files), relative: true}
      end

      private

      def regex_for(files)
        Regexp.new files.split("\n").join('|')
      end
    end
  end

  class GitTool
    attr_reader :name
    alias :to_s :name

    def initialize
      @name = 'git'
    end

    def installed?
      system "git -C . rev-parse 2>/dev/null"
    end

    def files
      `git ls-files`
    end
  end
end