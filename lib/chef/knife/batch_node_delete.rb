require 'chef/knife'
require_relative 'helpers/batch_node_base'

class Chef
  class Knife
    class BatchNodeDelete < Chef::Knife

      include Chef::Knife::BatchNodeBase

      banner 'knife batch node delete [NODE_NAME [NODE_NAME]] (options)'
      category 'batch'

      def run
        STDOUT.sync = STDERR.sync = true

        config[:format] = 'json'

        api   = Chef::ServerAPI.new
        nodes = batch_args
        resp  = {
          :errors => false,
          :items  => {
            :nodes   => [],
            :clients => []
          }
        }

        nodes.each do |node_name|
          node_name = node_name.strip
          next if node_name == ''

          begin

          rescue StandardError => e

          end

          unless config[:include_clients]
            ui.output(resp)
            return
          end

          begin

          rescue StandardError => e

          end

        end

      end
    end
  end
end
