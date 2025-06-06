# frozen_string_literal: true

class RankingsController < ApplicationController
  before_action :set_ranking, only: %i[edit update destroy]
  before_action :authenticate_user!, except: [:index]
  before_action :check_user_ownership, only: %i[edit update destroy]
  def index
    @rankings = Ranking.all
  end

  def new
    @ranking = current_user.rankings.build
  end

  def create
    @ranking = current_user.rankings.new(ranking_params)
    if @ranking.save
      flash[:success] = "ランキング: #{@ranking.title} は正常に作成されました。"
      redirect_to ranking_songs_path(@ranking)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ranking.update(ranking_params)
      flash[:success] = "ランキング: #{@ranking.title} は正常に更新されました。"
      redirect_to rankings_path
    else
      render :edit
    end
  end

  def destroy
    ranking_title = @ranking.title
    @ranking.destroy
    flash[:success] = "ランキング: #{ranking_title} は正常に削除されました。"
    redirect_to rankings_path
  end

  private

  def ranking_params
    params.require(:ranking).permit(:title, :detail, :start_date, :end_date)
  end

  def set_ranking
    @ranking = current_user.rankings.find(params[:id])
  end

  def check_user_ownership
    return if @ranking.made_by?(current_user)

    flash[:alert] = 'このランキングを編集する権限がありません。'
    redirect_to rankings_path
  end
end
