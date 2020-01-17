###############################################################################
# Copyright (c) 2017, 2019 Eurotech and/or its affiliates and others
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Eurotech - initial API and implementation
###############################################################################
@unit
@deviceRegistry
@deviceConnection
Feature: Device Registry Connection tests
    The Device Registry Connection service is responsible for performing CRUD operations
    regarding device connections on the Kapua database.

Scenario: Regular connection
    It must be possible to create a device connection entry in the database. The entry
    must match the creator parameters. The connection status must also be
    implicitly set to CONNECTED.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    Then The connection object is regular
    And The connection details match
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    And The connection status is "CONNECTED"

Scenario: Device connection update
    It must be possible to change the data of an existing device connection database
    entry.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I modify the connection details to
        | clientIp    | serverIp   | protocol | allowUserChange   |
        | 127.0.0.109 | 127.0.0.25 | udp      | true              |
    Then No exception was thrown
    And The connection details match
        | clientIp    | serverIp   | protocol | allowUserChange   |
        | 127.0.0.109 | 127.0.0.25 | udp      | true              |

Scenario: Try to modify the connection client ID
    It must not be possible to change the client ID of an existing device connection.
    Attempts to change the client ID must be silently ignored. No exceptions must
    be thrown.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I try to modify the connection client Id to "testClient2"
    Then No exception was thrown
    And The connection client ID remains unchanged

Scenario: Count connections in scope
    It must be possible to count all the connections in a given scope.

    Given Scope with ID 1
    And I have the following connections
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
        | testClient2 | 127.0.0.102 | 127.0.0.10 | tcp      | true              |
        | testClient3 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |
        | testClient4 | 127.0.0.104 | 127.0.0.10 | tcp      | true              |
        | testClient5 | 127.0.0.105 | 127.0.0.10 | tcp      | true              |
        | testClient6 | 127.0.0.106 | 127.0.0.10 | tcp      | true              |
        | testClient7 | 127.0.0.107 | 127.0.0.10 | tcp      | true              |
    Then No exception was thrown
    And I count 7 connections in scope 1

Scenario: Count connections in empty scope
    Counting connections for an empty (nonexisting) scope must not raise any exception.
    A regular result (in this case 0) must be returned.

    Given Scope with ID 1
    And I have the following connections
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
        | testClient2 | 127.0.0.102 | 127.0.0.10 | tcp      | true              |
        | testClient3 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |
        | testClient4 | 127.0.0.104 | 127.0.0.10 | tcp      | true              |
        | testClient5 | 127.0.0.105 | 127.0.0.10 | tcp      | true              |
        | testClient6 | 127.0.0.106 | 127.0.0.10 | tcp      | true              |
        | testClient7 | 127.0.0.107 | 127.0.0.10 | tcp      | true              |
    Then I count 0 connections in scope 42

Scenario: Try to change an existing connection ID
    It must not be possible to change the ID of an existing connection. Trying to
    do so must result in an exception being thrown.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    And I expect the exception "KapuaEntityNotFoundException" with the text "The entity of type deviceConnection with id/name"
    When I try to modify the connection Id
    Then An exception was thrown

Scenario: Find a connection by its IDs
    It must be possible to find a specific connection in the database based on
    its scope and entity IDs.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I search for a connection by scope and connection IDs
    Then The connection details match
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |

Scenario: I try to find a non-existing connection
    Searching for a non existing connection must not raise any exception. A null
    reference must be returned instead.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I search for a random connection ID
    Then No connection was found

Scenario: Find a connection by its client ID
    It must be possible to find a specific connection in the database based on its
    scope and client IDs.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connections
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
        | testClient2 | 127.0.0.102 | 127.0.0.10 | tcp      | true              |
        | testClient3 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |
        | testClient4 | 127.0.0.104 | 127.0.0.10 | tcp      | true              |
    When I search for a connection with the client ID "testClient3"
    Then The connection details match
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient3 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |

Scenario: Search for a non existent client ID
    Searching for a non existing connection must not raise any exception. A null
    reference must be returned instead.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connections
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
        | testClient2 | 127.0.0.102 | 127.0.0.10 | tcp      | true              |
        | testClient3 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |
        | testClient4 | 127.0.0.104 | 127.0.0.10 | tcp      | true              |
    When I search for a connection with the client ID "nonexistentId"
    Then No connection was found

Scenario: The Client ID is case sensitive
    Given The User ID 1
    And Scope with ID 1
    And I have the following connections
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I search for a connection with the client ID "TESTClient1"
    Then No connection was found
    When I search for a connection with the client ID "testClient1"
    Then The connection details match
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |

Scenario: Delete a connection from the database
    It must be possible to delete a specific entry fron the connection database.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connections
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
        | testClient2 | 127.0.0.102 | 127.0.0.10 | tcp      | true              |
        | testClient3 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |
        | testClient4 | 127.0.0.104 | 127.0.0.10 | tcp      | true              |
    And I search for a connection with the client ID "testClient3"
    And I delete the existing connection
    When I search for a connection with the client ID "testClient3"
    Then No connection was found

Scenario: Delete a non existing connection
    Trying to delete a non existent connection should result in an exception
    being thrown.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connection
        | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    And I expect the exception "KapuaEntityNotFoundException" with the text "The entity of type deviceConnection with id/name"
    When I try to delete a random connection ID
    Then An exception was thrown

Scenario: Generic connection query
    It must be possible to query for connections in the database based on various
    parameters.

    Given The User ID 1
    And Scope with ID 1
    And I have the following connections
        | clientId     | clientIp    | serverIp   | protocol | allowUserChange   |
        | testClient01 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
        | testClient02 | 127.0.0.102 | 127.0.0.10 | tcp      | true              |
        | testClient03 | 127.0.0.103 | 127.0.0.10 | tcp      | true              |
        | testClient04 | 127.0.0.104 | 127.0.0.11 | tcp      | true              |
        | testClient05 | 127.0.0.104 | 127.0.0.11 | tcp      | true              |
        | testClient06 | 127.0.0.104 | 127.0.0.11 | tcp      | true              |
        | testClient07 | 127.0.0.104 | 127.0.0.11 | udp      | true              |
        | testClient08 | 127.0.0.104 | 127.0.0.10 | udp      | true              |
        | testClient09 | 127.0.0.104 | 127.0.0.10 | udp      | true              |
        | testClient10 | 127.0.0.104 | 127.0.0.10 | udp      | true              |
        | testClient11 | 127.0.0.104 | 127.0.0.10 | udp      | true              |
    When I query for all connections with the parameter "protocol" set to "udp"
    Then I find 5 connections
    When I query for all connections with the parameter "serverIp" set to "127.0.0.11"
    Then I find 4 connections

    # *************************************
    # * Scenarios for connection clientId *
    # *************************************

    Scenario: Create connection with valid symbols for clientId
    Creating connection with clientId which contains allowed numeric and alphanumeric symbols.
    Finding connections which contain allowed symbol. Everything should pass without exception.

        Given I create the new connections with clientId "testClient" and allowed symbols "!$<;|:-@%()_={}'^`~[]0123456789"
        When I query for created connections
        Then I find connections with clientId which contains "testClient" word
        And No exception was thrown

    Scenario: Create connection with clientId which contains invalid symbols
    Creating connections with clientId which contains invalid symbols.
    Finding connections which contain invalid symbol. Connections shouldn't be found.

        Given I expect the exception "KapuaIllegalArgumentException" with the text "*"
        When I create the new connections with clientId "testClient" and invalid symbols "#+*&,?>/:"
        Then An exception was thrown
        And I query for connection with clientId "Test#"
        Then No connection was found

    Scenario: Create a connection with empty clientId
    Create a connection with empty clientId. Connection shouldn't be created.

        Given I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
        When I have the following connection
            | clientId | clientIp    | serverIp   | protocol | allowUserChange |
            |          | 127.0.0.101 | 127.0.0.10 | tcp      | true            |
        Then An exception was thrown
        When I query for connection with clientId ""
        Then No connection was found

    Scenario: Create a connection with too long clientId
    Create a connection with clientId which is longer than 255 characters. Connection shouldn't be created.

        Given I expect the exception "KapuaIllegalArgumentException" with the text "*"
        When I have the following connection
            | clientId                                                                                                                                                                                                                                                         | clientIp    | serverIp   | protocol | allowUserChange |
            | TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest | 127.0.0.101 | 127.0.0.10 | tcp      | true            |
        Then An exception was thrown
        When I query for connection with clientId "TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest"
        Then No connection was found

    Scenario: Create a connection with short clientId
    Create a connection with clientId which contains only one character. Connection should be created.

        Given I have the following connection
            | clientId | clientIp    | serverIp   | protocol | allowUserChange |
            | t        | 127.0.0.101 | 127.0.0.10 | tcp      | true            |
        When I query for connection with clientId "t"
        Then I find connection with clientId "t"
        And No exception was thrown

    Scenario: Create two connections with same clientId
    Creating two connections with same clientId. Only one connection should be created.

        Given I expect the exception "KapuaDuplicateNameException" with the text "*"
        And I have the following connections
            | clientId     | clientIp    | serverIp   | protocol | allowUserChange |
            | testClient01 | 127.0.0.101 | 127.0.0.10 | tcp      | true            |
            | testClient01 | 127.0.0.102 | 127.0.0.10 | tcp      | true            |
        Then An exception was thrown
        When I query for connection with clientId "testClient01"
        And I count 1 connection in scope 1

Scenario: Connection Service factory sanity checks
    Then All connection factory functions must return non null values

Scenario: Check the sanity of the Device Connection Domain data initialization
    Then The device connection domain defaults are correctly initialized

Scenario: Check the Device Connection Domain data seetting
    Then The device connection domain data can be updated
