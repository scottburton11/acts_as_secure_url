require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe <%= class_name -%> do
  before(:each) do
    @valid_attributes = {
      :public_key => "12345678"
    }
  end

  it "should create a new instance given valid attributes" do
    <%= class_name -%>.create(@valid_attributes)
  end
  
  it "should fail without a public key" do
    <%= class_name -%>.create(nil).should have(2).errors_on(:public_key)
  end
  
  it "should fail with a public key that is too short" do
    <%= class_name -%>.create(:public_key => "1234567").should have(1).errors_on(:public_key)
  end
  
end
