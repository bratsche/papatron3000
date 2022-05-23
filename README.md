# Papatron3000

**Papa challenge**

## Installation

`mix deps.get`
`mix ecto.create`
`mix ecto.migrate`
`mix escript.build`

At this point, either explore the CLI app using `./papatron3000` or
run the test suite using `mix test`.

## Example

```
> ./papatron3000 user create --email primrose@somewhere.com --first-name William --last-name Primrose
User successfully created! Use 'papatron3000 user login --email primrose@somewhere.com' to login with this user.

> ./papatron3000 user login --email primrose@somewhere.com
Successfully logged in!

> ./papatron3000 role add member
Role added.

> ./papatron3000 user whoami
CURRENT USER:
  William Primrose
  Email: primrose@somewhere.com
  Balance: 60

> ./papatron3000 visit request --minutes 30 --date 2022-12-05

> ./papatron3000 user logout
Logged out.

> ./papatron3000 user create --email heifetz@somewhere.com --first-name Jascha --last-name Heifetz
User successfully created! Use 'papatron3000 user login --email heifetz@somewhere.com' to login with this user.

> ./papatron3000 user login --email heifetz@somewhere.com
Successfully logged in!

> ./papatron3000 role add pal
Role added.

> ./papatron3000 visit list

--> ID: 1, Date: 2022-12-05, Minutes: 30

> ./papatron3000 visit fulfill --id 1
Visit has been fulfilled. Your balance has been updated.

> ./papatron3000 user whoami
CURRENT USER:
  Jascha Heifetz
  Email: heifetz@somewhere.com
  Balance: 85

> ./papatron3000 user logout
Logged out.

> ./papatron3000 user login --email primrose@somewhere.com
Successfully logged in!

> ./papatron3000 user whoami
CURRENT USER:
  William Primrose
  Email: primrose@somewhere.com
  Balance: 30
```
