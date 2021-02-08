class Book < ApplicationRecord
  belongs_to :user
  has_many :notes, :dependent => :delete_all

  validates :title, length: { maximum: 50 }, presence: true, uniqueness: {case_sensitive: false, scope: :user}

  def is_global?()
    return self.title == 'Global'
  end

  def export
    notes.each { |note| note.export }
  end
end
