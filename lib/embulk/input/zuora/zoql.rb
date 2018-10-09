module Embulk
  module Input
    module Zuora
      class Zoql
        attr_reader :config

        def initialize(config)
          @config = config
        end

        # keyword should be lowercase
        # https://www.zuora.com/developer/api-reference/#operation/Action_POSTquery
        def compose
          case type
          when :integrated
            formated_query
          when :separated
            "select #{target_column_names} from #{config[:object]} #{where_clause}"
          end
        end

        def columns
          case type
          when :integrated
            column_names_in_query.map{ |name|
              {name: name, type: :string, format: nil}
            }
          when :separated
            config[:columns]
          end
        end

        private
        def column_names_in_query
          config[:query].slice(str_index('select') + 6, str_index('from') - 1 - 6).gsub(/ /,"").split(",")
        end

        def str_index(keyword)
          formated_query.index(keyword)
        end

        def target_column_names
          config[:columns].map{|col| col[:name]}.join(",")
        end

        def where_clause
          "Where #{config[:where]}" if config[:where]
        end

        def formated_query
          config[:query].sub(/Select/,"select").sub(/From/,"from")
        end

        def type
          if config[:query]
            :integrated
          elsif config[:object] && config[:columns].size > 0
            :separated
          else
            raise Embulk::ConfigError.new("Parameters for ZOQL is missing. please check query:, or object: and columns:")
          end
        end
      end
    end
  end
end