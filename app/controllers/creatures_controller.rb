class CreaturesController < ApplicationController
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

  private

  def creature_params
    params.require(:creature).permit(:name, :description, :available, :price)
  end
end
