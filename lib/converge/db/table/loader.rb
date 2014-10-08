module Converge
  module DB
    class Table
      class Loader
        def initialize(table, conn)
          @table = table
          @conn = conn
          @truncated = false #assume we aren't truncated.
        end

        def load(object_collection)
          @table.truncate
          @table.copy(object_collection)
          @truncated = false
        end

        def finalize
          unless @truncated
            @table.truncate
            @truncated = true
          end
        end
      end
    end
  end
end
