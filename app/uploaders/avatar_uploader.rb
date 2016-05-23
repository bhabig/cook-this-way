class AvatarUploader < CarrierWave::Uploader::Base

  require 'carrierwave/orm/activerecord'
  storage :file
end
