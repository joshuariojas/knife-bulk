require 'chef/knife'

class Chef
  class Knife
    module BatchSharedOptions

      def self.included(includer)
        includer.class_eval do

          option :from_file,
            long: '--from-file FILE',
            description: 'File containing list of objects to pass to subcommand in place of expected argument(s)'

        end
      end

    end
  end
end
