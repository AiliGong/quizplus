class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    enable_extension "hstore"
    create_table :questions do |t|
      t.string :question
      t.string :description
      t.hstore :answers
      t.boolean :multiple_correct_answers
      t.hstore :correct_answers
      t.string :correct_answer
      t.string :explanation
      t.string :tip
      t.string :tags, array: true
      t.string :category
      t.string :difficulty

      t.timestamps
    end
  end
end
