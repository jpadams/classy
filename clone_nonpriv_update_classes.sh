pushd `puppet agent --configprint environmentpath`/production/modules
git clone https://github.com/jpadams/nonpriv.git

# update classes on master
curl -k --cacert `puppet agent --configprint localcacert` --cert `puppet agent --configprint hostcert` --key `puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups/00000000-0000-4000-8000-000000000000 | python -m json.tool

echo "####################################"

curl -X POST -H 'Content-Type: application/json' \
--cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/update-classes | python -m json.tool

popd
