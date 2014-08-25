class BoatsController < ApplicationController
  def index
    boats = Boat.all
    boats.map! do |object|
      hash = object.attributes.delete_if{|k, v| k == "created_at" || k == "updated_at"}
      object = hash
  end

    render json: boats, status: 200
  end

  def create
    boat = Boat.new(boat_params)

    if boat.save
      render json: boat, status: 201
    end
  end

  private
  def boat_params
    params.require(:boat).permit(:name, :capacity)
  end
end
