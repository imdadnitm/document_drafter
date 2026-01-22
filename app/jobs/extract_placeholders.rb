class ExtractPlaceholders
  require 'docx'
  include Sidekiq::Job
  sidekiq_options queue: :critical, retry: 3

  def perform(record_id)
    template = Template.find_by(id: record_id)
    placeholders = {}
    document_blob = template.template_document.blob
    document_blob.open do |uploaded_file|
      unless document_blob&.content_type == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        render json: { error: 'Invalid file type' }, status: :unprocessable_entity and return
      end
      
      doc = Docx::Document.open(uploaded_file.path)

      full_text = doc.paragraphs.map(&:text).join(" ")
  
      puts "Full text #{full_text}"
      scanned_placeholders =  full_text&.scan(/\{\{(.*?)\}\}/).flatten
  
      scanned_placeholders.each do |placeholder|
        if placeholder.include?("#")
          data_type, field_name = placeholder.split("#",2)
          placeholders[field_name.strip] = data_type.strip
        end
      end
  
      puts "Placeholders : #{placeholders}"
      #render json:{placeholders: placeholders}
    end

    template.update_column(:placeholders, placeholders.to_json)

    ## update_column method is used because it does not trigger callbacks again.

  rescue => e
    #render json: {error: e.message}, status: :internal_server_error
   template.update_column(:placeholders, {"error" => e.message, "status" => "Internal Server Error"}.to_json)
   Rails.logger.error "Error: #{e.message}"
   Rails.logger.error e.backtrace.join("\n")
   raise
  end

end