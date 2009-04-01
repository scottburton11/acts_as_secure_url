class <%= class_name -%> < ActiveRecord::Base

    include SecureUrl
    acts_as_secure_url
    
    <% unless options[:persist_public_key] %>
    attr_accessor :public_key
    
    ## Public Key Data
    # <%= class_name -%>#public_key_data can be overridden
    # with custom data:
    def public_key_data
      @public_key
    end
   <% end %> 
end