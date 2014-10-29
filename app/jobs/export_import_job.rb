module ExportImportJob

  def self.extended(base)

    base.class_eval do

      class << self

        def perform(*args);  end

        def perform_with_connections(*args)
          ActiveRecord::Base.verify_active_connections!

          perform_without_connections(*args)
        end

        alias_method_chain :perform, :connections
      end
    end
  end

  def perform_with_logging(export_file)
    elapsed = ""
    export_file.update_attribute(:status, "generating...")
    begin
      elapsed = Benchmark.realtime do
        yield
      end
      export_file.update_attributes(:info => "Created in #{"%.2f" % elapsed} sec", :status => "completed")
    rescue Exception => e
      export_file.update_attributes(:info => e.message + "\n\n" + e.backtrace.join("\n"), :status => "error")
      raise e
    end
  end

  def self.perform(*args)
  end

end
