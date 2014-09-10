require 'active_support'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/time/calculations'

module Converge
  module AWS
    module Redshift
      module DB
        class TableWithMonthlyPartition < Table

          def self.from_date_range(model, conn, date_range)
            date = start_date = date_range[:min].to_time.utc.beginning_of_day.beginning_of_month
            end_date = date_range[:max].to_time.utc.beginning_of_day.beginning_of_month

            dates = []

            while(date <= end_date)
              dates << date
              date = date.to_time.utc + 1.month
            end

            dates.map {|d|
              self.new(model, conn, d)
            }
          end

          def initialize(model, conn, date)
            super(model, conn)
            @date = date.beginning_of_month.midnight

            date_suffix = @date.strftime("%Y%m")
            @template_name = "#{base_name}_template"
            @suffixed_name = "#{base_name}_#{date_suffix}"
          end

          # XXX: This class wants to be reorganized so this alias_method goes
          # away. Specifically, I don't think this class wants to inherit from
          # Table; instead, it should be delegating to it.
          alias_method :base_name, :name

          def name
            @suffixed_name
          end

          def create
            run_command %{ 
            CREATE TABLE #{name} AS SELECT * FROM #{@template_name} WHERE 1=0
            }
            update_view
          end

          def upsert(staging_table)
            end_date = @date.to_time.utc + 1.month
            unless exists?
              create
            end

            start_timestamp = @date.strftime("%F %T")
            end_timestamp = end_date.strftime("%F %T")

            run_command %{ 
              UPDATE #{name} 
              SET #{col_settings_clause}
        FROM #{staging_table.name} s
        WHERE s.id = #{name}.id
        AND s.created_at BETWEEN '#{start_timestamp}' AND '#{end_timestamp}';

      INSERT INTO #{name}
        SELECT s.* FROM #{staging_table.name} s
          LEFT JOIN #{name} t
          ON s.id = t.id
        WHERE t.id IS NULL
        AND s.created_at BETWEEN '#{start_timestamp}' AND '#{end_timestamp}';
      }
          end

          private
          def update_view
            date = @date.beginning_of_year 
            months = []
            while (date <= @date)
              months << date.strftime("%Y%m")
              date = date + 1.month
            end
            view_select = months.map{|m| "SELECT * FROM #{base_name}_#{m}"}.join(" UNION ALL ")
            year_suffix = @date.strftime("%Y")
            run_command %{
        CREATE OR REPLACE VIEW #{base_name}_#{year_suffix} AS #{view_select}
        }
          end
        end
      end
    end
  end
end
