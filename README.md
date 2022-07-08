# Identifying Recurrent Transactions

This repository describes a hometask on identifying recurrent transactions.

My Approach was to come up with a simple rules based function that looks at the frequency of each transaction amount and description,
and factoring in the period for which the transaction avalaible for determines whether the same transaction amount, description, and day are similar.

* Number off occurences relative to the months for which data is available
* The day for which the transaction occurs is the same

So transactions with same day, description and frequency equal to the number of months for which the data is available are likely to be recurring.

![Screenshot from 2022-07-08 11-37-04](https://user-images.githubusercontent.com/17858711/177964757-fbf5cae7-475f-4155-a01a-47f392bc6385.png)
