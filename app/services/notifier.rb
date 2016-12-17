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
  end

  private

  def push_notifications
    build_notification
    Rails.logger.debug "#{Time.zone.now} notification: #{@message}, options: #{@options}"
  end

  private

  def build_notification
    airship = UA::Client.new(
      key: Rails.application.secrets.urban_key,
      secret: Rails.application.secrets.urban_secret
    )
    push = airship.create_push
    named_user = UA::NamedUser.new(client: airship)
    named_user.named_user_id = @user.id.to_s
    user = named_user.lookup
    push.audience = UA.named_user(user)
    push.notification = UA.notification(alert: @message)
    push.device_types = UA.device_types(['ios', 'android'])
    push.send_push
  end
end
