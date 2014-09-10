require 'aws'

module Converge
  module AWS
    module Redshift
      module DB
        class Cluster
          def initialize(conn=nil)
            @conn = conn
          end

          attr_reader :conn

          def raise_if_not_sane
            if !is_sane?
              raise "Cluster is not sane. Can not perform update."
            end
          end

          def is_sane?
            return true
            rs_console_client = AWS::Redshift::Client.new
            rs_cluster_status = rs_console_client.describe_clusters(:cluster_identifier => "")[:clusters][0][:cluster_status]

            rs_cluster_status == "available"
          end

          def run_command(cmd)
            return if Converge.ignore_redshift?
            Converge.logger.debug "Running command #{cmd}\n"
            @conn.exec(cmd)
          end

          def run_command_with_retry(cmd)
            run_command(cmd)
          rescue
            @conn.reset
            run_command(cmd)
          end
        end
      end
    end
  end
end
