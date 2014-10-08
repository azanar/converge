module Converge
  module Mock
    class Table
      def initialize(conn, dest)
        @conn = conn
        @dest = dest
      end
      def copy(objects)
        @conn.run_command(cmd: "copy", objects: objects)
      end
      def update(table)
        @conn.run_command(cmd: "update", source: table.name, destination: @dest.name, columns: table.columns)
      end
      def insert(table)
        @conn.run_command(cmd: "insert", source: table.name, destination: @dest.name, columns: table.columns)
      end
      def finalize
        @conn.run_command(cmd: "finalize")
      end
    end
  end
end
