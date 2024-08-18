class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'sample_image.svg'
  end

  def extension_allowlist
    %w(jpg jpeg png gif heic webp MOV wmv mp4)
  end

  # 画像を.webpに変換
  process :convert_to_webp

  def convert_to_webp
    manipulate! do |image|
      image.format 'webp'
      image
    end
  end

  def filename
    super.chomp(File.extname(super)) + '.webp' if original_filename.present?
  end
end
