class FileOperation < ActiveRecord::Base
	belongs_to :user

	validates :user_id, presence: true
	validates :file_path, presence: true

  def self.create_and_enqueue(klass, user, *params)
    if klass == ContactsImportJob
  	  create_file(params.first[:file]) 
      export_file = FileOperation.create!(:job_class => klass.to_s, :user => user, file_path: import_path(params.first[:file]))
    else
      export_file = FileOperation.create!(:job_class => klass.to_s, :user => user, file_path: export_path)
    end

    Resque.enqueue(klass, export_file.id, user.id, *params)
  end

  def self.import_path(options)
    File.join(Rails.root, "/files/import/#{Time.now.to_s(:db)[0..9]}/#{options.original_filename}")
  end

  def self.create_file(options)
    FileUtils.mkdir_p(File.dirname(import_path(options))) unless File.exists?(File.dirname(import_path(options)))
    FileUtils.cp(options.tempfile.to_path, import_path(options))
  end

  def self.export_path
    path = File.join(Rails.root, "/files/export/#{Time.now.to_s(:db)[0..9]}/contacts.csv")
    FileUtils.mkdir_p(File.dirname(path)) unless File.exists?(File.dirname(path))
    csv_file = File.new(path, "w")
    csv_file.close
    path
  end

  def file_type
    self.file_name.last(3)
  end

  private

  # def set_file_name
  #   self.file_name = "#{self.created_at.to_s(:db).parameterize}.csv"
  #   self.save!
  # end

  # def delete_csv_file
  #   FileUtils.rm_r(File.dirname(path)) if File.exists?(path)
  # end
end