require 'docx'
class GeneratedDocument < ApplicationRecord
  belongs_to :template
  has_one_attached :file
  belongs_to :user

  scope :for_user, -> (user) {where("user_id = ?", user.id).order(:created_at => :desc)}
  scope :search_filter, -> (filters) {
  scope =  all 
  scope = scope.where("lower(name) LIKE ?", "%#{filters[:name].downcase}%") if filters[:name].present?
  scope = scope.where("cast(id as text) = ?", filters[:id]) if filters[:id].present?
  scope = scope.where("date(created_at) = ?", filters[:created_at]) if filters[:created_at].present?
  scope = scope.where("date(updated_at) = ?", filters[:updated_at]) if filters[:updated_at].present?
  scope = scope.joins(:template).where("lower(templates.name) LIKE ?", "%#{filters[:template_id].downcase}%") if filters[:template_id].present?
  scope
}


  after_commit :trigger_generate_docx_job, on: [:create]

  def generate_the_document_old(template_id)

    template_doc = Template.find_by(id: template_id).template_document
    raise "Template document not found" unless template_doc&.attached?

    Tempfile.create(["template_file", ".docx"]) do |template_doc_file|
      template_doc_file.binmode
      template_doc_file.write(template_doc.download)
      template_doc_file.flush
      template_doc_file.rewind

      doc = Docx::Document.open(template_doc_file.path)

      # Replace placeholder in paragraphs
      doc.paragraphs.each do |paragraph|
        paragraph.each_text_run do |run|
          JSON.parse(placeholder_inputs || '{}').each do |key, value|
            pattern = /\{\{[^#]+##{Regexp.escape(key)}\}\}/
            run.substitute(pattern, value.to_s)
          end
        end
      end

      # Replace placeholder inside tables
      doc.tables.each do |table|
        table.rows.each do |row|
          row.cells.each do |cell|
            cell.paragraphs.each do |paragraph|
              paragraph.each_text_run do |run|
                JSON.parse(placeholder_inputs || '{}').each do |key, value|
                  pattern = /\{\{[^#]+##{Regexp.escape(key)}\}\}/
                  run.substitute(pattern, value.to_s)
                end
              end
            end
          end
        end
      end

      # Save generated document to a new file
      Tempfile.create(["generated_document", ".docx"]) do |output_file|
        doc.save(output_file.path)
        output_file.rewind

        # Attach it to the active storage field of this model
        self.file.attach(
          io: File.open(output_file.path, 'rb'),
          filename: "#{name}.docx",
          content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        )

        self.save!
      end
    end
  end

  def generate_the_document(template_id)
    template_doc = Template.find_by(id: template_id).template_document
    raise "Template document not found" unless template_doc&.attached?

    placeholders = JSON.parse(placeholder_inputs || '{}')

    Tempfile.create(["template_file", ".docx"]) do |template_doc_file|
      template_doc_file.binmode
      template_doc_file.write(template_doc.download)
      template_doc_file.flush
      template_doc_file.rewind

      doc = Docx::Document.open(template_doc_file.path)

      # Replace placeholder in paragraphs
      doc.paragraphs.each do |paragraph|
        text = paragraph.text
        placeholders.each do |key, value|
          text.gsub!(/\{\{[^#]+##{Regexp.escape(key)}\}\}/,value.to_s)
        end

        paragraph.text = text
      end

      doc.tables.each do |table|
        table.rows.each do |row|
          row.cells.each do |cell|
            cell.paragraphs.each do |paragraph|
              text = paragraph.text
              placeholders.each do |key, value|
                text.gsub!(/\{\{[^#]+##{Regexp.escape(key)}\}\}/,value.to_s)
              end
              paragraph.text = text
            end
          end
        end
      end

      # Save generated document to a new file
      Tempfile.create(["generated_document", ".docx"]) do |output_file|
        doc.save(output_file.path)
        output_file.rewind

        # Attach it to the active storage field of this model
        self.file.attach(
          io: File.open(output_file.path, 'rb'),
          filename: "#{name}.docx",
          content_type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        )

        self.save!
      end
    end
  end

  private

  def trigger_generate_docx_job()
    GenerateDocxJob.perform_async(self.id, self.template.id)
  end

end
