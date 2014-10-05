# This could be a great demo of the NC API. Change the rule in the PE MCollective group
# in the GUI. This script will print the current rule and then update it and print it again.
# You could then refesh the GUI to view the updated rule.

# This hackily extracts the group ID of the "PE MCollective" group from the NC
# ToDo: rewrite this
PEMCoID=$(curl --cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups| python -m json.tool |grep -C 2 "PE MCollective" | grep "id" | cut -d: -f2 | sed 's/[\", ]//g')

echo "#######PE MCollective group rule####"

# This will pretty print the JSON of the "PE MCollective" group in the NC
curl -k --cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups/$PEMCoID | python -m json.tool

echo "#######update rule w/is_admin fact##"

# This will update the matching rule of the "PE MCollective" group and print resulting JSON
# note: "00000000-0000-4000-8000-000000000000" is the root group
# https://github.com/puppetlabs/classifier/blob/master/doc/api/v1/groups.markdown#post-v1groups
curl -X POST -H 'Content-Type: application/json' \
-d \
'{
    "name": "PE MCollective",
    "environment": "production",
    "parent": "00000000-0000-4000-8000-000000000000",
    "rule": [
        "and",
        [
            "=",
            [
                "fact",
                "is_admin"
            ],
            "true"
        ],
        [
            "~",
            [
                "fact",
                "pe_version"
            ],
            ".+"
        ]
    ],
    "variables": {}
}' \
--cacert `/opt/puppet/bin/puppet agent --configprint localcacert` --cert `/opt/puppet/bin/puppet agent --configprint hostcert` --key `/opt/puppet/bin/puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups/$PEMCoID | python -m json.tool
