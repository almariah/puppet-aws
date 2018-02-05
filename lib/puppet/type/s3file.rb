Puppet::Type.newtype(:s3file) do
  desc <<-DESC
Copy file from AWS S3 bucket.
@example Using the type.
  s3file {'/tmp/file.txt':
    ensure => present,
    object => '/example/file.txt',
    bucket => "example-bucket",
    region => 'us-east-1'
  }
DESC

  def exists?
    @provider.get(:ensure) != :absent
  end

  ensurable do

    defaultto(:present)

    newvalue(:latest) do
      provider.update
    end

    newvalue(:absent) do
      provider.destroy
    end

    newvalue(:present) do
      provider.create
    end

    def insync?(is)
      @should.each { |should|
        case should
        when :latest
          return true if is == :latest
          return false
        when :present
          return true if is == :present
          return false
        when :absent
          return true if is == :absent
          return false
        end
      }
    end

    def retrieve
      if @should.include?(:latest)
        return :latest if provider.latest? and provider.exists?
      end
      return :present if provider.exists?
      return :absent unless provider.exists?
    end
  end

  newparam(:bucket) do
    desc "The AWS S3 bucket from which to copy the file."
  end

  newparam(:region) do
    desc "The AWS region for the S3 bucket."

    defaultto 'us-east-1'
  end

  newparam(:object) do
    desc "The key name that you assign to an AWS S3 object."

    munge do |value|
      if value.start_with?('/')
        value = value[1..-1]
      else
       value
     end
    end
  end

  newparam(:path, :namevar => true) do
    desc "The path to the file to manage. Must be fully qualified."

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, ("File paths must be fully qualified, not '%{path}'") % { :path => value }
      end
    end
  end
end
