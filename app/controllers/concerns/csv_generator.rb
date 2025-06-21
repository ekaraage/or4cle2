# frozen_string_literal: true

module CsvGenerator
  require 'csv'
  extend ActiveSupport::Concern

  def generate_csv(submissions) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    CSV.generate(headers: true, encoding: Encoding::SJIS) do |csv|
      csv << %w[ランキング名 機種名 曲名 順位 スコア ユーザー コメント]
      submissions.order(score: :desc, updated_at: :asc).each_with_index do |submission, index|
        csv << [
          submission.song.ranking.title,
          submission.song.model,
          submission.song.title,
          index + 1,
          submission.score,
          submission.screen_name,
          sanitize_csv_field(submission.comment)
        ]
      end
    end
  end

  def sanitize_csv_field(value)
    if value.to_s.start_with?('=', '+', '-', '@')
      "'#{value}"
    else
      value.to_s
    end
  end
end
