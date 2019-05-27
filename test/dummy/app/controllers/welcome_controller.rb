class WelcomeController < ApplicationController
  def index
    audit! :home
  end
end
