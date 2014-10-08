module Converge
  module DB
    class Table
      module Base
        def initialize(model)
          @model = model
          @stale = false
        end

        def columns
          @model.columns
        end

        def key
          @model.key
        end

        def loader(connection)
          Loader.new(self, connection)
        end
      end
    end
  end
end
