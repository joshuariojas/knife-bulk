require 'chef/knife'

class Chef
  class Knife
    class BatchNodeDelete < Chef::Knife
      banner 'knife batch node delete NODE_LIST (options)'
      category 'batch'

      def run
        STDOUT.sync = STDERR.sync = true

        if @named_args.empty?
          ui.error "Please specify the node list path. e.g-  'knife batch node delete <path>'"
          exit 1
        end

        file_path = @named_args.first
        api_endpoint = 'nodes/'
      end
    end
  end
end
