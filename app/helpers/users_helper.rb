module UsersHelper
    def year_of(user)
        user.created_at.strftime("%b %Y")
    end

    def profile_image(user, size=80)
        url = "http://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"

        image_tag(url, alt: user.name)
    end
end
