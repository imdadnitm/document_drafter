class Template < ApplicationRecord
  has_one_attached :template_document

  after_commit :extract_placeholders, on: [:update]

  private

  def extract_placeholders()
    return unless self.template_document.attached?
    ExtractPlaceholders.perform_async(self.id)
  end

end
