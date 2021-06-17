class HomeController < ApplicationController
  def index
    @diffculty_levels = ['easy','medium', 'hard']
  end
end
