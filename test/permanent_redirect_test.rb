require 'rubygems'
require 'spec'
require 'action_pack'
require 'action_controller'
require 'action_controller/test_process'
require 'test/unit'
begin; require 'redgreen'; rescue LoadError; end
$LOAD_PATH << 'lib'
require 'init'

ActionController::Routing::Routes.reload rescue nil
ActionController::Base.cache_store = :memory_store

class PermanentController < ActionController::Base
  def test
  end

  def test_string
    redirect_to '/xxx'
  end

  def test_hash
    redirect_to :action => :test
  end

  def test_status_with_string
    redirect_to '/xxx', :status => 303
  end

  def test_status_with_hash
    redirect_to :action => :test, :status => 303
  end

  def test_response_status_with_hash
    redirect_to({:action => :test}, :status => 303)
  end
end

class PermanentTest < ActionController::TestCase
  def setup
    @controller = PermanentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "it redirect with 301 for strings" do
    get :test_string
    @response.redirect_url.should == 'http://test.host/xxx'
    @response.code.should == "301"
  end

  test "it redirect with 301 for hashes" do
    get :test_hash
    @response.redirect_url.should == 'http://test.host/permanent/test'
    @response.code.should == "301"
  end

  test "it redirect with given status for strings" do
    get :test_status_with_string
    @response.redirect_url.should == 'http://test.host/xxx'
    @response.code.should == "303"
  end

  test "it redirect with given status for hashes" do
    get :test_status_with_hash
    @response.redirect_url.should == 'http://test.host/permanent/test'
    @response.code.should == "303"
  end

  test "it redirect with given response-status for hashes" do
    get :test_response_status_with_hash
    @response.redirect_url.should == 'http://test.host/permanent/test'
    @response.code.should == "303"
  end
end