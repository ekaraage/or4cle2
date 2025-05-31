# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_ranking
  before_action :set_song, only: %i[edit update destroy]

  def index
    @songs = @ranking.songs
  end

  def new
    @song = @ranking.songs.build
  end

  def create
    @song = @ranking.songs.new(song_params)
    if @song.save
      flash[:success] = "曲: #{@song.title} は正常に追加されました。"
      redirect_to ranking_songs_path(@ranking)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @song.update(song_params)
      flash[:success] = "曲: #{@song.title} は正常に更新されました。"
      redirect_to ranking_songs_path(@ranking)
    else
      render :edit
    end
  end

  def destroy
    song_title = @song.title
    @song.destroy
    flash[:success] = "曲: #{song_title} は正常に削除されました。"
    redirect_to ranking_songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :model)
  end

  def set_song
    @song = @ranking.songs.find(params[:id])
  end

  def set_ranking
    @ranking = Ranking.find(params[:ranking_id])
  end
end
