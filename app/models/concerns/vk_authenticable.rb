module VKAuthenticable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_from_vk(vk)
      vk_user = vk.users.get(fields: [:photo]).first
      user = find_by(vk_id: vk_user.uid)

      user || create!(
        first_name: vk_user.first_name, last_name: vk_user.last_name,
        vk_id: vk_user.uid, remote_avatar_url: vk_user.photo
      )
    end
  end
end
