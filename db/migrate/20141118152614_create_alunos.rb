class CreateAlunos < ActiveRecord::Migration
  def change
    create_table :alunos do |t|
      t.string :nome
      t.string :link_html
      t.string :link_github
      t.text :mini_curriculo

      t.timestamps
    end
  end
end
