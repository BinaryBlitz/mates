class Notifier
  def initialize(user, message, options = {})
    puts 'NOTIFYING'
    @device_tokens = user.device_tokens
    @message = message
    @options = options
  end

  def push
    android_tokens = @device_tokens.where(platform: 'android')
    push_android_notifications(android_tokens, @message)

    # apple_tokens = @device_tokens.where(platform: 'apple')
    # push_apple_notifications(apple_tokens, @message)
  end

  private

  def push_android_notifications(tokens)
    n = Rpush::Gcm::App.new
    n.app = Rpush::Gcm::App.find_by_name('android_app')
    n.registration_ids = tokens.map(&:token)
    n.data = { message: @message }.merge(@options)
    n.save!
  end

  def push_apple_notifications(tokens, message)
    tokens.each do |token|
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name("ios_app")
      n.device_token = token
      n.alert = @message
      n.data = @options
      n.save!
    end
  end
end
