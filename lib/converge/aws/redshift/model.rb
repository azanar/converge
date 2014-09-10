module Converge
  module AWS
    module Redshift
      class Model
        def initialize(config, model)
          @config = config
          @model = model
        end

        def name
          @model.table_name
        end

        def columns
          @config.columns || @model.redshift_columns
        end

        def partition?
          @config.partition?
        end

        def remove_quotes?
          @config.remove_quotes?
        end
      end
    end
  end
end
