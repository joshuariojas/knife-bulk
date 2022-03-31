require 'chef/knife'

class Chef
  class Knife
    module BatchBase

      def self.included(includer)
        includer.class_eval do

          option :append_domain,
            short: '-ad DOMAIN',
            long: '--append-domain DOMAIN',
            description: 'Domain that will be appended to each node during HTTP request'

          option :from_file,
            short: '-ff FILE',
            long: '--from-file FILE',
            description: 'File containing list of nodes to pass to subcommand in place of NODE'

        end
      end

      def file_exists_and_readable?(path)
        File.exist?(path) && File.readable?(path)
      end

    end
  end
end
