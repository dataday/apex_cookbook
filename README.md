# Apex Cookbook

The recipe contained within this cookbook installs [Apex](http://apex.run) which provides a helpful framework to develop and manage [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html) functions.

## Dependencies

Support was provided by this non-exhaustive list of vendors.

>[..] tools to create workflows and manage compliance for both legacy and new cloud-native applications
> - https://www.chef.io

>[..] a dependency manager for Chef cookbooks
> - https://docs.chef.io/berkshelf.html

>[..] a test harness to execute infrastructure code on one or more platforms
> - http://kitchen.ci

>[..] an open-source testing framework for infrastructure
> - https://www.inspec.io

>[..] a Behaviour-Driven Development tool for Ruby programmers
> - http://rspec.info

>[..] lets you build, deploy, and manage AWS Lambda functions with ease
> - http://apex.run

## Support

The following platform architectures are supported by the Apex recipe.

- darwin (macOS): x86_64
- linux: i686, x86_64
- openbsd: amd64

## Installation

The following commands can be used to create a local instance of the recipe installation using [KitchenCI](http://kitchen.ci).

```bash
$ git clone git@github.com:dataday/apex_cookbook.git && cd apex_cookbook
$ chef exec bundle install --path vendor/bundle
```

## Documentation

The following commands can be used to publish documentation associated to the project.

```bash
$ chef exec rake docs:cookbook # cookbook documentation (experimental)
$ chef exec rake docs:standard # standard documentation
```

## Tests

The following commands can be used to test the project. To generate JUnit formatted results please `export CI=true`.

```bash
$ chef exec rake spec:run     # unit tests
$ chef exec rake kitchen:test # integration tests
```

## Versioning

This project uses [Semantic Versioning](http://semver.org).

## Author

- [dataday](https://github.com/dataday)

## License

[MIT LICENSE](./MIT-LICENSE)
