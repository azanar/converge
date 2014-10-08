require 'converge/db/table/base'

require 'converge/db/table/loader'
require 'converge/db/table/merger'

module Converge
  module DB
    class Table
      class Staging
        include Converge::DB::Table::Base

        def name
          "#{@model.name}_staging"
        end

        def merger(connection)
          Merger.new(self, connection)
        end
      end
    end
  end
end
