class Notifier
  UA = Urbanairship

  def initialize(user, message, options = {})
    @user = user
    @message = message
    @options = options
    push
  end

  def push
    return if @message.blank?
    Rails.logger.debug "#{Time.zone.now} Notifying #{@user.full_name} with message: #{@message}"

    push_notifications
  rescue
    return
  end

  private

  def push_notifications
    build_ios_notification
    build_android_notification
    Rails.logger.debug "#{Time.zone.now} notification: #{@message}, options: #{@options}"
  end

  private

  def airship
    airship = UA::Client.new(
      key: Rails.application.secrets.urban_key,
      secret: Rails.application.secrets.urban_secret
    )
  end

  def named_user
    named_user = UA::NamedUser.new(client: airship)
    named_user.named_user_id = @user.id.to_s
  end

  def build_android_notification
    push = airship.create_push
    push.audience = UA.named_user(named_user)
    push.notification = UA.notification(alert: @message, android: UA.android(extra: @options))
    push.device_types = UA.device_types(['android'])
    push.send_push
  end

  def build_ios_notification
    push = airship.create_push
    push.audience = UA.named_user(named_user)
    push.notification = UA.notification(alert: @message, ios: UA.ios(extra: @options))
    push.device_types = UA.device_types(['ios'])
    push.send_push
  end
end
