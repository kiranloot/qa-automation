@regression @core @selenium
Feature: Data integrity checks 
    @ready @krisdev
    Scenario: All generated coupon codes are unique
      Then all coupon codes in the database should be unique
