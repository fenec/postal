**Overview of API:**

Read here: [Postal Server API Documentation](https://apiv1.postalserver.io/index.html)

**Authentication:**

Pass an `X-Server-API-Key` header as specified [here](https://apiv1.postalserver.io/authenticators/server.html).

This key is a server's Credential key, which should be added to the Database in the Postal UI.

Additionally, include a `Content-Type: application/json` header.

**Domain Endpoints:**

- `POST /api/v1/domains` - Creates a new domain.
- `POST /api/v1/domains/check` - Checks a domain's DNS.
- `PUT /api/v1/domains/check` - Updates domain's attributes.
- `DELETE /api/v1/domains` -  Delets the domain.

Both endpoints accept JSON with the `name` parameter, which is the domain name:

```
json
{
    "name": "example.com"
}
```

**Example request:**

```sh
curl --location 'YOUR_POSTAL_URL/api/v1/domains' \
--header 'X-Server-API-Key: YOUR_POSTAL_URL' \
--header 'Content-Type: application/json' \
--data '{ "name": "example.com" }'
```

```sh
curl --location --request PUT 'YOUR_POSTAL_URL/api/v1/domains' \
--header 'x-server-api-key: YOUR_POSTAL_URL' \
--header 'content-type: application/json' \
--data '{
"name": "example1.com",
"domain": {"name": "example1.com"}
}'
```
