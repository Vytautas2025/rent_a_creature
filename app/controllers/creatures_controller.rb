class CreaturesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :home]


  def show
    @creature = Creature.find(params[:id])
  end
  
  def home
    @creatures = Creature.where(available: true)
  end
end
