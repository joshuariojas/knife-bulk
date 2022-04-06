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
        res   = {
          :errors => false,
          :items  => {
            :nodes   => [],
            :clients => []
          }
        }

        nodes.each do |node_name|
          next if node_name.strip! == ''

          begin
            api.head("nodes/#{node_name}")

            results[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'head',
              :successful => true
            }
          rescue Exception => e
            results[:errors] ||= true
            code, message      = parse_exception(e)

            ui.error("Encountered #{e.class} when checking node '#{node_name}'\n#{e}")

            results[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'head',
              :successful => false,
              :error      => {
                :code    => code,
                :message => message
              }
            }
          end

          if config.has_key?(:skip_client)
            ui.output(results)
            return
          end

          begin
            _ = api.get("clients/#{node_name}")

            results[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'head',
              :successful => true
            }
          rescue Exception => e
            results[:errors] ||= true
            code, message      = parse_exception(e)

            ui.error("Encountered #{e.class} when checking client '#{node_name}'\n#{e}")

            results[:items][:clients] << {
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

        ui.output(results)
      end

    end
  end
end
