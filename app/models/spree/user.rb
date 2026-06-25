# Spree::User is fully defined by spree_auth_devise gem.
# We defer any customisations until after all gems are loaded.
Rails.application.config.to_prepare do
  Spree::User.class_eval do
    # Add custom methods, associations, or validations here if needed.
  end
end
