require 'converge/db/table/partitioner'
module Converge
  module DB
    class Table
      module Partitioner
        class Bookend
          include Partitioner
          def initialize(source)
            @source = source
          end

          def matches?
            true
          end

          def partition_for(dest)
            @source
          end
        end
      end
    end
  end
end
