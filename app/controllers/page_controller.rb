class PageController < ApplicationController
  def leaderboard
    @users = User.order('points DESC')
  end
end
