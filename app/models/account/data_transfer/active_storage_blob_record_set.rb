class Account::DataTransfer::ActiveStorageBlobRecordSet < Account::DataTransfer::RecordSet
  def initialize(account)
    super(
      account: account,
      model: ActiveStorage::Blob,
      attributes: ActiveStorage::Blob.column_names - %w[service_name]
    )
  end
end
