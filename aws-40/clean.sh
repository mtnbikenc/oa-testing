#!/usr/bin/env bash
# Clean color codes from log files

for log_file in logs/*.log
do
  echo "Stripping colors from ${log_file}"
  sed -i -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" ${log_file}
done
