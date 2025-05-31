# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :set_song, only: %i[index new create edit update destroy]
  before_action :set_ranking, only: %i[index new create edit update destroy]
  before_action :set_submission, only: %i[show edit update destroy]

  def index
    @submissions = @song.submissions
  end

  # def show; end

  def new
    @submission = @song.submissions.build(user: current_user)
  end

  def create
    @submission = @song.submissions.new(submission_params)
    @submission.user = current_user

    if @submission.save
      redirect_to ranking_song_submissions_path(@ranking, @song), notice: "曲: #{@song.title} への提出は正常に保存されました。"
    else
      render :new
    end
  end

  def edit
    @submission = @song.submissions.find(params[:id])
  end

  def update
    @submission = @song.submissions.find(params[:id])
    if @submission.update(submission_params)
      redirect_to ranking_song_submissions_path(@ranking, @song), notice: "曲: #{@song.title} への提出は正常に更新されました。"
    else
      render :edit
    end
  end

  def destroy
    @submission = @song.submissions.find(params[:id])
    @submission.destroy
    redirect_to ranking_song_submissions_path(@ranking, @song), notice: "曲: #{@song_title} への提出は正常に削除されました。"
  end

  private

  def submission_params
    ret = params.require(:submission).permit(:screen_name, :score, :comment, :song_id, :user_id)
    ret.merge(user: current_user)
  end

  def set_song
    @song = Song.find(params[:song_id])
  end

  def set_ranking
    @ranking = Ranking.find(params[:ranking_id])
  end

  def set_submission
    @submission = Submission.find(params[:id])
  end
end
