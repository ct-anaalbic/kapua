/*******************************************************************************
 * Copyright (c) 2016, 2019 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.restapi.steps;

public class AuthEntity {
    private String username;
    private String password;

    public AuthEntity(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public AuthEntity() {
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
}
