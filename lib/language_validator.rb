class LanguageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    languages = {}
    DetectLanguage.detect(value).each do |result|
      if result['isReliable']
        languages[result['language']] = true
      end
    end

    # It's possible multiple languages may be detected. We're OK with this
    # so long as the desired language is among them.
    unless languages.empty? || !languages[options[:language].to_s].nil?
      record.errors[attribute] << (options[:message] || "is not the correct language")
    end
  end
end