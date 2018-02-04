s3file {'/tmp/file.txt':
  ensure => absent,
  object => '/example/file.txt',
  bucket => "example-bucket",
  region => 'us-east-1'
}
