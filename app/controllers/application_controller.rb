class ApplicationController < ActionController::API
  include Authentication

  rescue_from Authentication::NotAuthorized do |_|
    head(:unauthorized)
  end
end
