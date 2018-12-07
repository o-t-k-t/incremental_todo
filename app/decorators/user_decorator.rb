class UserDecorator < ApplicationDecorator
  delegate_all

  def avatar_image_tag
    avatar =
      if object.avatar.attached?
        object.avatar.variant(resize: '300x300')
      else
        'no-image.svg'
      end

    h.image_tag avatar
  end
end
