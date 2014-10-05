echo "#######put nonpriv module in place##"

pushd `/opt/puppet/bin/puppet agent --configprint environmentpath`/production/modules
git clone https://github.com/jpadams/nonpriv.git
popd

echo "#######updating master classes######"

# update classes on master
curl -X POST -H 'Content-Type: application/json' \
--cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/update-classes
