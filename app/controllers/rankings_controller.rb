# frozen_string_literal: true

class RankingsController < ApplicationController
  before_action :set_ranking, only: %i[edit update destroy]
  def index
    @rankings = Ranking.all
  end

  def new
    @ranking = current_user.rankings.build
  end

  def create
    @ranking = current_user.rankings.new(ranking_params)
    if @ranking.save
      redirect_to @ranking, notice: "ランキング: #{@ranking.title} は正常に作成されました。"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ranking.update(ranking_params)
      redirect_to @ranking, notice: "ランキング: #{@ranking.title} は正常に更新されました。"
    else
      render :edit
    end
  end

  def destroy
    ranking_title = @ranking.title
    @ranking.destroy
    redirect_to rankings_path, notice: "ランキング: #{ranking_title} は正常に削除されました。"
  end

  private

  def ranking_params
    params.require(:ranking).permit(:title, :detail, :start_date, :end_date, :user_id)
  end

  def set_ranking
    @ranking = current_user.rankings.find(params[:id])
  end
end
