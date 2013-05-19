module Dynopoker
  # Connects to integration points for Rails 3 applications
  class Railtie < ::Rails::Railtie
    initializer :initialize_dynopoker_rails, :after => :before_initialize do
      Dynopoker::Rails.initialize
    end
  end
end

