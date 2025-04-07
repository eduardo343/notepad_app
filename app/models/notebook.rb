class Notebook < ApplicationRecord
    has_many :pages, dependent: :destroy
end
