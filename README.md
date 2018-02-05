# AWS module for Puppet

## Overview

To install the module:
```
puppet module install almariah-aws
```

Also, you will need `aws-sdk-s3` ruby gem dependency. You can use package type with gem provider to install it.

## Usage

The module will searches the following locations for AWS credentials:

* ENV['AWS_ACCESS_KEY_ID'] and ENV['AWS_SECRET_ACCESS_KEY']
* The shared credentials ini file at ~/.aws/credentials.
* From an instance profile when running on EC2.

To fetch a file from S3 bucket to specific path:

```puppet
s3file {'/tmp/file.txt':
  ensure => present,
  object => '/example/file.txt',
  bucket => "example-bucket",
  region => 'us-east-1'
}
```

If `aws-sdk-s3` ruby gem not installed you can use:

```puppet
s3file {'/tmp/file.txt':
  ensure  => present,
  object  => '/example/file.txt',
  bucket  => "example-bucket",
  region  => 'us-east-1'
  require => Package['aws-sdk-s3']
}

package {'aws-sdk-s3':
  ensure    => present,
  provider => gem
}
```

If you set ensure to present and the file does not exist, it will be fetched from the bucket. If you set ensure to latest, every time you apply the type, the file on the bucket will be checked against the local copy in the specified path using MD5.
