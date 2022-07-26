// /// A trait that exposes a method to speak depending on how this trait is implemented.
// trait Speak {
//     fn speak(&self);
// }
//
// // A bunch of races.
// struct Human;
// struct Orc;
// struct HalfOrc;
//
// impl Speak for Human {
//     fn speak(&self) {
//         println!("I'm a human.");
//     }
// }
//
// impl Speak for Orc {
//     fn speak(&self) {
//         println!("I'm an orc.");
//     }
// }
//
// impl Speak for HalfOrc {
//     fn speak(&self) {
//         println!("I'm half human and half orc.");
//     }
// }
//
// /// Free function that takes a reference to any object that implements Speak.
// fn let_unit_speak(unit: &impl Speak) {
//     unit.speak();
// }
//
// fn main() {
//     let_unit_speak(&Human); // prints "I'm a human."
//     let_unit_speak(&Orc); // prints "I'm an orc."
//     let_unit_speak(&HalfOrc); // prints "I'm half human and half orc."
// }

/// A custom struct which only wraps a single integer value.
struct Number {
    value: i32,
}

// The implementation of this trait describes how any i32 can be converted into a Number.
impl From<i32> for Number {
    // In this case Self refers to Number, the type for which we implement this trait.
    fn from(value: i32) -> Self {
        // This "conversion" is trivial as value is already an i32.
        Self { value }
    }
}

// The implementation of this trait describes how any f32 can be converted into a Number.
impl From<f32> for Number {
    fn from(value: f32) -> Self {
        Self {
            // We must convert the f32 to an i32 by rounding it.
            value: value.round() as i32,
        }
    }
}

/// A free function that expects anything that can be converted into Number.
// Remember that we don't need to implement Into ourselves. Every From we implement for
// Number automatically has a corresponding Into.
fn expects_number(numberlike: impl Into<Number>) {
    // The into method performs the conversion to Number and uses the Number::from()
    // methods declared in the previous implementations of the From trait.
    let number = numberlike.into();
    println!("Number Value: {}", number.value);
}

fn main() {
    expects_number(Number { value: 1 }); // prints "Number Value: 1"
    expects_number(2); // prints "Number Value: 2" using the From<i32> implementation
    expects_number(3.14); // prints "Number Value: 3" using the From<f32> implementation
}