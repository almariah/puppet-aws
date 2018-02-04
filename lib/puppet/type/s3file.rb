Puppet::Type.newtype(:s3file) do
  @doc = "Copy file from AWS S3 bucket."

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
  end

  newparam(:object) do
    desc "The weekday on which to run the command.
    Optional; if specified, must be between 0 and 7, inclusive, with
    0 (or 7) being Sunday, or must be the name of the day (e.g., Tuesday)."

    munge do |value|
      if value.start_with?('/')
        value = value[1..-1]
      else
       value
     end
    end
  end

  newparam(:path, :namevar => true) do
    desc "The weekday on which to run the command.
    Optional; if specified, must be between 0 and 7, inclusive, with
    0 (or 7) being Sunday, or must be the name of the day (e.g., Tuesday)."

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, ("File paths must be fully qualified, not '%{path}'") % { path: value }
      end
    end
  end
end
