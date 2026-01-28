class GenerateDocxJob
  include Sidekiq::Job
  sidekiq_options queue: :critical, retry: 3

  def perform(generated_document_id,template_id)
    generated_document = GeneratedDocument.find_by(id: generated_document_id)
    generated_document.generate_the_document(template_id)
  end
end