require 'converge/db/connection/table'

module Converge
  module DB
    class Connection
      def initialize(conn)
        @conn = conn
      end


      def table(table)
        Connection::Table.new(@conn, table)
      end
    end
  end
end
