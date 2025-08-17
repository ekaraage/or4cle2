# frozen_string_literal: true

class RankingsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
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

  def edit
    @ranking = current_user.rankings.find(params[:id])
    check_ranking_ownership(@ranking)
  end

  def update
    @ranking = current_user.rankings.find(params[:id])
    check_ranking_ownership(@ranking)

    if @ranking.update(ranking_params)
      flash[:success] = "ランキング: #{@ranking.title} は正常に更新されました。"
      redirect_to rankings_path
    else
      render :edit
    end
  end

  def destroy
    ranking = current_user.rankings.find(params[:id])
    check_ranking_ownership(ranking)

    ranking.destroy
    flash[:success] = "ランキング: #{ranking.title} は正常に削除されました。"
    redirect_to rankings_path
  end

  private

  def ranking_params
    params.require(:ranking).permit(:title, :detail, :start_date, :end_date)
  end

  def check_ranking_ownership(ranking)
    return if ranking.made_by?(current_user)

    flash[:alert] = 'このランキングを編集できませんでした。あなたはランキングの作成者ではありません。'
    redirect_to rankings_path
  end
end
