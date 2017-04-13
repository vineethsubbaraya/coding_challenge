# Word Count Validator

## How to Install

        bundle install --without production


## How to run server

        ./run

## How to check working code

### Get text from the example files

        curl -X GET localhost:8000

Response:

        {
          "text": "Hodor, hodor hodor. Hodor! Hodor hodor hodor hodor hodor hodor.",
          "exclude": ["hodor.", "hodor!", "hodor", "hodor,"],
          "client_id": 71845
        }

### Get text generated randomly

        curl -X GET localhost:8000/random

Response:

        {
          "text": "Placeat et ad iure nisi.",
          "exclude": ["iure", "ad", "et", "nisi.", "placeat"],
          "client_id": 29717
        }

### Post request to validate count

1. Correct frequency count

        curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"text": "Call me Ishmael", "exclude": ["Ishmael"], "freq_count": {"Call": 1, "Me": 1}, "client_id": 10}' localhost:8000

Response:

        {
          "message": "Looks great!"
          "status": "200" 
        }

2. Wrong frequency count

        curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"text": "Call me Ishmael", "exclude": ["Ishmael"], "freq_count": {"Call": 2, "Me": 1}, "client_id": 10}' localhost:8000

Response:

        {
          "message": "Sorry, that's wrong. Nice try space troll"
          "status": "400"
          
        }
        
3. Bad request made

        curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"text": "Call me Ishmael", "exclude": "bad request", "freq_count": {"Call": 1, "Me": 1}, "client_id": 10}' localhost:8000

Response:

        {"message":"Invalid Json format"}

4. If same message sent previously

      curl -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"text": "quia nobis laborum aliquid alias aliquam quia.", "exclude": ["quia.","laborum","aliquid","aliquam"], "freq_count": {"quia": 1, "nobis": 1, "alias": 1}, "client_id": 50536}' localhost:8000

Response:

      {
        "message": "Previous text same!"
        "status": "400"
        
          "previous_text": "quia nobis laborum aliquid alias aliquam quia."
          "previous_exclude": "quia.,laborum,aliquid,aliquam"
        
      }
      
## Running Test

        bundle exec rspec spec

## Bonus

In order to overcome cheating and statelessness I have introduceda unique id for each client (client_id). A client should sent this id with the post request so that their previous message can be retrieved.


## Additional Information

A ruby on Rails framework would be more easier than using a sinatra for deploying to server. I have used sqlite database inorder to save the information. DataMapper is used as the ORM and Faker gem is used to generate random sentences. The program doesn't eliminate the puntuation marks from the texts.

