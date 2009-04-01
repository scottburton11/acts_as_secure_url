class <%= controller_name %>Controller < ActionController::Base
  
  def create
    @<%= class_name.downcase %> = <%= class_name %>.authenticate(params[:id], params[:public_key])
    respond_to do |wants|
      if @<%= class_name.downcase %>
        # Here you can expose a file with send_file and a web browser, 
        # render an object type, or redirect to a URL
        wants.html {}
        wants.js {}
        wants.xml {@<%= class_name.downcase %>.to_xml}
        wants.json {@<%= class_name.downcase %>.to_json}
      else
        # Here you render error text - the public key didn't match the
        # requested resource
        wants.html {render :text => "Invalid Request", :status => 403}
        wants.js {render :text => "Invalid Request", :status => 403}
        wants.xml {render :text => "Invalid Request"}
        wants.json {render :text => "Invalid Request"}
      end
    end
  end
end