require "test_helper"

class GeneratedDocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @generated_document = generated_documents(:one)
  end

  test "should get index" do
    get generated_documents_url
    assert_response :success
  end

  test "should get new" do
    get new_generated_document_url
    assert_response :success
  end

  test "should create generated_document" do
    assert_difference("GeneratedDocument.count") do
      post generated_documents_url, params: { generated_document: { name: @generated_document.name, placeholder_inputs: @generated_document.placeholder_inputs, template_id: @generated_document.template_id } }
    end

    assert_redirected_to generated_document_url(GeneratedDocument.last)
  end

  test "should show generated_document" do
    get generated_document_url(@generated_document)
    assert_response :success
  end

  test "should get edit" do
    get edit_generated_document_url(@generated_document)
    assert_response :success
  end

  test "should update generated_document" do
    patch generated_document_url(@generated_document), params: { generated_document: { name: @generated_document.name, placeholder_inputs: @generated_document.placeholder_inputs, template_id: @generated_document.template_id } }
    assert_redirected_to generated_document_url(@generated_document)
  end

  test "should destroy generated_document" do
    assert_difference("GeneratedDocument.count", -1) do
      delete generated_document_url(@generated_document)
    end

    assert_redirected_to generated_documents_url
  end
end
