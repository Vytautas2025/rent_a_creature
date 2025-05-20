class CreaturesController < ApplicationController

  def show
    @creature = Creature.find(params[:id])
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
end


private

def creature_params
  params.require(:creature).permit(:description, :available, :price)
end
