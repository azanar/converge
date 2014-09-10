require 'aws'

module Converge
  module AWS
    module Redshift
      module DB
        class StagingTable
          attr_reader :name

          class Loader
            def initialize(staging_table, conn)
              @staging_table = staging_table
              @conn = conn
              @truncated = false #assume we aren't truncated.
            end

            def load(object_collection)
              truncate

              remove_quotes_clause = if @staging_table.remove_quotes?
                                 "REMOVEQUOTES"
                               else
                                 ""
                               end

              @conn.run_command_with_retry %{ 
                COPY #{@staging_table.name} (#{@staging_table.columns.join(",")}) FROM '#{object_collection.url}' CREDENTIALS 'aws_access_key_id=#{::AWS.config.access_key_id};aws_secret_access_key=#{::AWS.config.secret_access_key}' #{remove_quotes_clause} ESCAPE MAXERROR 100 DELIMITER '|' GZIP;
              }
              @truncated = false
            end

            def finalize
              truncate
            end

            private

            def truncate
              if !@truncated
                @conn.run_command_with_retry %{ 
            TRUNCATE TABLE #{@staging_table.name};
                }
                @truncated = true
              end
            end
          end

          def initialize(model, opts = {})
            @model = model
          end

          def name
            "#{@model.name}_staging"
          end

          def columns
            @model.columns
          end

          def remove_quotes?
            @model.remove_quotes?
          end

          def loader(redshift_connection)
            Loader.new(self, redshift_connection)
          end

          def date_range(conn)
            return @date_range if @date_range
            res = conn.run_command_with_retry %{
        SELECT min(created_at),max(created_at) FROM #{name};
            }
            if res.num_tuples > 0
              dates = res[0]
              @date_range = {min: DateTime.parse(dates["min"]), max: DateTime.parse(dates["max"])}
            else
              @date_range = {min: nil, max: nil}
            end
          end
        end
      end
    end
  end
end
