require 'chef/knife'
require_relative 'helpers/batch_node_base.rb'

class Chef
  class Knife
    class BatchNodeCheck < Chef::Knife

      include Chef::Knife::BatchNodeBase

      deps do
        require 'chef/json_compat' unless defined?(Chef::JSONCompat)
        require 'chef/server_api' unless defined?(Chef::ServerAPI)
      end

      banner 'knife batch node check [NODE_NAME [NODE_NAME]] (options)'
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
            api.head("nodes/#{node_name}")

            resp[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'head',
              :successful => true
            }
          rescue StandardError => e
            resp[:errors] ||= true
            code, message   = parse_exception(e)

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
            code, message   = parse_exception(e)

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
