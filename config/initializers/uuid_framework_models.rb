# Inject UUID primary key support into Rails framework models
Rails.application.config.to_prepare do
  ActionText::RichText.include UuidPrimaryKey
  ActiveStorage::Attachment.include UuidPrimaryKey
  ActiveStorage::Blob.include UuidPrimaryKey
  ActiveStorage::VariantRecord.include UuidPrimaryKey
end
