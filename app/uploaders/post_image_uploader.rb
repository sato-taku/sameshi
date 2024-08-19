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
  process :convert_to_webp, if: :image?

  def convert_to_webp
    manipulate! do |image|
      image.format 'webp'
      image
    end
  end

  def image?
    file && %w[jpg jpeg png gif heic].include?(file.extension.downcase)
  end

  def filename
    if original_filename.present? && image?
      super.chomp(File.extname(super)) + '.webp'
    else
      super
    end
  end
end
