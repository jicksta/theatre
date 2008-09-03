# Right now Adhearsion also defines this method. The eventual solution will be to extract the Adhearsion features on which
# Theatre depends and make that a dependent library.

unless respond_to? :new_guid
  
  def random_character
    case random_digit = rand(62)
      when  0...10 : random_digit.to_s
      when 10...36 : (random_digit + 55).chr
      when 36...62 : (random_digit + 61).chr
    end
  end
  
  def random_string(length_of_string=8)
    Array.new(length_of_string) { random_character }.join
  end
  
  def new_guid
    [8,4,4,4,12].map { |segment_length| random_string(segment_length) }.join('-')
  end
end