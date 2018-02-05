require 'aws-sdk-s3' if Puppet.features.awssdks3?
require 'digest'
require 'fileutils'

Puppet::Type.type(:s3file).provide(:s3file) do

  confine :feature => :awssdks3

  def exists?
    if File.file?(resource[:path])
      return true
    else
      false
    end
  end

  def latest?
    $s3_obj = getObject
    if exists?
      md5_new =  Digest::MD5.hexdigest $s3_obj.get.body.string
      md5_current = Digest::MD5.file(resource[:path]).hexdigest
      if md5_new == md5_current
        true
      else
        false
      end
    end
  end

  def create
    if !exists?
      $s3_obj = getObject
    end
    $s3_obj.get(:response_target => resource[:path])
  end

  def update
    self.create
  end

  def destroy
    FileUtils.rm_rf resource[:path]
  end

  def getObject
    notice "connecting to AWS"
    s3 = Aws::S3::Resource.new(:region => resource[:region])
    return s3.bucket(resource[:bucket]).object(resource[:object])
  end
end
