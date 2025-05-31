# frozen_string_literal: true

class SubmissionsController < ApplicationController
  require 'image_processing/vips'

  before_action :set_ranking
  before_action :set_song
  before_action :set_submission, only: %i[show edit update destroy]

  def index
    @submissions = @song.submissions.order(:score)
  end

  def show; end

  def new
    @submission = @song.submissions.build(user: current_user)
  end

  def create
    @submission = @song.submissions.new(submission_params)
    if @submission.save
      flash[:success] = "曲: #{@song.title} への提出は正常に保存されました。"
      redirect_to ranking_song_submissions_path(@ranking, @song)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @submission.update(submission_params)
      flash[:success] = "曲: #{@song.title} への提出は正常に更新されました。"
      redirect_to ranking_song_submissions_path(@ranking, @song)
    else
      render :edit
    end
  end

  def destroy
    @submission.destroy
    flash[:success] = "曲: #{@song.title} への提出は正常に削除されました。"
    redirect_to ranking_song_submissions_path(@ranking, @song)
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

  def set_song
    @song = @ranking.songs.find(params[:song_id])
  end

  def set_ranking
    @ranking = Ranking.find(params[:ranking_id])
  end

  def set_submission
    @submission = @song.submissions.find(params[:id])
  end
end
