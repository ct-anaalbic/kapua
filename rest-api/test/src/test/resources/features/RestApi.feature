###############################################################################
# Copyright (c) 2017, 2020 Eurotech and/or its affiliates and others
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Eurotech
###############################################################################
@restApi

Feature: Rest Api

  Scenario: Starting docker containers
  Starting docker containers, including API container.

    Given List images by name "kapua/kapua-broker:1.2.0-SNAPSHOT"
    Then Create network
    And Start DB container with name "db"
    And Start ES container with name "es"
    And Start EventBroker container with name "events-broker"
    Then I wait 15 seconds
    And Start Message Broker container
      | name     | brokerAddress | brokerIp | clusterName  | mqttPort | mqttHostPort | mqttsPort | mqttsHostPort | webPort | webHostPort | debugPort | debugHostPort | brokerInternalDebugPort | dockerImage                       |
      | broker-1 | broker1       | 0.0.0.0  | test-cluster | 1883     | 1883         | 8883      | 8883          | 8161    | 8161        | 9999      | 9999          | 9991                    | kapua/kapua-broker:1.2.0-SNAPSHOT |
    And Start API container with name "api"
    And I wait 60 seconds

  Scenario: User login
  Trying to login user with username "kapua-sys" and password "kapua-password".

    Given Login user with username "kapua-sys" and password "kapua-password"
    And I got response with status code 200
    And I try to get "tokenId" from json object
    And Token is received

  Scenario: Get all users
  Trying to get all users from database.

    Given Login user with username "kapua-sys" and password "kapua-password"
    And I got response with status code 200
    And I try to get "tokenId" from json object
    And I try to get all users
    And I get list of users with size 2

  Scenario: Stopping docker containers
  Stopping and removing started docker containers.

    And Stop container with name "broker-1"
    And Remove container with name "broker-1"
    And Stop container with name "events-broker"
    And Remove container with name "events-broker"
    And Stop container with name "es"
    And Remove container with name "es"
    And Stop container with name "db"
    And Remove container with name "db"
    And Stop container with name "api"
    And Remove container with name "api"
    And I wait 30 seconds
    And Remove network



