PEMCoID=$(curl --cacert `puppet agent --configprint localcacert` --cert `puppet agent --configprint hostcert` --key `puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups| python -m json.tool |grep -C 2 "PE MCollective" | grep "id" | cut -d: -f2 | sed 's/[\", ]//g')

echo "####################################"

curl -k --cacert `puppet agent --configprint localcacert` --cert `puppet agent --configprint hostcert` --key `puppet agent --configprint hostprivkey` --insecure https://localhost:4433/classifier-api/v1/groups/$PEMCoID | python -m json.tool

echo "####################################"

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
