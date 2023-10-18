class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        user = User.find_by(id: session[:user_id])
        if user
            recipes = Recipe.all
            render json: recipes, include: :user, status: :created
        else
            render json: { errors: ['Not authorized', 'For sure'] }, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe = Recipe.create!(title: params[:title], instructions: params[:instructions], minutes_to_complete: params[:minutes_to_complete], user_id: user.id)
            render json: recipe, include: :user, status: :created
        else
            render json: { errors: ["User not logged in", "Second part of array"] }, status: :unauthorized
        end
    end

    private

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
