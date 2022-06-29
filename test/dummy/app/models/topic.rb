# frozen_string_literal: true

class Topic < ActiveRecord::Base
  belongs_to :user
end
