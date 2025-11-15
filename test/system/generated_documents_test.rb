require "application_system_test_case"

class GeneratedDocumentsTest < ApplicationSystemTestCase
  setup do
    @generated_document = generated_documents(:one)
  end

  test "visiting the index" do
    visit generated_documents_url
    assert_selector "h1", text: "Generated documents"
  end

  test "should create generated document" do
    visit generated_documents_url
    click_on "New generated document"

    fill_in "Name", with: @generated_document.name
    fill_in "Placeholder inputs", with: @generated_document.placeholder_inputs
    fill_in "Template", with: @generated_document.template_id
    click_on "Create Generated document"

    assert_text "Generated document was successfully created"
    click_on "Back"
  end

  test "should update Generated document" do
    visit generated_document_url(@generated_document)
    click_on "Edit this generated document", match: :first

    fill_in "Name", with: @generated_document.name
    fill_in "Placeholder inputs", with: @generated_document.placeholder_inputs
    fill_in "Template", with: @generated_document.template_id
    click_on "Update Generated document"

    assert_text "Generated document was successfully updated"
    click_on "Back"
  end

  test "should destroy Generated document" do
    visit generated_document_url(@generated_document)
    click_on "Destroy this generated document", match: :first

    assert_text "Generated document was successfully destroyed"
  end
end
