require 'converge/aws/redshift/db/table'
require 'converge/aws/redshift/db/table_with_monthly_partition'

module Converge
  module AWS
    module Redshift
      module DB
        class TableCollection
          class Merger
            def initialize(table_collection, conn)
              @table_collection = table_collection
              @conn = conn
            end

            def merge(staging_table)
              date_range = staging_table.date_range(@conn)

              tables_to_merge = @table_collection.tables_for_date_range(date_range)

              tables_to_merge.each do |table|
                table.load(staging_table)
                table.finalize
              end
            end
          end

          def initialize(model, conn, opts = {})
            @model = model
            @conn = conn
          end

          def tables_for_date_range(date_range)
            if @model.partition?
              partitions = TableWithMonthlyPartition.from_date_range(@model, @conn, date_range)
            else
              partitions = [Table.new(@model, @conn)]
            end
          end

          def merger
            Merger.new(self, @conn)
          end
        end
      end
    end
  end
end
