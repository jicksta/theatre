require File.dirname(__FILE__) + "/spec_helper"

describe "Example" do
  
  it "should properly load the YAML in a file" do
    data_structure = {:foo => :bar, :qaz => [1,2,3,4,5]}
    yaml = data_structure.to_yaml
    file_contents = <<-FILE
# Some comment here
=begin YAML
#{yaml}
=end
events.blah.each { |event| }
events.blah2.each { |event| }

# More comments
=begin
another block
=end
    FILE
    
    flexmock(File).should_receive(:read).once.and_return file_contents
    example = Example.new("doesnt_matter")
    example.metadata.should == data_structure
  end
  
end