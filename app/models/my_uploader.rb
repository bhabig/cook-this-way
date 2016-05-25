class MyUploader < CarrierWave::Uploader::Base
  storage :fog # Needs to be :file for local and :fog for aws
  include CarrierWave::MiniMagick

  process resize_to_fit: [600, 400]

  version :thumb do
    process resize_to_fill: [300,200]
  end

  def store_dir
    "public/images/uploads/#{model.id}"
  end

  def cache_dir
    "../public/images/uploads/tmp/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    /image\//
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  if ENV['RACK_ENV'] == 'development'
    def default_url(*args)
      'https://s3-us-west-2.amazonaws.com/ctw-kbjwgqjqfzubu/public/images/missing.jpg'
    end
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  private

  def is_landscape? picture
    image = MiniMagick::Image.open(picture.path)
    image[:width] > image[:height]
  end
end
