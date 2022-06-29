# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  def name
    email.split("@").first
  end

  def profile_url
    "/users/#{id}"
  end

  def avatar_url
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}"
  end

  def admin?
    email == "huacnlee@gmail.com"
  end
end
