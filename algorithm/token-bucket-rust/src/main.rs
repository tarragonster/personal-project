use std::cmp::Ordering;
use chrono::{Utc, DateTime};
use std::{cmp, thread, time};
use rand::Rng;

#[derive(Debug)]
pub struct TokenBucket {
    rate: i64,
    max_tokens: i64,
    current_tokens: i64,
    last_refill_timestamp: DateTime<Utc>,
}

/// TokeBucket implementation
impl TokenBucket {
    pub fn new(rate: i64, max_token: i64) -> Self {
        TokenBucket {
            rate: rate,
            max_tokens: max_token,
            current_tokens: max_token,
            last_refill_timestamp: Utc::now(),
        }
    }

    fn update(&mut self) {
        let current = Utc::now();
        let diff = current.time() - self.last_refill_timestamp.time();
        let tokens_added = diff.num_seconds() * self.rate / 1000000000;
        self.current_tokens = cmp::min(self.current_tokens + tokens_added, self.max_tokens);
        self.last_refill_timestamp = current;
    }

    pub fn handle(&mut self, tokens: i64) {
        self.update();

        if self.current_tokens >= tokens {
            self.current_tokens = self.current_tokens - tokens;
            self.forward(tokens);
        } else {
            self.queue(tokens);
            // for demo
            // after some time period
            // we reset the capacites
            self.current_tokens = self.max_tokens;
        }
    }
}

pub trait Actions {
    fn forward(&self, people: i64);
    fn queue(&self, people: i64);
}

impl Actions for TokenBucket {
    fn forward(&self, people: i64) {
        println!("-> forward : {:?} people", people);
    }
    fn queue(&self, people: i64){
        println!("<- queue : {:?} people", people);
    }
}

#[test]
fn test_token_bucket() {
    let mut cinema = TokenBucket::new(2, 10);
    let mut number_of_showtime:i64 = 0;
    let mut random_volume_of_people = rand::thread_rng();

    while number_of_showtime < 10 {
        thread::sleep(time::Duration::from_secs_f64(2.0));
        cinema.handle(random_volume_of_people.gen_range(1..10));
        number_of_showtime += 1;
    }
}

fn main() {}