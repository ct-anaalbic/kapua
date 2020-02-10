/*******************************************************************************
 * Copyright (c) 2017, 2020 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech
 *******************************************************************************/
package org.eclipse.kapua.restapi.steps;

import com.fasterxml.jackson.databind.ObjectMapper;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import cucumber.api.java.en.Given;
import cucumber.runtime.java.guice.ScenarioScoped;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.shiro.SecurityUtils;
import org.eclipse.kapua.commons.security.KapuaSecurityUtils;
import org.eclipse.kapua.commons.security.KapuaSession;
import org.eclipse.kapua.commons.util.xml.XmlUtil;
import org.eclipse.kapua.locator.KapuaLocator;
import org.eclipse.kapua.qa.common.DBHelper;
import org.eclipse.kapua.qa.common.StepData;
import org.eclipse.kapua.qa.common.TestBase;
import org.eclipse.kapua.qa.common.TestJAXBContextProvider;
import org.eclipse.kapua.service.authentication.UsernamePasswordCredentials;
import org.eclipse.kapua.service.authentication.shiro.UsernamePasswordCredentialsImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import java.io.StringReader;

@ScenarioScoped
public class RestApiSteps extends TestBase {
    private static final Logger logger = LoggerFactory.getLogger(RestApiSteps.class);
    private static final String AUTH_ROUTE = "http://localhost:8088/v1/authentication/user";
    private static final String GET_USERS = "http://localhost:8088/v1/_/users";

    /**@
     * Tag service.
     */

    private DBHelper database;

    @Inject
    public RestApiSteps(StepData stepData, DBHelper dbHelper) {

        this.stepData = stepData;
        this.database = dbHelper;
    }

    // *************************************
    // Definition of Cucumber scenario steps
    // *************************************

    @Before
    public void beforeScenario(Scenario scenario) {

        this.scenario = scenario;
        database.setup();
        stepData.clear();

        locator = KapuaLocator.getInstance();

        if (isUnitTest()) {
            // Create KapuaSession using KapuaSecurtiyUtils and kapua-sys user as logged in user.
            // All operations on database are performed using system user.
            // Only for unit tests. Integration tests assume that a real logon is performed.
            KapuaSession kapuaSession = new KapuaSession(null, SYS_SCOPE_ID, SYS_USER_ID);
            KapuaSecurityUtils.setSession(kapuaSession);
        }

        // Setup JAXB context
        XmlUtil.setContextProvider(new TestJAXBContextProvider());
    }

    @After
    public void afterScenario() {

        // Clean up the database
        try {
            logger.info("Logging out in cleanup");
            if (isIntegrationTest()) {
                database.deleteAll();
                SecurityUtils.getSubject().logout();
            } else {
                database.dropAll();
                database.close();
            }
            KapuaSecurityUtils.clearSession();
        } catch (Exception e) {
            logger.error("Failed to log out in @After", e);
        }
    }

    @Given("^Login user with username \"([^\"]*)\" and password \"([^\"]*)\"$")
    public void loginUserWithUsernameAndPassword(String username, String password) throws Exception {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpPost request = new HttpPost(AUTH_ROUTE);
        request.setHeader("Content-Type", "application/json");
        ObjectMapper mapper = new ObjectMapper();

        UsernamePasswordCredentials authenticationCredentials = new UsernamePasswordCredentialsImpl(username, password);
        String json = mapper.writeValueAsString(authenticationCredentials);

        StringEntity entity = new StringEntity(json);
        request.setEntity(entity);

        HttpResponse response = httpClient.execute(request);
        stepData.put("Response", response);
    }

    @And("^I got response with status code (\\d+)$")
    public void iGotResponseWithStatusCode(int statusCode) throws Exception {
        HttpResponse response = (HttpResponse) stepData.get("Response");

        assertEquals(statusCode, response.getStatusLine().getStatusCode());
    }

    @And("^I try to get \"([^\"]*)\" from json object$")
    public void iTryToGetFromJsonObject(String tokenId) throws Exception {
        HttpResponse response = (HttpResponse) stepData.get("Response");
        String responseString = EntityUtils.toString(response.getEntity(), "UTF-8");
        JsonObject jsonObject = Json.createReader(new StringReader(responseString)).readObject();
        stepData.put("JSONObject", jsonObject);

        String token = jsonObject.get(tokenId).toString();
        stepData.put("Token", token);
    }

    @And("^Token is received$")
    public void tokenIsReceived() {
        String token = (String) stepData.get("Token");

        assertNotNull(token);
    }

    @And("^I try to get all users$")
    public void iTryToGetAllUsers() throws Exception {
        CloseableHttpClient httpClient = HttpClients.createDefault();
        HttpGet getRequest = new HttpGet(GET_USERS);
        String token = (String) stepData.get("Token");
        String finalToken = token.replace("\"", "");
        getRequest.setHeader("Authorization", "Bearer " + finalToken);

        HttpResponse getResponse = httpClient.execute(getRequest);
        String responseString = EntityUtils.toString(getResponse.getEntity(), "UTF-8");
        JsonObject jsonObject = Json.createReader(new StringReader(responseString)).readObject();
        stepData.put("UsersList", jsonObject);
    }

    @And("^I get list of users with size (\\d+)$")
    public void iGetListOfUsersWithSize(int userListSize) {
        JsonObject userList = (JsonObject) stepData.get("UsersList");

        JsonArray userArray = userList.getJsonArray("items");
        assertEquals(userListSize, userArray.size());
    }
}
