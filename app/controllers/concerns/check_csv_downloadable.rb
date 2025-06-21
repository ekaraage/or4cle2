# frozen_string_literal: true

module CheckCsvDownloadable
  extend ActiveSupport::Concern

  included do
    before_action :check_csv_downloadable, only: [:export_csv]
  end

  private

  def check_csv_downloadable
    ranking_id = params[:ranking_id] || params[:id]
    ranking = Ranking.find(ranking_id)

    return if ranking.made_by?(current_user)

    flash[:alert] = 'このランキングのスコアをダウンロードする権限がありません。'
    redirect_to action: :index
  end
end
