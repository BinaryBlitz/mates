module Authenticable
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

    def find_or_create_from_fb(graph)
      fb_user = graph.get_object("me?fields=id,first_name,last_name,picture")
      user = find_by(facebook_id: fb_user.id)

      user || create! {
        first_name: fb_user['first_name'], last_name: fb_user.last_name,
        facebook_id: fb_user['id'], remote_avatar_url: fb_user.picture.data.url.to_s
      }
    end
  end
end
