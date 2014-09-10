module Converge
  module AWS
    module Redshift
      module DB
        class Table
          def initialize(model, conn)
            @model = model
            @conn = conn
            @needs_analyze_vacuum = false
          end

          def name
            @model.name
          end

          def load(staging_table)
            upsert(staging_table)
            @needs_analyze_vacuum = true
          end

          def finalize
            if @needs_analyze_vacuum
              run_command %{
          VACUUM #{name};

          ANALYZE #{name};
              }
            end
          end

          def exists?
            result = run_command %{
        SELECT count(tablename) FROM PG_TABLE_DEF WHERE tablename = '#{name}';
            }
            result[0]["count"].to_i != 0
          end

          def upsert(staging_table)

            run_command %{ 
      UPDATE #{name}
      SET #{col_settings_clause}
        FROM #{staging_table.name} s
        WHERE s.id = #{name}.id;

      INSERT INTO #{name}
        SELECT s.* FROM #{staging_table.name} s
          LEFT JOIN #{name} t
          ON s.id = t.id
        WHERE t.id IS NULL;
      }
          end

          private

          def col_settings_clause
            @model.columns.reject{|c| c == "id"}.map {|c| "#{c}=s.#{c}"}.join(",\n")
          end

          def run_command(cmd)
            @conn.run_command_with_retry(cmd)
          end

        end
      end
    end
  end
end
