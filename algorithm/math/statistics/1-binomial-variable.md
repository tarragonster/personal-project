# Binomial variables

### Note

#### Binomial Definition
- Binomial variable counts how often a particular event occurs on a fix
  number of tries or trials

#### Binomial variables condition
 - Made up of independent trials
 - Each trial can be classified as success or failure
 - Fix number of trials
 - Probability of success on each trial is constant

#### Example

- `Is Binomial`: X = number of heads after 10 flips of a coin (P(H) = 0.5, P(T) = 0.5)
    * [x] Each trial of flipping a coin is independent of previous trials
    * [x] Outcome of every flip is head or tail (success or failure)
    * [x] Got 10 flips -> fix number of trial
    * [x] Probability of each trial is 0.5 for both head and tail unchanged
- `Not Binomial`: Y = number of kings without replacement after taking 2
   card from a standard deck (52 card)
    * [x] Outcome of every take is either king or other (success or failure)
    * [x] Take 2 cards -> fix number of trial
    * [ ] Outcome of second trail depends on the outcome of first one
    P(K on 1st trial) = 4/52, P(K on 2nd trial & 1st success) = 3/51
    -> not independent
    * [ ] P(K on 1st trial) = 4/52, P(K on 2nd trial & 1st success) = 3/51
    -> probability not constant


## References
[Vid] Khan Academy - [Binomial Variables](https://www.khanacademy.org/math/statistics-probability/random-variables-stats-library/binomial-random-variables/v/binomial-variables) \