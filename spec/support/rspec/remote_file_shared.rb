shared_examples_for "remote file" do
  let(:directory) { Rails.root.join("public") }
  let(:file_path) { directory.join(file) }

  it "should update file" do
    FakeWeb.register_uri(:get, url, :body => "FILE CONTENT")
    subject.update

    File.read(file_path).should == "FILE CONTENT"
  end

  it "should overwrite previous file" do
    File.open(file_path, "w+") << "OLD CONTENT"
    FakeWeb.register_uri(:get, url, :body => "UPDATED CONTENT")
    subject.update

    File.read(file_path).should == "UPDATED CONTENT"
  end
end
