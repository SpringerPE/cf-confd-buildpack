# cf-confd-buildpack

Cloudfoundry buildpack to manage application configuration files using templates
and data from etcd, consul, redis, vault, dns, environment variables

The idea is run [confd](https://github.com/kelseyhightower/confd) as pre-start
task with some template files which will be rendered by confd to get the final
configuration file for the application


## Using it

https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md

First of all, this buildpack has no requirements at all you can create app folder,
put a `manifest.yml` like this: 

```manifest.yml
---
applications:
- name: grafana
  memory: 512M
  instances: 1
  stack: cflinuxfs3
  random-route: true
  buildpacks:
  - https://github.com/SpringerPE/cf-confd-buildpack.git
  - https://github.com/SpringerPE/cf-grafana-buildpack.git
  env:
    ADMIN_USER: admin
    ANOTHER_VAR: admin
    OTHER_SECRET: blabal
```

and run `cf push`


# Documentation

https://github.com/kelseyhightower/confd/blob/master/docs/quick-start-guide.md


# Development

Implemented using bash scripts to make it easy to understand and change.

https://docs.cloudfoundry.org/buildpacks/understand-buildpacks.html

The builpack uses the `deps` and `cache` folders according the implementation purposes,
so, the first time the buildpack is used it will download all resources, next times 
it will use the cached resources.


# Author

(c) Jose Riguera Lopez  <jose.riguera@springernature.com>
Springernature Engineering Enablement

MIT License
