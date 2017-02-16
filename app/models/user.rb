class User < ApplicationRecord
  validates(:email, 
            presence: true, 
            length: {maximum: 255}, 
            uniqueness: { case_sensitive: false },
            format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
            )
end
