class AvatarUploader < ApplicationUploader
  # Process files as they are uploaded:
  process resize_to_fit: [500, 500]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [100, 100]
  end
end
