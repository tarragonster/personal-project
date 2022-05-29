# NAT gateway explanation

NAT gateway is used to allow outbound traffic
going from any service deployed in private-subnet

## NAT gateway with aws
- Create nat-gateway on any public-subnet
- Attach to elastic IP
- use route table associate private-subnet (Subnet association)
- use route table routes to route (destination: 0.0.0.0) with (target nat-gateway)
