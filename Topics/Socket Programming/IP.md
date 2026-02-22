# Loopback address
- The machine you're running now. (127.0.0.1)
Imagine a company was assigned the block 192.168.1.0/24 by their ISP.
         They subdivide it into subnets, one of which contains the device 192.168.1.45.

# Anatomy

    ┌─────────────────────────────────────────────────────────────────┐
    │                        SUBNET 192.168.1.0/24                   │
    │   (all devices here share the same network portion 192.168.1)  │
    │                                                                 │
    │    .1 (gateway)    .45 (this device)    .100    .101  ...  .254 │
    └─────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
              ┌───────────────────────────────────┐
              │         IP ADDRESS OF .45          │
              │                                   │
              │   192    .  168   .   1   .   45  │
              │ 11000000   10101000  00000001  00101101
              └───────────────────────────────────┘
                    │                        │
         ┌──────────┴──────────┐    ┌────────┴────────┐
         │   NETWORK PORTION   │    │   HOST PORTION  │
         │   192.168.1         │    │   .45           │
         │   (24 bits)         │    │   (8 bits)      │
         │                     │    │                 │
         │ Identifies which    │    │ Identifies this │
         │ subnet this device  │    │ specific device │
         │ belongs to          │    │ within subnet   │
         └──────────┬──────────┘    └────────┬────────┘
                    │                        │
                    ▼                        ▼

NETMASK:    255  . 255  . 255  .  0       (or /24 in CIDR)
           11111111 11111111 11111111  00000000
           │                        │  │       │
           └── 1s preserve network ─┘  └─ 0s ─┘
                    portion               zero out
                                          host portion

              AND operation:
              ┌─────────────────────────────────────────┐
              │ 11000000.10101000.00000001.00101101  (IP)│
              │ 11111111.11111111.11111111.00000000  (mask)
              │ ──────────────────────────────────────── │
              │ 11000000.10101000.00000001.00000000      │
              │          = 192.168.1.0   ← NETWORK ADDRESS
              └─────────────────────────────────────────┘
                    Host bits zeroed out — not a coincidence.
                    The mask's 0s always force host bits to 0.


RESERVED ADDRESSES IN THIS SUBNET:
   192.168.1.0    → Network address (result of AND above; not assignable)
   192.168.1.255  → Broadcast address (all host bits = 1; not assignable)
   192.168.1.1    → Conventionally assigned to the router/gateway
   192.168.1.2–254 → Usable host addresses (254 total)