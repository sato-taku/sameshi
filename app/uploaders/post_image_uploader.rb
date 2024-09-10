class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
	require 'streamio-ffmpeg'

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

  process :fix_exif_rotation, if: :is_image?

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end

  # 画像を.webpに変換、ファイル名最後に.webpを付け直す
  process :convert_to_webp, if: :is_image?

  def convert_to_webp
    manipulate! do |img|
      img.format 'webp'
      img
    end
  end

  def filename
    if original_filename.present? && is_image?(file)
      super.chomp(File.extname(super)) + '.webp'
    else
      super
    end
  end  

  private

  def is_image? picture
    picture.content_type.include?('image/')
  end

  def is_video? picture
    picture.content_type.include?('video/')
	end
end
