class GeneratedDocumentsController < ApplicationController
  before_action :set_generated_document, only: %i[ show edit update destroy ]

  # GET /generated_documents or /generated_documents.json
  def index
    @generated_documents = GeneratedDocument.all
  end

  # GET /generated_documents/1 or /generated_documents/1.json
  def show
  end

  # GET /generated_documents/new
  def new
    @generated_document = GeneratedDocument.new
  end

  # GET /generated_documents/1/edit
  def edit
  end

  # POST /generated_documents or /generated_documents.json
  def create
    @generated_document = GeneratedDocument.new(generated_document_params)
    puts "#####Parameters: #{generated_document_params}"
    @generated_document.placeholder_inputs = generated_document_params["placeholder_inputs"].to_json

    respond_to do |format|
      if @generated_document.save
        format.html { redirect_to @generated_document, notice: "Generated document was successfully created." }
        format.json { render :show, status: :created, location: @generated_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @generated_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /generated_documents/1 or /generated_documents/1.json
  def update
    respond_to do |format|
      if @generated_document.update(generated_document_params)
        format.html { redirect_to @generated_document, notice: "Generated document was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @generated_document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @generated_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /generated_documents/1 or /generated_documents/1.json
  def destroy
    @generated_document.destroy!

    respond_to do |format|
      format.html { redirect_to generated_documents_path, notice: "Generated document was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def render_placeholder_inputs
    selected_template_id = params[:template_id]
    selected_template = Template.find(selected_template_id)
    if (selected_template.id)
      template_placeholders = JSON.parse(selected_template.placeholders)
      render partial: "placeholder_inputs", locals:{template_placeholders:template_placeholders, input_values:JSON.parse(@generated_document&.placeholder_inputs || '{}')}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_generated_document
      @generated_document = GeneratedDocument.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def generated_document_params
      params.expect(generated_document: [ :name, {placeholder_inputs:{}}, :template_id ])
    end
end
