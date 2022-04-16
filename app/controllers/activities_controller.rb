class ActivitiesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_kanban, only: [:new, :create, :update, :index, :edit]
    before_action :set_kanban_column, only: [:new, :create, :update, :index, :edit]
    before_action :set_card, only: [:new, :create, :update, :index, :edit]
    before_action :set_activity, only: [:update, :edit]


    def index
        @activities = @card.activities.all
    end

    def new
        @activity = @card.activities.build
        @activity_tags = choose_specific_activity_creator!(params[:type])
    end

    def edit
        @activity_tags = choose_specific_activity_creator!(params[:type])
    end

    def create
        @activity = @card.activities.build(activity_params)
        if @activity.save
            redirect_to  edit_kanban_kanban_column_card_url(@kanban.id, @kanban_column.id, @card.id)
        else
            render :new
        end
    end

    def update
        if @activity.update(activity_params)
            if params[:from_activities]
                redirect_to kanban_kanban_column_card_activities_url(@kanban.id, @kanban_column.id, @card.id)
            else
                redirect_to edit_kanban_kanban_column_card_url(@kanban.id, @kanban_column.id, @card.id)
            end
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
        @activity = @card.activities.find(params[:id])
    end

    def set_card
        @card = @kanban_column.cards.find(params[:card_id])
    end

    def set_kanban_column
        @kanban_column = @kanban.kanban_columns.find(params[:kanban_column_id])
    end

    def set_kanban
        @kanban = current_user.kanbans.find(params[:kanban_id])
    end

    def activity_params
        params.require(:activity).permit(:kanban_id, :kanban_column_id, :card_id, :title, :notes, :startdate, :enddate, :completed, :tag)
    end

end