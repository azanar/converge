require 'converge/db/table/base'

module Converge
  module DB
    class Table
      class Target
        include Converge::DB::Table::Base

        def name
          @model.name
        end
      end
    end
  end
end
