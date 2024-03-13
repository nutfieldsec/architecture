# Security Use Case Views

Detailed security use case views of a generic web application are presented below.

## Resource Owner Password Grant Login Flow

The login flow for the web application is described by the following diagram.

```mermaid
%%| caption: "Resource Owner Password Grant Login Flow"
%%| name: "ROPG-login-flow"
%%| alt: "A flow chart representing the Resource Owner Password Grant login flow"
%%{init: {'theme': 'forest', "flowchart" : { "curve" : "basis" } } }%%

sequenceDiagram
    Participant Client as Web Client Application
    Participant REST as REST API

    Client ->> Client: GET /#35;/login
    Client ->> REST: POST /login with credentials
    Note right of REST: Connections to the REST API are encrypted with TLS 1.2+
    REST ->> REST: Validate Credentials
    alt credentials are invalid
        REST ->> REST: Log failed login
        REST ->> Client: HTTP 400
        Client ->> Client: Display login failure
    else credentials are valid
        REST ->> REST: Log successful login
        REST ->> Client: Send Access, Refresh, and Identity Tokens
        Note right of REST: Tokens are cryptographically signed by the REST API<br/>per the OAUTH Resource Owner Password Grant
        Client ->> Client: Store Tokens in local storage
        Client ->> Client: Display login success
        Client ->> REST: Subsequent API calls use the AUTHORIZATION header
    end
```

## Authorization Code Grant Login Flow

The login flow for the web application is described by the following diagram.

```mermaid
%%| caption: "Authorization Code Login Flow"
%%| name: "authz-code-login-flow"
%%| alt: "A flow chart representing the Authorization Code Grant login flow"
%%{init: {'theme': 'forest', "flowchart" : { "curve" : "basis" } } }%%

sequenceDiagram
    Participant CLIENT as Web Client Application
    Participant API as API
    Participant IDP as Identity Provider

    CLIENT ->> API: GET https://<API DOMAIN>/<Protected Resource Location>
    API ->> CLIENT: HTTP/1.1 301 Moved Permanently<br/>Location: https://<IDENTITY PROVIDER DOMAIN>/auth?response_type=code&<br/>client_id=29352915982374239857&<br/>redirect_uri=<URL_ENCODE(API DOMAIN)>%2Fcallback&<br/>scope=openid+create+delete&<br/>state=xcoiv98y2kd22vusuye3kch
    CLIENT ->> IDP: GET https://<IDENTITY PROVIDER DOMAIN>/auth?response_type=code&<br/>client_id=29352915982374239857&<br/>redirect_uri=<URL_ENCODE(API DOMAIN)>%2Fcallback&<br/>scope=create+delete&<br/>state=xcoiv98y2kd22vusuye3kch
    IDP ->> CLIENT: Present Login Screen
    CLIENT ->> IDP: Authenticate User
    IDP ->> CLIENT: Request Consent
    CLIENT ->> IDP: Authorize Consent
    IDP ->> CLIENT: HTTP/1.1 301 Moved Permanently<br/>Location: https://<API DOMAIN>/callback?code=g0ZGZmNjVmOWIjNTk2NTk4ZTYyZGI3&<br/>state=xcoiv98y2kd22vusuye3kch
    CLIENT ->> CLIENT: Validate State Token
    CLIENT ->> IDP: GET https://<IDENTITY PROVIDER DOMAIN>/token?grant_type=authorization_code&<br/>code=g0ZGZmNjVmOWIjNTk2NTk4ZTYyZGI3&<br/>redirect_uri=<URL_ENCODE(API DOMAIN)>%2Fcallback&<br/>client_id=29352915982374239857
    IDP ->> CLIENT: Send Access, Refresh, and Identity Tokens
    CLIENT ->> CLIENT: Store Tokens in local storage
    CLIENT ->> API: Subsequent API calls use the AUTHORIZATION header
```
