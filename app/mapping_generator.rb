class MappingGenerator
  attr_reader :index_file_path, :phone_number, :index

  def initialize(phone_number)
    @index_file_path = INDEX_FILE_PATH
    @phone_number    = phone_number
    @index           = fetch_index
  end

  def execute
    phone_number
  end

  private

  def fetch_index
    Marshal.load File.read index_file_path
  rescue => error
    puts "#{error}. Please create index file"
  end
end
