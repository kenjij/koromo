# koromo

[![Gem Version](https://badge.fury.io/rb/koromo.svg)](https://badge.fury.io/rb/koromo) [![Code Climate](https://codeclimate.com/github/kenjij/koromo/badges/gpa.svg)](https://codeclimate.com/github/kenjij/koromo)

A proxy server for MS SQL Server to present as a RESTful service.

## Requirements

- Ruby 2.0.0 <=
- FreeTDS library (uses the [tiny_tds](https://rubygems.org/gems/tiny_tds/) gem)

## Getting Started

### Install

```
$ gem install koromo
```

### Use

```
$ koromo start -c config.yml
```

### Examples

Config file.

```
$ koromo_config
```

