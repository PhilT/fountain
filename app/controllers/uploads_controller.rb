class UploadsController < ApplicationController
  def destroy
    @upload = Upload.find(params[:id])
    @page = @upload.page
    if @upload.destroy
      flash[:notice] = 'Attachment deleted'
    else
      flash[:error] = 'Count not delete attachment'
    end
    redirect_to edit_page_url(@page)
  end
end
