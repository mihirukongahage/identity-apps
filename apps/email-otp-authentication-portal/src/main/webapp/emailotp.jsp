<!--
~  Copyright (c) 2020, WSO2 Inc. (http://wso2.com) All Rights Reserved.
~
~  WSO2 Inc. licenses this file to you under the Apache License,
~  Version 2.0 (the "License"); you may not use this file except
~  in compliance with the License.
~  You may obtain a copy of the License at
~
~   http://www.apache.org/licenses/LICENSE-2.0
~
~  Unless required by applicable law or agreed to in writing,
~  software distributed under the License is distributed on an
~  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~  KIND, either express or implied.  See the License for the
~  specific language governing permissions and limitations
~  under the License.
-->
<%@page import="org.owasp.encoder.Encode" %>
<%@page import="org.wso2.carbon.identity.application.authentication.endpoint.util.Constants" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
        request.getSession().invalidate();
        String queryString = request.getQueryString();
        Map<String, String> idpAuthenticatorMapping = null;
        if (request.getAttribute(Constants.IDP_AUTHENTICATOR_MAP) != null) {
            idpAuthenticatorMapping = (Map<String, String>) request.getAttribute(Constants.IDP_AUTHENTICATOR_MAP);
        }

        String errorMessage = "Authentication Failed! Please Retry";
        String authenticationFailed = "false";

        if (Boolean.parseBoolean(request.getParameter(Constants.AUTH_FAILURE))) {
            authenticationFailed = "true";

            if (request.getParameter(Constants.AUTH_FAILURE_MSG) != null) {
                errorMessage = request.getParameter(Constants.AUTH_FAILURE_MSG);

                 if (errorMessage.equalsIgnoreCase("authentication.fail.message")) {
                    errorMessage = "Authentication Failed! Please Retry";
                }
            }
        }
    %>
<html>
<head>
    <!-- header -->
    <%
        File headerFile = new File(getServletContext().getRealPath("extensions/header.jsp"));
        if (headerFile.exists()) {
    %>
    <jsp:include page="extensions/header.jsp"/>
    <% } else { %>
    <jsp:directive.include file="includes/header.jsp"/>
    <% } %>

    <script src="js/scripts.js"></script>
    <!--[if lt IE 9]>
    <script src="js/html5shiv.min.js"></script>
    <script src="js/respond.min.js"></script>
    <![endif]-->
</head>

<body>

<main class="center-segment">
    <div class="ui container medium center aligned middle aligned">
        <!-- product-title -->
        <%
            File productTitleFile = new File(getServletContext().getRealPath("extensions/product-title.jsp"));
            if (productTitleFile.exists()) {
        %>
        <jsp:include page="extensions/product-title.jsp"/>
        <% } else { %>
        <jsp:directive.include file="includes/product-title.jsp"/>
        <% } %>

        <div class="ui segment">
            <!-- page content -->
            <h2>Email Verification</h2>
            <div class="ui divider hidden"></div>
            <%
                if ("true".equals(authenticationFailed)) {
            %>
                    <div class="ui negative message" id="failed-msg"><%=Encode.forHtmlContent(errorMessage)%></div>
                    <div class="ui divider hidden"></div>
            <% } %>
            <div id="alertDiv"></div>
            <div class="segment-form">
                <form class="ui large form" id="codeForm" name="codeForm" action="../commonauth"  method="POST">
                    <%
                        String loginFailed = request.getParameter("authFailure");
                        if (loginFailed != null && "true".equals(loginFailed)) {
                            String authFailureMsg = request.getParameter("authFailureMsg");
                            if (authFailureMsg != null && "login.fail.message".equals(authFailureMsg)) {
                    %>
                                <div class="ui negative message">Authentication Failed! Please Retry</div>
                                <div class="ui divider hidden"></div>
                    <% } }  %>
                    <% if (request.getParameter("screenValue") != null) { %>
                    <div class="field">
                    <label for="password">Enter the code sent to your email ID (<%=Encode.forHtmlContent(request.getParameter("screenValue"))%>)</label>
                    <input type="password" id='OTPCode' name="OTPCode" c size='30'/>
                    <% } else { %>
                    <div class="field">
                    <label for="password">Enter the code sent to your email ID:</label>
                    <input type="password" id='OTPCode' name="OTPCode" size='30'/>
                    <% } %>
                    <input type="hidden" name="sessionDataKey"
                           value='<%=Encode.forHtmlAttribute(request.getParameter("sessionDataKey"))%>'/>
                    <div class="ui divider hidden"></div>
                    <div class="align-right buttons">
                        <%
                            if ("true".equals(authenticationFailed)) {
                        %>
                            <a class="ui button link-button" id="resend">Resend Code</a>
                        <% } %>
                        <input type="button" name="authenticate" id="authenticate" value="Authenticate" class="ui primary button">
                    </div>
                </form>
            </div>
        </div>
    </div>
</main> 

    <!-- product-footer -->
<%
    File productFooterFile = new File(getServletContext().getRealPath("extensions/product-footer.jsp"));
    if (productFooterFile.exists()) {
%>
<jsp:include page="extensions/product-footer.jsp"/>
<% } else { %>
<jsp:directive.include file="includes/product-footer.jsp"/>
<% } %>


<!-- footer -->
<%
    File footerFile = new File(getServletContext().getRealPath("extensions/footer.jsp"));
    if (footerFile.exists()) {
%>
<jsp:include page="extensions/footer.jsp"/>
<% } else { %>
<jsp:directive.include file="includes/footer.jsp"/>
<% } %>
<script type="text/javascript">
    $(document).ready(function() {
    	$('#authenticate').click(function() {
            var code = document.getElementById("OTPCode").value;
            if (code == "") {
                document.getElementById('alertDiv').innerHTML = '<div id="error-msg" class="ui negative message">Please enter the code!</div><div class="ui divider hidden"></div>';
            } else {
                if ($('#codeForm').data("submitted") === true) {
                    console.warn("Prevented a possible double submit event");
                } else {
                    $('#codeForm').data("submitted", true);
                    $('#codeForm').submit();
                }
	        }
    	});
    });
    $(document).ready(function() {
    	$('#resendCodeLinkDiv').click(function() {
	        document.getElementById("resendCode").value = "true";
	        $('#codeForm').submit();
    	});
    });
</script>
</body>
</html>
