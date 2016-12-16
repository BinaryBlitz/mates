class Notifier
  UA = Urbanairship

  def initialize(user, message, options = {})
    @user = user
    @device_tokens = user.device_tokens
    @message = message
    @options = options
    push
  end

  def push
    return if @message.blank? || @device_tokens.blank?
    Rails.logger.debug "#{Time.zone.now} Notifying #{@user.full_name} with message: #{@message}"

    push_android_notifications
    push_ios_notifications
  end

  private

  def push_android_notifications
    tokens = @device_tokens.where(platform: 'android')
    return if tokens.blank?

    tokens.each { |token| build_android_notification(token) }
    Rails.logger.debug "#{Time.zone.now} GCM notification: #{@message}, options: #{@options}"
  end

  def push_ios_notifications
    tokens = @device_tokens.where(platform: 'ios')
    return if tokens.blank?

    tokens.each { |token| build_ios_notification(token) }
    Rails.logger.debug "#{Time.zone.now} Apple notification: #{@message}, options: #{@options}"
  end

  private

  def build_android_notification(token)
    airship = UA::Client.new(
      key: Rails.application.secrets.urban_key,
      secret: Rails.application.secrets.urban_secret
    )
    push = airship.create_push
    push.audience = UA.android_channel(token.token)
    push.notification = UA.android(alert: @message)
    push.device_types = UA.device_types(['android'])
    push.send_push
  end

  def build_ios_notification(token)
    airship = UA::Client.new(
      key: Rails.application.secrets.urban_key,
      secret: Rails.application.secrets.urban_secret
    )
    push = airship.create_push
    push.audience = UA.ios_channel(token.token)
    push.notification = UA.ios(alert: @message)
    push.device_types = UA.device_types(['ios'])
    push.send_push
  end
end
