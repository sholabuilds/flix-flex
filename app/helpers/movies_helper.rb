module MoviesHelper
    def total_gross(movie)
        # Business logic from model
        if movie.flop?
            "Flop!"
        else 
            number_to_currency(movie.total_gross, precision: 0)
        end
    end

    def year_of(movie)
        movie.release_date.strftime("%d %b %Y")
    end

    def nav_link_to(text, url)
        if current_page?(url)
            link_to(text, url, class: "active")
        else
            link_to(text, url)
        end
    end
end
