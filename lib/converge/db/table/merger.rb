module Converge
  module DB
    class Table
      class Merger
        def initialize(source, conn)
          @conn = conn
          @conn_source = @conn.table(source)
        end

        def merge(destination)
          conn_destination = @conn.table(destination)
          conn_destination.update(@conn_source)
          conn_destination.insert(@conn_source)
          conn_destination.finalize
        end
      end
    end
  end
end
