== README

## Application Workflow

An API consumer should be able to create charges to cards, tokenizing them first.

Example:

1. POST request to `/cards` to tokenize a card.
2. POST request to `/charges` to create a charge on an already tokenized card.


#### Example request to tokenize a card:

```
Success at tokenizing

$ curl http://localhost:5000/cards -H "Content-type: application/json" -X POST -d '{"token": "H0TT2FE0e0VpIJTKHjGUQg", "card": {"number": "4000000000000127", "exp_month": "10", "exp_year": "2018", "cvc": "123", "name": "Jane Doe"}}'

# response
{ "token":"NDAwMDAwMDAwMDAwMDEyNw==" }
```

```
Error at tokenizing

$ curl http://localhost:5000/cards -H "Content-type: application/json" -X POST -d '{"token": "H0TT2FE0e0VpIJTKHjGUQg", "card": {"number": "4000000000000127", "exp_month": "10", "exp_year": "2014", "cvc": "123", "name": "Jane Doe"}}'

# response
{
  "data": {
    "errors": {
      "exp_date": ["is expired"]
    },
    "error": true
  }
}
```


#### Example request to charge a card

```
Success at charging

$ curl http://localhost:5000/charges -H "Content-type: application/json" -X POST -d '{"token": "H0TT2FE0e0VpIJTKHjGUQg", "charge": {"amount": 900, "currency": "MXN", "card": "NDAwMDAwMDAwMDAwMDEyNw=="}}'


# response
{
  "_id": {"$oid":"572d182d565969fdaa000001"},
  "amount": 900,
  "card": "NDAwMDAwMDAwMDAwMDEyNw==",
  "currency": "MXN",
  "description": null,
  "details": null,
  "reference_id": null
}
```

```
Error at charging

$ curl http://localhost:5000/charges -H "Content-type: application/json" -X POST -d '{"token": "H0TT2FE0e0VpIJTKHjGUQg", "charge": {"amount": 900, "card": "NDAwMDAwMDAwMDAwMDEyNw=="}}'


# response
{
  "errors": {
    "currency":"can't be blank",
    "card":"card is invalid"
  }
}
```
