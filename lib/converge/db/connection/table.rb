module Converge
  module DB
    class Connection
      class Table
        def initialize(conn, table, opts = {})
          @conn = conn
          @table = table
          @stale = false
        end

        def name
          @table.name
        end

        def columns
          @table.columns
        end

        def key
          @table.key
        end

        def update(table)
          conn_table.update(table)
          @stale = true
        end

        def insert(table)
          conn_table.insert(table)
          @stale = true
        end

        def copy(object_collection)
          conn_table.copy(object_collection)
          @stale = true
        end

        def truncate
          conn_table.truncate
        end

        def finalize
          if @stale
            conn_table.finalize
            @stale = false
          else
            Converge.logger.warn "Called finalize on a finalized table"
          end
        end

        private

        def conn_table
          @conn.table(self)
        end
      end
    end
  end
end
