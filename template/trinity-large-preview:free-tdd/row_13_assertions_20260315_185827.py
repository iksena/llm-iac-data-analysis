def test_template(template: Template):
    # Assert EC2 instance exists
    template.resource_count_is("AWS::EC2::Instance", 1)

    # Assert instance has cfn-init metadata for package installation and service setup
    template.has_resource_properties("AWS::EC2::Instance", {
        "Metadata": {
            "AWS::CloudFormation::Init": Match.object_like({
                "config": Match.object_like({
                    "packages": Match.object_like({
                        "yum": Match.object_like({
                            "httpd": Match.any_value()
                        })
                    }),
                    "services": Match.object_like({
                        "sysvinit": Match.object_like({
                            "httpd": Match.object_like({
                                "enabled": True,
                                "ensureRunning": True
                            })
                        })
                    })
                })
            })
        }
    })

    # Assert cfn-hup configuration for metadata updates
    template.has_resource_properties("AWS::EC2::Instance", {
        "Metadata": {
            "AWS::CloudFormation::Init": Match.object_like({
                "config": Match.object_like({
                    "commands": Match.object_like({
                        "01_configure_cfn_hup": Match.object_like({
                            "command": Match.string_like_regexp(".*cfn-hup.*"),
                            "env": Match.object_like({
                                "HOME": Match.any_value(),
                                "PATH": Match.any_value()
                            })
                        })
                    })
                })
            })
        }
    })

    # Assert CreationPolicy with ResourceSignal and 5-minute timeout
    template.has_resource_properties("AWS::EC2::Instance", {
        "CreationPolicy": Match.object_like({
            "ResourceSignal": Match.object_like({
                "Timeout": "PT5M"
            })
        })
    })

    # Assert UserData includes cfn-init and cfn-signal commands
    template.has_resource_properties("AWS::EC2::Instance", {
        "UserData": Match.string_like_regexp(".*cfn-init.*"),
        "UserData": Match.string_like_regexp(".*cfn-signal.*")
    })

    # Assert index.html creation in UserData
    template.has_resource_properties("AWS::EC2::Instance", {
        "UserData": Match.string_like_regexp(".*echo '<html>.*</html>' > /var/www/html/index.html.*")
    })