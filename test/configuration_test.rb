require File.expand_path('../test_helper', __FILE__)

describe "gitdocs configuration" do
  before do
    @config = Gitdocs::Configuration.new("/tmp/gitdocs")
    @config.paths = [] # Reset paths
  end

  it "has sensible default config root" do
    assert_equal "/tmp/gitdocs", @config.config_root
  end

  it "can retrieve empty paths" do
    assert_equal [], @config.paths
  end

  it "can have a path added" do
    @config.add_path('/my/path')
    assert_equal "/my/path", @config.paths.first
  end

  it "can have a path removed" do
    @config.add_path('/my/path')
    @config.add_path('/my/path/2')
    @config.remove_path('/my/path/2')
    assert_equal ["/my/path"], @config.paths
  end

  it "can normalize paths" do
    assert_equal File.expand_path("../test_helper.rb", Dir.pwd), @config.normalize_path("../test_helper.rb")
  end
end