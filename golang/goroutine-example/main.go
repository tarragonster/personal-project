// Go program to illustrate the
// concept of select statement
package main

import("fmt"
 "time")

    // function 1
    func portal1(channel1 chan string) {

        time.Sleep(3*time.Second)
        channel1 <- "Welcome to channel 1"
    }

    // function 2
     func portal2(channel2 chan string) {

        time.Sleep(9*time.Second)
        channel2 <- "Welcome to channel 2"
    }

// main function
func main(){

    // Creating channels
   R1:= make(chan string)
   R2:= make(chan string)

   // calling function 1 and
   // function 2 in goroutine
   go portal1(R1)
   go portal2(R2)

   select{

        // case 1 for portal 1
       case op1:= <- R1:
       fmt.Println(op1)

       // case 2 for portal 2
       case op2:= <- R2:
       fmt.Println(op2)
   }

}