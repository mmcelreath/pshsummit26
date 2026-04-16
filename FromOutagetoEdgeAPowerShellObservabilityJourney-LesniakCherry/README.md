# From Outage to Edge: A PowerShell Observability Journey #

# Abstract #
This session tells the real-world story of how a critical service outage became the catalyst for creating a sophisticated, cross-platform monitoring solution. We begin with the chaos of a high-stakes client outage, where an intermittent network problem involving connectivity, DNS, and authentication evaded traditional tools. We'll show you how we met this challenge by partnering with an LLM as a development co-pilot to rapidly scaffold a multithreaded PowerShell script with concurrent checks, robust UTC logging, and graceful error handling.

With the core solution in place, our journey continues. We push the boundaries of PowerShell beyond the Windows server, hardening the script with platform-specific techniques—like cache-bypassed DNS lookups—to run seamlessly on Linux. We then take this powerful tool to the edge, deploying it to a fleet of Raspberry Pi devices and containerizing it with Docker for flexible, low-cost deployments. This journey from crisis to code culminates in a powerful live demo where you will see our fleet of PowerShell-running sensors detect a simulated failure in real-time, trigger a visual alert, and push telemetry to a centralized dashboard—transforming scattered logs into actionable observability.

# Speakers #
- Frank Lesniak
- Blake Cherry

# GitHub Repository Link #
- [PSConnMon](https://github.com/franklesniak/PSConnMon)