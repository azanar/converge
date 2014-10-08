module Converge
  class Model
    def initialize(config, model)
      @config = config
      @model = model
    end

    def name
      @model.table_name
    end

    def columns
      @config.columns || @model.columns
    end


    def remove_quotes?
      @config.remove_quotes?
    end
  end
end
