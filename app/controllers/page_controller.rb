class PageController < ApplicationController
  def home
  end
  def leaderboard
    @users = User.order('points DESC')
  end
end
