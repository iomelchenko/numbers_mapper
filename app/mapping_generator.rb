class MappingGenerator
  attr_reader :file_path, :phone_number

  def initialize(phone_number)
    @file_path    = DICTIONARY_FILE_PATH
    @phone_number = phone_number
  end

  def execute
    phone_number
  end
end
