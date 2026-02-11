class Template < ApplicationRecord
  has_one_attached :template_document
  belongs_to :user
  has_many :generated_documents

  scope :for_user, -> (user) {where(user_id: user.id)}

  after_commit :extract_placeholders, on: [:update]

  private

  def extract_placeholders()
    return unless self.template_document.attached?
    ExtractPlaceholders.perform_async(self.id)
  end

end
