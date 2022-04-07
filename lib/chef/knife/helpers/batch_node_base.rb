require 'chef/knife'
require_relative 'batch_shared_options'

class Chef
  class Knife
    module BatchNodeBase

      def self.included(includer)
        includer.class_eval do

          include Chef::Knife::BatchSharedOptions

          deps do
            require 'chef/json_compat' unless defined?(Chef::JSONCompat)
            require 'chef/server_api' unless defined?(Chef::ServerAPI)
          end

          option :append_domain,
            long: '--append-domain DOMAIN',
            description: 'Domain that will be appended to each node during HTTP request'

          option :include_clients,
            long: '--[no]-include-clients',
            description: 'Include operations against client objects',
            boolean: true,
            default: true

          def file_exists_and_readable?(path)
            File.exist?(path) && File.readable?(path)
          end

          def batch_args
            unless config.has_key?(:from_file)
              return @name_args
            end

            if file_exists_and_readable?(config[:from_file])
              File.readlines(config[:from_file], chomp: true)
            else
              show_usage
              ui.fatal("Invalid value provided to option '--from-file'. Could not find or open file '#{config[:from_file]}'")
              exit 1
            end
          end

          def parse_exception(exception)
            # TODO
            # Add something in here about handling different exception categories.
            # Exception.class.to_s.include? 'HTTP'

            code, message = exception.message.split(' ', 2)
            return code, message.delete_suffix('"').delete_prefix('"')
          end

        end
      end

    end
  end
end
