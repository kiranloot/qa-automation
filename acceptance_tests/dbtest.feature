Feature: DB and Redis object should find test data correctly
    @db_redis
    Scenario: DB object finds active user with one subscripiton
        Given that I want to test the db and redis objects
        Then the db object should be awesome