require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe <%= controller_name -%>Controller do
  controller_name :<%= controller_name.downcase -%>
  
  class <%= class_name -%> 
    include SecureUrl
    acts_as_secure_url
  end
  
  describe "download attempt with invalid credentials" do
    before(:each) do
      <%= class_name -%>.should_receive(:authenticate).and_return(nil)
      @invalid_params = {:public_key => "bad-url-code", :id => "bad-resource-descriptor"}
    end
    
    it "should not be successful" do
      post :create, @invalid_params
      response.should_not be_success
    end
    
  end
  
  describe "download attempt with invalid URL code and a real resource descriptor" do
    before(:each) do
      <%= class_name -%>.should_receive(:authenticate).and_return(nil)
      @invalid_params = {:public_key => "bad-url-code", :id => "real-resource-descriptor"}
      post :create, @invalid_params
    end
    
    it "should not be successful" do
      response.should_not be_success
    end
    
  end
  
  describe "download attempt with valid URL code and a real resource descriptor" do
    before(:each) do
      @<%= class_name.downcase -%> = mock_model(<%= class_name -%>)
      <%= class_name -%>.should_receive(:authenticate).and_return(@<%= class_name.downcase -%>)
      @valid_params = {:public_key => "real-url-code", :id => "real-resource-descriptor"}
      post :create, @valid_params
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should assign a instance variable" do
      assigns[:<%= class_name.downcase -%>].should == @<%= class_name.downcase -%> 
    end
    
  end
  
end
