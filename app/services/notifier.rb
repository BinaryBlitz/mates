class Notifier
  def initialize(user, message, options = {})
    @device_tokens = user.device_tokens
    @message = message
    @options = options

    Rails.logger.debug "#{Time.zone.now} Notifying #{user} with message: #{@message}"
  end

  def push
    return if @message.blank?

    android_tokens = @device_tokens.where(platform: 'android')
    push_android_notifications(android_tokens)
    # apple_tokens = @device_tokens.where(platform: 'apple')
    # push_apple_notifications(apple_tokens, @message)
  end

  private

  def push_android_notifications(tokens)
    return if tokens.blank?

    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name('android_app')
    n.registration_ids = tokens.map(&:token)
    n.data = { message: @message }.merge(@options)
    n.save!
    Rails.logger.debug "#{Time.zone.now} GCM notification: #{@message}, options: #{@options}"
  rescue
    Rails.logger.debug "#{Time.zone.now} Failed GCM notification: #{@message}, options: #{@options}"
  end

  def push_apple_notifications(tokens)
    return if tokens.blank?

    tokens.each do |token|
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name('ios_app')
      n.device_token = token
      n.alert = @message
      n.data = @options
      n.save!

      Rails.logger.debug "#{Time.zone.now} Apple notification: #{@message}, options: #{@options}"
    end
  end
end
