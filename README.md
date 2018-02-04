# AWS module for Puppet

## Overview

## Usage

To fetch a file from S3 bucket to specific path:

```puppet
s3file {'/tmp/file.txt':
  ensure => present,
  object => '/example/file.txt',
  bucket => "example-bucket",
  region => 'us-east-1'
}
```

If you set ensure to present and the file does not exist, it will be featched from the bucket. If you set ensure to latest, every time you apply the type, the file on the bucket will be checked against the local copy in the specified path using MD5. 
