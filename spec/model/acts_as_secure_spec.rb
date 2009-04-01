require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class GenericSecureUrlClass < ActiveRecord::Base
  acts_as_secure_url
end

describe "a secure URL instance" do
  before(:each) do
    @secure = GenericSecureUrlClass.new
  end
  
end