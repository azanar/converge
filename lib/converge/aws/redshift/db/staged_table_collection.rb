module Converge
  module AWS
    module Redshift
      module DB
        class StagedTableCollection
          def initialize(conn, partitions, staged_table)
            @conn = conn
            @partitions = partitions
            @staged_table = staged_table
            @finalized = false
          end

          def load
            if @finalized
              raise "You've already finalized this staged collection. It can't be loaded again."
            end
            @partitions.each do |table|
              table.load(@staged_table)
            end
          end

          def finalize
            return if @finalized
            @staged_table.finalize
            @partitions.each do |table|
              table.finalize
            end
            @finalized = true
          end
        end
      end
    end
  end
end
