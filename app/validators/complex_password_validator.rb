# frozen_string_literal: true

class ComplexPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    # 必須条件: 数字, 大文字, 小文字, 記号
    return if value =~ /[0-9]/ && value =~ /[A-Z]/ && value =~ /[a-z]/ && value =~ /[^A-Za-z0-9]/

    record.errors.add(attribute, :complexity, message: 'パスワードには、大文字、小文字、数字、記号をそれぞれ1つ以上含めてください。')
  end
end
