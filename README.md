[https://myip.sqooba.io](https://myip.sqooba.io)
====

This project is the source code powering [https://myip.sqooba.io](https://myip.sqooba.io).

It simply returns the IP address of the caller, is an easy-to-integrate manner

```
curl https://myip.sqooba.io
1.2.3.4
```

It can be used in scripts, such as updating an 
[AWS security group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)
to grant you ssh access:

```
myip=$(curl -s https://myip.sqooba.io)
aws ec2 authorize-security-group-ingress \
    --group-id $group \
    --protocol tcp \
    --port 22 \
    --cidr $myip/32
```

# Hack

```
make all
```
