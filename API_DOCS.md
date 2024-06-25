**Overview of API:**

Read here: [Postal Server API Documentation](https://apiv1.postalserver.io/index.html)

**Authentication:**

Pass an `X-Server-API-Key` header as specified [here](https://apiv1.postalserver.io/authenticators/server.html).

This key is a server's Credential key, which should be added to the Database in the Postal UI.

Additionally, include a `Content-Type: application/json` header.

**Domain Endpoints:**

- `POST /api/v1/domains` - Creates a new domain.
- `POST /api/v1/domains/check` - Checks a domain's DNS.

Both endpoints accept JSON with the `name` parameter, which is the domain name:

```
json
{
    "name": "example.com"
}
```

**Example request:**

```
sh
curl --location 'YOUR_POSTAL_URL/api/v1/domains' \
--header 'X-Server-API-Key: GYQSvSnU0VKGUeAAZ698gD6Z' \
--header 'Content-Type: application/json' \
--data '{ "name": "example.com" }'
```
