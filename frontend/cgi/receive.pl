#!/usr/bin/env perl

use strict;
use warnings;

use autoconnect;

# This script gets new output from the DB if client-side scripting is available.
# The expected request type is POST and the entity body should contain the id of
# the last received output message. The session-id should be available. The
# request will be generated by a client-side script.
# The script queries the Messages table for all messages with an mid greater
# than the id provided with the request. If the session is expired or not busy,
# a 200 response containing the messages and the mid of the last message will
# be sent to the client. The mid can be contained in a proptietary X- HTTP header
# field, which makes additional client-side parsing of the response body
# unnecessary. If the session is not expired and busy, a 200 response containing
# the messages and the last mid is sent as well, but a Refresh header-field will
# be added. This will be detected by the client, which will spawn a new
# request to get the remaining output (if no Refresh header is sent, the session
# is not busy and the client can re-enable the user input fields). If no new
# messages are available in the DB, the script will wait for a time and query the
# DB again, possibly repeatedly until new messages are available, the session is
# no longer busy or the connection to the client has been closed.