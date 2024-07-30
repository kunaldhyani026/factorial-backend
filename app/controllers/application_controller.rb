class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate
    # decode jwt token here and retrieve customer_id from it
    # for simplicity and to keep the assignment light-weight, hardcoding first customer
    $customer_id = Customer.first.id
  end

  def render_error(code, type, message, http_status_code)
    render json: { error: { code: code, message: message, type: type } }, status: http_status_code
  end
end
