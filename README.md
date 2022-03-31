# knife batch

Knife plugin that allows for batch requests against key Chef Server endpoints.

## Requirements

A current version of Chef Infra Client that includes knife. Most easily provided by installing [Chef Workstation](https://www.chef.io/downloads/tools/workstation)

## Installation

Via Rubygems

```bash
chef gem install knife-batch
```

Via Source

```bash
git clone https://github.com/joshuariojas/knife-batch.git
cd knife-batch
gem build knife-batch.gemspec && gem install knife-batch-*.gem --no-ri --no-rdoc
```

