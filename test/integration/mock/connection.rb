module Converge
  module Mock
    class Connection
      def initialize(conn)
        @conn = conn
      end

      def run_command(cmd)
        @conn.run_command(cmd)
      end

      def table(name)
        Table.new(self, name)
      end

      attr_reader :conn
    end
  end
end

