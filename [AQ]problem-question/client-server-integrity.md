# Client server integrity

### Problem 1:
Is there any way to verify the GPS location data received from client?
- Answer: You can use an IP geolocation service to obtain an approximate location from where the user is connecting. Compare this with the GPS data received and you can weed out some extreme cases (players connecting though proxy, etc). You can even calculate distances between user logins and if they are too high (say, the location moved 1000 kms between two login attemps in 5 or 10 minutes) notify the user.
However this isn't foolproof and you will cause more than one inconvenience to legitimate players.


