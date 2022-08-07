# Standard project

## Update the Go version

### 1.Uninstall the exisiting version

```shell
sudo rm -rf /usr/local/go
```

### 2. Install the new version

Go to the downloads page and download the binary release suitable for your system.

### 3. Extract the archive file

```shell
sudo tar -C /usr/local -xzf [UserPath]/Downloads/go1.8.1.linux-amd64.tar.gz
```

### 4. Make sure that your PATH contains /usr/local/go/bin

```shell
echo $PATH | grep "/usr/local/go/bin"
```

### 5. References

Ref: [Code] nikhita - [update-golang](https://gist.github.com/nikhita/432436d570b89cab172dcf2894465753) \

## Project layout

### 1. cmd

- Main application of the project
- The directory name for each application should match the name of the executable you want to have (e.g., /cmd/myapp).
- Don't put a lot of code in the application directory
- if you think the code can be imported and used in other projects, then it should live in the /pkg directory
- Usually main.go would be resided

### 2. pkg

- Library code that's ok to use by external applications
- Other projects will import these libraries expecting them to work, so think twice before you put something here
- internal directory is a better way to ensure your private packages are not importable because it's enforced by Go

### 3. internal

- Private application and library code
- This is the code you don't want others importing in their applications or libraries
- You can optionally add a bit of extra structure to your internal packages to separate your shared and non-shared internal code
- Your actual application code can go in the /internal/app directory (e.g., /internal/app/myapp) and the code shared by those apps in the /internal/pkg directory (e.g., /internal/pkg/myprivlib)

### 4. configs

- Configuration file templates or default configs.

### 5. api

- OpenAPI/Swagger specs
- JSON schema files
- Protocol definition files

### 6. asset

- Other assets to go along with your repository (images, logos, etc).

### 7. build

- Packaging and Continuous Integration
- Put your cloud (AMI), container (Docker), OS (deb, rpm, pkg) package configurations and scripts in the /build/package directory
- Put your CI (travis, circle, drone) configurations and scripts in the /build/ci directory

### 8. deployment

- IaaS, PaaS, system and container orchestration deployment configurations and templates (docker-compose, kubernetes/helm, mesos, terraform, bosh).

### 9. docs

- Design and user documents (in addition to your godoc generated documentation).

### 10. examples

- Examples for your applications and/or public libraries

### 11. githooks

- Githook

### 12. init

- System init (systemd, upstart, sysv) and process manager/supervisor (runit, supervisord) configs.

### 13. scripts

- Scripts to perform various build, install, analysis, etc operations.
- These scripts keep the root level Makefile small and simple.

### 14. test

- Additional external test apps and test data.
- Feel free to structure the /test directory anyway you want.
- You can have /test/data or /test/testdata if you need Go to ignore what's in that directory

### 15. third_party

- External helper tools, forked code and other 3rd party utilities (e.g., Swagger UI).

### 16. tools

- Supporting tools for this project.
- Note that these tools can import code from the /pkg and /internal directories.

### 17. vendor

- Application dependencies (managed manually or by your favorite dependency management tool like the new built-in, but still experimental, modules feature).
- Note that since 1.13 Go also enabled the module proxy feature (using https://proxy.golang.org as their module proxy server by default).

### 18. web (app/static/template)

- Web application specific components: static web assets, server side templates and SPAs.

### 19. website

- This is the place to put your project's website data if you are not using GitHub pages.

## Golang common Idea

### 1. What is Golang?

- Golang is a procedural and statically typed programming language having the syntax similar to C programming language

### 2. Golang Identifier

- function name
- variable name
- constant
- statement labels
- package name
- types

### 3. What is blank identifier?

- The identifier represented by the underscore character(_) is known as a blank identifier. 
  It is used as an anonymous placeholder instead of a regular identifier, and it has a special meaning in declarations, 
  as an operand, and in assignments.
- The underscore character, which is called blank identifier, is the Go way of discarding a value

### 4. What is exported identifier?

- The identifier which is allowed to access it from another package
- The first character of the exported identifier’s name should be in the Unicode upper case letter
- The identifier should be declared in the package block, or it is a variable name, or it is a method name


### 5. Golang keywords?

- break - default - func - interface - select - case -defer - go - map
- struct - chan - else - goto - package - switch - const - fallthrough - if
- range - type - continue - for - import - return - var


### 6. Data Types in Go

- Basic types: Numbers, strings, and booleans
- Integers: int8, int16, int32, int64, uint8, uint16, uint32, uint64, int, uint, rune, byte, uintptr
- Floating-Point Numbers: float32, float64
- Complex Numbers: complex64, complex128
- Booleans: The boolean data type represents only one bit of information either true or false
- Strings: The string data type represents a sequence of Unicode code points. Or in other words, we can say a string is a sequence of immutable bytes, means once a string is created you cannot change that string

### 7. Go variable and constant

- var keyword: connected with name and provide its initial value
- var keyword: If you use type, then you are allowed to declare multiple variables of the same type in the single declaration
- Using short variable declaration: type of the variable is determined by the type of the expression (myvar3 := 34.67)
- Using short variable declaration: you are allowed to declare multiple variables of different types in the single declaration
- Untyped and Typed Numeric Constants

### 8. Functions in Go

- func
- example
```shell
func function_name(Parameter-list)(Return_type){
    // function body.....
}
```

- 2 ways to pass arguments to function
    * Call by value: In this parameter passing method, values of actual parameters are copied to function’s formal parameters 
      and the two types of parameters are stored in different memory locations. 
      So any changes made inside functions are not reflected in actual parameters of the caller.
    
      ```shell
      func swap(a, b int)int
      
      swap(p, q)
      ```
    * Call by reference: Both the actual and formal parameters refer to the same locations, 
      so any changes made inside the function are actually reflected in actual parameters of the caller

      ```shell
      func swap(a, b *int)int{
        var o int
        o = *a
        *a = *b
        *b = o

        return o
      }
      
      swap(&p, &q)
      ```
- Variadic Functions
    * The function that is called with the varying number of arguments is known as variadic function
    * a user is allowed to pass zero or more arguments in the variadic function
    
    ```shell
    function function_name(para1, para2...type)type {// code...}
    ```
    * Variadic functions can be used instead of passing a slice to a function
    * Variadic functions are especially useful when the arguments to your function are most likely not going to come from a single data structure

- Anonymous function (function literal)
    * Syntax
    ```shell
    func(parameter_list)(return_type){ 
    // code..
    return
    }()
    ```
  
    * In Go language, you are allowed to assign an anonymous function to a variable. When you assign a function to a variable, then the type of the variable is of function type and you can call that variable like a function call
    ```shell
    func main() {
      // Assigning an anonymous 
      // function to a variable
      value := func(){
        fmt.Println("Welcome! to GeeksforGeeks")
      }
      value()
    }
    ```
    * You can also pass an anonymous function as an argument into other function
    ```shell
    func GFG(i func(p, q string) string){
      fmt.Println(i ("Geeks", "for")) 
    }

    func main() {
      value:= func(p, q string) string {
        return p + q + "Geeks"
      }
      GFG(value)
    }
    ```
    * You can also return an anonymous function from another function

    ```shell
     func GFG() func(i, j string) string{
       myf := func(i, j string)string{
          return i + j + "GeeksforGeeks"
       }
       return myf
     }

     func main() {
       value := GFG()
       fmt.Println(value("Welcome ", "to "))
     }
    ```
- main() function
    * It does not take any argument nor return anything
    * is the entry point of the executable programs

- init() function 
    * does not take any argument nor return anything
    * present in every package and this function is called when the package is initialized
    * This function is declared implicitly, so you cannot reference it from anywhere
    * you are allowed to create multiple init() function in the same program
    * init() function is executed before the main() function call, so it does not depend to main() function
    * purpose of the init() function is to initialize the global variables that cannot be initialized in the global context

- Defer keyword in Golang
    * In Go language, defer statements delay the execution of the function or method or an anonymous method until the nearby functions returns
    * defer function or method call arguments evaluate instantly, but they don’t execute until the nearby functions returns
    * multiple defer statements are allowed in the same program and they are executed in LIFO(Last-In, First-Out) order
    * In the defer statements, the arguments are evaluated when the defer statement is executed, not when it is called
    * Defer statements are generally used to ensure that the files are closed when their need is over, or to close the channel, or to catch the panics in the program
    ```shell
    // Functions
    func add(a1, a2 int) int {
      res := a1 + a2
      fmt.Println("Result: ", res)
      return 0
    }

    // Main function
    func main() {

      fmt.Println("Start")
 
      // Multiple defer statements
      // Executes in LIFO order
      defer fmt.Println("End")
      defer add(34, 56)
      defer add(10, 10)
    }
    ```
- Method in Golang
    * method contains a receiver argument in it
    * the method can access the properties of the receiver
    * the receiver can be of struct type or non-struct type
    * Method with struct type receiver
    ```shell
    // Author structure
    type author struct {
      name      string
      branch    string
      particles int
      salary    int
    }

    // Method with a receiver
    // of author type
    func (a author) show() {

      fmt.Println("Author's Name: ", a.name)
      fmt.Println("Branch Name: ", a.branch)
      fmt.Println("Published articles: ", a.particles)
      fmt.Println("Salary: ", a.salary)
    }
    ```
  
    * Method with Non-Struct Type Receiver
    ```shell
    // Type definition
    type data int

    // Defining a method with
    // non-struct type receiver
    func (d1 data) multiply(d2 data) data {
      return d1 * d2
    }
    ```
  
    * Methods with Pointer Receiver
    ```shell
    // Author structure
    type author struct {
      name      string
      branch    string
      particles int
    }

    // Method with a receiver of author type
    func (a *author) show(abranch string) {
      (*a).branch = abranch
    }

    // Main function
    func main() {

      // Initializing the values
      // of the author structure
      res := author{
          name:   "Sona",
          branch: "CSE",
      }
 
      fmt.Println("Author's name: ", res.name)
      fmt.Println("Branch Name(Before): ", res.branch)
 
      // Creating a pointer
      p := &res
 
      // Calling the show method
      p.show("ECE")
      fmt.Println("Author's name: ", res.name)
      fmt.Println("Branch Name(After): ", res.branch)
    }
    ```
  
    * Method Can Accept both Pointer and Value
    ```shell
    // Author structure
    type author struct {
      name   string
      branch string
    }

    // Method with a pointer
    // receiver of author type
    func (a *author) show_1(abranch string) {
      (*a).branch = abranch
    }

    // Method with a value
    // receiver of author type
    func (a author) show_2() {
      a.name = "Gourav"
      fmt.Println("Author's name(Before) : ", a.name)
    }

    // Main function
    func main() {

      // Initializing the values
      // of the author structure
      res := author{
        name:   "Sona",
        branch: "CSE",
      }
 
      fmt.Println("Branch Name(Before): ", res.branch)
 
      // Calling the show_1 method
      // (pointer method) with value
      res.show_1("ECE")
      fmt.Println("Branch Name(After): ", res.branch)
 
      // Calling the show_2 method
      // (value method) with a pointer
      (&res).show_2()
      fmt.Println("Author's name(After): ", res.name)
    }
    ```

### 9. Struct in Go

- user-defined type that allows to group/combine items of possibly different types into a single type
- Declaring a structure:
```shell
 type Address struct {
      name string 
      street string
      city string
      state string
      Pincode int
}
```

- To Define a structure
```shell
var a Address
```

- initialize a variable of a struct type using a struct literal

```shell
var a = Address{"Akshay", "PremNagar", "Dehradun", "Uttarakhand", 252636}
```

- How to access fields of a struct?

```shell
c := Car{Name: "Ferrari", Model: "GTC4", Color: "Red", WeightInKg: 1920}
fmt.Println("Car Name: ", c.Name)
fmt.Println("Car Color: ", c.Color)
```

- Pointers to a struct
```shell
// passing the address of struct variable
// emp8 is a pointer to the Employee struct
emp8 := &Employee{"Sam", "Anderson", 55, 6000}
  
// (*emp8).firstName is the syntax to access
// the firstName field of the emp8 struct
fmt.Println("First Name:", (*emp8).firstName)
fmt.Println("Age:", (*emp8).age)
```

- Nested struct

```shell
// Creating structure
type Author struct {
    name   string
    branch string
    year   int
}
  
// Creating nested structure
type HR struct {
  
    // structure as a field
    details Author
}
```

- Anonymous struct:  useful when you want to create a one-time usable structure

```shell
Element := struct {
        name      string
        branch    string
        language  string
        Particles int
    }{
        name:      "Pikachu",
        branch:    "ECE",
        language:  "C++",
        Particles: 498,
    }
```

- Anonymous Fields
    * Anonymous fields are those fields which do not contain any name you just simply mention the type of the fields and Go will automatically use the type as the name of the field
    ```shell
    type struct_name struct{
      int
      bool
      float64
    }
    ```
    * In a structure, you are not allowed to create two or more fields of the same type
    * You are allowed to combine the anonymous fields with the named fields

### 9. Array in Go

- Creating and accessing an Array
```shell
Var array_name[length]Type
```
```shell
array_name:= [length]Type{item1, item2, item3,...itemN}
```
- Multi-Dimensional Array
```shell
Array_name[Length1][Length2]..[LengthN]Type
```

- Copy array to into Another array

```shell
// creating a copy of an array by value
arr := arr1

// Creating a copy of an array by reference
arr := &arr1
```

- pass an Array to a Function

```shell
// For sized array
func function_name(variable_name [size]type){
// Code
}
```

### 10. Slice in Go

- Slice is a variable-length sequence which stores elements of a similar type, you are not allowed to store different type of elements in the same slice
```shell
[]T
or 
[]T{}
or 
[]T{value1, value2, value3, ...value n}
```

- Zero value slice: In Go language, you are allowed to create a nil slice that does not contain any element in it. So the capacity and the length of this slice is 0. Nil slice does not contain an array reference as shown in the below example:
- [sort - trim - split slice](https://www.geeksforgeeks.org/how-to-sort-a-slice-of-ints-in-golang/?ref=lbp)
- Composite literals: are used to construct the values for arrays, structs, slices, and maps. 
  Each time they are evaluated, it will create new value. They consist of the type of the literal followed by a brace-bound 
  list of elements. (Did you get this point!) Well, after this read you will get to know what is a composite literal

### 11. Pointers

- What is pointers?
  * Is a variable used to store memory address of other variable
  * The memory address is always found in hexadecimal format (0xFF/0x9C)

- What is concept of variable?
  * Variables are the names given to a memory location where the actual data is stored
  * To access the stored data we need the address of that particular memory location

- Problem with storing hexadecimal number into variable
  * storing the hexadecimal number into a variable
  * type of values is int and saved as the decimal or you can say the decimal value of type int is storing
  * we are storing a hexadecimal value(consider it a memory address) but it is not a pointer as it is not pointing to any other memory location of another variable
  * this arises the need for pointers
```shell
func main() {
 
    // storing the hexadecimal
    // values in variables
    x := 0xFF
    y := 0x9C
     
    // Displaying the values
    fmt.Printf("Type of variable x is %T\n", x)
    fmt.Printf("Value of x in hexadecimal is %X\n", x)
    fmt.Printf("Value of x in decimal is %v\n", x)
     
    fmt.Printf("Type of variable y is %T\n", y)
    fmt.Printf("Value of y in hexadecimal is %X\n", y)
    fmt.Printf("Value of y in decimal is %v\n", y)   
     
}
```
```shell
Type of variable x is int
Value of x in hexadecimal is FF
Value of x in decimal is 255
Type of variable y is int
Value of y in hexadecimal is 9C
Value of y in decimal is 156
```

- Declaration and Initialization of Pointers
  * \* Operator also termed as the `dereferencing` operator used to `declare pointer` variable and `access the value` stored in the address
  * & operator termed as address operator used to returns the address of a variable or to access the address of a variable to a pointer
  * pointer of type int which can store only the memory addresses of string variables.
  * The default value or zero-value of a pointer is always nil. Or you can say that an uninitialized pointer will always have a nil value.
  * You can also use the shorthand (:=) syntax to declare and initialize the pointer variables

```shell
func main() {
 
    // taking a normal variable
    var x int = 5748
     
    // declaration of pointer
    var p *int
     
    // initialization of pointer
    p = &x
 
    // displaying the result
    fmt.Println("Value stored in x = ", x)
    fmt.Println("Address of x = ", &x)
    fmt.Println("Value stored in variable p = ", p)
}
```
```shell
func main() {
 
    // using := operator to declare
    // and initialize the variable
    y := 458
     
    // taking a pointer variable using
    // := by assigning it with the
    // address of variable y
    p := &y
 
    fmt.Println("Value stored in y = ", y)
    fmt.Println("Address of y = ", &y)
    fmt.Println("Value stored in pointer variable p = ", p)
}
```

- Dereferencing the Pointer
  * \* operator is also termed as the dereferencing operator. It is not only used to declare the pointer variable but also used to access the value stored in the variable which the pointer points to which is generally termed as indirecting or dereferencing

```shell
func main() {
  
    // using var keyword
    // we are not defining
    // any type with variable
    var y = 458
      
    // taking a pointer variable using
    // var keyword without specifying
    // the type
    var p = &y
  
    fmt.Println("Value stored in y before changing = ", y)
    fmt.Println("Address of y = ", &y)
    fmt.Println("Value stored in pointer variable p = ", p)
 
    // this is dereferencing a pointer
    // using * operator before a pointer
    // variable to access the value stored
    // at the variable at which it is pointing
    fmt.Println("Value stored in y(*p) Before Changing = ", *p)
 
    // changing the value of y by assigning
    // the new value to the pointer
    *p = 500
 
     fmt.Println("Value stored in y(*p) after Changing = ",y)
 
}
```

- Pointers to a Function in Go
  * Create a pointer and simply pass it to the Function
  ```shell
  func ptf(a *int) {
 
    // dereferencing
    *a = 748
  }

  // Main function
  func main() {
    // taking a normal variable
    var x = 100
 
        fmt.Printf("The value of x before function call is: %d\n", x)
 
    // taking a pointer variable
    // and assigning the address
    // of x to it
    var pa *int = &x
 
    // calling the function by
    // passing pointer to function
    ptf(pa)
 
    fmt.Printf("The value of x after function call is: %d\n", x)
  }
  ```
  * Passing an address of the variable to the function call
  ```shell
  func ptf(a *int) {
 
    // dereferencing
    *a = 748
  }

  // Main function
  func main() {

    // taking a normal variable
    var x = 100
     
    fmt.Printf("The value of x before function call is: %d\n", x)
 
    // calling the function by
    // passing the address of
    // the variable x
    ptf(&x)
 
    fmt.Printf("The value of x after function call is: %d\n", x)

  }
  ```

- Pointer to a Struct
  * Golang allows the programmers to access the fields of a structure using the pointers without any dereferencing explicitly
  
```shell
type Employee struct {
  
    // taking variables
    name  string
    empid int
}
  
// Main Function
func main() {
  
    // creating the instance of the
    // Employee struct type
    emp := Employee{"ABC", 19078}
  
    // Here, it is the pointer to the struct
    pts := &emp
  
    // displaying the values
    fmt.Println(pts)
  
    // updating the value of name
    pts.name = "XYZ"
  
    fmt.Println(pts)
  
}
```

- Pointer to pointer
  *  have to place an additional ‘*’ before the name of pointer name. This is generally done when we are declaring the pointer variable using the var keyword along with the type
```shell
func main() {
   
        // taking a variable
        // of integer type
    var V int = 100
       
    // taking a pointer 
    // of integer type 
    var pt1 *int = &V
       
    // taking pointer to 
    // pointer to pt1
    // storing the address 
    // of pt1 into pt2
    var pt2 **int = &pt1
   
    fmt.Println("The Value of Variable V is = ", V)
    fmt.Println("Address of variable V is = ", &V)
   
    fmt.Println("The Value of pt1 is = ", pt1)
    fmt.Println("Address of pt1 is = ", &pt1)
   
    fmt.Println("The value of pt2 is = ", pt2)
   
    // Dereferencing the 
    // pointer to pointer
    fmt.Println("Value at the address of pt2 is or *pt2 = ", *pt2)
       
    // double pointer will give the value of variable V
    fmt.Println("*(Value at the address of pt2 is) or **pt2 = ", **pt2)
}
```
```shell
func main() {
  
    // taking a variable
    // of integer type
    var v int = 100
  
    // taking a pointer
    // of integer type
    var pt1 *int = &v
  
    // taking pointer to
    // pointer to pt1
    // storing the address
    // of pt1 into pt2
    var pt2 **int = &pt1
  
    fmt.Println("The Value of Variable v is = ", v)
  
    // changing the value of v by assigning
    // the new value to the pointer pt1
    *pt1 = 200
  
    fmt.Println("Value stored in v after changing pt1 = ", v)
  
    // changing the value of v by assigning
    // the new value to the pointer pt2
    **pt2 = 300
  
    fmt.Println("Value stored in v after changing pt2 = ", v)
}
```

- Comparing Pointers
  * == operator: This operator return true if both the pointer points to the same variable. Or return false if both the pointer points to different variables.
  * != operator: This operator return false if both the pointer points to the same variable. Or return true if both the pointer points to different variables.
  * Ref [Comparing Pointers in Golang](https://www.geeksforgeeks.org/comparing-pointers-in-golang/?ref=lbp)

### 11. What is Goroutines?
- A Goroutine is a function or method which executes independently and simultaneously in connection with any other Goroutines present in your program
- Ref: [Goroutines – Concurrency](https://www.geeksforgeeks.org/goroutines-concurrency-in-golang/?ref=lbp)

### 12. Select statement goroutines?
- The select statement lets a goroutine wait on multiple communication operations. A select blocks until one of its cases can run, then it executes that case. It chooses one at random if multiple are ready.

```shell
func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x:
			x, y = y, x+y
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}
		quit <- 0
	}()
	fibonacci(c, quit)
}
```

- Ref: [Select](https://go.dev/tour/concurrency/5#:~:text=The%20select%20statement%20lets%20a,random%20if%20multiple%20are%20ready.)
- Ref: [Select Statement in Go](https://www.geeksforgeeks.org/select-statement-in-go-language/?ref=lbp)

### 13. Unidirectional Channel?
- A channel that can only receive data or a channel that can only send data is the unidirectional channel

```shell
// Main function
func main() {
 
    // Only for receiving
    mychanl1 := make(<-chan string)
 
    // Only for sending
    mychanl2 := make(chan<- string)
 
    // Display the types of channels
    fmt.Printf("%T", mychanl1)
    fmt.Printf("\n%T", mychanl2)
}
```

### 14. sync.Mutex
- But what if we don't need communication? What if we just want to make sure only one goroutine can access a variable at a time to avoid conflicts?
- This concept is called mutual exclusion, and the conventional name for the data structure that provides it is mutex.

```shell
package main

import (
	"fmt"
	"sync"
	"time"
)

// SafeCounter is safe to use concurrently.
type SafeCounter struct {
	mu sync.Mutex
	v  map[string]int
}

// Inc increments the counter for the given key.
func (c *SafeCounter) Inc(key string) {
	c.mu.Lock()
	// Lock so only one goroutine at a time can access the map c.v.
	c.v[key]++
	c.mu.Unlock()
}

// Value returns the current value of the counter for the given key.
func (c *SafeCounter) Value(key string) int {
	c.mu.Lock()
	// Lock so only one goroutine at a time can access the map c.v.
	defer c.mu.Unlock()
	return c.v[key]
}

func main() {
	c := SafeCounter{v: make(map[string]int)}
	for i := 0; i < 1000; i++ {
		go c.Inc("somekey")
	}

	time.Sleep(time.Second)
	fmt.Println(c.Value("somekey"))
}
```

- Ref: [sync.Mutex](https://go.dev/tour/concurrency/9)

### 15. Range
- The range form of the for loop iterates over a slice or map.

```shell
var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

func main() {
	for i, v := range pow {
		fmt.Printf("2**%d = %d\n", i, v)
	}
}
```

## References

[Code] golang-standards - [project-layout](https://github.com/golang-standards/project-layout) \