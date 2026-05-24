# frozen_string_literal: true

class SongsController < ApplicationController
  require 'zip'
  include CsvGenerator
  include CheckCsvDownloadable

  before_action :authenticate_user!, except: %i[index]

  def index
    @ranking = Ranking.find(params[:ranking_id])
    @songs = @ranking.songs
  end

  def new
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.build
    check_song_ownership(@song)
  end

  def create
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.new(song_params)
    check_song_ownership(@song)

    if @song.save
      flash[:success] = "曲: #{@song.title} は正常に追加されました。"
      redirect_to ranking_songs_path(@ranking)
    else
      render :new
    end
  end

  def edit
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:id])
    check_song_ownership(@song)
  end

  def update
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:id])
    check_song_ownership(@song)

    if @song.update(song_params)
      flash[:success] = "曲: #{@song.title} は正常に更新されました。"
      redirect_to ranking_songs_path(@ranking)
    else
      render :edit
    end
  end

  def destroy
    @ranking = Ranking.find(params[:ranking_id])
    song = ranking.songs.find(params[:id])
    check_song_ownership(song)

    song.destroy
    flash[:success] = "曲: #{song.title} は正常に削除されました。"
    redirect_to ranking_songs_path(@ranking)
  end

  def export_csv
    @ranking = Ranking.find(params[:ranking_id])
    # Create a zip file
    zip_buffer = Zip::OutputStream.write_buffer do |zip|
      @ranking.songs.each do |song|
        zip.put_next_entry("submissions_ranking_#{@ranking.id}_song_#{song.id}.csv")
        zip.write(generate_csv(song.submissions))
      end
    end

    send_data zip_buffer.string, filename: "all_submissions_rankings-#{@ranking.id}.zip", type: 'application/zip'
  end

  private

  def song_params
    params.require(:song).permit(:title, :model)
  end

  # 今はランキングを作った人しか選曲の編集をできないようにしている
  def check_song_ownership(song)
    return if current_user&.can_edit_song_for_ranking?(song.ranking)

    flash[:alert] = 'この選曲を編集できませんでした。あなたがランキングの作成者でないか、ランキングが開催期間外です。'
    redirect_to ranking_songs_path(song.ranking)
  end
end
