class CreateGeneratedDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :generated_documents do |t|
      t.text :name
      t.text :placeholder_inputs
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
