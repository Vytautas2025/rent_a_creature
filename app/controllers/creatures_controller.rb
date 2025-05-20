class CreaturesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:show, :home]
  
  def home
    @creatures = Creature.where(available: true)
  end
  
  def show
    @creature = Creature.find(params[:id])
  end

  def new
    @creature = Creature.new
  end

  def create
    @creature = Creature.new(creature_params)
    @creature.user = current_user
    if @creature.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @creature = Creature.find(params[:id])
  end

  def update
    @creature = Creature.find(params[:id])
    if @creature.update(creature_params)
      redirect_to creature_path(@creature)
    else
      render :edit
    end
  end

  private

  def creature_params
    params.require(:creature).permit(:name, :description, :available, :price)

  end
end


