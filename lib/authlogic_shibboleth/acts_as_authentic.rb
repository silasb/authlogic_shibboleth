module AuthlogicShibboleth
	module ActsAsAuthentic
		def self.included(klass)
			klass.class_eval do
				extend Config
				add_acts_as_authentic_module(Methods, :prepend)
			end
		end
		
		module Config
		  def validate_shibboleth_id(value = nil)
        config(:validate_shibboleth_id. value, true)
      end
      alias_method :validate_shibboleth_id=, :validate_shibboleth_id
		end
		
		module Methods
			def self.included(klass)
				return if !klass.column_names.include?("shibboleth_id")
        
        klass.class_eval do
          if validate_shibboleth_id
            validates_uniqueness_of :shibboleth_id, :scope => validations_scope
          end
        end
      end
      
      private
      
      def validate_shibboleth_id
        return if errors.count > 0
        
        errors.add_to_base("Shibboleth ID does not match REMOTE_USER") if shibboleth_id != request.env['REMOTE_USER']
      end
      
      def validate_shibboleth_id?
        shibboleth_id_changed && !shibboleth_id.blank?
      end
		end
	end
end