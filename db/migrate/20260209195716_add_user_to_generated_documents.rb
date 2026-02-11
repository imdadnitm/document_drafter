class AddUserToGeneratedDocuments < ActiveRecord::Migration[8.0]
  def change
    add_reference :generated_documents, :user, foreign_key: true
  end
end
