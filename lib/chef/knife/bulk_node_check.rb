require 'chef/knife'
require_relative 'helpers/bulk_node_base.rb'

class Chef
  class Knife
    class BulkNodeCheck < Chef::Knife

      include Chef::Knife::BulkNodeBase

      deps do
        require 'chef/json_compat' unless defined?(Chef::JSONCompat)
        require 'chef/server_api' unless defined?(Chef::ServerAPI)
      end

      banner 'knife bulk node check [NODE_NAME [NODE_NAME]] (options)'
      category 'bulk'

      def run
        STDOUT.sync = STDERR.sync = true

        config[:format] = 'json'

        api   = Chef::ServerAPI.new
        nodes = bulk_args
        resp  = {
          :errors => false,
          :items  => {
            :nodes   => [],
            :clients => []
          }
        }

        nodes.each do |node_name|
          begin
            api.head("nodes/#{node_name}")

            resp[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'head',
              :successful => true
            }
          rescue StandardError => e
            resp[:errors] ||= true
            message, code   = parse_exception(e)

            ui.error("Encountered #{e.class} when checking node '#{node_name}'\n#{e}")

            resp[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'head',
              :successful => false,
              :error      => {
                :code    => code,
                :message => message
              }
            }
          end

          unless config[:include_clients]
            ui.output(resp)
            return
          end

          begin
            _ = api.get("clients/#{node_name}")

            resp[:items][:clients] << {
              :client_name  => node_name,
              :method      => 'head',
              :successful  => true
            }
          rescue StandardError => e
            resp[:errors] ||= true
            message, code   = parse_exception(e)

            ui.error("Encountered #{e.class} when checking client '#{node_name}'\n#{e}")

            resp[:items][:clients] << {
              :client_name => node_name,
              :method      => 'head',
              :successful  => false,
              :error       => {
                :code    => code,
                :message => message
              }
            }
          end
        end

        ui.output(resp)
      end

    end
  end
end
