## Introduction

NginxPulse is a lightweight Nginx access log analysis and visualization panel designed to provide developers and operations staff with a convenient log monitoring and analysis tool. By parsing Nginx access logs in real time, it offers multi-dimensional statistical metrics, PV/UV filtering, IP geolocation queries, and client information parsing. The project transforms raw log files into intuitive visual charts, helping users quickly understand website traffic, user distribution, and access behavior.

## Features

- **Real-time Log Analysis and Statistics**: Automatically scans and parses Nginx access logs (supports gzip compressed format), providing real-time statistics on key metrics such as PV (Page Views), UV (Unique Visitors), request status code distribution, and top access paths, all presented through intuitive charts.

- **IP Geolocation and Client Parsing**: Integrates the local ip2region database and the remote ip-api.com service to achieve IP address geolocation resolution (supports IPv4/IPv6). Simultaneously, it parses User-Agent strings to extract client device, browser, and operating system information, aiding in the analysis of user sources and access environments.

- **Flexible Data Filtering and Configuration**: Offers configurable PV filtering rules, supporting the exclusion of internal IPs or specific addresses to ensure the accuracy of statistical data. The system uses asynchronous tasks to handle log parsing and IP geolocation completion, preventing real-time analysis blockage, and includes a built-in caching mechanism to enhance query performance.

## Configuration and Usage Instructions

During installation, the default mapping is from the server's site directory (default: `/opt/1panel/www/sites`) to the container's `/sites`. Therefore, after starting the application and configuring Website & Logs, your log path should be written as:

```
/sites/<site-directory>/log/*.log
```

If you wish to match all sites at once, you can also use a wildcard:

```
/sites/*/log/*.log
```