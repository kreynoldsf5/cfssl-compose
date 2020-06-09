# cfssl-compose

A simple CFSSL example fronted by NGINX (OSS). 

## API Example

POST {{cfssl}}/api/v1/cfssl/newcert
```json
{
	"request": {
		"key": {"algo":"rsa","size":2048},
		"hosts":["example.application.internal"],
		"names":[{"C":"US", "ST":"WA", "L":"Seattle", "O":"GSA"}],
		"CN": "example.application.internal"
	} 
}
```