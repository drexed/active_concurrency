module FileHelpers

  FILE_PATH ||= 'spec/support/test.txt'

  def read_file
    file = File.read(FILE_PATH)
    file.split("\n").map(&:to_i)
  end

  def truncate_file
    File.open(FILE_PATH, 'w') do |file|
      file.truncate(0)
    end
  end

  def write_file(result)
    File.open(FILE_PATH, 'a') do |file|
      file.write("#{result}\n")
    end
  end

end
