# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: %i[show]
  before_action :set_ranking, only: %i[index new create edit update destroy]

  def index
    @songs = @ranking.songs
  end

  def show; end

  def new
    @song = @ranking.songs.build
  end

  def create
    @song = @ranking.songs.new(song_params)
    if @song.save
      redirect_to ranking_song_path(@ranking, @song), notice: "曲: #{@song.title} は正常に追加されました。"
    else
      render :new
    end
  end

  def edit
    @song = @ranking.songs.find(params[:id])
  end

  def update
    @song = @ranking.songs.find(params[:id])
    if @song.update(song_params)
      redirect_to ranking_songs_path(@ranking), notice: "曲: #{@song.title} は正常に更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @song = @ranking.songs.find(params[:id])
    song_title = @song.title
    @song.destroy
    redirect_to ranking_songs_path, notice: "曲: #{song_title} は正常に削除されました。"
  end

  private

  def song_params
    params.require(:song).permit(:title, :model, :ranking_id)
  end

  def set_song
    @song = Song.find(params[:id])
  end

  def set_ranking
    @ranking = Ranking.find(params[:ranking_id])
  end
end
