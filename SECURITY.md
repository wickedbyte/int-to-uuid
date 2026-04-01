# Security Policy

## Supported Versions

The following versions of this project are currently receiving security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues,
pull requests, or discussion threads.** Public disclosure before a fix is
available puts all users at risk.

Instead, use one of the following private channels:

- **Email:** [security@wickedbyte.com](mailto:security@wickedbyte.com)
- **Contact form:** [wickedbyte.com](https://wickedbyte.com) (use the website contact form and
  indicate that your message concerns a security matter)

We aim to acknowledge receipt of your report within **2 business days** and will
keep you informed as the issue is triaged and resolved.

### What to Include

A thorough report helps us reproduce and fix the issue faster. Please include as
much of the following as is applicable:

- A clear description of the vulnerability and its potential impact
- The affected version(s) and component(s)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept code or a working exploit (if available)
- Any suggested mitigations or patches you have in mind

---

## Our Disclosure Process

Once a report is received, we follow a coordinated disclosure process:

1. **Acknowledgment** — We confirm receipt within 2 business days and open a
   private channel with the reporter.
2. **Triage** — We reproduce the issue, assess its severity
   using [CVSS](https://www.first.org/cvss/), and assign an internal priority.
3. **Remediation** — We develop and test a fix. The timeline will vary with
   severity:

    | Severity | Target patch timeline |
    | -------- | --------------------- |
    | Critical | 7 days                |
    | High     | 14 days               |
    | Medium   | 30 days               |
    | Low      | 60 days               |

    We will communicate openly with you if circumstances require a longer
    timeline.

4. **Notification** — Before public release, we share the draft advisory and fix
   with you for review and agree on a disclosure date.
5. **Release & Advisory** — The patched version is published and a security
   advisory is posted. We will credit you in the advisory unless you prefer to
   remain anonymous.

---

## Safe Harbor

We appreciate the work of security researchers acting in good faith. If you:

- Report the vulnerability privately and give us reasonable time to respond,
- Do not exploit the issue beyond what is necessary to demonstrate it,
- Do not access, modify, or exfiltrate data belonging to others, and
- Do not disrupt or degrade our services,

we will not pursue legal action against you related to your research and will
make a good-faith effort to work with you to understand and resolve the issue
quickly.

---

## Scope

This policy applies to security vulnerabilities in code maintained in this
repository. The following are **out of scope** for this policy:

- Vulnerabilities in third-party dependencies (please report those to the
  upstream project)
- Issues that require physical access to a device
- Social engineering attacks
- Denial-of-service attacks that rely solely on resource exhaustion without a
  code-level root cause
- Security issues in infrastructure or tooling not published in this repository

---

## Preferred Languages

We prefer to receive reports in **English**.

---

## Attribution

We gratefully acknowledge security researchers who help keep our projects safe.
Unless you request anonymity, your name (or handle) will be credited in the
corresponding security advisory.

---

_This policy is maintained by [WickedByte](https://wickedbyte.com) and applies
to all open source projects published under this organization._
