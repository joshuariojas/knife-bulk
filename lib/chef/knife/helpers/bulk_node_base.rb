require 'chef/knife'
require_relative 'bulk_shared_options'

class Chef
  class Knife
    module BulkNodeBase

      def self.included(includer)
        includer.class_eval do

          include Chef::Knife::BulkSharedOptions

          deps do
            require 'chef/json_compat' unless defined?(Chef::JSONCompat)
            require 'chef/server_api' unless defined?(Chef::ServerAPI)
          end

          option :append_domain,
            long: '--append-domain DOMAIN',
            description: 'Domain that will be appended to each node during HTTP request'

          option :include_clients,
            long: '--[no-]include-clients',
            description: 'Include operations against client objects',
            boolean: true,
            default: true

          def append_domain(nodes)
            if config.has_key?(:append_domain)
              return nodes.map { |line| "#{line}.#{config[:append_domain]}" }
            else
              return nodes
            end
          end

          def file_exists_and_readable?(path)
            File.exist?(path) && File.readable?(path)
          end

          def bulk_args
            unless config.has_key?(:from_file)
              if @name_args.size == 0
                ui.fatal('You must provide at least one node name')
                exit 1
              end

              return append_domain(@name_args)
            end

            if file_exists_and_readable?(config[:from_file])
              nodes = File.readlines(config[:from_file], chomp: true).map(&:strip).reject(&:empty?)

              if nodes.size == 0
                ui.fatal("Invalid value provided to option '--from-file'. File '#{config[:from_file]} was empty'")
                exit 1
              end

              return append_domain(nodes)
            else
              show_usage
              ui.fatal("Invalid value provided to option '--from-file'. Could not find or open file '#{config[:from_file]}'")
              exit 1
            end
          end

          def parse_exception(exception)
            # TODO
            # Extend this to handling different exception categories.
            # exception.class.name.include? 'HTTP' is for handing the family of errors under net/http, but it is barely best effort
            # Undecided on how to handle returns. Currently, the else case intends that code will be set to nil, and a caller may need to
            # check for an exception category that is not yet support below.
            #
            # message, code = parse_exception(exception)
            # if code.nil? then do the things

            if exception.class.name.include?('HTTP')
              code, message = exception.message.split(' ', 2)
              return message.delete_suffix('"').delete_prefix('"'), code
            else
              return exception.message, nil
            end
          end

        end
      end

    end
  end
end
