require 'chef/knife'
require_relative 'helpers/bulk_node_base'

class Chef
  class Knife
    class BulkNodeDelete < Chef::Knife

      include Chef::Knife::BulkNodeBase

      banner 'knife bulk node delete [NODE_NAME [NODE_NAME]] (options)'
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
            api.delete("nodes/#{node_name}")

            resp[:items][:nodes] << {
              :node_name  => node_name,
              :method     => 'delete',
              :successful => true
            }
          rescue StandardError => e
            message, code = parse_exception(e)

            if code == 404
              resp[:items][:nodes] << {
                :node_name  => node_name,
                :method     => 'delete',
                :successful => true
              }
            else
              resp[:items][:nodes] << {
                :node_name  => node_name,
                :method     => 'delete',
                :successful => false,
                :error      => {
                  :code    => code,
                  :message => message
                }
              }

              resp[:errors] ||= true
              ui.error("Encountered #{e.class} when checking node '#{node_name}'\n#{e}")
            end
          end

          unless config[:include_clients]
            ui.output(resp)
            return
          end

          begin
            api.delete("clients/#{node_name}")

            resp[:items][:clients] << {
              :client_name => node_name,
              :method      => 'delete',
              :successful  => true
            }
          rescue StandardError => e
            message, code = parse_exception(e)

            if code == 404
              resp[:items][:clients] << {
                :client_name => node_name,
                :method      => 'delete',
                :successful  => true
              }
            else
              resp[:errors] ||= true
              ui.error("Encountered #{e.class} when checking node '#{node_name}'\n#{e}")

              resp[:items][:clients] << {
                :client_name => node_name,
                :method      => 'delete',
                :successful  => false,
                :error       => {
                  :code    => code,
                  :message => message
                }
              }
            end
          end
        end

        ui.output(resp)
      end

    end
  end
end
