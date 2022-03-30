require 'chef/knife'

class Chef
  class Knife
    class BatchNodeHead < Chef::Knife

      deps do
        require 'chef/json_compat' unless defined?(Chef::JSONCompat)
      end

      banner 'knife batch node head NODE_LIST (options)'
      category 'batch'

      option :append_domain,
        short: '-ad',
        long: '--append-domain',
        description: 'Append domain name to each hostname within NODE_LIST during HTTP request '

      def file_exists_and_readable?(path)
        File.exist?(file) && File.readable?(file)
      end

      def run
        STDOUT.sync = STDERR.sync = true

        file_path = @name_args[0]

        if file_path.nil?
          show_usage
          ui.fatal('You must specify a path to a node list')
          #ui.error "Please specify the node list path. e.g-  'knife batch node head <path>'"
          exit 1
        end

        unless file_exists_and_readable?(file_path)
          ui.fatal("Could not find or open file '#{file_path}'")
          exit 1
        end

        results = {}

        File.foreach(file_path) do |node_name|
          next if node_name.strip! == ''

          begin
            api.head("nodes/#{node_name}")
            results[node_name] = 'exists'
          rescue NET::HTTPServerException => e
            ui.error("Encountered NET::HTTPServerException node '#{node_name}'\n#{e}")
            results[node_name] = 'not found'
          end
        end

        config[:format] = 'json'
        ui.output(results)
      end

    end
  end
end
