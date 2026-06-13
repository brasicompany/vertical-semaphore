# Security Policy

VerticalSemaphore is a UI package. It does not perform file access, network
requests, shell execution, persistence, or credential handling.

## Reporting

If you find a vulnerability or a behavior that could affect host app safety,
please report it privately to the Brasico maintainers before publishing details.

Include:

- package version or commit;
- affected platform and OS version;
- minimal reproduction steps;
- expected and actual behavior.

## Scope

In scope:

- unsafe macOS window chrome behavior caused by this package;
- crashes triggered by normal use of public APIs;
- accessibility behavior that could mislead users about close/minimize/zoom actions.

Out of scope:

- vulnerabilities in host apps embedding this package;
- misuse of callbacks supplied by the host app;
- platform bugs outside this package's code.
