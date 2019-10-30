###############################################################################
# Copyright (c) 2019 Eurotech and/or its affiliates and others
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Eurotech - initial API and implementation
###############################################################################
@user
@userRole
@integration

Feature: User role service integration tests

  Scenario: Start datastore for all scenarios

    Given Start Datastore

  Scenario: Start event broker for all scenarios

    Given Start Event Broker

  Scenario: Adding existing roles to user
  Adding more than one role to user

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I configure the role service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I create the domain
      | name | actions             |
      | test | read,write, execute |
    And The permissions "read, write, execute"
    And I create the access info entity
    And I create the roles
      | name  |
      | role1 |
      | role2 |
      | role3 |
    And I add permissions to the role
    And I add access roles to user
    Then Access role with name "role3" is found
    And I logout

  Scenario: Add user permissions to the role
  Creating user "user1" and role "test_role", adding permissions with user domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create users as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "user"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create user with name "new-user"
    And I find user with name "new-user"
    And I try to edit user to name "new-user"
    And I try to delete user "new-user"
    Then No exception was thrown
    And I logout

  Scenario: Add device permissions to the role
  Creating user "user1" and role "test_role", adding permissions with device domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create devices as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "device"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create a device with name "device1"
    And I find device with client id "device1"
    And I try to edit device to clientId "device2"
    And I delete the device with the client id "device1"
    Then No exception was thrown
    And I logout

  Scenario: Add device event permissions to the role
  Creating user "user1" and role "test_role", adding permissions with device and device_event domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find device events"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    Given User A
      | name  | displayName  | email             | phoneNumber     | status  | userType |
      | user1 | Kapua User A | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I select the domain "device"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I select the domain "account"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And A birth message from device "device_1"
    And I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: device_event:read:"
    When I search for events from device "device_1" in account "kapua-sys"
    Then An exception was thrown
    And I logout
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select the domain "device_event"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I logout
    Given I login as user with name "user1" and password "User@10031995"
    When I search for events from device "device_1" in account "kapua-sys"
    Then I find 1 device events
    And The type of the last event is "BIRTH"
    And No exception was thrown
    And I logout

  Scenario: Add group permissions to the role
  Creating user "user1" and role "test_role", adding permissions with group domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create groups as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "group"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create the group with name "group1"
    And I find last created group
    And I update the group name to "group-ana"
    And I delete the last created group
    Then No exception was thrown
    And I logout

  Scenario: Add role permissions to the role
  Creating user "user1" and role "test_role", adding permissions with role domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create roles as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "role"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create the following role
      | scopeId | name       |
      | 1       | test_role1 |
    And I find role with name "test_role"
    And I update the last created role name to "role-ana"
    And I delete the last created role
    Then No exception was thrown
    And I logout

  Scenario: Add tag permissions to the role
  Creating user "user1" and role "test_role", adding permissions with tag domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create tags as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "tag"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And Tag with name "tag1"
    And Tag with name "tag1" is found
    And Tag name is changed into name "tag2"
    And Tag is deleted
    Then No exception was thrown
    And I logout

  Scenario: Add account permissions to the role
  Creating user "user1" and role "test_role", adding permissions with account domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create accounts as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "account"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I find account with name "account1"
    And I try to edit description to "account in child account"
    And I delete account "account1"
    Then No exception was thrown
    And I logout

  Scenario: Add job permissions to the role
  Creating user "user1" and role "test_role", adding permissions with job domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to find, delete or create jobs as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "job"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create a job with the name "job1"
    And I find a job with name "job1"
    And I try to edit job to name "job2"
    And I delete the job with name "job2"
    Then No exception was thrown
    And I logout

  Scenario: Add domain, user and access_info permissions to the role
  Creating user "user1" and role "test_role", adding permissions with domain, access_info and user domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to add permission as user "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And User A
      | name  | displayName  | email             | phoneNumber     | status  | userType |
      | user1 | Kapua User B | kapua_b@kapua.com | +386 31 323 555 | ENABLED | INTERNAL |
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I select the domain "domain"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I select the domain "access_info"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I select the domain "user"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I create the domain
      | name | actions             |
      | test | read,write, execute |
    And The permissions "read, write, execute"
    And I create the permissions
    Then No exception was thrown
    And I logout

  Scenario: Add datastore permissions to the role
  Creating user "user1" and role "test_role", adding permissions with tag datastore and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to work with data as "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I select the domain "device"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And The device "test-device-1"
    And I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: datastore:read:"
    And I search for data message with id "fake-id"
    And I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    And I select the domain "datastore"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I logout
    When I login as user with name "user1" and password "User@10031995"
    And I search for data message with id "fake-id"
    Then I don't find message
    And No exception was thrown
    And I logout

  Scenario: Delete access role from user
  Login as kapua-sys user, adding role and create access role.
  If user deletes existing role, access role has to be null.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I add access role to user
    Then Access role with name "test_role" is found
    When I delete the last created role
    Then Access role is not found
    And I logout

  Scenario: Add deleted role again
  First add deleted role, and after that create access role

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    When I add access role to user
    Then Access role with name "test_role" is found
    And I logout

  Scenario: Delete permissions from role
  After access role permissions are removed, user also should not have that permissions

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I select the domain "user"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
    And I add access role to user
    And I delete role permissions
    And I logout
    And I login as user with name "user1" and password "User@10031995"
    And I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission to perform this action. Missing permission: user:write:1:*. Please perform a new login to refresh users permissions."
    And I create user with name "user-test"
    Then An exception was thrown
    And I logout


  Scenario: Add same role to user twice
  If user tries to add same role two times, he gets exception

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And I create the access info entity
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I add access role to user
    And I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name test_role already exists."
    And I add access role to user
    And An exception was thrown
    Then I logout

  Scenario: Add same permission twice to the same role
  If user wants to add user:read permission two times to the same role,
  than exception was thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And I select the domain "user"
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
    Then No exception was thrown
    And I expect the exception "KapuaEntityUniquenessException"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
    Then An exception was thrown
    And I logout

  Scenario: Add scheduler permissions to the role
  Creating user "user1" and role "test_role", adding permissions with scheduler domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to work with schedules as "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I select the domain "job"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I select the domain "scheduler"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I found trigger properties with name "Interval Job"
    And A regular trigger creator with the name "TestSchedule" and following properties
      | name     | type              | value |
      | interval | java.lang.Integer | 1     |
    And I try to create a new trigger entity from the existing creator
    And I try to edit trigger name "TestSchedule1"
    And I try to delete last created trigger
    Then No exception was thrown
    And I logout
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I delete the last created role permissions
    And I logout
    Given I login as user with name "user1" and password "User@10031995"
    And I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: scheduler:write:"
    And I try to create a new trigger entity from the existing creator
    Then An exception was thrown
    And I logout

  Scenario: Add endpoint_info permissions to the role
  Creating user "user1" and role "test_role", adding permissions with endpoint_info domain and read, write and delete actions to the "test_role",
  adding "test_role" to "user1" and after that trying to work with endpoints as "user1"

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And I create user with name "user1"
    And Credentials
      | name  | password      | enabled |
      | user1 | User@10031995 | true    |
    And I create endpoint with schema "endpoint1", dns "com" and port 8000
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I select the domain "endpoint_info"
    And I create the following role permission
      | scopeId | actionName | targetScopeId |
      | 1       | read       | 1             |
      | 1       | write      | 1             |
      | 1       | delete     | 1             |
    And I add access role to user
    And I logout
    Then I login as user with name "user1" and password "User@10031995"
    And I try to find endpoint with schema "endpoint1"
    Then I found endpoint with schema "endpoint1"
    When I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:write:"
    And I create endpoint with schema "endpoint2", dns "dns" and port 20000
    Then An exception was thrown
    When I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:delete:"
    And I delete the last created endpoint
    Then An exception was thrown
    And I logout
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I delete the last created role permissions
    And I logout
    Given I login as user with name "user1" and password "User@10031995"
    And I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:read:"
    And I try to find endpoint with schema "endpoint1"
    Then An exception was thrown
    And I logout

  Scenario: Try to add two different roles with same permissions
  Creating user "TestUser" and roles "test_role" and "test_role1".
  Adding the same permissions with user domain and read, write and
  delete actions to the both roles, and adding roles to the user.
  After that, trying to work with users as user "TestUser".

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "TestUser"
    And Credentials
      | name     | password      | enabled |
      | TestUser | User@10031995 | true    |
    And I create the access info entity
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I select the domain "user"
    And I create the following role permissions
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I create the following role
      | scopeId | name       |
      | 1       | test_role1 |
    And I select the domain "user"
    And I create the following role permissions
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I add access role to user
    And I count the access roles from user
    And I count 2
    And No exception was thrown
    And I logout
    And I login as user with name "TestUser" and password "User@10031995"
    And I create user with name "TestUser1"
    And I find user with name "TestUser1"
    And I try to edit user to name "TestUser2"
    And I try to delete user "TestUser2"
    Then No exception was thrown
    And I logout

  Scenario: Add admin role to the user
  Creating user "TestUser", adding admin role to user. Login as user TestUser
  and try to add, delete, find or edit users, devices, tags, jobs, groups, roles, endpoints.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "TestUser"
    And Credentials
      | name     | password      | enabled |
      | TestUser | User@10031995 | true    |
    And I search for user with name "TestUser"
    And I find user with name "TestUser"
    And I find role with name "admin"
    And I search for the permissions of founded role
    And I count 1
    And I create the access info entity
    And I add access role to user
    And I logout
    And I login as user with name "TestUser" and password "User@10031995"
    And I create user with name "user"
    And I find user with name "user"
    And I try to edit user to name "user1"
    And I try to delete user "user1"
    And I create a device with name "TestDevice"
    And I find device with client id "TestDevice"
    And I try to edit device to clientId "TestDevice1"
    And I delete the device with the client id "TestDevice1"
    And I create a job with the name "TestJob"
    And I find a job with name "TestJob"
    And I try to edit job to name "TestJob1"
    And I delete the job with name "TestJob1"
    And Tag with name "Tag"
    And Tag with name "Tag" is found
    And Tag name is changed into name "Tag1"
    And Tag is deleted
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I find role with name "test_role"
    And I update the last created role name to "role1"
    And I delete the last created role
    And I create the group with name "TestGroup"
    And I find last created group
    And I update the group name to "TestGroup1"
    And I delete the last created group
    And I create endpoint with schema "TestEndpoint", dns "com" and port 8000
    And I try to find endpoint with schema "TestEndpoint"
    And I try to edit endpoint schema to "TestEndpoint1"
    And I delete the last created endpoint
    Then No exception was thrown
    And I logout

  Scenario: Deleting admin role
  Login as kapua-sys user, and try to delete "admin" role.
  An exception with proper text should be raised.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I expect the exception "KapuaException" with the text "Operation not allowed on admin role"
    When I delete the last created role
    Then An exception was thrown
    And I logout

  Scenario: Deleting default permissions from admin role
  Login as kapua-sys user, and try to find and delete default permission
  from admin role. An exception with proper text should be raised.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And I find role with name "admin"
    And I search for the permissions of founded role
    And I count 1
    And I expect the exception "KapuaException" with the text "Operation not allowed on this specific permission"
    And I delete the default admin role permission
    Then An exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Add and delete user permissions to the admin role
  Login as user kapua-sys, go to roles and add user permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "user"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I count the role permissions in scope 1
    And I count 1
    And I logout

  Scenario: Add and delete device permissions to the admin role
  Login as user kapua-sys, go to roles and add device permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "device"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Add and delete job permissions to the admin role
  Login as user kapua-sys, go to roles and add job permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "job"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Add and delete account permissions to the admin role
  Login as user kapua-sys, go to roles and add account permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "account"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Add and delete group permissions to the admin role
  Login as user kapua-sys, go to roles and add group permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "group"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Add and delete role permissions to the admin role
  Login as user kapua-sys, go to roles and add role permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "role"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Add and delete endpoint_info permissions to the admin role
  Login as user kapua-sys, go to roles and add endpoint_info permissions with
  read, write and delete actions to the admin role. Try to delete
  added permission. After deleting, exception should not be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I find role with name "admin"
    And I search for the permissions of founded role
    Then I count 1
    And I select the domain "endpoint_info"
    And I create the following role permission
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role
    And I count 4
    When I delete all admin role permissions except of default permission
    Then No exception was thrown
    And I search for the permissions of founded role
    And I count 1
    And I logout

  Scenario: Try to find users granted to admin role
  Creating two users as user kapua-sys, and adding "admin" role to these users.
  Searching for granted users, counting them and confirming name of them.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "TestUser"
    And I create the access info entity
    And I find role with name "admin"
    And I add access role to user
    And I create user with name "TestUser1"
    And I create the access info entity
    And I add access role to user
    When I search for granted user
    Then I count 2
    And I found granted users with name
      | name      |
      | TestUser  |
      | TestUser1 |
    And No exception was thrown
    And I logout

  Scenario: Try to find users granted to role
  Creating two users as user kapua-sys, creating role "test_role" and adding
  a created role to these users. Searching for granted users, counting them
  and confirming name of them.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "TestUser1"
    And I create the access info entity
    And I create the following role
      | scopeId | name       |
      | 1       | test_role1 |
    And I add access role to user
    And I create user with name "TestUser2"
    And I create the access info entity
    And I add access role to user
    When I search for granted user
    Then I count 2
    And I found granted users with name
      | name      |
      | TestUser1 |
      | TestUser2 |
    And No exception was thrown
    And I logout

  Scenario: Adding role twice in child account
  Creating new child account as user kapua-sys. In child account, creating new role TestRole
  and new user TestUser. Adding role to created user. Trying to add the same role twice. An
  exception should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "SubAccount", organization name "Organization" and email adress "test@test.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I create user with name "TestUser" in child account
    And I create role "TestRole" in child account
    And I create the access info entity in child account
    And I add access role to user in child account
    And I count the access roles from user in child account
    And I count 1
    And I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name TestRole already exists."
    And I add access role to user in child account
    Then An exception was thrown
    And I logout

  Scenario: Add user permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with user domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete users.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "user"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I create user with name "User"
    And I find user with name "User"
    And I try to edit user to name "User"
    And  I try to delete user "User"
    And No exception was thrown
    And I logout

  Scenario: Add device permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with device domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete devices.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "device"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I create a device with name "TestDevice"
    And I find device with client id "TestDevice"
    And I try to edit device to clientId "TestDevice1"
    And I delete the device with the client id "TestDevice1"
    And No exception was thrown
    And I logout

  Scenario: Add job permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with job domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete jobs.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "job"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I create a job with the name "TestJob"
    And I find a job with name "TestJob"
    And I try to edit job to name "TestJob1"
    And  I delete the job with name "TestJob1"
    And No exception was thrown
    And I logout

  Scenario: Add account permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with account domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete accounts.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "account"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I create a account with name "TestAccount", organization name "Organization" and email adress "organization@org.com"
    And I find account with name "TestAccount"
    And I expect the exception "KapuaAccountException" with the text "An illegal value was provided for the argument"
    When I change the account "TestAccount" name to "TestAccount1"
    Then An exception was thrown
    When I delete account "TestAccount"
    And No exception was thrown
    And I logout

  Scenario: Add endpoint_info permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with endpoint_info domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete endpoints.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create endpoint with schema "TestEndpoint", dns "com" and port 8000
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "endpoint_info"
    And I create the following role permission in child account
      | scopeId | actionName | targetScopeId |
      | 1       | read       | 1             |
      | 1       | write      | 1             |
      | 1       | delete     | 1             |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I try to find endpoint with schema "TestEndpoint"
    Then I found endpoint with schema "TestEndpoint"
    When I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:write:"
    And I create endpoint with schema "endpoint2", dns "dns" and port 20000
    Then An exception was thrown
    When I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:delete:"
    And I delete the last created endpoint
    Then An exception was thrown
    And I logout

  Scenario: Add group permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with group domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete groups.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "group"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I create the group with name "TestGroup"
    And I find last created group
    And I update the group name to "TestGroup1"
    When I delete the last created group
    And No exception was thrown
    And I logout

  Scenario: Add role permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with role domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete roles.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "role"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I find role with name "test_role"
    And I update the last created role name to "test_role1"
    When I delete the last created role
    And No exception was thrown
    And I logout

  Scenario: Add scheduler permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with scheduler domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete schedulers.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "scheduler"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: job:read:-1:*"
    When I found trigger properties with name "Interval Job"
    Then An exception was thrown
    And I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    And I select the domain "job"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And I found trigger properties with name "Interval Job"
    And A regular trigger creator with the name "TestSchedule" and following properties
      | name     | type              | value |
      | interval | java.lang.Integer | 1     |
    And I try to create a new trigger entity from the existing creator
    And I try to edit trigger name "TestSchedule1"
    And I try to delete last created trigger
    And No exception was thrown
    And I logout

  Scenario: Add tag permissions to the role in child account
  Creating child account as user kapua-sys, adding user and role into child account.
  Adding permissions with tag domain and read, write and delete actions to the role,
  and after that adding role with permissions to the user. Logout as kapua-sys and
  login as created user, and try to add, edit, find or delete tags.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "account1", organization name "organization" and email adress "organization@gmail.com"
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
    And The account with Id 1 has 1 subaccounts
    And I find account with name "account1"
    And I create role "Role1" in child account
    And I try to find role "Role1" in child account
    Then Role in child account is found
    And I select the domain "tag"
    And I create the following role permission in child account
      | scopeId | actionName |
      | 1       | read       |
      | 1       | write      |
      | 1       | delete     |
    And I search for the permissions of founded role in child account
    And I count 3
    And I create user with name "SubUser" in child account
    And Credentials
      | name    | password      | enabled |
      | SubUser | User@10031995 | true    |
    And I create the access info entity in child account
    And I add access role to user in child account
    And I logout
    And I login as user with name "SubUser" and password "User@10031995"
    And Tag with name "TestTag"
    And Tag with name "TestTag" is found
    And Tag name is changed into name "TestTag1"
    And Tag is deleted
    And No exception was thrown
    And I logout

  Scenario: Adding admin role twice
  Creating user TestUser as user kapua-sys and trying to add admin role twice.
  The expected exception was thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create user with name "TestUser"
    And I find role with name "admin"
    And I create the access info entity
    And I add access role to user
    When I count the access roles from user
    Then I count 1
    And I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name admin already exists."
    And I add access role to user
    Then An exception was thrown
    And I logout

  Scenario: Adding admin role to a user in child account
  Creating child account as user kapua-sys, creating user TestUser into child account.
  Trying to add admin role to a user in child account. Expected exception should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I find role with name "admin"
    And I count the roles in scope 1
    And I count 1
    And I create a account with name "SubAccount", organization name "Organization" and email adress "test@test.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I create user with name "TestUser" in child account
    And I create the access info entity in child account
    And I expect the exception "KapuaEntityNotFoundException" with the text "The entity of type role with id/name 1 was not found"
    When I add access role to user in child account
    Then An exception was thrown
    And I logout

  Scenario: Adding admin role to multiple users
  Creating two users as kapua-sys user and adding admin role to these two users.
  Both of users should have 1 access role, and exception shouldn't be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I find role with name "admin"
    When I count the roles in scope 1
    Then I count 1
    And I create user with name "TestUser"
    And I create the access info entity
    And I add access role to user
    When I search for access roles from the last user
    Then I count 1
    And I create user with name "TestUser2"
    And I create the access info entity
    And I add access role to user
    When I search for access roles from the last user
    Then I count 1
    And No exception was thrown
    And I logout

  Scenario: Deleting role after it has been added to user
  Creating role test_role as kapua-sys user, creating user TestUser.
  Adding role to created user. Delete role and check if user still has role.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create the following role
      | scopeId | name      |
      | 1       | test_role |
    And I create user with name "TestUser"
    And I create the access info entity
    And I add access role to user
    And I search for access roles from the last user
    And I count 1
    And I delete the last created role
    When I search for access roles from the last user
    Then I count 0
    And No exception was thrown
    And I logout

  Scenario: Adding role to multiple users in child account
  Creating child account and two users in that child account. Creating role in child account. Adding
  new roles to these two users. Both of users should have 1 access role, and exception shouldn't be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "SubAccount", organization name "Organization" and email adress "test@test.com"
    And I create role "SubRole" in child account
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I create user with name "SubUser" in child account
    And I create the access info entity in child account
    And I add access role to user in child account
    When I count the access roles from user in child account
    Then I count 1
    And I create user with name "SubUser1" in child account
    And I create the access info entity in child account
    And I add access role to user in child account
    When I count the access roles from user in child account
    Then I count 1
    And No exception was thrown
    And I logout

  Scenario: Adding role from child account to user in new child account
  Creating child account SubAccount in kapua-sys account. Creating role TestRole in SubAccount.
  Creating child account SubSubAccount in SubAccount account. Creating user in SubSubAccount.
  Trying to add created role from SubAccount to user in SubSubAccount. An exception should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "SubAccount", organization name "Organization" and email adress "test@test.com"
    And I create role "TestRole" in child account
    And I configure account service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I create a account with name "SubSubAccount", organization name "Organization" and email adress "test1@test.com" and child account
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I create user with name "TestUser" in child account
    And I create the access info entity in child account
    And I expect the exception "KapuaEntityNotFoundException" with the text "*"
    When I add access role to user in child account
    Then An exception was thrown
    And I logout

  Scenario: Adding the same role to user twice in child account
  Creating child account as kapua-sys user, creating role and user in new child account.
  Trying to add created role twice to the user. An expected exception should be thrown.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "SubAccount", organization name "Organization" and email adress "test@test.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I create user with name "TestUser" in child account
    And I create role "TestRole" in child account
    And I create the access info entity in child account
    And I add access role to user in child account
    And I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name TestRole already exists."
    When I add access role to user in child account
    Then An exception was thrown
    And I logout

  Scenario: Deleting role after it has been added to user in child account
  Creating child account as user kapua-sys, creating role and user in child account.
  Adding role to the user. Deleting role. Checking if user still has created role.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I create a account with name "SubAccount", organization name "Organization" and email adress "test@test.com"
    And I configure user service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 50    |
    And I create role "TestRole" in child account
    And I create user with name "TestUser" in child account
    And I create the access info entity in child account
    And I add access role to user in child account
    When I count the access roles from user in child account
    And I count 1
    And I delete the last created role
    When I count the access roles from user in child account
    Then I count 0
    And No exception was thrown
    And I logout

  Scenario: Stop broker after all scenarios

    Given Stop Broker

  Scenario: Stop event broker for all scenarios

    Given Stop Event Broker

  Scenario: Stop datastore after all scenarios

    Given Stop Datastore












