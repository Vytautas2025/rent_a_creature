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
    redirect_to root_path, alert: "You can only edit your own creatures" unless @creature.user == current_user
  end

  def update
    @creature = Creature.find(params[:id])

    if @creature.user != current_user
      redirect_to root_path, alert: "You can only edit your own creatures"
    elsif @creature.update(creature_params)
      redirect_to creature_path(@creature), notice: "Creature successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def creature_params
    params.require(:creature).permit(:name, :description, :available, :price)

  end
end


