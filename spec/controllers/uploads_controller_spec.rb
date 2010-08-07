require 'spec/spec_helper'

describe UploadsController do
  before do
    controller.stub!(:current_user).and_return(mock_model(User))
  end
  it 'deletes an upload' do
    page = mock_model(Page)
    upload = mock_model(Upload, :page => page)
    Upload.stub!(:find).and_return(upload)
    upload.should_receive(:destroy)
    delete :destroy, :id => upload.id, :page_id => page.id
    response.should redirect_to(edit_page_url(page))
  end
end
