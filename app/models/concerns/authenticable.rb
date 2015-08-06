module Authenticable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_from_vk(vk)
      vk_user = vk.users.get(fields: [:photo_max_orig, :screen_name, :bdate, :email]).first
      user = find_by(vk_id: vk_user.uid)

      user || create!(
        first_name: vk_user.first_name, last_name: vk_user.last_name, password: SecureRandom.hex,
        email: vk_user.email, vk_id: vk_user.uid, remote_avatar_url: vk_user.photo_max_orig,
        birthday: format_vk_date(vk_user.bdate)
      )
    end

    def find_or_create_from_fb(graph)
      fb_user = graph.get_object('me?fields=id,first_name,last_name,name,picture,email')
      user = find_by(facebook_id: fb_user['id'])

      user || create!(
        first_name: fb_user['first_name'], last_name: fb_user['last_name'], password: SecureRandom.hex,
        email: fb_user['email'], facebook_id: fb_user['id'], remote_avatar_url: fb_user['picture']['data']['url'].to_s
      )
    end

    private

    def format_vk_date(string)
      Date.parse(string) rescue nil
    end
  end
end
