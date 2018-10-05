module Embulk
  module Input
    module Zuora
      class Plugin < InputPlugin
        ::Embulk::Plugin.register_input("zuora", self)

        def self.transaction(config, &control)
          # configuration code:
          task = convert_to_task(config)
          client  = Client.new(task)
          client.validate_credentials

          columns = client.zoql.columns.map.with_index do |column, i|
            Column.new(i, column[:name], column[:type].to_sym, column[:format])
          end

          resume(task, columns, 1, &control)
        end

        def self.resume(task, columns, count, &control)
          task_reports = yield(task, columns, count)

          next_config_diff = {}
          return next_config_diff
        end

        # TODO
        # def self.guess(config)
        #   sample_records = [
        #     {"example"=>"a", "column"=>1, "value"=>0.1},
        #     {"example"=>"a", "column"=>2, "value"=>0.2},
        #   ]
        #   columns = Guess::SchemaGuess.from_hash_records(sample_records)
        #   return {"columns" => columns}
        # end

        def init
          # initialization code:
        end

        def run
          client.export do |record|
            value = extract_values(record)
            page_builder.add(value)
          end

          page_builder.finish

          task_report = {}
          return task_report
        end

        def self.convert_to_task(config)
          {
            base_url:       config.param("base_url",       :string),
            auth_method:    config.param("auth_method",    :string,  default: nil),
            username:       config.param("username",       :string,  default: nil),
            password:       config.param("password",       :string,  default: nil),
            query:          config.param("query",          :string,  default: nil),
            object:         config.param("from",           :string,  default: nil),
            where:          config.param("where",          :string,  default: nil),
            columns:        config.param("columns",        :array,   default: []),
            retry_limit:    config.param("retry_limit",    :integer, default: 5),
            retry_wait_sec: config.param("retry_wait_sec", :integer, default: 5)
          }
        end


        def client
          Client.new(task)
        end

        def preview?
          begin
            org.embulk.spi.Exec.isPreview()
          rescue java.lang.NullPointerException => e
            false
          end
        end

        def extract_values(record)
          client.zoql.columns.map do |col|
            value = record[col[:name].to_s]
            cast(value, col[:type].to_s)
          end
        end

        def cast(value, type)
          case type
          when "timestamp"
            Time.parse(value)
          when "double"
            Float(value)
          when "long"
            Integer(value)
          when "boolean"
            !!value
          when "string"
            value.to_s
          else
            value
          end
        end
      end
    end
  end
end