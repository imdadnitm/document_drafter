class Template < ApplicationRecord
  has_one_attached :template_document
  belongs_to :user
  has_many :generated_documents

  scope :for_user, -> (user) {where(user_id: user.id)}

  scope :search_filter, -> (filters) {
  scope =  all 
  scope = scope.where("lower(name) LIKE ?", "%#{filters[:name].downcase}%") if filters[:name].present?
  scope = scope.where("cast(id as text) = ?", filters[:id]) if filters[:id].present?
  scope = scope.where("date(created_at) = ?", filters[:created_at]) if filters[:created_at].present?
  scope = scope.where("date(updated_at) = ?", filters[:updated_at]) if filters[:updated_at].present?
  scope = scope.joins(template_document_attachment: :blob).where("lower(active_storage_blobs.filename) LIKE ?", "%#{filters[:attachment_name].downcase}%") if filters[:attachment_name].present?
  scope
}

  after_commit :extract_placeholders, on: [:update]

  private

  def extract_placeholders()
    return unless self.template_document.attached?
    ExtractPlaceholders.perform_async(self.id)
  end

end
