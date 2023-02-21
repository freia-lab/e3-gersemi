#!/bin/bash

awk -f extract_data.awk $1 | sort -k 1n
