class Notifier
  def initialize(user, message, options = {})
    @device_tokens = user.device_tokens
    @message = message
    @options = options
    push
  end

  def push
    return if @message.blank? || @device_tokens.blank?
    Rails.logger.debug "#{Time.zone.now} Notifying #{@user} with message: #{@message}"

    push_android_notifications
    push_ios_notifications
  end

  private

  def push_android_notifications
    tokens = @device_tokens.where(platform: 'android')
    return if tokens.blank?

    build_android_notification(tokens)
    Rails.logger.debug "#{Time.zone.now} GCM notification: #{@message}, options: #{@options}"
  end

  def push_ios_notifications
    tokens = @device_tokens.where(platform: 'ios')
    return if tokens.blank?

    tokens.each { |token| build_ios_notification(token) }
    Rails.logger.debug "#{Time.zone.now} Apple notification: #{@message}, options: #{@options}"
  end

  private

  def build_android_notification(tokens)
    notification = Rpush::Gcm::Notification.new
    notification.app = Rpush::Gcm::App.find_by_name('android_app')
    notification.registration_ids = tokens.map(&:token)
    notification.data = { message: @message }.merge(@options)
    notification.save
  end

  def build_ios_notification(token)
    notification = Rpush::Apns::Notification.new
    notification.app = Rpush::Apns::App.find_by_name('ios_app')
    notification.device_token = token.token
    notification.alert = @message
    notification.data = @options
    notification.save
  end
end
