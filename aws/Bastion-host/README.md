# Bastion host

Synonyms
- Private server (pServer): the server located in a private subnet and not accessible
- Tunneling server (tServer): the server located in public subnet associated with the private subnet through NAT-gateway

Require
- Require NAT-gateway
- The pServer must open port for tServer sg (inbound: sg-pServer -> sq-tServer:anyPort)
- The pServer must open port for ssh from tServer (inbound: sg-pServer -> sq-tServer:22)
- The tServer need to open ssh access from outside (inbound: sg-tServer -> 0.0.0.0:22)
- The tServer must include key.pem to access to pServer
