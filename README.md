# Description
This project is a bash script that searches over all repositories in a specified GitHub org, looking for occurnaces of problematic language (currently: `master`, `slave`, `blacklist`, `whitelist`) and produces a CSV file with the results. The script can also be configured to look back in time to generate a report in the past. This is useful to compare how well you've done at removing the problematic language occurances.

You can take the produced CSV file and enter into your favourite spreasheeting tool for further analysis.

## Prerequisites
You need the GitHub CLI command installing first: https://github.com/cli/cli

## Usage:

    report.sh <GH org name> <path to report> [code date. Format: 2021-01-31]
    
    
## Examples

Generates a report for the https://github.com/quarkusio/ org based on the current code (default branch):

    report.sh quarkusio quarkusio.csv

Generates a report for the https://github.com/quarkusio/ org based on the code as it was on 2021-03-01:

    report.sh quarkusio quarkusio.csv 2021-03-01
