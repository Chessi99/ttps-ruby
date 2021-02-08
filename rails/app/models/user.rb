class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  has_many :books

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_global_book

  def get_book(book_id)
    return books.find(book_id)
  end

  def create_global_book()
    Book.create(title: "Global", user: self)
  end

  def export_all_books
    books.each { |book| book.export }
  end
end
