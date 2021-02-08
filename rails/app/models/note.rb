class Note < ApplicationRecord
  belongs_to :book

  validates :title, length: { maximum: 50 }, presence: true, uniqueness: {case_sensitive: false, scope: :book}
  validates :content, presence: true

  def export
    markdown= Redcarpet::Markdown.new(Redcarpet::Render::HTML,autolink: true, tables: true)
    new_content =markdown.render(self.content)
    self.export_content = new_content
    self.save
  end



end
