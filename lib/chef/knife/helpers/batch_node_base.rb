require 'chef/knife'

class Chef
  class Knife
    module BatchNodeBase

      def self.included(includer)
        includer.class_eval do

          deps do
            require 'chef/json_compat' unless defined?(Chef::JSONCompat)
            require 'chef/server_api' unless defined?(Chef::ServerAPI)
          end

          option :append_domain,
            long: '--append-domain DOMAIN',
            description: 'Domain that will be appended to each node during HTTP request'

          option :from_file,
            long: '--from-file FILE',
            description: 'File containing list of objects to pass to subcommand in place of expected argument(s)'

          option :skip_client,
            long: '--skip-client',
            description: 'Skip checking against client objects '

          if config.has_key?(:from_file)
            file_path = config[:from_file]

            if file_path.nil?
              ui.fatal('You must specify a path to an object list')
              exit 1
            elsif file_exists_and_readable(file_path)
              show_usage
              ui.fatal("Could not find or open file '#{file_path}")
              exit 1
            end
          end

          def file_exists_and_readable?(path)
            File.exist?(path) && File.readable?(path)
          end

          def batch_args
            if config.has_key?(:from_file) && file_exists_and_readable(config[:from_file])
              File.readline(config[:from_file], chomp: true)
            else
              @name_args
            end
          end

          def parse_exception(exception)
            code, message = exception.message.split(' ', 2)
            return code, message.delete_suffix('"').delete_prefix('"')
          end

        end
      end

    end
  end
end
