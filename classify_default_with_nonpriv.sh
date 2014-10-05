
echo "#######print config default group####"

# print config of default group
# default group always has group id of "00000000-0000-4000-8000-000000000000"
curl -k --cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups/00000000-0000-4000-8000-000000000000 | python -m json.tool

echo "#######add class nonpriv->default###"

curl -X POST -H 'Content-Type: application/json' \
-d \
'{
    "name": "default",
    "classes": {
      "nonpriv": {
        "suffix": "nonroot",
        "password": "puppetlabs",
        "server": "master.inf.puppetlabs.demo"
      }
    }
}' \
--cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups/00000000-0000-4000-8000-000000000000 | python -m json.tool
