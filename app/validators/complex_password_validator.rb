# frozen_string_literal: true

class ComplexPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.length.between?(8, 128) # rubocop:disable Style/IfUnlessModifier
      record.errors.add(attribute, :length, message: 'パスワードは8文字以上128文字以下で入力してください。')
    end
    unless value =~ /[0-9]/ && value =~ /[A-Z]/ && value =~ /[a-z]/ && value =~ /[^A-Za-z0-9]/ # rubocop:disable Style/GuardClause
      record.errors.add(attribute, :complexity, message: 'パスワードには、大文字、小文字、数字、記号をそれぞれ1つ以上含めてください。')
    end
  end
end
