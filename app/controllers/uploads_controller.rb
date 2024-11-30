class UploadsController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :set_file, only: :create
  before_action :set_attachment, only: :show

  def create
    @upload = Current.account.uploads_attachments.create! blob: create_blob!
  end

  def show
    expires_in 1.year, public: true
    redirect_to @attachment.url
  end

  private
    def set_file
      @file = params[:file]
    end

    def set_attachment
      @attachment = ActiveStorage::Attachment.find_by! slug: "#{params[:slug]}.#{params[:format]}"
    end

    def create_blob!
      ActiveStorage::Blob.create_and_upload! io: @file, filename: @file.original_filename, content_type: @file.content_type
    end
end
