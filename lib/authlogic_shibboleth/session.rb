module AuthlogicShibboleth
	module Session
		def self.included(klass)
			klass.class_eval do
				extend Config
				include Methods
			end
		end
		
		module Config
			def find_by_shibboleth_id_method(value = nil)
				rw_config(:finx_by_shibboleth_id_method, value, :find_by_shibboleth_id)
			end
			alias_method :find_by_shibboleth_id_method=, :find_by_shibboleth_id_method
		end
		
		module Methods
			def self.included(klass)
        klass.class_eval do
          attr_reader :shibboleth_id
          validate :validate_by_shibboleth_id, :if => :authenticating_with_shibboleth_id?
          
          #Because we are dealing with Shibboleth, the id comes to us via
          #the request's REMOTE_USER variable
          def shibboleth_id
            controller.request.env['REMOTE_USER']
          end
        end
      end
      
      #TODO: I am not sure this behavior is correct.
      def credentials
        if authenticating_with_shibboleth_id?
          values = [:shibboleth_id]
        else
          super
        end
      end
      
			private
			
			def authenticating_with_shibboleth_id?
			  shibboleth_id_defined?
		  end
		  
		  #REMOTE_USER will return blank if it is not set
		  def shibboleth_id_defined?
		    !shibboleth_id.blank?
	    end
		  
	    #Attempts to find the given ID in the database
	    #TODO: create some type of auto-registration system
	    #      if the id is not found
		  def validate_by_shibboleth_id
		    self.attempted_record = klass.send(find_by_shibboleth_id_method, shibboleth_id)
		    
		    unless self.attempted_record
		      errors.add_to_base(I18n.t('error_messages.shibboleth_id_not_found'), :default => "Your Shibboleth ID was not found.")
		    end
	    end
			
			def find_by_shibboleth_id_method
				self.class.find_by_shibboleth_id_method
			end
			
			def shibboleth_id
			  self.class.shibboleth_id
		  end
		end
	end
end