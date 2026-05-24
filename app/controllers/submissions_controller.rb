# frozen_string_literal: true

class SubmissionsController < ApplicationController
  require 'image_processing/vips'
  include CsvGenerator
  include CheckCsvDownloadable

  before_action :authenticate_user!, except: %i[index show]

  def index
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submissions = @song.submissions.order(:score)
  end

  def show
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submission = @song.submissions.find(params[:id])
  end

  def new
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submission = @song.submissions.build(user: current_user)

    check_submittable(@song)
  end

  def create # rubocop:disable Metrics/AbcSize
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submission = @song.submissions.new(submission_params)

    check_submittable(@song)

    if @submission.save
      flash[:success] = "曲: #{@song.title} への提出は正常に保存されました。"
      redirect_to ranking_song_submissions_path(@ranking, @song)
    else
      render :new
    end
  end

  def edit
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submission = @song.submissions.find(params[:id])

    check_submission_ownership(@submission)
  end

  def update # rubocop:disable Metrics/AbcSize
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submission = @song.submissions.find(params[:id])

    check_submission_ownership(@submission)

    if @submission.update(submission_params)
      flash[:success] = "曲: #{@song.title} への提出は正常に更新されました。"
      redirect_to ranking_song_submissions_path(@ranking, @song)
    else
      render :edit
    end
  end

  def destroy # rubocop:disable Metrics/AbcSize
    @ranking = Ranking.find(params[:ranking_id])
    @song = @ranking.songs.find(params[:song_id])
    @submission = @song.submissions.find(params[:id])

    check_submission_ownership(@submission)

    @submission.destroy
    flash[:success] = "曲: #{@song.title} への提出は正常に削除されました。"
    redirect_to ranking_song_submissions_path(@ranking, @song)
  end

  def export_csv
    @submissions = @song.submissions
    respond_to do |format|
      format.csv do
        send_data generate_csv(@submissions), filename: "submissions_ranking_#{@ranking.id}_song_#{@song.id}.csv",
                                              type: 'text/csv;', disposition: 'attachment'
      end
    end
  end

  private

  def submission_params
    ret = params.require(:submission).permit(:screen_name, :score, :comment, :image)

    if ret[:image].present? && ret[:image].respond_to?(:tempfile)
      resized_picture = image_resize(ret[:image].tempfile)
      ret[:image].tempfile = resized_picture if resized_picture.present?
    end

    ret.merge(user: current_user)
  end

  # 絶対にやってることがおかしいのでなんとかしたい
  def image_resize(image)
    ImageProcessing::Vips
      .source(image)
      .resize_to_limit(1280, 1280)
      .convert('jpg')
      .call
  end

  def check_submission_ownership(submission)
    song = submission.song
    ranking = song.ranking

    return if current_user&.can_edit_submission?(submission)

    flash[:alert] = 'この提出を編集する権限がありません。提出の作成者でないか、ランキングが開催期間外です。'
    redirect_to ranking_song_submissions_path(ranking, song)
  end

  def check_submittable(song)
    ranking = song.ranking

    return if current_user&.can_submit_score?(song)

    flash[:alert] = 'この曲への新たな提出はできません。編集機能を使用してください。'
    redirect_to ranking_song_submissions_path(ranking, song)
  end
end
