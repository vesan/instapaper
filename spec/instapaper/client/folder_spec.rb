require 'spec_helper'

describe Instapaper::Client::Folder do
  before(:each) do
    @client = Instapaper::Client.new
  end

  describe '.folders' do
    before do
      stub_post("folders/list").
        to_return(:body => fixture("folders_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.folders
      expect(a_post("folders/list")).
        to have_been_made
    end

    it "should return an array containing folders on success" do
      folders = @client.folders
      expect(folders).to be_an Array
      expect(folders.size).to eq(2)
      expect(folders.first).to be_a Hashie::Rash
      expect(folders.first['title']).to eq('Ruby')
    end
  end

  describe '.add_folder' do
    before do
      stub_post("folders/add").with(:body => {:title => "Ruby" }).
        to_return(:body => fixture("folders_add.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.add_folder("Ruby")
      expect(a_post("folders/add")).
        to have_been_made
    end

    it "should return an array containing the new folder on success" do
      folders = @client.add_folder("Ruby")
      expect(folders).to be_an Array
      expect(folders).not_to be_empty
      expect(folders.first).to be_a Hashie::Rash
      expect(folders.first['title']).to eq('Ruby')
    end
  end

  describe '.delete_folder' do
    before do
      stub_post("folders/delete"). with(:body => {:folder_id => "1" }).
        to_return(:body => fixture("folders_delete.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.delete_folder("1")
      expect(a_post("folders/delete")).
        to have_been_made
    end

    it "should return an empty array on success" do
      confirm = @client.delete_folder("1")
      expect(confirm).to be_an Array
      expect(confirm).to be_empty
    end
  end

  describe '.set_order' do
    before do
      stub_post("folders/set_order"). with(:body => {:order => "1121173:2,1121174:1" }).
        to_return(:body => fixture("folders_set_order.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.set_order(['1121173:2','1121174:1'])
      expect(a_post("folders/set_order")).
        to have_been_made
    end

    it "should return an array reflecting the new order on success" do
      folders = @client.set_order(['1121173:2','1121174:1'])
      expect(folders).to be_an Array
      expect(folders.first).to be_a Hashie::Rash
      expect(folders.first['position']).to eq(1)
    end
  end

end