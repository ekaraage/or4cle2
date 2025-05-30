# frozen_string_literal: true

class RankingsController < ApplicationController
  before_action :set_ranking, only: %i[show edit update destroy]

  def index
    @rankings = Ranking.all
  end

  def show; end

  def new
    @ranking = Ranking.new
  end

  def create
    @ranking = Ranking.new(ranking_params)
    if @ranking.save
      redirect_to @ranking, notice: 'ランキング:{@ranking.name}は正常に作成されました。'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ranking.update(ranking_params)
      redirect_to @ranking, notice: 'ランキング:{@ranking.name}は正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @ranking.destroy
    redirect_to rankings_path, notice: 'Ranking was successfully deleted.'
  end

  private

  def ranking_params
    params.require(:ranking).permit(:name, :description, :start_date, :end_date, :user_id)
  end

  def set_ranking
    @ranking = Ranking.find(params[:id])
  end
end
