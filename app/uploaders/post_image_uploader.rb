class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  require 'streamio-ffmpeg'
	include CarrierWave::Video
	include CarrierWave::Video::Thumbnailer

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

  # 画像を.webpに変換、ファイル名最後に.webpを付け直す
  process :convert_to_webp, if: :is_image?
  process :convert_to_webm, if: :is_video?

  def convert_to_webp
    manipulate! do |image|
      image.format 'webp'
      image
    end
  end

  def convert_to_webm
    maniplate! do |video|
      video.format 'webm'
      video
    end
  end

  def filename
    if original_filename.present?
      if is_image?(file)
        super.chomp(File.extname(super)) + '.webp'
      elsif is_video?(file)
        super.chomp(File.extname(super)) + '.webm'
      else
        super
      end
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
