# Subdomain Enumerator & Alive Checker

This script automates the process of discovering subdomains for a given domain by leveraging multiple sources like AlienVault, URLScan, and the Wayback Machine. It also checks if the discovered subdomains are alive (resolvable), storing the results in separate files.

## Features

- **Subdomain Enumeration**:
  - Collects subdomains from **AlienVault**, **URLScan**, and **Wayback Machine**.
  
- **Results Saving**:
  - Saves the discovered subdomains into separate files (`alienvault_subs.txt`, `urlscan_subs.txt`, `webarchive_subs.txt`).
  - Combines all subdomains into a single file (`all_subdomains.txt`), ensuring no duplicates.
  
- **Alive Check**:
  - Checks if the discovered subdomains are alive (i.e., resolvable via DNS or ICMP).
  - Saves active subdomains into `alive_subdomains.txt`.

## Usage

### Make the script executable:

```bash
chmod +x subhunt.sh
