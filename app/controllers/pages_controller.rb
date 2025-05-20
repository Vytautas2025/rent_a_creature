class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  
  def home
    @creatures = Creature.all
  end
end
