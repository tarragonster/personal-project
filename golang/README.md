#Standard project

##Update the Go version

###1.Uninstall the exisiting version

```shell
sudo rm -rf /usr/local/go
```

###2. Install the new version

Go to the downloads page and download the binary release suitable for your system.

###3. Extract the archive file

```shell
sudo tar -C /usr/local -xzf [UserPath]/Downloads/go1.8.1.linux-amd64.tar.gz
```

###4. Make sure that your PATH contains /usr/local/go/bin

```shell
echo $PATH | grep "/usr/local/go/bin"
```

###5. References

Ref: [Code] nikhita - [update-golang](https://gist.github.com/nikhita/432436d570b89cab172dcf2894465753) \

##Project layout

###1. cmd

- Main application of the project
- The directory name for each application should match the name of the executable you want to have (e.g., /cmd/myapp).
- Don't put a lot of code in the application directory
- if you think the code can be imported and used in other projects, then it should live in the /pkg directory
- Usually main.go would be resided

###2. pkg

- Library code that's ok to use by external applications
- Other projects will import these libraries expecting them to work, so think twice before you put something here
- internal directory is a better way to ensure your private packages are not importable because it's enforced by Go

###3. internal

- Private application and library code
- This is the code you don't want others importing in their applications or libraries
- You can optionally add a bit of extra structure to your internal packages to separate your shared and non-shared internal code
- Your actual application code can go in the /internal/app directory (e.g., /internal/app/myapp) and the code shared by those apps in the /internal/pkg directory (e.g., /internal/pkg/myprivlib)

###4. configs

- Configuration file templates or default configs.

###5. api

- OpenAPI/Swagger specs
- JSON schema files
- Protocol definition files

###6. asset

- Other assets to go along with your repository (images, logos, etc).

###7. build

- Packaging and Continuous Integration
- Put your cloud (AMI), container (Docker), OS (deb, rpm, pkg) package configurations and scripts in the /build/package directory
- Put your CI (travis, circle, drone) configurations and scripts in the /build/ci directory

###8. deployment

- IaaS, PaaS, system and container orchestration deployment configurations and templates (docker-compose, kubernetes/helm, mesos, terraform, bosh).

###9. docs

- Design and user documents (in addition to your godoc generated documentation).

###10. examples

- Examples for your applications and/or public libraries

###11. githooks

- Githook

###12. init

- System init (systemd, upstart, sysv) and process manager/supervisor (runit, supervisord) configs.

###13. scripts

- Scripts to perform various build, install, analysis, etc operations.
- These scripts keep the root level Makefile small and simple.

###14. test

- Additional external test apps and test data.
- Feel free to structure the /test directory anyway you want.
- You can have /test/data or /test/testdata if you need Go to ignore what's in that directory

###15. third_party

- External helper tools, forked code and other 3rd party utilities (e.g., Swagger UI).

###16. tools

- Supporting tools for this project.
- Note that these tools can import code from the /pkg and /internal directories.

###17. vendor

- Application dependencies (managed manually or by your favorite dependency management tool like the new built-in, but still experimental, modules feature).
- Note that since 1.13 Go also enabled the module proxy feature (using https://proxy.golang.org as their module proxy server by default).

###18. web (app/static/template)

- Web application specific components: static web assets, server side templates and SPAs.

###19. website

- This is the place to put your project's website data if you are not using GitHub pages.

##References

[Code] golang-standards - [project-layout](https://github.com/golang-standards/project-layout) \