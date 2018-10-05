module Embulk
  module Input
    module Zuora
      class Zoql
        attr_reader :task

        def initialize(task)
          @task = task
        end

        # keyword should be lowercase
        # https://www.zuora.com/developer/api-reference/#operation/Action_POSTquery
        def compose
          case type
          when :integrated
            formated_query
          when :separated
            "select #{target_column_names} from #{task[:object]} #{where_clause}"
          end
        end

        def columns
          case type
          when :integrated
            column_names_in_query.map{ |name|
              {name: name, type: :string}
            }
          when :separated
            task[:columns]
          end
        end

        private
        def column_names_in_query
          task[:query].slice(str_index('select') + 6, str_index('from') - 1 - 6).gsub(/^ /,"").split(",")
        end

        def str_index(keyword)
          formated_query.index(keyword)
        end

        def target_column_names
          task[:columns].map{|col| col[:name]}.join(",")
        end

        def where_clause
          "Where #{@task[:where]}" if @task[:where]
        end

        def formated_query
          task[:query].sub(/Select/,"select").sub(/From/,"from")
        end

        def type
          if task[:query]
            :integrated
          elsif task[:object] && task[:columns].size > 0
            :separated
          else
            raise Embulk::ConfigError.new("Parameters for ZOQL is missing. please check query:, or object: and columns:")
          end
        end
      end
    end
  end
end