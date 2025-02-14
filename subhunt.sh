#!/bin/bash

#CREATED BY WEARDHAT

# Function to replace DOMAIN placeholder with the user-defined domain
get_subdomains() {
  local domain=$1

  # Replace DOMAIN in each command
  echo "Getting subdomains for $domain using AlienVault..."
  curl -s "https://otx.alienvault.com/api/v1/indicators/hostname/${domain}/passive_dns" | \
    jq -r '.passive_dns[]?.hostname' | \
    grep -E "^[a-zA-Z0-9._-]+\.${domain}$" | \
    sort -u | \
    tee "alienvault_subs.txt"

  echo "Getting subdomains for $domain using URLScan..."
  curl -s "https://urlscan.io/api/v1/search/?q=domain:${domain}&size=10000" | \
    jq -r '.results[]?.page?.domain' | \
    grep -E "^[a-zA-Z0-9.-]+\.${domain}$" | \
    sort -u | \
    tee "urlscan_subs.txt"

 # Wayback Machine section 
  echo "Getting subdomains for $domain using Wayback Machine..."
  curl -s "https://web.archive.org/cdx/search/cdx?url=*.${domain}/*&output=json&collapse=urlkey" | \
    jq -r '.[1:][] | .[2]' | \
    grep -Eo '([a-zA-Z0-9._-]+\.)?'"${domain}" | \
    sort -u | \
    tee "webarchive_subs.txt"



  # Counting the total number of subdomains found in each file
  echo "Number of subdomains from AlienVault: $(wc -l < alienvault_subs.txt)"
  echo "Number of subdomains from URLScan: $(wc -l < urlscan_subs.txt)"
  echo "Number of subdomains from Wayback Machine: $(wc -l < webarchive_subs.txt)"
}

# Combine the results from all sources into one file, removing duplicates
combine_subs() {
    cat alienvault_subs.txt urlscan_subs.txt webarchive_subs.txt | sort -u > all_subdomains.txt
}

# Check if subdomains are alive (resolvable) and store active subdomains
combine_alive_subs() {
    echo "Checking which subdomains are alive..."
    > alive_subdomains.txt  

    while read subdomain; do
        if ping -c 1 -W 1 "$subdomain" &>/dev/null; then
            echo "$subdomain is alive" >> alive_subdomains.txt
        fi
    done < all_subdomains.txt

    
    echo "Number of active subdomains: $(wc -l < alive_subdomains.txt)"
}

read -p "Enter the domain (e.g., example.com): " domain

get_subdomains "$domain"

combine_subs

combine_alive_subs
