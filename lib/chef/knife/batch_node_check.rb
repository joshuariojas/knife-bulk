require 'chef/knife'
require_relative 'helpers/batch_base.rb'

class Chef
  class Knife
    class BatchNodeCheck < Chef::Knife

      deps do
        require 'chef/json_compat' unless defined?(Chef::JSONCompat)
        require 'chef/server_api' unless defined?(Chef::ServerAPI)
      end

      banner 'knife batch node check NODE_LIST (options)'
      category 'batch'

      def run
        STDOUT.sync = STDERR.sync = true

        file_path = @name_args[0]

        if file_path.nil?
          show_usage
          ui.fatal('You must specify a path to a node list')
          exit 1
        end

        unless file_exists_and_readable?(file_path)
          ui.fatal("Could not find or open file '#{file_path}'")
          exit 1
        end

        api = Chef::ServerAPI.new
        res = {}

        File.foreach(file_path) do |node_name|
          next if node_name.strip! == ''

          begin
            api.head("nodes/#{node_name}")
            res[node_name] = 'exists'
          rescue Exception => e
            ui.error("#{e.class} raised when checking node '#{node_name}'\n#{e}")
            res[node_name] = 'not found'
          end
        end

        config[:format] = 'json'
        ui.output(res)
      end

    end
  end
end
