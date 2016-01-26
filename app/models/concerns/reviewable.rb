module Reviewable
  extend ActiveSupport::Concern

  included do
    scope :reviewed, -> { where.not(accepted: nil) }
    scope :unreviewed, -> { where(accepted: nil) }
  end
end
