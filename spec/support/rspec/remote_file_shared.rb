shared_examples_for "remote file" do
  let(:directory) { Rails.root.join("public") }
  let(:file_path) { directory.join(file) }

  it "should update file" do
    mock = mock(:read => "FILE CONTENT")
    subject.should_receive(:open).with(url).and_return(mock)
    subject.update

    File.read(file_path).should == "FILE CONTENT"
  end

  it "should overwrite previous file" do
    File.open(file_path, "w+") << "OLD CONTENT"
    mock = mock(:read => "UPDATED CONTENT")
    subject.should_receive(:open).with(url).and_return(mock)
    subject.update

    File.read(file_path).should == "UPDATED CONTENT"
  end
end
