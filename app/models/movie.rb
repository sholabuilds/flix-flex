class Movie < ApplicationRecord
    def flop?
        total_gross.blank? || total_gross < 15000000
    end
end
