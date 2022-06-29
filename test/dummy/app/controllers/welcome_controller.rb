# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    audit! :home
  end
end
