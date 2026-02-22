# What is a socket
The socket is an abstraction used to enable communication between processes.

Now, everything in UNIX is a file. Each file has a file descriptor- an integer associated with an open file. A file descriptor for a 'socket'-type file is a 'socket descriptor'. Communication is enabled via this **socket descriptor**, which is a type of file descriptor, as mentioned before.
# Sockets in C
[Just watch this instead of reading](https://www.youtube.com/watch?v=XXfdzwEsxFk)
In C, sockets are easily made via the 'socket API', an API that developers can use to conveniently create sockets without extreme low level coding. So we need to get familiar with this API. 
# A 'process' perspective
From a 'process' perspective (a procedural view), an example is presented now. Say you want to establish communication and then carry out communication between two 'things' (for lack of a better specifier), you would have a simple **'client-server**' model where the server 'serves' the client. How does it do it? The following 2 diagrams are good mental models.

Client Initiates connection
```
socket()  →  getaddrinfo()  →  connect()  →  send()/recv()  →  close()
```

Server waits for connection
```
socket()  →  bind()  →  listen()  →  accept()  →  send()/recv()  →  close()
```
# A data model perspective (written by Sonnet 4.6)

When learning socket programming, most tutorials thrust you immediately into a wall of function calls — `socket()`, `bind()`, `connect()` — and hand you a mental model that is essentially: _you talk, the network listens, magic happens_. This is fine, until you actually have to read the code. Then you encounter `struct sockaddr`, immediately followed by a cast to `struct sockaddr_in`, passed into a function that takes a `struct sockaddr *`, populated by `getaddrinfo()` which returns a linked list of `struct addrinfo`, and somewhere in there is a field called `sin_zero` that exists purely as padding and does absolutely nothing. At this point, most people either quit or develop an unhealthy relationship with `man` pages.

The problem is not the API. The problem is that the API was designed with a very specific set of constraints — it must be protocol-agnostic, it must work in C, and it was designed in the 1980s before the vocabulary for talking about type hierarchies and tagged unions was in widespread use among systems programmers. Nobody handed you the design document. They just handed you the structs.

This is where thinking in terms of **data models** rescues you. A data model, in this context, simply means asking: _what are the types involved, what do they contain, what is their relationship to one another, and why were they designed that way?_ This reframing is powerful because the socket API's apparent complexity is almost entirely a consequence of one design decision — the need for a single set of function signatures to operate over multiple address families (IPv4, IPv6, Unix domain sockets, and others). Once you see that `sockaddr` is not a real address but a **generic pointer target**, that `sockaddr_in` is the actual data, and that `addrinfo` is a linked list node that packages everything `socket()` and `connect()` need in one place, the entire API snaps into focus. The functions do not get simpler, but they become _legible_ — you can read a call to `connect()` and understand precisely which bytes the kernel is inspecting and why.

There is also a practical benefit. Bugs in socket code are almost always data bugs: a port in the wrong byte order, a cast to the wrong struct type, a buffer too small for an IPv6 address. Thinking structurally about the types makes these errors visible before they become two-hour debugging sessions involving Wireshark and existential doubt.

Key takeways (written by gemini 3)

- The complexity of socket programming often stems from its **data models** rather than the logic of the network itself. By shifting your focus from "how to call functions" to "how data is structured," the API becomes much more legible.

- **The "Generic" Interface Constraint:** Because the API was designed in the 1980s without modern language features like generics or tagged unions, it uses **struct casting** to achieve polymorphism. You must treat `struct sockaddr` as a generic base class and `struct sockaddr_in` as a specific implementation.
    
- **Protocol Agnosticism:** The primary design goal was to allow a single function (like `connect()`) to handle different address families (IPv4, IPv6, Unix sockets). This is why you see a repetitive pattern of populating a specific struct but casting it to a generic pointer for the function call.
    
- **Data Models Over Function Calls:** Most "magic" in socket programming happens in the structs. Understanding the relationship between `getaddrinfo()` (the provider) and `struct addrinfo` (the container) clarifies why the API feels so verbose.
    
- **Preventing "Data Bugs":** Most networking errors aren't logic failures but **data alignment issues**. Common pitfalls include:
    
    - **Byte Order:** Failing to convert between host and network order.
        
    - **Buffer Overflows:** Not accounting for the larger size requirements of IPv6.
        
    - **Padding:** Misunderstanding fields like `sin_zero` which are purely for structural alignment.
        
- **The Role of `getaddrinfo`:** Rather than manually filling out structs (the old way), modern code uses `getaddrinfo` to return a **linked list** of potential connection targets, packaging everything the kernel needs in a format it already understands.

What follows is an examination of the socket API not from the perspective of _what you do_ — client connects, server listens — but from the perspective of _what the data looks like_ at each step, why each type exists, and how the type hierarchy as a whole solves the problem of writing a protocol-agnostic networking API in a language with no generics. It is, in other words, the explanation you wished someone had given you at the beginning.
# The Data model
We should think of a heirarchy of 'types' when we want to understand the socket API. This heirarchy is shown below
Great question. The socket API has a small, carefully designed type hierarchy whose entire purpose is to let one set of function signatures work across multiple protocol families. Here is the full picture.

---

### The core problem the data model solves

`connect()`, `bind()`, and `accept()` need to accept an address argument. But an IPv4 address looks nothing like an IPv6 address, which looks nothing like a Unix domain socket path. The API predates C generics and void pointers were considered too loose. The solution was a **tagged union disguised as a cast hierarchy**.

---

### The type hierarchy

```
struct addrinfo
│
│  ai_addr ──────────────────────────────────────────────┐
│  ai_addrlen                                            │
│  ai_family, ai_socktype, ai_protocol                   │
│  ai_next ──▶ (next addrinfo in linked list)            │
│                                                        │ points to
▼                                                        ▼
                                          struct sockaddr          ← generic handle
                                          │  sa_family  (uint16)  ← the tag
                                          │  sa_data[14]          ← opaque bytes
                                          │
                                          │ same memory, reinterpreted via cast
                                          │
                          ┌───────────────┴───────────────┐
                          ▼                               ▼
              struct sockaddr_in                struct sockaddr_in6
              (IPv4, AF_INET)                   (IPv6, AF_INET6)
              │  sin_family                     │  sin6_family
              │  sin_port                       │  sin6_port
              │  sin_addr                       │  sin6_addr
              │    └─ s_addr (uint32)           │    └─ s6_addr[16]
              │  sin_zero[8] (padding)          │  sin6_flowinfo
                                                │  sin6_scope_id
```

---

### The tag: `sa_family`

Every concrete struct begins with the same field — `sa_family` / `sin_family` / `sin6_family` — at the same byte offset. This is the **discriminant**. When the kernel or your code receives a `sockaddr *`, it reads this first field to know how to interpret the rest of the memory. This is the manual equivalent of a tagged union.

```c
struct sockaddr *addr = p->ai_addr;

if (addr->sa_family == AF_INET) {
    // safe to cast to sockaddr_in *
} else if (addr->sa_family == AF_INET6) {
    // safe to cast to sockaddr_in6 *
}
```

---

### Why `sockaddr` itself is never populated directly

`sockaddr` has only 14 bytes of `sa_data`. IPv6 addresses alone are 16 bytes — they do not fit. `sockaddr` is purely a **pointer target for API calls**. You always allocate a `sockaddr_in` or `sockaddr_in6`, fill it in, then cast its pointer to `sockaddr *` when passing it to `bind()`/`connect()`/`accept()`. The cast does not copy or transform the memory; it just changes how the compiler interprets the pointer type.

---

### `addrinfo`: the container that ties everything together

`addrinfo` is not an address — it is a **node in a linked list** that packages an address together with everything `socket()` needs to use it. This is what `getaddrinfo()` produces and what you walk in the connection loop.

```
addrinfo node contains:
  ┌─ what to pass to socket() ─────────────────────────────┐
  │  ai_family    →  first arg  of socket()                │
  │  ai_socktype  →  second arg of socket()                │
  │  ai_protocol  →  third arg  of socket()                │
  └────────────────────────────────────────────────────────┘
  ┌─ what to pass to connect() / bind() ───────────────────┐
  │  ai_addr      →  second arg (sockaddr *)               │
  │  ai_addrlen   →  third arg  (length of that struct)    │
  └────────────────────────────────────────────────────────┘
  ┌─ list plumbing ─────────────────────────────────────────┐
  │  ai_next      →  next node, or NULL at end of list     │
  └────────────────────────────────────────────────────────┘
```

Each node in the list represents one viable way to reach the host. A hostname may resolve to several IPs (load balancing, IPv4+IPv6 dual-stack), so you get one node per viable address, and you try them in order until one connects.

---

### Byte ordering: the hidden data transformation

Every multi-byte integer that crosses the network must be in **big-endian (network) byte order**. x86/ARM machines are little-endian. The mismatch is silent — no compiler warning, just a wrong port number or wrong IP on the wire.

```
host byte order          network byte order
(little-endian)          (big-endian)
port 8080 = 0x1F90       port 8080 = 0x901F   ← bytes reversed
```

The four conversion functions are:

```
htons()   host→network  16-bit   (ports)
ntohs()   network→host  16-bit
htonl()   host→network  32-bit   (IPv4 addresses)
ntohl()   network→host  32-bit
```

You call these when writing into `sin_port` and `sin_addr.s_addr`, and when reading them back out. `getaddrinfo()` does this for you automatically — which is one major reason to prefer it over constructing `sockaddr_in` by hand.

---

### Relating the data model back to the high-level API

|High-level call|Data structs involved|What actually happens|
|---|---|---|
|`getaddrinfo()`|produces `addrinfo` list, allocates `sockaddr_in`/`in6` behind each `ai_addr`|name resolution + struct population|
|`socket()`|reads `ai_family`, `ai_socktype`, `ai_protocol` from the node|kernel allocates a socket object, returns fd|
|`connect()` / `bind()`|receives `sockaddr *` + `addrlen` from `ai_addr` / `ai_addrlen`|kernel reads `sa_family`, casts internally to the right type, extracts IP+port|
|`accept()`|writes a new `sockaddr_in`/`in6` into a buffer you provide|kernel fills in the remote address of the incoming connection|
|`send()` / `recv()`|raw byte buffers — no address structs|data transfer; addressing is already established by `connect()`/`accept()`|
|`close()`|no structs; just the fd integer|kernel tears down the socket and the TCP connection|

The structs are only needed during the **setup phase** — `getaddrinfo` through `connect`/`accept`. Once a connection is established, the kernel already knows the source and destination addresses internally, and `send()`/`recv()` operate purely on byte buffers with no address involvement.