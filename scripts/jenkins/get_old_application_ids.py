#!/usr/bin/env python
#
# This script can be used to parse a response from the Marathon API returning a
# list of running applications (/v2/apps)
# 
# The applications are assumed to be named like this:
#
# application-1
# application-2
# ...
# application-ID
#
# The script will output a list of applications that should be suspended,
# leaving only the last one running (= the application with the highest ID)
#
# USAGE: 
#
# ./get_old_application_ids.py APPLICATION_NAME
#
# The JSON response from Marathon will be read from standard input.
#
# Example:
#
# Say, the following applications are running: test-3, app-2, app-4
# And we run the script as follows: 
# 
#   ./get_old_application_ids.py app < json_response
#
# The output will then be: app-2, meaning that only this instance should 
# be suspended. The script doesn't actually suspend the application, and 
# doesn't even interact with Marathon.

import json
import sys

def get_running_applications(stream):
  decoded = json.loads(stream.read())
  return map(lambda app: app["id"], decoded["apps"])

def get_matching_application_ids(applications, application):
  ids = []
  for id in applications:
    parts = id.split("-")
    app = "-".join(parts[:-1])
    if app == application:
      ids.append(int(parts[-1]))
  return ids
    
def get_application_ids_that_should_be_deleted(application_ids):
  application_ids.sort()
  return application_ids[:-1]

def output_applications_that_should_be_deleted(application_ids, application):
  for id in application_ids:
    print str.format("{0}-{1}", application, id)

def main(match_application, input_stream):
  applications = get_running_applications(input_stream)
  application_ids = get_matching_application_ids(applications, match_application)
  delete = get_application_ids_that_should_be_deleted(application_ids)
  output_applications_that_should_be_deleted(delete, match_application)

if __name__ == "__main__":
  main(sys.argv[1], sys.stdin)
